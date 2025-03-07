<template>
    <div class="max-w-7xl mx-auto px-4 py-8">
      <!-- En-tête de la page -->
      <div class="flex justify-between items-center mb-8">
        <div>
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Paramètres de l'application</h1>
          <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les paramètres globaux de la plateforme</p>
        </div>
        
        <button 
          @click="showAddSettingModal = true"
          class="flex items-center px-6 py-2.5 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full transition-colors shadow-sm"
        >
          <Plus class="h-4 w-4 mr-1.5" />
          Ajouter un paramètre
        </button>
      </div>
      
      <!-- Alerte de statut -->
      <ErrorAlert 
        v-if="statusMessage.show"
        :type="statusMessage.type"
        :message="statusMessage.message"
        dismissible
        @dismiss="statusMessage.show = false"
        class="mb-6"
      />
      
      <!-- Filtres -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-6 mb-8 shadow-sm">
        <div class="flex flex-wrap gap-4 items-end">
          <div class="flex-1 min-w-[250px]">
            <label for="search" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Rechercher</label>
            <div class="relative">
              <input
                v-model="search"
                type="text"
                id="search"
                placeholder="Rechercher un paramètre..."
                class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white pl-10"
              />
              <Search class="absolute left-3 top-3 h-4 w-4 text-gray-400" />
            </div>
          </div>
          
          <div class="w-44">
            <label for="visibility" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Visibilité</label>
            <select
              v-model="visibilityFilter"
              id="visibility"
              class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
            >
              <option value="all">Tous les paramètres</option>
              <option value="public">Paramètres publics</option>
              <option value="private">Paramètres privés</option>
            </select>
          </div>
          
          <div class="w-44">
            <label for="category" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Catégorie</label>
            <select
              v-model="categoryFilter"
              id="category"
              class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
            >
              <option value="all">Toutes les catégories</option>
              <option value="site">Site</option>
              <option value="payment">Paiement</option>
              <option value="feature">Fonctionnalités</option>
              <option value="notification">Notifications</option>
              <option value="other">Autres</option>
            </select>
          </div>
        </div>
      </div>
      
      <!-- Section de chargement -->
      <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 animate-pulse shadow-sm">
        <div class="flex flex-col items-center justify-center">
          <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
          <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement des paramètres...</p>
        </div>
      </div>
      
      <!-- Message si aucun résultat -->
      <div v-else-if="filteredSettings.length === 0" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 text-center shadow-sm">
        <div class="flex flex-col items-center justify-center">
          <Search class="h-12 w-12 text-gray-400 mb-3" />
          <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">Aucun paramètre trouvé</h3>
          <p class="text-gray-600 dark:text-gray-400">
            {{ search ? `Aucun résultat pour "${search}"` : 'Aucun paramètre disponible' }}
          </p>
        </div>
      </div>
      
      <!-- Sections de paramètres -->
      <div v-else class="space-y-8">
        <!-- Section Site -->
        <div 
          v-if="getSettingsByCategory('site').length > 0"
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm"
        >
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
              <Settings class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
              Paramètres du site
            </h2>
          </div>
          
          <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
            <div 
              v-for="setting in getSettingsByCategory('site')" 
              :key="setting.id"
              class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-5 border border-gray-100 dark:border-gray-700"
            >
              <div class="flex justify-between items-start mb-3">
                <div>
                  <h3 class="font-medium text-gray-900 dark:text-white flex items-center">
                    {{ setting.key }}
                    <span 
                      class="ml-2 px-2 py-0.5 text-xs rounded-full"
                      :class="setting.is_public ? 'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-300' : 'bg-gray-100 text-gray-800 dark:bg-gray-600 dark:text-gray-300'"
                    >
                      {{ setting.is_public ? 'Public' : 'Privé' }}
                    </span>
                  </h3>
                  <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5">{{ setting.description || 'Aucune description' }}</p>
                </div>
                
                <div class="flex space-x-1">
                  <button 
                    @click="editSetting(setting)"
                    class="p-1 text-gray-500 hover:text-primary-600 dark:text-gray-400 dark:hover:text-primary-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600"
                  >
                    <Pencil class="h-4 w-4" />
                  </button>
                  <button 
                    @click="confirmDelete(setting)"
                    class="p-1 text-gray-500 hover:text-red-600 dark:text-gray-400 dark:hover:text-red-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600"
                  >
                    <Trash2 class="h-4 w-4" />
                  </button>
                </div>
              </div>
              
              <div class="bg-white dark:bg-gray-800 rounded-lg p-3 border border-gray-200 dark:border-gray-600 text-sm">
                <pre class="text-gray-700 dark:text-gray-300 overflow-auto max-h-24">{{ formatValueForDisplay(setting.value) }}</pre>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Section Paiement -->
        <div 
          v-if="getSettingsByCategory('payment').length > 0"
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm"
        >
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
              <CreditCard class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
              Paramètres de paiement
            </h2>
          </div>
          
          <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
            <div 
              v-for="setting in getSettingsByCategory('payment')" 
              :key="setting.id"
              class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-5 border border-gray-100 dark:border-gray-700"
            >
              <div class="flex justify-between items-start mb-3">
                <div>
                  <h3 class="font-medium text-gray-900 dark:text-white flex items-center">
                    {{ setting.key }}
                    <span 
                      class="ml-2 px-2 py-0.5 text-xs rounded-full"
                      :class="setting.is_public ? 'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-300' : 'bg-gray-100 text-gray-800 dark:bg-gray-600 dark:text-gray-300'"
                    >
                      {{ setting.is_public ? 'Public' : 'Privé' }}
                    </span>
                  </h3>
                  <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5">{{ setting.description || 'Aucune description' }}</p>
                </div>
                
                <div class="flex space-x-1">
                  <button 
                    @click="editSetting(setting)"
                    class="p-1 text-gray-500 hover:text-primary-600 dark:text-gray-400 dark:hover:text-primary-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600"
                  >
                    <Pencil class="h-4 w-4" />
                  </button>
                  <button 
                    @click="confirmDelete(setting)"
                    class="p-1 text-gray-500 hover:text-red-600 dark:text-gray-400 dark:hover:text-red-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600"
                  >
                    <Trash2 class="h-4 w-4" />
                  </button>
                </div>
              </div>
              
              <div class="bg-white dark:bg-gray-800 rounded-lg p-3 border border-gray-200 dark:border-gray-600 text-sm">
                <pre class="text-gray-700 dark:text-gray-300 overflow-auto max-h-24">{{ formatValueForDisplay(setting.value) }}</pre>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Section Fonctionnalités -->
        <div 
          v-if="getSettingsByCategory('feature').length > 0"
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm"
        >
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
              <Sliders class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
              Paramètres des fonctionnalités
            </h2>
          </div>
          
          <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
            <div 
              v-for="setting in getSettingsByCategory('feature')" 
              :key="setting.id"
              class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-5 border border-gray-100 dark:border-gray-700"
            >
              <div class="flex justify-between items-start mb-3">
                <div>
                  <h3 class="font-medium text-gray-900 dark:text-white flex items-center">
                    {{ setting.key }}
                    <span 
                      class="ml-2 px-2 py-0.5 text-xs rounded-full"
                      :class="setting.is_public ? 'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-300' : 'bg-gray-100 text-gray-800 dark:bg-gray-600 dark:text-gray-300'"
                    >
                      {{ setting.is_public ? 'Public' : 'Privé' }}
                    </span>
                  </h3>
                  <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5">{{ setting.description || 'Aucune description' }}</p>
                </div>
                
                <div class="flex space-x-1">
                  <button 
                    @click="editSetting(setting)"
                    class="p-1 text-gray-500 hover:text-primary-600 dark:text-gray-400 dark:hover:text-primary-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600"
                  >
                    <Pencil class="h-4 w-4" />
                  </button>
                  <button 
                    @click="confirmDelete(setting)"
                    class="p-1 text-gray-500 hover:text-red-600 dark:text-gray-400 dark:hover:text-red-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600"
                  >
                    <Trash2 class="h-4 w-4" />
                  </button>
                </div>
              </div>
              
              <div class="bg-white dark:bg-gray-800 rounded-lg p-3 border border-gray-200 dark:border-gray-600 text-sm">
                <pre class="text-gray-700 dark:text-gray-300 overflow-auto max-h-24">{{ formatValueForDisplay(setting.value) }}</pre>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Section Notifications -->
        <div 
          v-if="getSettingsByCategory('notification').length > 0"
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm"
        >
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
              <Bell class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
              Paramètres de notifications
            </h2>
          </div>
          
          <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
            <div 
              v-for="setting in getSettingsByCategory('notification')" 
              :key="setting.id"
              class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-5 border border-gray-100 dark:border-gray-700"
            >
              <div class="flex justify-between items-start mb-3">
                <div>
                  <h3 class="font-medium text-gray-900 dark:text-white flex items-center">
                    {{ setting.key }}
                    <span 
                      class="ml-2 px-2 py-0.5 text-xs rounded-full"
                      :class="setting.is_public ? 'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-300' : 'bg-gray-100 text-gray-800 dark:bg-gray-600 dark:text-gray-300'"
                    >
                      {{ setting.is_public ? 'Public' : 'Privé' }}
                    </span>
                  </h3>
                  <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5">{{ setting.description || 'Aucune description' }}</p>
                </div>
                
                <div class="flex space-x-1">
                  <button 
                    @click="editSetting(setting)"
                    class="p-1 text-gray-500 hover:text-primary-600 dark:text-gray-400 dark:hover:text-primary-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600"
                  >
                    <Pencil class="h-4 w-4" />
                  </button>
                  <button 
                    @click="confirmDelete(setting)"
                    class="p-1 text-gray-500 hover:text-red-600 dark:text-gray-400 dark:hover:text-red-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600"
                  >
                    <Trash2 class="h-4 w-4" />
                  </button>
                </div>
              </div>
              
              <div class="bg-white dark:bg-gray-800 rounded-lg p-3 border border-gray-200 dark:border-gray-600 text-sm">
                <pre class="text-gray-700 dark:text-gray-300 overflow-auto max-h-24">{{ formatValueForDisplay(setting.value) }}</pre>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Section Autres Paramètres -->
        <div 
          v-if="getSettingsByCategory('other').length > 0"
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm"
        >
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
              <Settings class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
              Autres paramètres
            </h2>
          </div>
          
          <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
            <div 
              v-for="setting in getSettingsByCategory('other')" 
              :key="setting.id"
              class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-5 border border-gray-100 dark:border-gray-700"
            >
              <div class="flex justify-between items-start mb-3">
                <div>
                  <h3 class="font-medium text-gray-900 dark:text-white flex items-center">
                    {{ setting.key }}
                    <span 
                      class="ml-2 px-2 py-0.5 text-xs rounded-full"
                      :class="setting.is_public ? 'bg-green-100 text-green-800 dark:bg-green-900/40 dark:text-green-300' : 'bg-gray-100 text-gray-800 dark:bg-gray-600 dark:text-gray-300'"
                    >
                      {{ setting.is_public ? 'Public' : 'Privé' }}
                    </span>
                  </h3>
                  <p class="text-sm text-gray-500 dark:text-gray-400 mt-0.5">{{ setting.description || 'Aucune description' }}</p>
                </div>
                
                <div class="flex space-x-1">
                  <button 
                    @click="editSetting(setting)"
                    class="p-1 text-gray-500 hover:text-primary-600 dark:text-gray-400 dark:hover:text-primary-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600"
                  >
                    <Pencil class="h-4 w-4" />
                  </button>
                  <button 
                    @click="confirmDelete(setting)"
                    class="p-1 text-gray-500 hover:text-red-600 dark:text-gray-400 dark:hover:text-red-400 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600"
                  >
                    <Trash2 class="h-4 w-4" />
                  </button>
                </div>
              </div>
              
              <div class="bg-white dark:bg-gray-800 rounded-lg p-3 border border-gray-200 dark:border-gray-600 text-sm">
                <pre class="text-gray-700 dark:text-gray-300 overflow-auto max-h-24">{{ formatValueForDisplay(setting.value) }}</pre>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Modal d'ajout/édition de paramètre -->
      <Teleport to="body">
        <div v-if="showAddSettingModal || showEditSettingModal" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div @click.stop class="bg-white dark:bg-gray-800 rounded-2xl w-full max-w-lg shadow-xl overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
              <h3 class="text-lg font-medium text-gray-900 dark:text-white">
                {{ showEditSettingModal ? 'Modifier le paramètre' : 'Ajouter un paramètre' }}
              </h3>
              <button @click="closeModal" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
                <X class="h-5 w-5" />
              </button>
            </div>
            
            <div class="p-6">
              <div class="space-y-5">
                <div>
                  <label for="key" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Clé</label>
                  <input
                    v-model="formData.key"
                    :disabled="showEditSettingModal"
                    type="text"
                    id="key"
                    placeholder="Exemple: site_name"
                    class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white disabled:opacity-70 disabled:cursor-not-allowed"
                  />
                </div>
                
                <div>
                  <label for="category" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Catégorie</label>
                  <select
                    v-model="formData.category"
                    id="category"
                    class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
                  >
                    <option value="site">Site</option>
                    <option value="payment">Paiement</option>
                    <option value="feature">Fonctionnalités</option>
                    <option value="notification">Notifications</option>
                    <option value="other">Autres</option>
                  </select>
                </div>
                
                <div>
                  <label for="value" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Valeur (JSON)</label>
                  <textarea
                    v-model="formData.value"
                    id="value"
                    rows="3"
                    placeholder='Exemple: "Sénégal Services" ou [1, 2, 3] ou {"key": "value"}'
                    class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                  ></textarea>
                  <p v-if="valueError" class="mt-1.5 text-sm text-red-600 dark:text-red-400">{{ valueError }}</p>
                </div>
                
                <div>
                  <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Description</label>
                  <input
                    v-model="formData.description"
                    type="text"
                    id="description"
                    placeholder="Description du paramètre"
                    class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                  />
                </div>
                
                <div class="flex items-center space-x-2">
                  <div class="flex items-center h-5">
                    <input
                      v-model="formData.is_public"
                      type="checkbox"
                      id="is_public"
                      class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
                    />
                  </div>
                  <div class="ml-2">
                    <label for="is_public" class="text-sm font-medium text-gray-700 dark:text-gray-300">Paramètre public</label>
                    <p class="text-xs text-gray-500 dark:text-gray-400">Les paramètres publics sont accessibles côté client</p>
                  </div>
                </div>
              </div>
              
              <div class="mt-8 flex justify-end space-x-3">
                <button
                  @click="closeModal"
                  type="button"
                  class="px-5 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none"
                >
                  Annuler
                </button>
                <button
                  @click="saveSetting"
                  type="button"
                  class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 rounded-full text-white font-medium focus:outline-none flex items-center justify-center min-w-[100px]"
                  :disabled="isSaving"
                >
                  <div v-if="isSaving" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                  {{ isSaving ? 'Enregistrement...' : 'Enregistrer' }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </Teleport>
      
      <!-- Modal de confirmation de suppression -->
      <Teleport to="body">
        <div v-if="showDeleteModal" class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div @click.stop class="bg-white dark:bg-gray-800 rounded-2xl w-full max-w-md shadow-xl overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
              <h3 class="text-lg font-medium text-gray-900 dark:text-white">Confirmer la suppression</h3>
              <button @click="showDeleteModal = false" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
                <X class="h-5 w-5" />
              </button>
            </div>
            
            <div class="p-6">
              <p class="text-gray-600 dark:text-gray-300">
                Êtes-vous sûr de vouloir supprimer le paramètre <span class="font-medium text-gray-900 dark:text-white">{{ deleteTargetKey }}</span> ?
                Cette action est irréversible.
              </p>
              
              <div class="mt-8 flex justify-end space-x-3">
                <button
                  @click="showDeleteModal = false"
                  type="button"
                  class="px-5 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none"
                >
                  Annuler
                </button>
                <button
                  @click="deleteSetting"
                  type="button"
                  class="px-5 py-2.5 bg-red-600 hover:bg-red-700 rounded-full text-white font-medium focus:outline-none flex items-center justify-center min-w-[100px]"
                  :disabled="isDeleting"
                >
                  <div v-if="isDeleting" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                  {{ isDeleting ? 'Suppression...' : 'Supprimer' }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </Teleport>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue'
  import { useSupabaseClient } from '#imports'
  import { 
    Plus, 
    Pencil, 
    Trash2, 
    X, 
    Search, 
    Settings,
    CreditCard,
    Sliders,
    Bell
  } from 'lucide-vue-next'
  
  // États
  const settings = ref([])
  const isLoading = ref(false)
  const showAddSettingModal = ref(false)
  const showEditSettingModal = ref(false)
  const showDeleteModal = ref(false)
  const formData = ref({
    key: '',
    value: '',
    description: '',
    is_public: false,
    category: 'site'
  })
  const valueError = ref('')
  const search = ref('')
  const visibilityFilter = ref('all')
  const categoryFilter = ref('all')
  const isSaving = ref(false)
  const isDeleting = ref(false)
  const deleteTargetId = ref(null)
  const deleteTargetKey = ref('')
  const statusMessage = ref({
    show: false,
    type: 'info',
    message: ''
  })
  
  // Composable Supabase
  const supabase = useSupabaseClient()
  
  // Méthodes
  const fetchSettings = async () => {
    isLoading.value = true
    
    try {
      const { data, error } = await supabase
        .from('app_settings')
        .select('*')
        .order('key')
      
      if (error) throw error
      
      // Ajouter la catégorie par défaut si elle n'existe pas
      settings.value = data.map(setting => ({
        ...setting,
        category: getCategoryFromKey(setting.key)
      }))
    } catch (error) {
      console.error('Erreur lors du chargement des paramètres:', error)
      showStatusMessage('error', 'Erreur lors du chargement des paramètres')
    } finally {
      isLoading.value = false
    }
  }
  
  // Déterminer la catégorie à partir de la clé
  const getCategoryFromKey = (key) => {
    if (key.startsWith('site_') || key.includes('_site') || key === 'site_name' || key === 'contact_email') return 'site'
    if (key.includes('payment') || key.includes('fee') || key.includes('price') || key.includes('currency')) return 'payment'
    if (key.includes('notification') || key.includes('email_') || key.includes('alert')) return 'notification'
    if (key.includes('feature') || key.includes('enable_') || key.includes('_enabled')) return 'feature'
    return 'other'
  }
  
  // Filtrer les paramètres
  const filteredSettings = computed(() => {
    let result = [...settings.value]
    
    // Filtre par recherche
    if (search.value) {
      const searchLower = search.value.toLowerCase()
      result = result.filter(setting => 
        setting.key.toLowerCase().includes(searchLower) || 
        (setting.description && setting.description.toLowerCase().includes(searchLower))
      )
    }
    
    // Filtre par visibilité
    if (visibilityFilter.value === 'public') {
      result = result.filter(setting => setting.is_public)
    } else if (visibilityFilter.value === 'private') {
      result = result.filter(setting => !setting.is_public)
    }
    
    // Filtre par catégorie
    if (categoryFilter.value !== 'all') {
      result = result.filter(setting => setting.category === categoryFilter.value)
    }
    
    return result
  })
  
  // Obtenir les paramètres par catégorie
  const getSettingsByCategory = (category) => {
    return filteredSettings.value.filter(setting => setting.category === category)
  }
  
  // Formater la valeur pour l'affichage
  const formatValueForDisplay = (value) => {
    if (typeof value === 'object') {
      return JSON.stringify(value, null, 2)
    }
    return value
  }
  
  // Validation de la valeur JSON
  const validateJsonValue = (value) => {
    try {
      JSON.parse(value)
      valueError.value = ''
      return true
    } catch (e) {
      valueError.value = 'Format JSON invalide'
      return false
    }
  }
  
  // Éditer un paramètre
  const editSetting = (setting) => {
    formData.value = {
      id: setting.id,
      key: setting.key,
      value: typeof setting.value === 'object' ? JSON.stringify(setting.value, null, 2) : setting.value,
      description: setting.description || '',
      is_public: setting.is_public,
      category: setting.category || 'other'
    }
    showEditSettingModal.value = true
  }
  
  // Confirmer la suppression
  const confirmDelete = (setting) => {
    deleteTargetId.value = setting.id
    deleteTargetKey.value = setting.key
    showDeleteModal.value = true
  }
  
  // Réinitialiser le formulaire
  const resetForm = () => {
    formData.value = {
      key: '',
      value: '',
      description: '',
      is_public: false,
      category: 'site'
    }
    valueError.value = ''
  }
  
  // Fermer les modales
  const closeModal = () => {
    showAddSettingModal.value = false
    showEditSettingModal.value = false
    resetForm()
  }
  
  // Afficher un message de statut
  const showStatusMessage = (type, message, duration = 5000) => {
    statusMessage.value = {
      show: true,
      type,
      message
    }
    
    setTimeout(() => {
      statusMessage.value.show = false
    }, duration)
  }
  


  
//   const filteredSettings = computed(() => {
//     let result = [...settings.value]
    
//     // Filtre par recherche
//     if (search.value) {
//       const searchLower = search.value.toLowerCase()
//       result = result.filter(setting => 
//         setting.key.toLowerCase().includes(searchLower) || 
//         (setting.description && setting.description.toLowerCase().includes(searchLower))
//       )
//     }
    
//     // Filtre par visibilité
//     if (visibilityFilter.value === 'public') {
//       result = result.filter(setting => setting.is_public)
//     } else if (visibilityFilter.value === 'private') {
//       result = result.filter(setting => !setting.is_public)
//     }
    
//     return result
//   })
  
  const formatValue = (value) => {
    if (typeof value === 'object') {
      return JSON.stringify(value)
    }
    return value
  }
  
//   const validateJsonValue = (value) => {
//     try {
//       JSON.parse(value)
//       valueError.value = ''
//       return true
//     } catch (e) {
//       valueError.value = 'Format JSON invalide'
//       return false
//     }
//   }
  
//   const editSetting = (setting) => {
//     formData.value = {
//       id: setting.id,
//       key: setting.key,
//       value: typeof setting.value === 'object' ? JSON.stringify(setting.value, null, 2) : setting.value,
//       description: setting.description || '',
//       is_public: setting.is_public
//     }
//     showEditSettingModal.value = true
//   }
  
//   const confirmDelete = (setting) => {
//     deleteTargetId.value = setting.id
//     deleteTargetKey.value = setting.key
//     showDeleteModal.value = true
//   }
  
//   const resetForm = () => {
//     formData.value = {
//       key: '',
//       value: '',
//       description: '',
//       is_public: false
//     }
//     valueError.value = ''
//   }
  
//   const closeModal = () => {
//     showAddSettingModal.value = false
//     showEditSettingModal.value = false
//     resetForm()
//   }
  
//   const showStatusMessage = (type, message, duration = 5000) => {
//     statusMessage.value = {
//       show: true,
//       type,
//       message
//     }
    
//     setTimeout(() => {
//       statusMessage.value.show = false
//     }, duration)
//   }
  
  const saveSetting = async () => {
    // Validation
    if (!formData.value.key) {
      return showStatusMessage('error', 'La clé est requise')
    }
    
    if (!formData.value.value || !validateJsonValue(formData.value.value)) {
      return
    }
    
    isSaving.value = true
    
    try {
      // Préparer les données
      const settingData = {
        key: formData.value.key,
        value: JSON.parse(formData.value.value),
        description: formData.value.description,
        is_public: formData.value.is_public
      }
      
      if (showEditSettingModal.value) {
        // Mise à jour d'un paramètre existant
        const { error } = await supabase
          .from('app_settings')
          .update(settingData)
          .eq('id', formData.value.id)
        
        if (error) throw error
        
        showStatusMessage('success', 'Paramètre mis à jour avec succès')
      } else {
        // Ajout d'un nouveau paramètre
        const { error } = await supabase
          .from('app_settings')
          .insert([settingData])
        
        if (error) throw error
        
        showStatusMessage('success', 'Paramètre ajouté avec succès')
      }
      
      // Rafraîchir la liste et fermer le modal
      await fetchSettings()
      closeModal()
    } catch (error) {
      console.error('Erreur lors de la sauvegarde:', error)
      showStatusMessage('error', 'Erreur lors de la sauvegarde du paramètre')
    } finally {
      isSaving.value = false
    }
  }
  
  const deleteSetting = async () => {
    isDeleting.value = true
    
    try {
      const { error } = await supabase
        .from('app_settings')
        .delete()
        .eq('id', deleteTargetId.value)
      
      if (error) throw error
      
      showStatusMessage('success', 'Paramètre supprimé avec succès')
      showDeleteModal.value = false
      await fetchSettings()
    } catch (error) {
      console.error('Erreur lors de la suppression:', error)
      showStatusMessage('error', 'Erreur lors de la suppression du paramètre')
    } finally {
      isDeleting.value = false
    }
  }
  
  // Initialisation
  onMounted(() => {
    fetchSettings()
  })
  </script>