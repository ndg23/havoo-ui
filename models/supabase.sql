-- Schéma des tables pour Havoo Services

-- Enumérations
CREATE TYPE user_role AS ENUM ('client', 'expert', 'admin');
CREATE TYPE service_status AS ENUM ('pending', 'accepted', 'in_progress', 'completed', 'cancelled');
CREATE TYPE expert_status AS ENUM ('pending', 'active', 'inactive', 'suspended');
CREATE TYPE payment_status AS ENUM ('pending', 'paid', 'failed', 'refunded');
CREATE TYPE notification_type AS ENUM ('message', 'service_update', 'payment', 'system');
CREATE TYPE request_status AS ENUM ('pending', 'accepted', 'in_progress', 'completed', 'cancelled');
CREATE TYPE payment_method AS ENUM ('mobile_money', 'card', 'cash');

-- Table des utilisateurs (étend auth.users de Supabase)
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    role user_role DEFAULT 'client',
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    avatar_url TEXT,
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100) DEFAULT 'Bénin',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des experts
CREATE TABLE public.experts (
    id UUID REFERENCES public.profiles(id) ON DELETE CASCADE PRIMARY KEY,
    status expert_status DEFAULT 'pending',
    bio TEXT,
    experience_years INTEGER DEFAULT 0,
    hourly_rate INTEGER,
    availability JSON, -- Stockage des disponibilités
    total_jobs INTEGER DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0,
    verified BOOLEAN DEFAULT false,
    documents JSON, -- Stockage des documents vérifiés
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des catégories de services
CREATE TABLE public.service_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    icon TEXT,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des services
CREATE TABLE public.services (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    icon TEXT,
    base_price INTEGER NOT NULL, -- Prix en FCFA
    category VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des compétences des experts
CREATE TABLE public.expert_services (
    expert_id UUID REFERENCES public.experts(id),
    service_id UUID REFERENCES public.services(id),
    price_per_hour INTEGER,
    PRIMARY KEY (expert_id, service_id)
);

-- Table des demandes de service
CREATE TABLE public.service_requests (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    client_id UUID REFERENCES public.profiles(id),
    service_id UUID REFERENCES public.services(id),
    expert_id UUID REFERENCES public.experts(id),
    status request_status DEFAULT 'pending',
    description TEXT,
    date_needed DATE NOT NULL,
    time_needed TIME NOT NULL,
    duration INTEGER NOT NULL, -- Durée en heures
    location TEXT NOT NULL,
    budget INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des propositions des experts
CREATE TABLE public.expert_proposals (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    request_id UUID REFERENCES public.service_requests(id),
    expert_id UUID REFERENCES public.experts(id),
    price INTEGER NOT NULL,
    message TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(request_id, expert_id)
);

-- Table des missions
CREATE TABLE public.jobs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    request_id UUID REFERENCES public.service_requests(id),
    expert_id UUID REFERENCES public.experts(id),
    status service_status DEFAULT 'pending',
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    final_price INTEGER,
    rating INTEGER,
    review TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des paiements
CREATE TABLE public.payments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    request_id UUID REFERENCES public.service_requests(id),
    client_id UUID REFERENCES public.profiles(id),
    expert_id UUID REFERENCES public.experts(id),
    amount INTEGER NOT NULL,
    platform_fee INTEGER NOT NULL,
    status payment_status DEFAULT 'pending',
    payment_method payment_method,
    transaction_id VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    paid_at TIMESTAMPTZ
);

-- Table des messages
CREATE TABLE public.messages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    sender_id UUID REFERENCES public.profiles(id),
    receiver_id UUID REFERENCES public.profiles(id),
    job_id UUID REFERENCES public.jobs(id),
    content TEXT NOT NULL,
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des notifications
CREATE TABLE public.notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id),
    type notification_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    read BOOLEAN DEFAULT false,
    data JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des favoris
CREATE TABLE public.favorites (
    client_id UUID REFERENCES public.profiles(id),
    expert_id UUID REFERENCES public.experts(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (client_id, expert_id)
);

-- Indexes pour optimiser les performances
CREATE INDEX idx_service_requests_client ON service_requests(client_id);
CREATE INDEX idx_service_requests_status ON service_requests(status);
CREATE INDEX idx_jobs_expert ON jobs(expert_id);
CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_messages_receiver ON messages(receiver_id, read);
CREATE INDEX idx_notifications_user ON notifications(user_id, read);

-- Triggers pour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_at_column();

-- Répéter pour les autres tables avec updated_at

-- RLS (Row Level Security) Policies
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.experts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Exemple de politique RLS pour les profils
CREATE POLICY "Les profils sont visibles par tous les utilisateurs authentifiés"
    ON public.profiles
    FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY "Les utilisateurs peuvent modifier leur propre profil"
    ON public.profiles
    FOR UPDATE
    USING (auth.uid() = id);

-- ... autres policies selon les besoins 