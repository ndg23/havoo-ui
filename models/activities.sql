-- Fichier de migration pour ajouter la table des activités administratives

-- Création d'un type ENUM pour les types d'activités
CREATE TYPE activity_type AS ENUM (
    'new_user',
    'new_mission',
    'service_completed',
    'payment',
    'service_created',
    'user_verified',
    'admin_action'
);

-- Table des activités administratives
CREATE TABLE public.activities (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    type activity_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    user_id UUID REFERENCES public.profiles(id),
    related_id UUID, -- ID de l'objet concerné (utilisateur, demande, etc.)
    related_type VARCHAR(50), -- Type de l'objet concerné (user, mission, etc.)
    metadata JSONB, -- Données supplémentaires en format JSON
    created_at TIMESTAMPTZ DEFAULT NOW(),
    created_by UUID REFERENCES public.profiles(id)
);

-- Index pour optimiser les performances
CREATE INDEX idx_activities_type ON activities(type);
CREATE INDEX idx_activities_user ON activities(user_id);
CREATE INDEX idx_activities_created_at ON activities(created_at);

-- RLS (Row Level Security) Policies
ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;

-- Seuls les administrateurs peuvent voir toutes les activités
CREATE POLICY "Les administrateurs peuvent voir toutes les activités"
    ON public.activities
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Les utilisateurs peuvent voir leurs propres activités
CREATE POLICY "Les utilisateurs peuvent voir leurs propres activités"
    ON public.activities
    FOR SELECT
    USING (user_id = auth.uid());

-- Fonction pour enregistrer automatiquement une activité lors d'un nouvel utilisateur
CREATE OR REPLACE FUNCTION log_new_user_activity()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.activities (
        type,
        title,
        description,
        user_id,
        related_id,
        related_type
    ) VALUES (
        'new_user',
        'Nouvel utilisateur inscrit',
        'Un nouvel utilisateur a rejoint la plateforme',
        NEW.id,
        NEW.id,
        'user'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour enregistrer l'activité d'un nouvel utilisateur
CREATE TRIGGER log_new_user_activity_trigger
AFTER INSERT ON public.profiles
FOR EACH ROW
EXECUTE PROCEDURE log_new_user_activity();

-- Fonction pour enregistrer automatiquement une activité lors d'une nouvelle demande
CREATE OR REPLACE FUNCTION log_new_mission_activity()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.activities (
        type,
        title,
        description,
        user_id,
        related_id,
        related_type
    ) VALUES (
        'new_mission',
        'Nouvelle demande créée',
        'Une nouvelle demande a été soumise',
        NEW.client_id,
        NEW.id,
        'mission'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour enregistrer l'activité d'une nouvelle demande
CREATE TRIGGER log_new_mission_activity_trigger
AFTER INSERT ON public.service_missions
FOR EACH ROW
EXECUTE PROCEDURE log_new_mission_activity();

-- Fonction pour enregistrer automatiquement une activité lors d'un paiement
CREATE OR REPLACE FUNCTION log_payment_activity()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.activities (
        type,
        title,
        description,
        user_id,
        related_id,
        related_type,
        metadata
    ) VALUES (
        'payment',
        'Paiement reçu',
        format('%s pour service', (NEW.amount || ' XOF')),
        NEW.client_id,
        NEW.id,
        'payment',
        jsonb_build_object(
            'amount', NEW.amount,
            'payment_method', NEW.payment_method
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour enregistrer l'activité d'un paiement
CREATE TRIGGER log_payment_activity_trigger
AFTER UPDATE ON public.payments
FOR EACH ROW
WHEN (NEW.status = 'paid' AND OLD.status != 'paid')
EXECUTE PROCEDURE log_payment_activity(); 