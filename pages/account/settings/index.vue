<template>
    <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
      <!-- En-tête -->
      <AccountHeader 
        title="Paramètres du compte" 
        subtitle="Gérez vos préférences et informations personnelles" 
      />
  
      <!-- Onglets -->
      <div class="mb-7 overflow-x-auto bg-white dark:bg-gray-800 rounded-xl shadow-sm">
        <div class="flex space-x-1 px-2">
          <button 
            v-for="tab in tabs" 
            :key="tab.id"
            @click="activeTab = tab.id"
            class="px-5 py-3 text-sm font-medium whitespace-nowrap transition-colors"
            :class="activeTab === tab.id 
              ? 'border-b-2 border-primary-500 text-gray-800 dark:text-gray-200' 
              : 'text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200'"
          >
            <component :is="tab.icon" class="h-4 w-4 mr-1.5 inline-block" />
            {{ tab.name }}
          </button>
        </div>
      </div>
  
      <!-- Sections selon l'onglet actif -->
      <div class="space-y-6">
        <!-- Profil -->
        <div v-if="activeTab === 'profile'" class="space-y-6">
          <!-- Informations personnelles -->
          <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Informations personnelles
            </h2>
            <div class="space-y-4">
              <div class="flex flex-col md:flex-row items-start md:items-center gap-4 pb-4">
                <div class="relative">
                  <div class="h-20 w-20 rounded-full bg-gray-200 dark:bg-gray-700 overflow-hidden">
                    <img 
                      v-if="profile.avatar_url" 
                      :src="profile.avatar_url" 
                      alt="Photo de profil"
                      class="h-full w-full object-cover" 
                    />
                    <User v-else class="h-full w-full p-5 text-gray-400" />
                  </div>
                  <button 
                    @click="uploadAvatar"
                    class="absolute bottom-0 right-0 bg-white dark:bg-gray-800 p-1.5 rounded-full border border-gray-200 dark:border-gray-700 shadow-sm hover:bg-gray-50 dark:hover:bg-gray-700"
                  >
                    <Camera class="h-4 w-4 text-gray-600 dark:text-gray-400" />
                  </button>
                </div>
  
                <div class="flex-1">
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                    Votre profil public
                  </label>
                  <div class="flex flex-wrap gap-2">
                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300">
                      {{ isExpert ? 'Profil Expert' : 'Profil Client' }}
                    </span>
                    <span v-if="profile.is_verified" class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400">
                      <CheckCircle class="h-3 w-3 mr-1" />
                      Vérifié
                    </span>
                    <NuxtLink to="/account" class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-400">
                      <Eye class="h-3 w-3 mr-1" />
                      Voir mon profil
                    </NuxtLink>
                  </div>
                </div>
              </div>
  
              <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                  Type de compte
                </label>
                <div class="flex items-center space-x-4">
                  <div class="inline-flex items-center">
                    <input 
                      id="roleClient" 
                      type="radio" 
                      v-model="profile.role" 
                      value="client"
                      class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300"
                      :disabled="!canChangeRole"
                    />
                    <label for="roleClient" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
                      Client
                    </label>
                  </div>
                  <div class="inline-flex items-center">
                    <input 
                      id="roleExpert" 
                      type="radio" 
                      v-model="profile.role" 
                      value="expert"
                      class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300"
                      :disabled="!canChangeRole"
                    />
                    <label for="roleExpert" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
                      Expert
                    </label>
                  </div>
                </div>
                <p v-if="!canChangeRole" class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  Vous ne pouvez pas changer de rôle car vous avez déjà des transactions en cours.
                </p>
              </div>
  
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label for="firstName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                    Prénom
                  </label>
                  <input 
                    id="firstName"
                    v-model="form.firstName"
                    type="text"
                    class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  />
                </div>
                <div>
                  <label for="lastName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                    Nom
                  </label>
                  <input 
                    id="lastName"
                    v-model="form.lastName"
                    type="text"
                    class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  />
                </div>
              </div>
  
              <div>
                <label for="bio" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                  Biographie
                </label>
                <textarea 
                  id="bio"
                  v-model="form.bio"
                  rows="3"
                  placeholder="Décrivez-vous en quelques mots..."
                  class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                ></textarea>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  {{ form.bio ? form.bio.length : 0 }}/150 caractères
                </p>
              </div>
  
              <div>
                <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                  Adresse e-mail
                </label>
                <input 
                  id="email"
                  v-model="form.email"
                  type="email"
                  disabled
                  class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-gray-50 dark:bg-gray-700 text-gray-600 dark:text-gray-400 cursor-not-allowed"
                />
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  L'adresse e-mail ne peut pas être modifiée
                </p>
              </div>
  
              <div>
                <label for="phone" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                  Téléphone
                </label>
                <input 
                  id="phone"
                  v-model="form.phone"
                  type="tel"
                  placeholder="06 12 34 56 78"
                  class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                />
              </div>
  
              <div v-if="isExpert" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label for="profession" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                    Profession
                  </label>
                  <input 
                    id="profession"
                    v-model="form.profession"
                    type="text"
                    placeholder="Ex: Développeur web"
                    class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  />
                </div>
                <div>
                  <label for="experience" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                    Années d'expérience
                  </label>
                  <input 
                    id="experience"
                    v-model="form.experience"
                    type="number"
                    min="0"
                    class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  />
                </div>
              </div>
  
              <div class="pt-2">
                <button 
                  @click="saveProfile"
                  class="px-6 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-semibold rounded-full shadow-sm inline-flex items-center transition-colors"
                  :disabled="isSubmitting"
                >
                  <span v-if="isSubmitting" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></span>
                  <Save v-else class="h-4 w-4 mr-2" />
                  Enregistrer les modifications
                </button>
              </div>
            </div>
          </div>
  
          <!-- Section des compétences -->
          <div class="my-7">
              <div class="flex items-center justify-between">
                <div>
                  <h2 class="text-xl font-bold text-gray-900 dark:text-white">Compétences</h2>
                  <p class="text-sm text-gray-600 dark:text-gray-400">
                    Gérez les compétences que vous souhaitez mettre en avant
                  </p>
                </div>
                <button 
                  @click="showAddSkillModal = true"
                  class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm flex items-center transition-colors"
                >
                  <PlusIcon class="h-4 w-4 mr-2" />
                  Ajouter une compétence
                </button>
              </div>
            
            <div class="space-y-4">
              <!-- Liste des compétences -->
              <div v-if="userSkills.length > 0" class="flex flex-wrap items-center gap-2">
                <div 
                  v-for="skill in userSkills" 
                  :key="skill.id"
                  class="inline-flex items-center bg-gray-100 dark:bg-gray-700 px-3 py-1.5 rounded-full group"
                >
                  <span class="text-sm font-medium text-gray-800 dark:text-gray-200">{{ skill.name }}</span>
                  <div class="ml-1.5 flex items-center gap-1">
                    <button 
                      v-if="skill.level"
                      class="px-1.5 py-0.5 bg-primary-100 dark:bg-primary-900/30 text-xs text-primary-700 dark:text-primary-400 rounded-md"
                      title="Niveau de compétence"
                    >
                      {{ skill.level }}/5
                    </button>
                    <button 
                      @click="removeSkill(skill.id)"
                      class="ml-1 text-gray-400 hover:text-red-500 dark:hover:text-red-400 transition-colors"
                      title="Supprimer cette compétence"
                    >
                      <XIcon class="h-4 w-4" />
                    </button>
                  </div>
                </div>
              </div>
              
              <!-- Message si aucune compétence -->
              <div v-else class="py-3 text-center text-gray-500 dark:text-gray-400 border border-dashed border-gray-300 dark:border-gray-600 rounded-lg">
                Vous n'avez pas encore ajouté de compétences
              </div>
              
              <p class="text-sm text-gray-500 dark:text-gray-400 italic">
                Les compétences vous permettent d'être plus facilement trouvé par les clients à la recherche de vos services.
              </p>
            </div>
        </div>
  
          <!-- Mot de passe -->
          <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Changer de mot de passe
            </h2>
            <div class="space-y-4">
              <div>
                <label for="currentPassword" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                  Mot de passe actuel
                </label>
                <input 
                  id="currentPassword"
                  v-model="passwordForm.current"
                  type="password"
                  class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  :class="{ 'border-red-500 dark:border-red-500': passwordErrors.current }"
                />
                <p v-if="passwordErrors.current" class="text-red-600 dark:text-red-400 text-xs mt-1">
                  {{ passwordErrors.current }}
                </p>
              </div>
  
              <div>
                <label for="newPassword" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                  Nouveau mot de passe
                </label>
                <div class="relative">
                  <input 
                    id="newPassword"
                    v-model="passwordForm.new"
                    :type="showPassword ? 'text' : 'password'"
                    class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500 pr-10"
                    :class="{ 'border-red-500 dark:border-red-500': passwordErrors.new }"
                  />
                  <button 
                    type="button" 
                    @click="showPassword = !showPassword"
                    class="absolute inset-y-0 right-0 pr-3 flex items-center"
                  >
                    <Eye v-if="showPassword" class="h-5 w-5 text-gray-400" />
                    <EyeOff v-else class="h-5 w-5 text-gray-400" />
                  </button>
                </div>
                <p v-if="passwordErrors.new" class="text-red-600 dark:text-red-400 text-xs mt-1">
                  {{ passwordErrors.new }}
                </p>
              </div>
  
              <div>
                <label for="confirmPassword" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                  Confirmez le nouveau mot de passe
                </label>
                <input 
                  id="confirmPassword"
                  v-model="passwordForm.confirm"
                  type="password"
                  class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                  :class="{ 'border-red-500 dark:border-red-500': passwordErrors.confirm }"
                />
                <p v-if="passwordErrors.confirm" class="text-red-600 dark:text-red-400 text-xs mt-1">
                  {{ passwordErrors.confirm }}
                </p>
              </div>
  
              <div class="pt-2">
                <button 
                  @click="changePassword"
                  class="px-6 py-2.5 bg-gray-600 hover:bg-gray-700 text-white text-sm font-semibold rounded-full shadow-sm inline-flex items-center transition-colors"
                  :disabled="isChangingPassword"
                >
                  <span v-if="isChangingPassword" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></span>
                  <Key v-else class="h-4 w-4 mr-2" />
                  Modifier le mot de passe
                </button>
              </div>
            </div>
          </div>
        </div>
  
        <!-- Notifications -->
        <div v-if="activeTab === 'notifications'" class="space-y-6">
          <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Préférences de notification
            </h2>
            <div class="space-y-4">
              <div class="flex items-center justify-between py-2">
                <div>
                  <h3 class="text-sm font-medium text-gray-900 dark:text-white">Notifications par e-mail</h3>
                  <p class="text-xs text-gray-500 dark:text-gray-400">Recevoir des notifications par e-mail</p>
                </div>
                <Switch v-model="notifs.email" />
              </div>
              
              <div class="border-t border-gray-200 dark:border-gray-700"></div>
              
              <div class="flex items-center justify-between py-2">
                <div>
                  <h3 class="text-sm font-medium text-gray-900 dark:text-white">Notifications par SMS</h3>
                  <p class="text-xs text-gray-500 dark:text-gray-400">Recevoir des alertes par SMS</p>
                </div>
                <Switch v-model="notifs.sms" />
              </div>
              
              <div class="border-t border-gray-200 dark:border-gray-700"></div>
              
              <div class="flex items-center justify-between py-2">
                <div>
                  <h3 class="text-sm font-medium text-gray-900 dark:text-white">Notifications sur le site</h3>
                  <p class="text-xs text-gray-500 dark:text-gray-400">Afficher des notifications dans l'application</p>
                </div>
                <Switch v-model="notifs.app" />
              </div>
            </div>
            
            <div class="pt-4 mt-4 border-t border-gray-200 dark:border-gray-700">
              <h3 class="text-sm font-medium text-gray-900 dark:text-white mb-3">Types de notifications</h3>
              
              <div class="space-y-3">
                <div class="flex items-center">
                  <input 
                    id="notif-messages" 
                    v-model="notifs.messages" 
                    type="checkbox" 
                    class="h-4 w-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                  />
                  <label for="notif-messages" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                    Nouveaux messages
                  </label>
                </div>
                
                <div class="flex items-center">
                  <input 
                    id="notif-proposals" 
                    v-model="notifs.proposals" 
                    type="checkbox" 
                    class="h-4 w-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                  />
                  <label for="notif-proposals" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                    Nouvelles propositions
                  </label>
                </div>
                
                <div class="flex items-center">
                  <input 
                    id="notif-contracts" 
                    v-model="notifs.contracts" 
                    type="checkbox" 
                    class="h-4 w-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                  />
                  <label for="notif-contracts" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                    Mises à jour des contrats
                  </label>
                </div>
                
                <div class="flex items-center">
                  <input 
                    id="notif-payments" 
                    v-model="notifs.payments" 
                    type="checkbox" 
                    class="h-4 w-4 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                  />
                  <label for="notif-payments" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                    Paiements et transactions
                  </label>
                </div>
              </div>
              
              <div class="pt-4 mt-2">
                <button 
                  @click="saveNotifications"
                  class="px-6 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-semibold rounded-full shadow-sm inline-flex items-center transition-colors"
                  :disabled="isSavingNotifs"
                >
                  <span v-if="isSavingNotifs" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></span>
                  <Save v-else class="h-4 w-4 mr-2" />
                  Enregistrer les préférences
                </button>
              </div>
            </div>
          </div>
        </div>
  
        <!-- Sécurité et Vie privée -->
        <div v-if="activeTab === 'privacy'" class="space-y-6">
          <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Visibilité du profil
            </h2>
            <div class="space-y-4">
              <div class="flex items-center justify-between py-2">
                <div>
                  <h3 class="text-sm font-medium text-gray-900 dark:text-white">Profil public</h3>
                  <p class="text-xs text-gray-500 dark:text-gray-400">Votre profil est visible par tous les utilisateurs</p>
                </div>
                <Switch v-model="privacy.publicProfile" />
              </div>
              
              <div class="border-t border-gray-200 dark:border-gray-700"></div>
              
              <div class="flex items-center justify-between py-2">
                <div>
                  <h3 class="text-sm font-medium text-gray-900 dark:text-white">Afficher le numéro de téléphone</h3>
                  <p class="text-xs text-gray-500 dark:text-gray-400">Votre numéro est visible sur votre profil</p>
                </div>
                <Switch v-model="privacy.showPhone" />
              </div>
              
              <div class="border-t border-gray-200 dark:border-gray-700"></div>
              
              <div class="flex items-center justify-between py-2">
                <div>
                  <h3 class="text-sm font-medium text-gray-900 dark:text-white">Indexation par les moteurs de recherche</h3>
                  <p class="text-xs text-gray-500 dark:text-gray-400">Votre profil apparaît dans les résultats de recherche</p>
                </div>
                <Switch v-model="privacy.allowIndexing" />
              </div>
            </div>
            
            <div class="pt-4 mt-2">
              <button 
                @click="savePrivacy"
                class="px-6 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-semibold rounded-full shadow-sm inline-flex items-center transition-colors"
                :disabled="isSavingPrivacy"
              >
                <span v-if="isSavingPrivacy" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></span>
                <Save v-else class="h-4 w-4 mr-2" />
                Enregistrer les paramètres
              </button>
            </div>
          </div>
          
          <!-- Sessions actives -->
          <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Sessions actives
            </h2>
            <div class="space-y-4">
              <div class="flex items-start justify-between py-2 border-b border-gray-200 dark:border-gray-700">
                <div>
                  <h3 class="text-sm font-medium text-gray-900 dark:text-white">Chrome sur MacBook Pro</h3>
                  <p class="text-xs text-gray-500 dark:text-gray-400">Paris, France • Actif maintenant</p>
                </div>
                <span class="px-2 py-1 bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400 text-xs rounded-full">
                  Actuelle
                </span>
              </div>
              
              <div class="flex items-start justify-between py-2 border-b border-gray-200 dark:border-gray-700">
                <div>
                  <h3 class="text-sm font-medium text-gray-900 dark:text-white">Safari sur iPhone 13</h3>
                  <p class="text-xs text-gray-500 dark:text-gray-400">Paris, France • Il y a 2 heures</p>
                </div>
                <button class="text-xs text-red-600 dark:text-red-400 hover:underline">
                  Déconnecter
                </button>
              </div>
              
              <div class="flex items-start justify-between py-2">
                <div>
                  <h3 class="text-sm font-medium text-gray-900 dark:text-white">Firefox sur Windows 10</h3>
                  <p class="text-xs text-gray-500 dark:text-gray-400">Lyon, France • Il y a 3 jours</p>
                </div>
                <button class="text-xs text-red-600 dark:text-red-400 hover:underline">
                  Déconnecter
                </button>
              </div>
            </div>
            
            <div class="pt-4 mt-4 border-t border-gray-200 dark:border-gray-700">
              <button class="px-5 py-2 bg-red-50 hover:bg-red-100 text-red-700 dark:bg-red-900/20 dark:text-red-400 dark:hover:bg-red-900/30 text-sm font-medium rounded-lg inline-flex items-center transition-colors">
                <LogOut class="h-4 w-4 mr-2" />
                Se déconnecter de toutes les sessions
              </button>
            </div>
          </div>
          
          <!-- Supprimer le compte -->
          <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 transition-shadow hover:shadow-sm">
            <h2 class="text-lg font-semibold text-red-600 dark:text-red-400 mb-4">
              Danger zone
            </h2>
            
            <p class="text-sm text-gray-700 dark:text-gray-300 mb-4">
              La suppression de votre compte est une action permanente et ne peut pas être annulée. Toutes vos données personnelles seront définitivement effacées.
            </p>
            
            <button 
              @click="showDeleteModal = true"
              class="px-5 py-2 bg-red-600 hover:bg-red-700 text-white text-sm font-medium rounded-lg inline-flex items-center transition-colors"
            >
              <Trash2 class="h-4 w-4 mr-2" />
              Supprimer mon compte
            </button>
          </div>
        </div>
      </div>
  
      <!-- Modal de confirmation pour la suppression du compte -->
      <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
        <div class="bg-white dark:bg-gray-800 rounded-xl max-w-md w-full p-6 shadow-lg">
          <h3 class="text-lg font-semibold text-red-600 dark:text-red-400 mb-2">
            Confirmer la suppression
          </h3>
          <p class="text-sm text-gray-700 dark:text-gray-300 mb-4">
            Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.
          </p>
          
          <div class="mb-4">
            <label for="delete-confirm" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
              Tapez "SUPPRIMER" pour confirmer
            </label>
            <input 
              id="delete-confirm"
              v-model="deleteConfirmation"
              type="text"
              class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-red-500 focus:border-red-500"
            />
          </div>
          
          <div class="flex justify-end space-x-3">
            <button 
              @click="showDeleteModal = false; deleteConfirmation = ''"
              class="px-4 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-lg transition-colors"
            >
              Annuler
            </button>
            <button 
              @click="deleteAccount"
              class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white text-sm font-medium rounded-lg inline-flex items-center transition-colors"
              :disabled="deleteConfirmation !== 'SUPPRIMER' || isDeletingAccount"
            >
              <span v-if="isDeletingAccount" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></span>
              <Trash2 v-else class="h-4 w-4 mr-2" />
              Supprimer définitivement
            </button>
          </div>
        </div>
      </div>
  
      <!-- Modal d'ajout de compétence -->
      <TransitionRoot appear :show="showAddSkillModal" as="template">
        <Dialog as="div" @close="closeSkillModal" class="relative z-50">
          <TransitionChild
            enter="ease-out duration-300"
            enter-from="opacity-0"
            enter-to="opacity-100"
            leave="ease-in duration-200"
            leave-from="opacity-100"
            leave-to="opacity-0"
          >
            <div class="fixed inset-0 bg-black bg-opacity-25" />
          </TransitionChild>
  
          <div class="fixed inset-0 overflow-y-auto">
            <div class="flex min-h-full items-center justify-center p-4 text-center">
              <TransitionChild
                enter="ease-out duration-300"
                enter-from="opacity-0 scale-95"
                enter-to="opacity-100 scale-100"
                leave="ease-in duration-200"
                leave-from="opacity-100 scale-100"
                leave-to="opacity-0 scale-95"
              >
                <DialogPanel class="w-full max-w-md transform overflow-hidden rounded-2xl bg-white dark:bg-gray-800 p-6 text-left align-middle shadow-xl transition-all">
                  <DialogTitle as="h3" class="text-lg font-medium leading-6 text-gray-900 dark:text-white mb-4">
                    Ajouter une compétence
                  </DialogTitle>
                  
                  <div v-if="skillSaveError" class="mb-4 text-sm text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-900/20 p-3 rounded-lg">
                    {{ skillSaveError }}
                  </div>
                  
                  <div class="space-y-4">
                    <!-- Sélection de compétence -->
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Compétence
                      </label>
                      <div class="relative">
                        <select 
                          v-model="newSkill.skill_id"
                          class="w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                        >
                          <option value="" disabled selected>Sélectionnez une compétence</option>
                          <optgroup 
                            v-for="category in skillCategories" 
                            :key="category.id" 
                            :label="category.name"
                          >
                            <option 
                              v-for="skill in category.skills" 
                              :key="skill.id" 
                              :value="skill.id"
                              :disabled="userSkills.some(s => s.id === skill.id)"
                            >
                              {{ skill.name }}
                            </option>
                          </optgroup>
                        </select>
                      </div>
                    </div>
                    
                    <!-- Niveau de compétence -->
                    <div>
                      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                        Niveau d'expertise (optionnel)
                      </label>
                      <div class="flex items-center">
                        <input 
                          v-model="newSkill.level"
                          type="range" 
                          min="1" 
                          max="5" 
                          class="w-full h-2 bg-gray-200 dark:bg-gray-700 rounded-lg appearance-none cursor-pointer"
                        />
                        <span class="ml-3 text-gray-700 dark:text-gray-300 font-medium">{{ newSkill.level }}/5</span>
                      </div>
                    </div>
                  </div>
  
                  <div class="mt-6 flex justify-end gap-3">
                    <button 
                      @click="closeSkillModal"
                      class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-700 dark:text-gray-300 text-sm font-medium hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors"
                    >
                      Annuler
                    </button>
                    <button 
                      @click="addSkill"
                      :disabled="!newSkill.skill_id || savingSkill"
                      class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-lg shadow-sm disabled:opacity-70 disabled:cursor-not-allowed transition-colors flex items-center"
                    >
                      <Loader2 v-if="savingSkill" class="animate-spin h-4 w-4 mr-2" />
                      <span>Ajouter</span>
                    </button>
                  </div>
                </DialogPanel>
              </TransitionChild>
            </div>
          </div>
        </Dialog>
      </TransitionRoot>
    </div>
  </template>
    
  <script setup>
  import { ref, onMounted, computed } from 'vue'
  import { useRouter } from 'vue-router'
  import { useSupabaseClient, useSupabaseUser } from '#imports'
  import {
    User,
    Settings,
    Bell,
    Shield,
    Key,
    LogOut,
    Trash2,
    Camera,
    Save,
    Eye,
    EyeOff,
    CheckCircle,
    PlusIcon,
    XIcon,
    Loader2
  } from 'lucide-vue-next'
  import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'
  import AccountHeader from '~/components/account/AccountHeader.vue'
  
  const supabase = useSupabaseClient()
  const user = useSupabaseUser()
  const router = useRouter()
  
  // État des onglets
  const activeTab = ref('profile')
  const tabs = [
    { id: 'profile', name: 'Profil', icon: User },
    { id: 'notifications', name: 'Notifications', icon: Bell },
    { id: 'privacy', name: 'Sécurité & Confidentialité', icon: Shield }
  ]
  
  // États du formulaire de profil
  const profile = ref({})
  const form = ref({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    bio: '',
    profession: '',
    experience: ''
  })
  const isSubmitting = ref(false)
  
  // États du formulaire de mot de passe
  const passwordForm = ref({
    current: '',
    new: '',
    confirm: ''
  })
  const passwordErrors = ref({})
  const showPassword = ref(false)
  const isChangingPassword = ref(false)
  
  // États des préférences de notification
  const notifs = ref({
    email: true,
    sms: false,
    app: true,
    messages: true,
    proposals: true,
    contracts: true,
    payments: true
  })
  const isSavingNotifs = ref(false)
  
  // États des paramètres de confidentialité
  const privacy = ref({
    publicProfile: true,
    showPhone: false,
    allowIndexing: true
  })
  const isSavingPrivacy = ref(false)
  
  // États de la suppression de compte
  const showDeleteModal = ref(false)
  const deleteConfirmation = ref('')
  const isDeletingAccount = ref(false)
  
  // États pour la gestion des compétences
  const userSkills = ref([])
  const skillCategories = ref([])
  const showAddSkillModal = ref(false)
  const savingSkill = ref(false)
  const skillSaveError = ref('')
  const newSkill = ref({
    skill_id: '',
    level: 3
  })
  
  // Calcul du mode expert
  const isExpert = computed(() => {
    return profile.value?.is_expert || false
  })
  
  // Charger les données du profil
  const fetchProfile = async () => {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.value.id)
        .single()
      
      if (error) throw error
      
      profile.value = data
      
      // Remplir le formulaire
      form.value = {
        firstName: data.first_name || '',
        lastName: data.last_name || '',
        email: user.value.email,
        phone: data.phone || '',
        bio: data.bio || '',
        profession: data.profession || '',
        experience: data.years_experience || ''
      }
      
      // Récupérer les préférences de notification (simulé)
      notifs.value = {
        email: data.notif_email !== false,
        sms: data.notif_sms === true,
        app: data.notif_app !== false,
        messages: data.notif_messages !== false,
        proposals: data.notif_proposals !== false,
        contracts: data.notif_contracts !== false,
        payments: data.notif_payments !== false
      }
      
      // Récupérer les paramètres de confidentialité (simulé)
      privacy.value = {
        publicProfile: data.is_public !== false,
        showPhone: data.show_phone === true,
        allowIndexing: data.allow_indexing !== false
      }
      
      // Charger les compétences de l'utilisateur
      await loadUserSkills()
      
    } catch (error) {
      console.error('Erreur lors du chargement du profil:', error)
    }
  }
  
  // Enregistrer les modifications du profil
  const saveProfile = async () => {
    isSubmitting.value = true
    formErrors.value = {}
    
    try {
      // Valider les données
      // ...
      
      // Enregistrer le profil
      const { error } = await supabase
        .from('users')
        .update({
          first_name: profile.value.first_name,
          last_name: profile.value.last_name,
          bio: profile.value.bio,
          phone: profile.value.phone,
          location: profile.value.location,
          role: profile.value.role, // Ajouter le rôle ici
          // autres champs...
        })
        .eq('id', user.value.id)
      
      if (error) throw error
      
      toast.success('Profil mis à jour avec succès')
      
      // Si l'utilisateur change de rôle vers expert, afficher une section spécifique
      if (profile.value.role === 'expert') {
        activeTab.value = 'professional' // Assurez-vous d'avoir cet onglet défini
      }
    } catch (error) {
      console.error('Erreur lors de la mise à jour du profil:', error)
      formErrors.value.general = 'Une erreur est survenue lors de la mise à jour du profil'
    } finally {
      isSubmitting.value = false
    }
  }
  
  // Changer le mot de passe
  const changePassword = async () => {
    // Réinitialiser les erreurs
    passwordErrors.value = {}
    
    // Valider les entrées
    if (!passwordForm.value.current) {
      passwordErrors.value.current = 'Veuillez saisir votre mot de passe actuel'
      return
    }
    
    if (!passwordForm.value.new) {
      passwordErrors.value.new = 'Veuillez saisir un nouveau mot de passe'
      return
    }
    
    if (passwordForm.value.new.length < 8) {
      passwordErrors.value.new = 'Le mot de passe doit contenir au moins 8 caractères'
      return
    }
    
    if (passwordForm.value.new !== passwordForm.value.confirm) {
      passwordErrors.value.confirm = 'Les mots de passe ne correspondent pas'
      return
    }
    
    isChangingPassword.value = true
    
    try {
      const { error } = await supabase.auth.updateUser({
        password: passwordForm.value.new
      })
      
      if (error) throw error
      
      // Réinitialiser le formulaire
      passwordForm.value = {
        current: '',
        new: '',
        confirm: ''
      }
      
      alert('Mot de passe mis à jour avec succès')
    } catch (error) {
      console.error('Erreur lors du changement de mot de passe:', error)
      
      // Afficher une erreur
      if (error.message.includes('password')) {
        passwordErrors.value.current = 'Mot de passe actuel incorrect'
      } else {
        alert('Une erreur est survenue lors du changement de mot de passe')
      }
    } finally {
      isChangingPassword.value = false
    }
  }

  // Charger les compétences de l'utilisateur
  const loadUserSkills = async () => {
    try {
      const { data, error } = await supabase
        .from('user_skills')
        .select(`
          skill_id,
          level,
          skills (id, name, description)
        `)
        .eq('user_id', user.value.id)
      
      if (error) throw error
      
      userSkills.value = data.map(item => ({
        id: item.skill_id,
        name: item.skills.name,
        description: item.skills.description,
        level: item.level
      }))
    } catch (error) {
      console.error('Erreur lors du chargement des compétences:', error)
    }
  }

  // Charger toutes les compétences disponibles
  const loadAllSkills = async () => {
    try {
      // Charger les catégories
      const { data: categories, error: catError } = await supabase
        .from('categories')
        .select('id, name')
        .order('name')
      
      if (catError) throw catError
      
      // Pour chaque catégorie, charger les compétences associées
      const categoriesWithSkills = await Promise.all(
        categories.map(async (category) => {
          const { data: skills, error: skillError } = await supabase
            .from('skills')
            .select('id, name, description')
            .eq('category_id', category.id)
            .order('name')
          
          if (skillError) throw skillError
          
          return {
            ...category,
            skills: skills || []
          }
        })
      )
      
      skillCategories.value = categoriesWithSkills
    } catch (error) {
      console.error('Erreur lors du chargement des compétences disponibles:', error)
    }
  }

  // Ajouter une compétence
  const addSkill = async () => {
    if (!newSkill.value.skill_id) return
    
    try {
      savingSkill.value = true
      skillSaveError.value = ''
      
      const { error } = await supabase
        .from('user_skills')
        .insert({
          user_id: user.value.id,
          skill_id: newSkill.value.skill_id,
          level: newSkill.value.level
        })
      
      if (error) throw error
      
      // Recharger les compétences et fermer le modal
      await loadUserSkills()
      closeSkillModal()
      toast.success('Compétence ajoutée avec succès')
    } catch (error) {
      console.error('Erreur lors de l\'ajout de la compétence:', error)
      skillSaveError.value = 'Impossible d\'ajouter cette compétence. Veuillez réessayer.'
    } finally {
      savingSkill.value = false
    }
  }

  // Supprimer une compétence
  const removeSkill = async (skillId) => {
    try {
      const { error } = await supabase
        .from('user_skills')
        .delete()
        .eq('user_id', user.value.id)
        .eq('skill_id', skillId)
      
      if (error) throw error
      
      // Mettre à jour la liste locale
      userSkills.value = userSkills.value.filter(skill => skill.id !== skillId)
      toast.success('Compétence supprimée')
    } catch (error) {
      console.error('Erreur lors de la suppression de la compétence:', error)
      toast.error('Erreur lors de la suppression de la compétence')
    }
  }

  // Fermer le modal et réinitialiser le formulaire
  const closeSkillModal = () => {
    showAddSkillModal.value = false
    skillSaveError.value = ''
    newSkill.value = {
      skill_id: '',
      level: 3
    }
  }

  // Enregistrer les préférences de notification
  const saveNotificationPreferences = async () => {
    isSavingNotifs.value = true
    
    try {
      const { error } = await supabase
        .from('profiles')
        .update({
          notification_preferences: {
            email: notifs.value.email,
            sms: notifs.value.sms,
            app: notifs.value.app,
            messages: notifs.value.messages,
            proposals: notifs.value.proposals,
            contracts: notifs.value.contracts,
            payments: notifs.value.payments
          }
        })
        .eq('id', user.value.id)
      
      if (error) throw error
      
      alert('Préférences de notification mises à jour')
    } catch (error) {
      console.error('Erreur lors de la mise à jour des préférences de notification:', error)
      alert('Une erreur est survenue lors de la mise à jour des préférences')
    } finally {
      isSavingNotifs.value = false
    }
  }

  // Enregistrer les paramètres de confidentialité
  const savePrivacySettings = async () => {
    isSavingPrivacy.value = true
    
    try {
      const { error } = await supabase
        .from('profiles')
        .update({
          is_public: privacy.value.publicProfile,
          show_phone: privacy.value.showPhone,
          allow_indexing: privacy.value.allowIndexing
        })
        .eq('id', user.value.id)
      
      if (error) throw error
      
      alert('Paramètres de confidentialité mis à jour')
    } catch (error) {
      console.error('Erreur lors de la mise à jour des paramètres de confidentialité:', error)
      alert('Une erreur est survenue lors de la mise à jour des paramètres')
    } finally {
      isSavingPrivacy.value = false
    }
  }

  // Upload avatar
  const uploadAvatar = async () => {
    const input = document.createElement('input')
    input.type = 'file'
    input.accept = 'image/*'
    
    input.onchange = async (e) => {
      const file = e.target.files[0]
      if (!file) return
      
      try {
        // Créer un nom de fichier unique
        const fileExt = file.name.split('.').pop()
        const fileName = `${user.value.id}-${Date.now()}.${fileExt}`
        const filePath = `avatars/${fileName}`
        
        // Upload du fichier
        const { error: uploadError } = await supabase.storage
          .from('avatars')
          .upload(filePath, file)
        
        if (uploadError) throw uploadError
        
        // Obtenir l'URL publique
        const { data: { publicUrl } } = supabase.storage
          .from('avatars')
          .getPublicUrl(filePath)
        
        // Mettre à jour le profil
        const { error: updateError } = await supabase
          .from('profiles')
          .update({
            avatar_url: publicUrl
          })
          .eq('id', user.value.id)
        
        if (updateError) throw updateError
        
        // Mettre à jour l'UI
        profile.value.avatar_url = publicUrl
        
      } catch (error) {
        console.error('Erreur lors de l\'upload de l\'avatar:', error)
        alert('Erreur lors de l\'upload de l\'avatar')
      }
    }
    
    input.click()
  }

  // Supprimer le compte
  const deleteAccount = async () => {
    if (deleteConfirmation.value !== user.value.email) {
      alert('Veuillez saisir votre adresse e-mail pour confirmer')
      return
    }
    
    isDeletingAccount.value = true
    
    try {
      // Supprimer le profil d'abord
      const { error: profileError } = await supabase
        .from('profiles')
        .delete()
        .eq('id', user.value.id)
      
      if (profileError) throw profileError
      
      // Supprimer l'utilisateur
      const { error: userError } = await supabase.auth.admin.deleteUser(
        user.value.id
      )
      
      if (userError) throw userError
      
      // Déconnexion
      await supabase.auth.signOut()
      
      // Redirection
      router.push('/')
    } catch (error) {
      console.error('Erreur lors de la suppression du compte:', error)
      alert('Une erreur est survenue lors de la suppression du compte')
    } finally {
      isDeletingAccount.value = false
      showDeleteModal.value = false
    }
  }

  // Initialisation
  onMounted(async () => {
    fetchProfile()
    await loadUserSkills()
    await loadAllSkills()
  })

  definePageMeta({
    layout: 'account'
  })
</script>

<style scoped>
/* Animation des composants */
.space-y-6 > div {
  animation: fadeIn 0.4s ease;
  animation-fill-mode: both;
}

/* Animation séquentielle pour chaque section */
.space-y-6 > div:nth-child(1) { animation-delay: 0.05s; }
.space-y-6 > div:nth-child(2) { animation-delay: 0.1s; }
.space-y-6 > div:nth-child(3) { animation-delay: 0.15s; }
.space-y-6 > div:nth-child(4) { animation-delay: 0.2s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Améliorer l'apparence du focus */
input:focus, select:focus, textarea:focus {
  outline: none;
}

/* Styliser le sélecteur de date pour le rendre plus cohérent */
input[type="date"] {
  appearance: none;
}

/* Empêcher le redimensionnement des textarea */
textarea {
  resize: none;
}

/* Personnalisation du switch */
.switch {
  position: relative;
  display: inline-block;
  width: 38px;
  height: 22px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: .3s;
  border-radius: 34px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 16px;
  width: 16px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .3s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #4f46e5;
}

input:focus + .slider {
  box-shadow: 0 0 1px #4f46e5;
}

input:checked + .slider:before {
  transform: translateX(16px);
}

/* Dark mode pour les switches */
.dark .slider {
  background-color: #4b5563;
}

.dark input:checked + .slider {
  background-color: #6366f1;
}

.dark input:focus + .slider {
  box-shadow: 0 0 1px #6366f1;
}
</style> 