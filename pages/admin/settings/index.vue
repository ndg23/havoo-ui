<template>
  <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header with modern design -->
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Paramètres</h1>
        <p class="text-gray-600 mt-1">Configurez les paramètres généraux de la plateforme</p>
    </div>
    
      <div class="flex items-center gap-3">
        <button 
          @click="resetToDefaults" 
          class="px-4 py-2.5 bg-white hover:bg-gray-50 text-gray-700 border border-gray-300 font-medium rounded-full transition-colors flex items-center gap-2 shadow-sm"
        >
          <RefreshCw class="h-4 w-4" />
          <span>Réinitialiser</span>
        </button>
        
        <button 
          @click="saveAllSettings" 
          class="px-5 py-2.5 bg-black hover:bg-gray-800 text-white font-medium rounded-full transition-colors flex items-center gap-2 shadow-sm"
          :disabled="saving"
        >
          <span v-if="saving">
            <Loader2 class="h-4 w-4 animate-spin" />
          </span>
          <Save v-else class="h-4 w-4" />
          <span>Enregistrer</span>
        </button>
      </div>
    </div>
    
    <!-- Success notification -->
    <div 
      v-if="notification.show" 
      class="mb-6 p-4 rounded-xl flex items-start gap-3"
      :class="[
        notification.type === 'success' ? 'bg-green-50 text-green-800' : 
        notification.type === 'error' ? 'bg-red-50 text-red-800' : 
        'bg-blue-50 text-blue-800'
      ]"
    >
      <component 
        :is="notification.type === 'success' ? 'CheckCircle' : notification.type === 'error' ? 'AlertTriangle' : 'Info'" 
        class="h-5 w-5 mt-0.5 flex-shrink-0" 
      />
      <div class="flex-1">
        <h3 class="font-medium">{{ notification.title }}</h3>
        <div class="text-sm opacity-80 mt-0.5 whitespace-pre-line">{{ notification.message }}</div>
      </div>
      <button 
        @click="notification.show = false" 
        class="ml-auto p-1.5 rounded-full hover:bg-black/5"
      >
        <X class="h-4 w-4" />
      </button>
    </div>
    
    <!-- Settings tabs -->
    <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
      <div class="border-b border-gray-200">
        <nav class="flex flex-wrap">
          <button 
            v-for="tab in tabs" 
            :key="tab.id"
            @click="activeTab = tab.id"
            class="px-6 py-4 text-sm font-medium border-b-2 -mb-px transition-colors"
            :class="activeTab === tab.id ? 
              'border-blue-500 text-blue-600' : 
              'border-transparent text-gray-500 hover:text-gray-700'"
          >
            <component :is="tab.icon" class="h-4 w-4 inline-block mr-2" />
            {{ tab.label }}
          </button>
        </nav>
      </div>
      
      <div class="p-6">
        <!-- Paramètres généraux -->
        <div v-if="activeTab === 'general'" class="space-y-6">
          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Nom de l'application
              </label>
              <input 
                v-model="settings.app_name"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
                placeholder="Havoo"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                URL du site
              </label>
              <input 
                v-model="settings.app_url"
                type="url"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
                placeholder="https://havoo.fr"
              />
            </div>
            </div>
            
          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Email de contact
              </label>
              <input 
                v-model="settings.contact_email"
                type="email"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
                placeholder="contact@havoo.fr"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Numéro de téléphone
              </label>
              <input 
                v-model="settings.contact_phone"
                type="tel"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
                placeholder="+33 1 23 45 67 89"
              />
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Description de l'application
            </label>
            <textarea
              v-model="settings.app_description"
              rows="3"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
              placeholder="Plateforme de mise en relation entre clients et experts..."
            ></textarea>
          </div>
          
          <div class="flex items-center p-4 bg-gray-50 rounded-xl border border-gray-100">
            <Switch v-model="settings.maintenance_mode" />
            <div class="ml-3">
              <span class="font-medium text-gray-900">Mode maintenance</span>
              <p class="text-sm text-gray-500 mt-0.5">Affiche une page de maintenance aux utilisateurs</p>
            </div>
          </div>
          
          <!-- AI Model Configuration -->
          <div class="border-t border-gray-100 pt-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
              <Brain class="h-5 w-5 mr-2 text-purple-500" />
              Configuration de l'IA
            </h3>
            
            <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">
                  Modèle d'IA par défaut
                </label>
                <select 
                  v-model="settings.ai_default_model" 
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
                >
                  <option value="gpt-4">GPT-4 (Haute précision)</option>
                  <option value="gpt-3.5-turbo">GPT-3.5 Turbo (Standard)</option>
                  <option value="claude-3">Claude 3 (Premium)</option>
                  <option value="llama-3">Llama 3 (Économique)</option>
                </select>
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">
                  Clé API OpenAI
                </label>
                <input 
                  v-model="settings.openai_api_key"
                  type="password"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
                  placeholder="sk-..."
                />
              </div>
            </div>
            
            <div class="mt-4 space-y-4">
              <div class="flex items-center p-4 bg-gray-50 rounded-xl border border-gray-100">
                <Switch v-model="settings.ai_features_enabled" />
                <div class="ml-3">
                  <span class="font-medium text-gray-900">Fonctionnalités d'IA</span>
                  <p class="text-sm text-gray-500 mt-0.5">Activer les fonctionnalités d'intelligence artificielle sur la plateforme</p>
                </div>
              </div>
              
              <div class="flex items-center p-4 bg-gray-50 rounded-xl border border-gray-100">
                <Switch v-model="settings.ai_suggestions_enabled" />
                <div class="ml-3">
                  <span class="font-medium text-gray-900">Suggestions intelligentes</span>
                  <p class="text-sm text-gray-500 mt-0.5">Activer les suggestions automatiques basées sur l'IA pour les utilisateurs</p>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Schéma de la base de données -->
          <div class="border-t border-gray-100 pt-6 mt-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
              <Database class="h-5 w-5 mr-2 text-blue-500" />
              Schéma de la base de données
            </h3>
            
            <div class="p-4 bg-blue-50 rounded-xl border border-blue-100 mb-4">
              <div class="flex">
                <Info class="h-5 w-5 text-blue-500 mr-3 mt-0.5" />
                <div>
                  <h3 class="font-medium text-blue-800">Structure de la table settings</h3>
                  <p class="text-sm text-blue-700 mt-1">
                    Les paramètres sont stockés dans une table "settings" sous forme de paires clé-valeur.
                  </p>
                </div>
              </div>
            </div>
            
            <div class="bg-gray-50 p-4 rounded-xl border border-gray-100 mb-4 overflow-auto">
              <pre class="text-sm text-gray-700 font-mono">
CREATE TABLE settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  key TEXT NOT NULL UNIQUE,
  value JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Politiques RLS pour la sécurité
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- Seuls les admins peuvent lire/modifier les paramètres
CREATE POLICY "Les admins peuvent tout faire" ON settings
  USING (auth.uid() IN (SELECT id FROM profiles WHERE role = 'admin'))
  WITH CHECK (auth.uid() IN (SELECT id FROM profiles WHERE role = 'admin'));

-- Index pour accélérer les recherches par clé
CREATE INDEX settings_key_idx ON settings (key);

-- Trigger pour mettre à jour le champ updated_at
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON settings
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at_timestamp();
              </pre>
            </div>
            
            <div class="bg-white p-4 rounded-xl border border-gray-200 mb-4">
              <h4 class="font-medium text-gray-900 mb-2">Exemple d'utilisation</h4>
              <pre class="text-sm text-gray-700 font-mono bg-gray-50 p-3 rounded-lg">
// Récupérer tous les paramètres
const { data, error } = await supabase
  .from('settings')
  .select('*');

// Récupérer un paramètre spécifique
const { data, error } = await supabase
  .from('settings')
  .select('value')
  .eq('key', 'app_name')
  .single();

// Insérer ou mettre à jour un paramètre
const { error } = await supabase
  .from('settings')
  .upsert({ key: 'app_name', value: 'Havoo' }, 
  { onConflict: 'key' });
              </pre>
            </div>
            
            <div class="bg-white p-4 rounded-xl border border-gray-200 mb-4">
              <h4 class="font-medium text-gray-900 mb-2">Paramètres par défaut</h4>
              <div class="text-sm text-gray-600 mb-3">
                Le système initialise automatiquement ces paramètres par défaut si la table est vide :
              </div>
              <div class="overflow-auto max-h-56">
                <pre class="text-sm text-gray-700 font-mono bg-gray-50 p-3 rounded-lg">
{
  "app_name": "Havoo",
  "app_url": "https://havoo.fr",
  "app_description": "Plateforme de mise en relation entre clients et experts",
  "contact_email": "contact@havoo.fr",
  "contact_phone": "+33 1 23 45 67 89",
  "maintenance_mode": false,
  
  "ai_default_model": "gpt-3.5-turbo",
  "ai_features_enabled": true,
  "ai_suggestions_enabled": false,
  
  "service_commission": 10,
  "expert_validation_days": 3,
  "auto_assign_experts": false,
  "allow_user_categories": true,
  
  "currency": "XOF",
  "payment_delay_days": 14,
  "enable_payment": true
}
                </pre>
              </div>
            </div>
            
            <div class="mt-4">
              <p class="text-sm text-gray-600">
                Cette structure est idéale pour stocker des paramètres flexibles car la colonne "value" de type JSONB permet de stocker n'importe quel type de données (texte, nombres, tableaux, objets).
              </p>
            </div>
          </div>
        </div>
        
        <!-- Paramètres des services -->
        <div v-else-if="activeTab === 'services'" class="space-y-6">
          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Commission sur les services (%)
              </label>
              <input 
                v-model="settings.service_commission"
                type="number"
                min="0"
                max="100"
                step="0.1"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Délai de validation expert (jours)
              </label>
              <input 
                v-model="settings.expert_validation_days"
                type="number"
                min="1"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
          </div>
          
          <div class="space-y-4">
            <div class="flex items-center p-4 bg-gray-50 rounded-xl border border-gray-100">
              <Switch v-model="settings.auto_assign_experts" />
              <div class="ml-3">
                <span class="font-medium text-gray-900">Attribution automatique des experts</span>
                <p class="text-sm text-gray-500 mt-0.5">Attribue automatiquement des experts aux demandes selon leurs compétences</p>
              </div>
          </div>
          
            <div class="flex items-center p-4 bg-gray-50 rounded-xl border border-gray-100">
              <Switch v-model="settings.allow_user_categories" />
              <div class="ml-3">
                <span class="font-medium text-gray-900">Suggestions de catégories</span>
                <p class="text-sm text-gray-500 mt-0.5">Permet aux experts de suggérer de nouvelles catégories</p>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Paramètres d'email -->
        <div v-else-if="activeTab === 'email'" class="space-y-6">
          <div class="p-4 bg-blue-50 rounded-xl border border-blue-100 mb-4">
            <div class="flex">
              <InfoIcon class="h-5 w-5 text-blue-500 mr-3 mt-0.5" />
              <div>
                <h3 class="font-medium text-blue-800">Configuration email</h3>
                <p class="text-sm text-blue-700 mt-1">
                  Configurez les paramètres SMTP pour envoyer des emails depuis la plateforme.
                </p>
              </div>
            </div>
          </div>
          
          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Serveur SMTP
              </label>
              <input 
                v-model="settings.smtp_host"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
                placeholder="smtp.example.com"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Port SMTP
              </label>
              <input 
                v-model="settings.smtp_port"
                type="number"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
                placeholder="587"
              />
            </div>
            </div>
            
          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Utilisateur SMTP
              </label>
              <input 
                v-model="settings.smtp_user"
                type="text"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
                placeholder="user@example.com"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                Mot de passe SMTP
              </label>
              <input 
                v-model="settings.smtp_password"
                type="password"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
                placeholder="••••••••"
              />
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Adresse d'expéditeur
            </label>
            <input 
              v-model="settings.mail_from_address"
              type="email"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg -shadow-sm focus:ring-blue-500 focus:border-blue-500"
              placeholder="noreply@havoo.fr"
            />
          </div>
          
          <div class="flex items-center p-4 bg-gray-50 rounded-xl border border-gray-100">
            <Switch v-model="settings.enable_email_notifications" />
            <div class="ml-3">
              <span class="font-medium text-gray-900">Notifications par email</span>
              <p class="text-sm text-gray-500 mt-0.5">Activer l'envoi de notifications par email aux utilisateurs</p>
          </div>
        </div>
        
          <div class="flex justify-end">
            <button 
              @click="sendTestEmail" 
              class="px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-full text-gray-800 text-sm font-medium flex items-center gap-2"
            >
              <Mail class="h-4 w-4" />
              Envoyer un email de test
            </button>
          </div>
            </div>
            
        <!-- Paramètres légaux (CGU/Mentions légales) -->
        <div v-else-if="activeTab === 'legal'" class="space-y-6">
          <div class="p-4 bg-purple-50 rounded-xl border border-purple-100 mb-4">
            <div class="flex">
              <FileText class="h-5 w-5 text-purple-500 mr-3 mt-0.5" />
            <div>
                <h3 class="font-medium text-purple-800">Documents légaux</h3>
                <p class="text-sm text-purple-700 mt-1">
                  Gérez les documents légaux de votre plateforme tels que les CGU, politique de confidentialité et mentions légales.
                </p>
              </div>
            </div>
            </div>
            
          <!-- CGU -->
            <div>
            <div class="flex items-center justify-between mb-2">
              <label class="block text-lg font-medium text-gray-900">
                Conditions Générales d'Utilisation (CGU)
              </label>
              <div class="text-xs text-gray-500">Dernière mise à jour: {{ formatDate(settings.cgu_last_updated) }}</div>
            </div>
            <div class="border border-gray-200 rounded-lg overflow-hidden">
              <div class="bg-gray-50 px-4 py-3 border-b border-gray-200 flex items-center">
                <span class="text-sm font-medium text-gray-700">Éditeur de texte enrichi</span>
                <div class="ml-auto flex space-x-2">
                  <button class="p-1.5 rounded hover:bg-gray-200" title="Gras">
                    <Bold class="h-4 w-4 text-gray-700" />
                  </button>
                  <button class="p-1.5 rounded hover:bg-gray-200" title="Italique">
                    <Italic class="h-4 w-4 text-gray-700" />
                  </button>
                  <button class="p-1.5 rounded hover:bg-gray-200" title="Liste à puces">
                    <List class="h-4 w-4 text-gray-700" />
                  </button>
                </div>
              </div>
              <textarea
                v-model="settings.cgu_content"
                rows="10"
                class="w-full px-4 py-3 border-0 focus:ring-0"
                placeholder="Saisissez ici vos Conditions Générales d'Utilisation..."
              ></textarea>
            </div>
            <div class="mt-2 flex justify-between items-center">
              <div class="text-sm text-gray-500">Format Markdown supporté</div>
              <button 
                @click="updateLegalDocument('cgu')"
                class="px-3 py-1.5 bg-gray-100 hover:bg-gray-200 rounded-full text-gray-800 text-sm font-medium flex items-center gap-1.5"
              >
                <Save class="h-3.5 w-3.5" />
                Mettre à jour
              </button>
            </div>
            </div>
            
          <!-- Politique de confidentialité -->
          <div class="pt-6 border-t border-gray-100 mt-6">
            <div class="flex items-center justify-between mb-2">
              <label class="block text-lg font-medium text-gray-900">
                Politique de confidentialité
              </label>
              <div class="text-xs text-gray-500">Dernière mise à jour: {{ formatDate(settings.privacy_last_updated) }}</div>
            </div>
            <div class="border border-gray-200 rounded-lg overflow-hidden">
              <div class="bg-gray-50 px-4 py-3 border-b border-gray-200 flex items-center">
                <span class="text-sm font-medium text-gray-700">Éditeur de texte enrichi</span>
                <div class="ml-auto flex space-x-2">
                  <button class="p-1.5 rounded hover:bg-gray-200" title="Gras">
                    <Bold class="h-4 w-4 text-gray-700" />
                  </button>
                  <button class="p-1.5 rounded hover:bg-gray-200" title="Italique">
                    <Italic class="h-4 w-4 text-gray-700" />
                  </button>
                  <button class="p-1.5 rounded hover:bg-gray-200" title="Liste à puces">
                    <List class="h-4 w-4 text-gray-700" />
                  </button>
                </div>
              </div>
              <textarea
                v-model="settings.privacy_content"
                rows="10"
                class="w-full px-4 py-3 border-0 focus:ring-0"
                placeholder="Saisissez ici votre Politique de confidentialité..."
              ></textarea>
            </div>
            <div class="mt-2 flex justify-between items-center">
              <div class="text-sm text-gray-500">Format Markdown supporté</div>
              <button 
                @click="updateLegalDocument('privacy')"
                class="px-3 py-1.5 bg-gray-100 hover:bg-gray-200 rounded-full text-gray-800 text-sm font-medium flex items-center gap-1.5"
              >
                <Save class="h-3.5 w-3.5" />
                Mettre à jour
              </button>
            </div>
          </div>
          
          <!-- Mentions légales -->
          <div class="pt-6 border-t border-gray-100 mt-6">
            <div class="flex items-center justify-between mb-2">
              <label class="block text-lg font-medium text-gray-900">
                Mentions légales
              </label>
              <div class="text-xs text-gray-500">Dernière mise à jour: {{ formatDate(settings.legal_notice_last_updated) }}</div>
            </div>
            <div class="border border-gray-200 rounded-lg overflow-hidden">
              <div class="bg-gray-50 px-4 py-3 border-b border-gray-200 flex items-center">
                <span class="text-sm font-medium text-gray-700">Éditeur de texte enrichi</span>
                <div class="ml-auto flex space-x-2">
                  <button class="p-1.5 rounded hover:bg-gray-200" title="Gras">
                    <Bold class="h-4 w-4 text-gray-700" />
                  </button>
                  <button class="p-1.5 rounded hover:bg-gray-200" title="Italique">
                    <Italic class="h-4 w-4 text-gray-700" />
                  </button>
                  <button class="p-1.5 rounded hover:bg-gray-200" title="Liste à puces">
                    <List class="h-4 w-4 text-gray-700" />
                  </button>
                </div>
              </div>
              <textarea
                v-model="settings.legal_notice_content"
                rows="10"
                class="w-full px-4 py-3 border-0 focus:ring-0"
                placeholder="Saisissez ici vos Mentions légales..."
              ></textarea>
            </div>
            <div class="mt-2 flex justify-between items-center">
              <div class="text-sm text-gray-500">Format Markdown supporté</div>
              <button 
                @click="updateLegalDocument('legal_notice')"
                class="px-3 py-1.5 bg-gray-100 hover:bg-gray-200 rounded-full text-gray-800 text-sm font-medium flex items-center gap-1.5"
              >
                <Save class="h-3.5 w-3.5" />
                Mettre à jour
              </button>
            </div>
          </div>
          
          <div class="mt-6 flex justify-end">
            <button
              @click="previewLegalDocs"
              class="px-4 py-2 bg-black text-white rounded-full hover:bg-gray-800 text-sm font-medium flex items-center gap-2"
            >
              <Eye class="h-4 w-4" />
              Prévisualiser les documents
            </button>
          </div>
        </div>
          </div>
        </div>
      </div>
      
  <!-- Footer avec diagnostic -->
  <div class="mt-8 bg-gray-50 border-t border-gray-100 py-4 px-4 sm:px-6 lg:px-8">
    <div class="max-w-5xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4">
      <div class="text-sm text-gray-500">
        <span>Version: 1.0.0</span>
        <span class="mx-2">•</span>
        <span>© {{ new Date().getFullYear() }} Havoo</span>
      </div>
      
      <div class="flex items-center gap-3">
        <button 
          @click="exportSettings"
          class="px-3 py-1.5 bg-gray-100 hover:bg-gray-200 rounded-full text-gray-800 text-sm font-medium flex items-center gap-1.5"
        >
          <Download class="h-3.5 w-3.5" />
          Exporter
        </button>
        
        <label
          class="px-3 py-1.5 bg-gray-100 hover:bg-gray-200 rounded-full text-gray-800 text-sm font-medium flex items-center gap-1.5 cursor-pointer"
        >
          <Upload class="h-3.5 w-3.5" />
          Importer
          <input 
            type="file" 
            ref="importFileInput" 
            class="hidden" 
            accept=".json" 
            @change="handleImportFile"
          />
        </label>
        
        <button 
          @click="debugSupabase"
          class="px-3 py-1.5 bg-gray-100 hover:bg-gray-200 rounded-full text-gray-800 text-sm font-medium flex items-center gap-1.5"
        >
          <Database class="h-3.5 w-3.5" />
          Tester la connexion
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { 
  Settings, Mail, Bell, CreditCard, AlertTriangle, CheckCircle, 
  Info, X, Save, Loader2, ShieldCheck, Phone, Globe, Sliders,
  FileText, Brain, Bold, Italic, List, Eye, Database, RefreshCw,
  Download, Upload
} from 'lucide-vue-next'
import Switch from '@/components/ui/Switch.vue'

const client = useSupabaseClient()

// State variables
const activeTab = ref('general')
const settings = ref({
  app_name: 'Havoo',
  app_url: 'https://havoo.fr',
  app_description: 'Plateforme de mise en relation entre clients et experts',
  contact_email: 'contact@havoo.fr',
  contact_phone: '+33 1 23 45 67 89',
  maintenance_mode: false,
  
  // AI Model settings
  ai_default_model: 'gpt-3.5-turbo',
  openai_api_key: '',
  ai_features_enabled: true,
  ai_suggestions_enabled: false,
  
  service_commission: 10,
  expert_validation_days: 3,
  auto_assign_experts: false,
  allow_user_categories: true,
  
  smtp_host: 'smtp.example.com',
  smtp_port: 587,
  smtp_user: 'user@example.com',
  smtp_password: '',
  mail_from_address: 'noreply@havoo.fr',
  enable_email_notifications: true,
  
  currency: 'XOF',
  payment_delay_days: 14,
  enable_payment: true,
  
  // Legal documents
  cgu_content: 'Les conditions générales d\'utilisation de Havoo seront définies ici.',
  cgu_last_updated: null,
  privacy_content: 'La politique de confidentialité de Havoo sera définie ici.',
  privacy_last_updated: null,
  legal_notice_content: 'Les mentions légales de Havoo seront définies ici.',
  legal_notice_last_updated: null
})

const notification = ref({
  show: false,
  type: 'success',
  title: '',
  message: ''
})

const saving = ref(false)
const tabs = [
  { id: 'general', label: 'Général', icon: Settings },
  { id: 'services', label: 'Services', icon: Sliders },
  { id: 'email', label: 'Email', icon: Mail },
  { id: 'legal', label: 'CGU & Mentions', icon: FileText },
]

// Import file input reference
const importFileInput = ref(null)

// Load settings
onMounted(async () => {
  await init()
})

const init = async () => {
  try {
    // Afficher indicateur de chargement
    showNotification('info', 'Chargement', 'Chargement des paramètres en cours...')
    
    // Vérifier la connexion à Supabase
    const isConnected = await checkSupabaseConnection()
    if (!isConnected) {
      throw new Error('Impossible de se connecter à la base de données. Veuillez vérifier votre connexion internet ou réessayer plus tard.')
    }
    
    // Charger les paramètres
    await loadSettings()
    
    // Masquer la notification après chargement réussi
    notification.value.show = false
  } catch (err) {
    console.error('Erreur lors de l\'initialisation:', err)
    showNotification('error', 'Erreur d\'initialisation', err.message || 'Erreur inconnue')
  }
}

// Vérifier la connexion à Supabase
const checkSupabaseConnection = async () => {
  try {
    // On fait une simple requête pour vérifier la connexion
    const { count, error } = await client
      .from('settings')
      .select('*', { count: 'exact', head: true })
    
    if (error) {
      console.error('Erreur de connexion à Supabase:', error)
      return false
    }
    
    return true
  } catch (err) {
    console.error('Erreur lors de la vérification de connexion:', err)
    return false
  }
}

// Handle Supabase errors
const handleSupabaseError = (error, operation) => {
  console.error(`Erreur Supabase (${operation}):`, error)
  
  // Gérer les différents types d'erreurs
  if (error.code === 'PGRST301') {
    return 'Authentification requise. Veuillez vous reconnecter.'
  } else if (error.code === '42501') {
    return 'Vous n\'avez pas les permissions nécessaires pour effectuer cette opération.'
  } else if (error.code === '23505') {
    return 'Un paramètre avec cette clé existe déjà.'
  } else if (error.message) {
    return error.message
  } else {
    return `Erreur lors de l'opération: ${operation}`
  }
}

// Load settings
const loadSettings = async () => {
  try {
    const { data, error } = await client.from('settings').select('*')
    
    if (error) {
      const errorMessage = handleSupabaseError(error, 'chargement des paramètres')
      throw new Error(errorMessage)
    }
    
    if (data && data.length > 0) {
      // Transform the array of settings into an object
      const settingsObject = {}
      data.forEach(item => {
        settingsObject[item.key] = item.value
      })
      
      // Merge with default settings while preserving defaults for missing values
      settings.value = {
        ...settings.value,
        ...settingsObject
      }
      
      console.log('Paramètres chargés avec succès:', settings.value)
    } else {
      // If no settings exist yet, initialize with defaults
      console.log('Aucun paramètre trouvé, initialisation avec les valeurs par défaut')
      await createDefaultSettings()
    }
  } catch (err) {
    showNotification('error', 'Erreur', 'Impossible de charger les paramètres: ' + (err.message || 'Erreur inconnue'))
    throw err
  }
}

// Create default settings in Supabase
const createDefaultSettings = async () => {
  try {
    saving.value = true
    showNotification('info', 'Initialisation', 'Création des paramètres par défaut...')
    
    // Créer un tableau de toutes les valeurs par défaut
    const defaultSettings = Object.entries(settings.value).map(([key, value]) => ({
      key,
      value,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    }))
    
    // Insérer tous les paramètres par défaut
    const { error } = await client.from('settings').upsert(defaultSettings)
    
    if (error) {
      const errorMessage = handleSupabaseError(error, 'création des paramètres par défaut')
      throw new Error(errorMessage)
    }
    
    // Log l'activité
    await logActivity('settings_initialized', 'Paramètres système initialisés avec les valeurs par défaut')
    
    console.log('Paramètres par défaut créés avec succès')
    showNotification('success', 'Initialisation terminée', 'Les paramètres par défaut ont été créés avec succès.')
    
    return true
  } catch (err) {
    console.error('Erreur lors de la création des paramètres par défaut:', err)
    showNotification('error', 'Erreur d\'initialisation', 'Impossible de créer les paramètres par défaut: ' + (err.message || 'Erreur inconnue'))
    return false
  } finally {
    saving.value = false
  }
}

// Function to reset settings to default values
const resetToDefaults = async () => {
  try {
    // Confirmation de l'utilisateur
    if (!confirm('Êtes-vous sûr de vouloir réinitialiser tous les paramètres aux valeurs par défaut ? Cette action est irréversible.')) {
      return
    }
    
    saving.value = true
    showNotification('info', 'Réinitialisation', 'Réinitialisation des paramètres en cours...')
    
    // Supprimer tous les paramètres existants
    const { error: deleteError } = await client.from('settings').delete().neq('key', '')
    
    if (deleteError) {
      const errorMessage = handleSupabaseError(deleteError, 'suppression des paramètres existants')
      throw new Error(errorMessage)
    }
    
    // Recréer les paramètres par défaut
    const success = await createDefaultSettings()
    
    if (!success) {
      throw new Error('Échec de la création des paramètres par défaut')
    }
    
    // Log l'activité
    await logActivity('settings_reset', 'Paramètres système réinitialisés aux valeurs par défaut')
    
    showNotification('success', 'Réinitialisation terminée', 'Les paramètres ont été réinitialisés aux valeurs par défaut.')
  } catch (err) {
    console.error('Erreur lors de la réinitialisation des paramètres:', err)
    showNotification('error', 'Erreur de réinitialisation', 'Impossible de réinitialiser les paramètres: ' + (err.message || 'Erreur inconnue'))
  } finally {
    saving.value = false
  }
}

// Save all settings
const saveAllSettings = async () => {
  try {
    saving.value = true
    
    // Validate settings before saving
    const { isValid, errors } = validateSettings()
    
    if (!isValid) {
      // Show error notification with all validation errors
      const errorMessage = `Veuillez corriger les erreurs suivantes :\n${errors.join('\n')}`
      showNotification('error', 'Erreurs de validation', errorMessage)
      return
    }
    
    // Vérifier la connexion à Supabase
    const isConnected = await checkSupabaseConnection()
    if (!isConnected) {
      throw new Error('Impossible de se connecter à la base de données. Veuillez vérifier votre connexion internet ou réessayer plus tard.')
    }
    
    // Transform the settings object into an array of upsert operations
    const settingsToUpsert = Object.entries(settings.value).map(([key, value]) => ({
      key,
      value,
      updated_at: new Date().toISOString()
    }))
    
    // Log the settings being saved
    console.log('Sauvegarde des paramètres:', settingsToUpsert)
    
    // Update or insert settings in database using upsert
    const { error } = await client.from('settings').upsert(
      settingsToUpsert,
      { onConflict: 'key' }
    )
    
    if (error) {
      const errorMessage = handleSupabaseError(error, 'sauvegarde des paramètres')
      throw new Error(errorMessage)
    }
    
    // Log activity
    await logActivity('settings_updated', 'Paramètres système mis à jour')
    
    showNotification('success', 'Paramètres enregistrés', 'Les paramètres ont été mis à jour avec succès.')
  } catch (err) {
    console.error('Erreur lors de la sauvegarde des paramètres:', err.message, err)
    showNotification('error', 'Erreur', 'Impossible de sauvegarder les paramètres: ' + (err.message || 'Erreur inconnue'))
  } finally {
    saving.value = false
  }
}

// Save a single setting
const saveSetting = async (key, value) => {
  try {
    const { error } = await client.from('settings').upsert(
      {
        key,
        value,
        updated_at: new Date().toISOString()
      },
      { onConflict: 'key' }
    )
    
    if (error) {
      const errorMessage = handleSupabaseError(error, `sauvegarde du paramètre ${key}`)
      throw new Error(errorMessage)
    }
    
    showNotification('success', 'Paramètre enregistré', `Le paramètre "${key}" a été mis à jour avec succès.`)
    return true
  } catch (err) {
    console.error(`Erreur lors de la sauvegarde du paramètre ${key}:`, err)
    showNotification('error', 'Erreur', `Impossible de sauvegarder le paramètre "${key}": ` + (err.message || 'Erreur inconnue'))
    return false
  }
}

// Récupérer un paramètre spécifique
const getSetting = async (key, defaultValue = null) => {
  try {
    const { data, error } = await client
      .from('settings')
      .select('value')
      .eq('key', key)
      .single()
    
    if (error) {
      if (error.code === 'PGRST116') { // Code for "No rows found"
        // If setting doesn't exist, create it with default value
        if (defaultValue !== null) {
          await saveSetting(key, defaultValue)
        }
        return defaultValue
      }
      
      const errorMessage = handleSupabaseError(error, `récupération du paramètre ${key}`)
      throw new Error(errorMessage)
    }
    
    return data?.value || defaultValue
  } catch (err) {
    console.error(`Erreur lors de la récupération du paramètre ${key}:`, err)
    return defaultValue
  }
}

// Supprimer un paramètre
const deleteSetting = async (key) => {
  try {
    const { error } = await client
      .from('settings')
      .delete()
      .eq('key', key)
    
    if (error) {
      const errorMessage = handleSupabaseError(error, `suppression du paramètre ${key}`)
      throw new Error(errorMessage)
    }
    
    showNotification('success', 'Paramètre supprimé', `Le paramètre "${key}" a été supprimé avec succès.`)
    return true
  } catch (err) {
    console.error(`Erreur lors de la suppression du paramètre ${key}:`, err)
    showNotification('error', 'Erreur', `Impossible de supprimer le paramètre "${key}": ` + (err.message || 'Erreur inconnue'))
    return false
  }
}

// Log activity
const logActivity = async (type, title) => {
  try {
    const { error } = await client
      .from('activities')
      .insert({
        type,
        title,
        description: 'Modification des paramètres système'
      })
    
    if (error) {
      console.error('Erreur lors de l\'enregistrement de l\'activité:', error)
    }
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'activité:', error)
  }
}

// Send test email
const sendTestEmail = async () => {
  try {
    showNotification('info', 'Envoi en cours', 'Tentative d\'envoi d\'un email de test...')
    
    // Vérifier les paramètres SMTP
    if (!settings.value.smtp_host || !settings.value.smtp_port || !settings.value.smtp_user) {
      throw new Error('Configuration SMTP incomplète. Veuillez remplir tous les champs SMTP.')
    }
    
    if (!settings.value.mail_from_address || !settings.value.contact_email) {
      throw new Error('Adresses email manquantes. Veuillez définir une adresse d\'expéditeur et de contact.')
    }
    
    // Call your email sending function here
    const { error } = await client.functions.invoke('send-test-email', {
      body: { 
        to: settings.value.contact_email,
        from: settings.value.mail_from_address,
        subject: 'Test email de Havoo',
        smtp: {
          host: settings.value.smtp_host,
          port: settings.value.smtp_port,
          user: settings.value.smtp_user,
          pass: settings.value.smtp_password
        }
      }
    })
    
    if (error) throw error
    
    // Log activity
    await logActivity('email_test', 'Email de test envoyé')
    
    showNotification('success', 'Email envoyé', 'L\'email de test a été envoyé avec succès.')
  } catch (err) {
    console.error('Erreur lors de l\'envoi de l\'email:', err)
    showNotification('error', 'Erreur', 'Impossible d\'envoyer l\'email de test: ' + (err.message || 'Erreur inconnue'))
  }
}

// Show notification
const showNotification = (type, title, message) => {
  notification.value = {
    show: true,
    type,
    title,
    message
  }
  
  // Auto-hide after 5 seconds only for success and info notifications
  if (type !== 'error') {
  setTimeout(() => {
      // Only hide this specific notification (not a new one that might have appeared)
      if (notification.value.title === title && notification.value.message === message) {
    notification.value.show = false
      }
  }, 5000)
  }
}

// Update a legal document
const updateLegalDocument = async (docType) => {
  try {
    const now = new Date().toISOString()
    
    if (docType === 'cgu') {
      settings.value.cgu_last_updated = now
      await saveSetting('cgu_content', settings.value.cgu_content)
      await saveSetting('cgu_last_updated', now)
    } else if (docType === 'privacy') {
      settings.value.privacy_last_updated = now
      await saveSetting('privacy_content', settings.value.privacy_content)
      await saveSetting('privacy_last_updated', now)
    } else if (docType === 'legal_notice') {
      settings.value.legal_notice_last_updated = now
      await saveSetting('legal_notice_content', settings.value.legal_notice_content)
      await saveSetting('legal_notice_last_updated', now)
    }
    
    // Log activity
    await logActivity('legal_doc_updated', `Document légal mis à jour: ${docType}`)
    
    showNotification('success', 'Document mis à jour', `Le document a été mis à jour avec succès.`)
  } catch (err) {
    console.error(`Erreur lors de la mise à jour du document ${docType}:`, err)
    showNotification('error', 'Erreur', `Impossible de mettre à jour le document: ` + (err.message || 'Erreur inconnue'))
  }
}

// Format date for displaying in the UI
const formatDate = (dateString) => {
  if (!dateString) return 'Jamais'
  
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// Preview legal documents
const previewLegalDocs = () => {
  try {
    // Sauvegarder temporairement les documents légaux si modifiés
    if (settings.value.cgu_content) {
      localStorage.setItem('preview_cgu', settings.value.cgu_content)
    }
    
    if (settings.value.privacy_content) {
      localStorage.setItem('preview_privacy', settings.value.privacy_content)
    }
    
    if (settings.value.legal_notice_content) {
      localStorage.setItem('preview_legal_notice', settings.value.legal_notice_content)
    }
    
    // Dans une implémentation réelle, cela ouvrirait une nouvelle fenêtre avec la prévisualisation
    const previewUrl = `/admin/preview/legal?type=all&timestamp=${Date.now()}`
    window.open(previewUrl, '_blank')
    
    showNotification('info', 'Prévisualisation', 'Les documents sont ouverts dans un nouvel onglet.')
  } catch (err) {
    console.error('Erreur lors de la prévisualisation:', err)
    showNotification('error', 'Erreur', 'Impossible d\'ouvrir la prévisualisation: ' + (err.message || 'Erreur inconnue'))
  }
}

// Validate settings before saving
const validateSettings = () => {
  const errors = []
  
  // Valider les paramètres généraux
  if (!settings.value.app_name) {
    errors.push('Le nom de l\'application est requis')
  }
  
  if (settings.value.app_url && !isValidUrl(settings.value.app_url)) {
    errors.push('L\'URL du site doit être une URL valide')
  }
  
  if (settings.value.contact_email && !isValidEmail(settings.value.contact_email)) {
    errors.push('L\'email de contact doit être une adresse email valide')
  }
  
  // Valider les paramètres SMTP si l'envoi d'email est activé
  if (settings.value.enable_email_notifications) {
    if (!settings.value.smtp_host) {
      errors.push('Le serveur SMTP est requis lorsque les notifications par email sont activées')
    }
    
    if (!settings.value.smtp_port || isNaN(settings.value.smtp_port)) {
      errors.push('Le port SMTP doit être un nombre valide')
    }
    
    if (!settings.value.smtp_user) {
      errors.push('L\'utilisateur SMTP est requis')
    }
    
    if (!settings.value.mail_from_address || !isValidEmail(settings.value.mail_from_address)) {
      errors.push('L\'adresse d\'expéditeur doit être une adresse email valide')
    }
  }
  
  // Validation des taux pour les services
  if (settings.value.service_commission < 0 || settings.value.service_commission > 100) {
    errors.push('La commission sur les services doit être comprise entre 0 et 100')
  }
  
  if (settings.value.expert_validation_days < 1) {
    errors.push('Le délai de validation des experts doit être d\'au moins 1 jour')
  }
  
  return {
    isValid: errors.length === 0,
    errors
  }
}

// Helper function to validate email
const isValidEmail = (email) => {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return re.test(email)
}

// Helper function to validate URL
const isValidUrl = (url) => {
  try {
    new URL(url)
    return true
  } catch (e) {
    return false
  }
}

// Debug Supabase connection with detailed information
const debugSupabase = async () => {
  try {
    showNotification('info', 'Débogage Supabase', 'Vérification de la connexion...')
    console.log('URL Supabase:', client.supabaseUrl)
    
    // Masquer partiellement la clé API pour la sécurité
    const maskedKey = client.supabaseKey ? 
      client.supabaseKey.substring(0, 4) + '...' + client.supabaseKey.substring(client.supabaseKey.length - 4) : 
      'Non disponible'
    console.log('Clé API (masquée):', maskedKey)
    
    // Vérifier l'authentification
    const { data: { user }, error: authError } = await client.auth.getUser()
    
    if (authError) {
      console.error('Erreur d\'authentification:', authError)
      showNotification('error', 'Erreur d\'authentification', handleSupabaseError(authError, 'authentification'))
      return
    }
    
    if (!user) {
      showNotification('error', 'Non authentifié', 'Vous n\'êtes pas authentifié. Veuillez vous connecter.')
      return
    }
    
    console.log('Utilisateur authentifié:', user.id)
    
    // Teste une requête simple
    const { count, error: testError } = await client.from('settings').select('*', { count: 'exact', head: true })
    
    if (testError) {
      console.error('Erreur lors du test de requête:', testError)
      showNotification('error', 'Erreur de requête', handleSupabaseError(testError, 'test de requête'))
      return
    }
    
    console.log('Test de requête réussi:', count)
    showNotification('success', 'Connexion établie', 'La connexion à Supabase fonctionne correctement.')
  } catch (error) {
    console.error('Erreur lors du débogage Supabase:', error)
    showNotification('error', 'Erreur', 'Une erreur est survenue lors du débogage: ' + (error.message || 'Erreur inconnue'))
  }
}

// Export settings to JSON file
const exportSettings = async () => {
  try {
    // Récupérer tous les paramètres de Supabase
    const { data, error } = await client.from('settings').select('*')
    
    if (error) {
      const errorMessage = handleSupabaseError(error, 'exportation des paramètres')
      throw new Error(errorMessage)
    }
    
    // Transformer les données en objet JSON
    const exportData = {
      version: '1.0.0',
      timestamp: new Date().toISOString(),
      environment: window.location.hostname,
      settings: {}
    }
    
    // Convertir les paires clé-valeur en objet
    data.forEach(item => {
      exportData.settings[item.key] = item.value
    })
    
    // Créer un blob et générer un URL
    const blob = new Blob([JSON.stringify(exportData, null, 2)], { type: 'application/json' })
    const url = URL.createObjectURL(blob)
    
    // Créer un élément a temporaire pour le téléchargement
    const a = document.createElement('a')
    a.href = url
    a.download = `havoo-settings-${new Date().toISOString().slice(0, 10)}.json`
    document.body.appendChild(a)
    a.click()
    
    // Nettoyer
    setTimeout(() => {
      document.body.removeChild(a)
      URL.revokeObjectURL(url)
    }, 100)
    
    showNotification('success', 'Paramètres exportés', 'Les paramètres ont été exportés avec succès.')
  } catch (err) {
    console.error('Erreur lors de l\'exportation des paramètres:', err)
    showNotification('error', 'Erreur d\'exportation', 'Impossible d\'exporter les paramètres: ' + (err.message || 'Erreur inconnue'))
  }
}

// Handle import file selection
const handleImportFile = (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  const reader = new FileReader()
  reader.onload = async (e) => {
    try {
      const content = e.target.result
      const importData = JSON.parse(content)
      
      // Vérifier la validité du fichier d'importation
      if (!importData.settings || typeof importData.settings !== 'object') {
        throw new Error('Format de fichier d\'importation invalide. Le fichier doit contenir un objet "settings".')
      }
      
      // Confirmer l'importation
      if (!confirm(`Voulez-vous importer ces paramètres ? Cette action remplacera certains paramètres existants.\n\nVersion du fichier: ${importData.version || 'Inconnue'}\nDate d'exportation: ${importData.timestamp || 'Inconnue'}`)) {
        return
      }
      
      await importSettings(importData.settings)
    } catch (err) {
      console.error('Erreur lors de la lecture du fichier d\'importation:', err)
      showNotification('error', 'Erreur d\'importation', 'Impossible de lire le fichier d\'importation: ' + (err.message || 'Erreur inconnue'))
    } finally {
      // Réinitialiser l'input file
      if (importFileInput.value) {
        importFileInput.value.value = ''
      }
    }
  }
  
  reader.readAsText(file)
}

// Import settings from parsed JSON
const importSettings = async (importedSettings) => {
  try {
    saving.value = true
    showNotification('info', 'Importation', 'Importation des paramètres en cours...')
    
    // Convertir l'objet en tableau de paires clé-valeur pour Supabase
    const settingsToImport = Object.entries(importedSettings).map(([key, value]) => ({
      key,
      value,
      updated_at: new Date().toISOString()
    }))
    
    // Enregistrer les paramètres importés
    const { error } = await client.from('settings').upsert(settingsToImport, {
      onConflict: 'key'
    })
    
    if (error) {
      const errorMessage = handleSupabaseError(error, 'importation des paramètres')
      throw new Error(errorMessage)
    }
    
    // Mettre à jour les paramètres locaux
    await loadSettings()
    
    // Log l'activité
    await logActivity('settings_imported', 'Paramètres importés depuis un fichier')
    
    showNotification('success', 'Importation terminée', 'Les paramètres ont été importés avec succès.')
  } catch (err) {
    console.error('Erreur lors de l\'importation des paramètres:', err)
    showNotification('error', 'Erreur d\'importation', 'Impossible d\'importer les paramètres: ' + (err.message || 'Erreur inconnue'))
  } finally {
    saving.value = false
  }
}

// Page configuration
definePageMeta({
  layout: 'admin',
})
</script> 
