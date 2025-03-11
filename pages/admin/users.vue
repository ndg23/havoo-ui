<template>
  <div class="space-y-6 max-w-7xl mx-auto">
    <!-- En-tête avec style Twitter -->
    <div class="px-4 py-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Gestion des utilisateurs</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les utilisateurs, experts et administrateurs de la plateforme</p>
    </div>
    
    <!-- Notifications -->
    <div 
      v-if="notification.show" 
      class="mx-4 p-4 rounded-xl flex items-start gap-3"
      :class="[
        notification.type === 'success' ? 'bg-green-50 text-green-800 dark:bg-green-900/20 dark:text-green-400' : 
        notification.type === 'error' ? 'bg-red-50 text-red-800 dark:bg-red-900/20 dark:text-red-400' : 
        'bg-blue-50 text-blue-800 dark:bg-blue-900/20 dark:text-blue-400'
      ]"
    >
      <component 
        :is="notification.type === 'success' ? 'CheckCircle' : notification.type === 'error' ? 'AlertTriangle' : 'Info'" 
        class="h-5 w-5 mt-0.5 flex-shrink-0" 
      />
      <div>
        <h3 class="font-medium">{{ notification.title }}</h3>
        <p class="text-sm opacity-80 mt-0.5">{{ notification.message }}</p>
      </div>
      <button 
        @click="notification.show = false" 
        class="ml-auto p-1.5 rounded-full hover:bg-black/5 dark:hover:bg-white/5"
      >
        <X class="h-4 w-4" />
      </button>
    </div>
    
    <!-- Statistiques rapides -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div 
        v-for="stat in stats" 
        :key="stat.label"
        class="bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-100 dark:border-gray-700"
      >
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ stat.label }}</p>
            <p class="text-2xl font-bold text-gray-900 dark:text-white mt-1">{{ stat.value }}</p>
          </div>
          <div 
            class="h-12 w-12 rounded-full flex items-center justify-center"
            :class="stat.colorClass"
          >
            <component :is="stat.icon" class="h-6 w-6 text-white" />
          </div>
        </div>
      </div>
    </div>
    
    <!-- Filtres et actions -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-5">
      <div class="flex flex-wrap gap-4 items-center justify-between">
        <div class="flex flex-wrap gap-3">
          <!-- Recherche -->
          <div class="relative">
            <Search class="absolute left-3 top-2.5 h-5 w-5 text-gray-400" />
            <input 
              v-model="search"
              type="text"
              placeholder="Rechercher un utilisateur..."
              class="pl-10 pr-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white w-60"
            />
          </div>
          
          <!-- Filtre de rôle -->
          <select 
            v-model="roleFilter"
            class="px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
          >
            <option value="all">Tous les rôles</option>
            <option value="expert">Experts</option>
            <option value="client">Clients</option>
            <option value="admin">Administrateurs</option>
          </select>
          
          <!-- Filtre de statut de vérification -->
          <select 
            v-model="verificationFilter"
            class="px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
          >
            <option value="all">Tous les statuts</option>
            <option value="verified">Vérifiés</option>
            <option value="pending">En attente</option>
            <option value="rejected">Rejetés</option>
          </select>
        </div>
        
        <!-- Actions -->
        <div class="flex items-center gap-2">
          <button 
            @click="resetFilters"
            class="flex items-center p-2.5 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-full hover:bg-gray-50 dark:hover:bg-gray-700"
            title="Réinitialiser les filtres"
          >
            <RefreshCw class="h-5 w-5" />
          </button>
          <button 
            @click="exportData"
            class="flex items-center p-2.5 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-full hover:bg-gray-50 dark:hover:bg-gray-700"
            title="Exporter"
          >
            <Download class="h-5 w-5" />
          </button>
          <button 
            @click="refreshData"
            class="flex items-center p-2.5 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-full hover:bg-gray-50 dark:hover:bg-gray-700"
            title="Rafraîchir"
          >
            <RefreshCw class="h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
    
    <!-- Liste des utilisateurs -->
    <div v-if="isLoading" class="flex justify-center p-12">
      <div class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
    </div>
    
    <div v-else-if="filteredUsers.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-100 dark:border-gray-700">
      <div class="inline-flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
        <Users class="h-8 w-8 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun utilisateur trouvé</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-4">
        Essayez de modifier vos filtres pour trouver ce que vous cherchez.
      </p>
      <button 
        @click="resetFilters"
        class="inline-flex items-center justify-center px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700"
      >
        <RefreshCw class="h-4 w-4 mr-2" />
        Réinitialiser les filtres
      </button>
    </div>
    
    <div v-else class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden">
      <!-- Table des utilisateurs -->
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
          <thead class="bg-gray-50 dark:bg-gray-800">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Utilisateur
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Rôle
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Statut
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Date d'inscription
              </th>
              <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
            <tr v-for="user in paginatedUsers" :key="user.id" class="hover:bg-gray-50 dark:hover:bg-gray-750">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center">
                  <div class="flex-shrink-0 h-10 w-10 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center overflow-hidden">
                    <img 
                      v-if="user.avatar_url" 
                      :src="user.avatar_url" 
                alt="Avatar" 
                class="h-full w-full object-cover"
              />
                    <UserIcon 
                      v-else 
                      class="h-5 w-5 text-primary-600 dark:text-primary-400" 
                    />
            </div>
                  <div class="ml-4">
                    <div class="text-sm font-medium text-gray-900 dark:text-white">
                      {{ user.first_name || '' }} {{ user.last_name || '' }}
            </div>
                    <div class="text-sm text-gray-500 dark:text-gray-400">
                      {{ user.email }}
          </div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
            <span 
              class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
              :class="getRoleClass(user.role)"
            >
              {{ formatRole(user.role) }}
            </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div v-if="user.role === 'expert'">
            <span 
              class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
                    :class="getVerificationStatusClass(user.verification_status)"
                  >
                    <component 
                      :is="getVerificationIcon(user.verification_status)" 
                      class="h-3.5 w-3.5 mr-1"
                    />
                    {{ user.verification_status === 'approved' ? 'Vérifié' : 
                       user.verification_status === 'pending' ? 'En attente' : 
                       user.verification_status === 'rejected' ? 'Rejeté' : 'Non vérifié' }}
            </span>
          </div>
                <span v-else class="text-sm text-gray-500 dark:text-gray-400">-</span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
            {{ formatDate(user.created_at) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <div class="flex justify-end space-x-2">
            <button 
                    @click="viewUserProfile(user)"
                    class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300"
              title="Voir le profil"
            >
                    <Eye class="h-5 w-5" />
            </button>
            <button 
                    v-if="user.role === 'expert' && user.verification_status !== 'approved'"
              @click="openVerificationModal(user)"
                    class="text-primary-500 hover:text-primary-700 dark:text-primary-400 dark:hover:text-primary-300"
              title="Vérifier l'expert"
            >
                    <UserCheck class="h-5 w-5" />
            </button>
            <button 
                    @click="openEditRoleModal(user)"
                    class="text-amber-500 hover:text-amber-700 dark:text-amber-400 dark:hover:text-amber-300"
              title="Modifier le rôle"
            >
              <UserCog class="h-5 w-5" />
            </button>
          </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <!-- Pagination -->
      <div class="px-6 py-3 flex items-center justify-between border-t border-gray-200 dark:border-gray-700">
        <div class="flex-1 flex justify-between sm:hidden">
          <button
            @click="currentPage > 1 ? currentPage-- : null"
            :disabled="currentPage === 1"
            class="relative inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Précédent
          </button>
          <button
            @click="currentPage < totalPages ? currentPage++ : null"
            :disabled="currentPage === totalPages"
            class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Suivant
          </button>
        </div>
        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
          <div>
            <p class="text-sm text-gray-700 dark:text-gray-300">
              Affichage de <span class="font-medium">{{ paginatedUsers.length }}</span> utilisateur(s) sur <span class="font-medium">{{ filteredUsers.length }}</span> au total
            </p>
          </div>
          <div>
            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
          <button 
                @click="currentPage > 1 ? currentPage-- : null"
            :disabled="currentPage === 1"
                class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
          >
                <span class="sr-only">Précédent</span>
            <ChevronLeft class="h-5 w-5" />
          </button>
          <button 
            v-for="page in visiblePages" 
            :key="page"
                @click="page !== '...' ? currentPage = page : null"
                :disabled="page === '...' || page === currentPage"
                :class="[
                  'relative inline-flex items-center px-4 py-2 border text-sm font-medium',
                  page === currentPage
                    ? 'z-10 bg-primary-50 dark:bg-primary-900/30 border-primary-500 dark:border-primary-500 text-primary-600 dark:text-primary-400'
                    : 'bg-white dark:bg-gray-800 border-gray-300 dark:border-gray-600 text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700',
                  page === '...' ? 'cursor-default' : ''
                ]"
          >
            {{ page }}
          </button>
          <button 
                @click="currentPage < totalPages ? currentPage++ : null"
                :disabled="currentPage === totalPages || totalPages === 0"
                class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <span class="sr-only">Suivant</span>
            <ChevronRight class="h-5 w-5" />
          </button>
            </nav>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal de vérification d'expert -->
    <teleport to="body">
      <div v-if="showVerificationModal" class="fixed inset-0 overflow-y-auto z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
          <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" @click="showVerificationModal = false"></div>
          <div class="relative bg-white dark:bg-gray-800 rounded-lg max-w-lg w-full mx-auto shadow-xl overflow-hidden">
            <div class="flex justify-between items-center p-4 border-b border-gray-200 dark:border-gray-700">
              <h3 class="text-lg font-medium text-gray-900 dark:text-white">
                Vérification d'expert
              </h3>
              <button @click="showVerificationModal = false" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                <X class="h-5 w-5" />
              </button>
            </div>
            
            <div class="p-6 space-y-4">
              <div class="flex items-center mb-4">
                <div class="flex-shrink-0 h-12 w-12 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center overflow-hidden">
                  <img 
                    v-if="selectedUser?.avatar_url" 
                    :src="selectedUser.avatar_url" 
                alt="Avatar" 
                class="h-full w-full object-cover"
              />
                  <UserIcon 
                    v-else 
                    class="h-6 w-6 text-primary-600 dark:text-primary-400" 
                  />
            </div>
                <div class="ml-4">
                  <h4 class="text-lg font-medium text-gray-900 dark:text-white">
                    {{ selectedUser?.first_name }} {{ selectedUser?.last_name }}
                  </h4>
                  <p class="text-sm text-gray-500 dark:text-gray-400">
                    {{ selectedUser?.email }}
                  </p>
            </div>
          </div>
          
            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Notes de vérification
                </label>
                <textarea
                  v-model="verificationNotes"
                  rows="3"
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                  placeholder="Notes concernant cette vérification..."
                ></textarea>
              </div>
            </div>
            
            <div class="p-4 border-t border-gray-200 dark:border-gray-700 flex justify-end space-x-3">
              <button
                @click="showVerificationModal = false"
                class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700"
              >
                Annuler
              </button>
              <button
                @click="rejectExpert"
                class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                :disabled="isVerifying"
              >
                <span v-if="isVerifying">
                  <RefreshCw class="animate-spin -ml-1 mr-2 h-4 w-4 inline-block" />
                </span>
                Rejeter
              </button>
              <button
                @click="approveExpert"
                class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
                :disabled="isVerifying"
              >
                <span v-if="isVerifying">
                  <RefreshCw class="animate-spin -ml-1 mr-2 h-4 w-4 inline-block" />
                </span>
                Approuver
              </button>
              </div>
            </div>
        </div>
      </div>
    </teleport>
    
    <!-- Modal d'édition de rôle -->
    <teleport to="body">
      <div v-if="showRoleModal" class="fixed inset-0 overflow-y-auto z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
          <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" @click="showRoleModal = false"></div>
          <div class="relative bg-white dark:bg-gray-800 rounded-lg max-w-md w-full mx-auto shadow-xl overflow-hidden">
            <div class="flex justify-between items-center p-4 border-b border-gray-200 dark:border-gray-700">
              <h3 class="text-lg font-medium text-gray-900 dark:text-white">
                Modifier le rôle
              </h3>
              <button @click="showRoleModal = false" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                <X class="h-5 w-5" />
              </button>
            </div>
            
            <div class="p-6">
              <div class="flex items-center mb-4">
                <div class="flex-shrink-0 h-12 w-12 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center overflow-hidden">
                  <img 
                    v-if="selectedUser?.avatar_url" 
                    :src="selectedUser.avatar_url" 
                    alt="Avatar"
                    class="h-full w-full object-cover"
                  />
                  <UserIcon 
                    v-else 
                    class="h-6 w-6 text-primary-600 dark:text-primary-400" 
                  />
                </div>
                <div class="ml-4">
                  <h4 class="text-lg font-medium text-gray-900 dark:text-white">
                    {{ selectedUser?.first_name }} {{ selectedUser?.last_name }}
                  </h4>
                  <p class="text-sm text-gray-500 dark:text-gray-400">
                    {{ selectedUser?.email }}
                  </p>
                </div>
            </div>
            
              <div class="space-y-4">
            <div>
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                    Rôle
                  </label>
                  <select 
                    v-model="selectedRole"
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                  >
                    <option value="client">Client</option>
                    <option value="expert">Expert</option>
                    <option value="admin">Administrateur</option>
                  </select>
                    </div>
                  </div>
            </div>
            
            <div class="p-4 border-t border-gray-200 dark:border-gray-700 flex justify-end space-x-3">
                  <button 
                @click="showRoleModal = false"
                class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700"
              >
                Annuler
              </button>
              <button
                @click="updateUserRole"
                class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
                :disabled="isUpdatingRole"
              >
                <span v-if="isUpdatingRole">
                  <RefreshCw class="animate-spin -ml-1 mr-2 h-4 w-4 inline-block" />
                </span>
                Enregistrer
                  </button>
                </div>
                </div>
              </div>
            </div>
    </teleport>
    
    <!-- Modal de profil utilisateur -->
    <teleport to="body">
      <div v-if="showProfileModal" class="fixed inset-0 overflow-y-auto z-50">
        <div class="flex items-center justify-center min-h-screen p-4">
          <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" @click="showProfileModal = false"></div>
          <div class="relative bg-white dark:bg-gray-800 rounded-lg max-w-2xl w-full mx-auto shadow-xl overflow-hidden">
            <div class="flex justify-between items-center p-4 border-b border-gray-200 dark:border-gray-700">
              <h3 class="text-lg font-medium text-gray-900 dark:text-white">
                Profil utilisateur
              </h3>
              <button @click="showProfileModal = false" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                <X class="h-5 w-5" />
              </button>
            </div>
            
            <div class="p-6">
              <div class="flex flex-col sm:flex-row items-center sm:items-start mb-6">
                <div class="flex-shrink-0 h-24 w-24 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center overflow-hidden mb-4 sm:mb-0">
                  <img 
                    v-if="selectedUser?.avatar_url" 
                    :src="selectedUser.avatar_url" 
                    alt="Avatar"
                    class="h-full w-full object-cover"
                  />
                  <UserIcon 
                    v-else 
                    class="h-10 w-10 text-primary-600 dark:text-primary-400" 
                  />
                </div>
                <div class="sm:ml-6 text-center sm:text-left">
                  <h4 class="text-xl font-bold text-gray-900 dark:text-white">
                    {{ selectedUser?.first_name }} {{ selectedUser?.last_name }}
                  </h4>
                  <div class="flex flex-wrap justify-center sm:justify-start gap-2 mt-2">
                    <span 
                      class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
                      :class="getRoleClass(selectedUser?.role)"
                    >
                      {{ formatRole(selectedUser?.role) }}
                    </span>
                    <span 
                      v-if="selectedUser?.role === 'expert'"
                      class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
                      :class="getVerificationStatusClass(selectedUser?.verification_status)"
                    >
                      <component 
                        :is="getVerificationIcon(selectedUser?.verification_status)" 
                        class="h-3.5 w-3.5 mr-1"
                      />
                      {{ selectedUser?.verification_status === 'approved' ? 'Vérifié' : 
                         selectedUser?.verification_status === 'pending' ? 'En attente' : 
                         selectedUser?.verification_status === 'rejected' ? 'Rejeté' : 'Non vérifié' }}
                    </span>
                  </div>
                  <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                    {{ selectedUser?.email }}
                  </p>
                  <p v-if="selectedUser?.phone" class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                    {{ selectedUser.phone }}
                  </p>
                </div>
              </div>
              
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                  <h5 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Informations personnelles</h5>
                  <div class="bg-gray-50 dark:bg-gray-750 rounded-lg p-4 space-y-3">
                    <div>
                      <span class="text-xs text-gray-500 dark:text-gray-400 block">Inscrit le</span>
                      <span class="text-sm text-gray-900 dark:text-white">{{ formatDate(selectedUser?.created_at) }}</span>
            </div>
                    <div>
                      <span class="text-xs text-gray-500 dark:text-gray-400 block">Dernière connexion</span>
                      <span class="text-sm text-gray-900 dark:text-white">{{ formatDate(selectedUser?.last_sign_in_at) }}</span>
                    </div>
                    <div>
                      <span class="text-xs text-gray-500 dark:text-gray-400 block">Localisation</span>
                      <span class="text-sm text-gray-900 dark:text-white">{{ selectedUser?.location || 'Non spécifiée' }}</span>
          </div>
        </div>
      </div>
      
                <div>
                  <h5 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Activité</h5>
                  <div class="bg-gray-50 dark:bg-gray-750 rounded-lg p-4 space-y-3">
                    <div>
                      <span class="text-xs text-gray-500 dark:text-gray-400 block">Demandes</span>
                      <span class="text-sm text-gray-900 dark:text-white">{{ selectedUser?.requests_count || 0 }}</span>
                    </div>
                    <div>
                      <span class="text-xs text-gray-500 dark:text-gray-400 block">Propositions</span>
                      <span class="text-sm text-gray-900 dark:text-white">{{ selectedUser?.proposals_count || 0 }}</span>
                    </div>
                    <div>
                      <span class="text-xs text-gray-500 dark:text-gray-400 block">Évaluations</span>
                      <span class="text-sm text-gray-900 dark:text-white">{{ selectedUser?.reviews_count || 0 }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="p-4 border-t border-gray-200 dark:border-gray-700 flex justify-end">
            <button 
                @click="showProfileModal = false"
                class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700"
              >
                Fermer
            </button>
          </div>
        </div>
      </div>
      </div>
    </teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { 
  User, Users as UsersIcon, CheckCircle, XCircle, Search, 
  AlertTriangle, Filter, Download, RefreshCw, MoreVertical,
  Check as CheckIcon, X as XIcon, Eye as EyeIcon, Edit as EditIcon, 
  Trash2 as Trash2Icon, UserCheck, BadgeCheck, Info, 
  File as DocumentIcon, UserPlus, Download as DownloadIcon
} from 'lucide-vue-next'
import AdminModal from '~/components/admin/AdminModal.vue'

const supabase = useSupabaseClient()

// États
const users = ref([])
const isLoading = ref(true)
const search = ref('')
const roleFilter = ref('all')
const verificationFilter = ref('all')
const currentPage = ref(1)
const itemsPerPage = ref(10)
const selectedUser = ref(null)
const showVerificationModal = ref(false)
const showProfileModal = ref(false)
const verificationNotes = ref('')
const isVerifying = ref(false)

// Notification
const notification = ref({
  show: false,
  type: 'info',
  title: '',
  message: '',
})

// Statistiques
const stats = ref([
  { 
    label: 'Utilisateurs', 
    value: '0', 
    icon: UsersIcon, 
    colorClass: 'bg-blue-500 dark:bg-blue-600' 
  },
  { 
    label: 'Experts vérifiés', 
    value: '0', 
    icon: UserCheck, 
    colorClass: 'bg-green-500 dark:bg-green-600' 
  },
  { 
    label: 'En attente', 
    value: '0', 
    icon: AlertTriangle, 
    colorClass: 'bg-amber-500 dark:bg-amber-600' 
  },
  { 
    label: 'Nouveaux ce mois', 
    value: '0', 
    icon: UserPlus, 
    colorClass: 'bg-purple-500 dark:bg-purple-600' 
  }
])

// Pagination - pages visibles
const visiblePages = computed(() => {
  const totalPageCount = totalPages.value
  if (totalPageCount <= 7) {
    return Array.from({ length: totalPageCount }, (_, i) => i + 1)
  }
  
  // Logique pour afficher un nombre limité de pages avec des ellipses
  if (currentPage.value <= 3) {
    return [1, 2, 3, 4, 5, '...', totalPageCount]
  } else if (currentPage.value >= totalPageCount - 2) {
    return [1, '...', totalPageCount - 4, totalPageCount - 3, totalPageCount - 2, totalPageCount - 1, totalPageCount]
  } else {
    return [1, '...', currentPage.value - 1, currentPage.value, currentPage.value + 1, '...', totalPageCount]
  }
})

// Mettre à jour les statistiques
const updateStats = () => {
  if (!users.value.length) return
  
  // Total des utilisateurs
  stats.value[0].value = users.value.length.toString()
  
  // Experts vérifiés
  stats.value[1].value = users.value.filter(
    u => u.is_expert && u.verification_status === 'approved'
  ).length.toString()
  
  // En attente de vérification
  stats.value[2].value = users.value.filter(
    u => u.is_expert && u.verification_status === 'pending'
  ).length.toString()
  
  // Nouveaux ce mois
  const oneMonthAgo = new Date()
  oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1)
  stats.value[3].value = users.value.filter(
    u => new Date(u.created_at) > oneMonthAgo
  ).length.toString()
}

// Filtrer les utilisateurs
const filteredUsers = computed(() => {
  let filtered = [...users.value]
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(user => 
      user.first_name?.toLowerCase().includes(searchLower) ||
      user.last_name?.toLowerCase().includes(searchLower) ||
      user.email?.toLowerCase().includes(searchLower)
    )
  }
  
  // Filtre de rôle
  if (roleFilter.value !== 'all') {
    if (roleFilter.value === 'expert') {
      filtered = filtered.filter(user => user.is_expert)
    } else if (roleFilter.value === 'client') {
      filtered = filtered.filter(user => !user.is_expert && !user.is_admin)
    } else if (roleFilter.value === 'admin') {
      filtered = filtered.filter(user => user.is_admin)
    }
  }
  
  // Filtre de vérification
  if (verificationFilter.value !== 'all') {
    if (verificationFilter.value === 'verified') {
      filtered = filtered.filter(user => user.verification_status === 'approved')
    } else if (verificationFilter.value === 'pending') {
      filtered = filtered.filter(user => user.verification_status === 'pending')
    } else if (verificationFilter.value === 'rejected') {
      filtered = filtered.filter(user => user.verification_status === 'rejected')
    }
  }
  
  return filtered
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredUsers.value.length / itemsPerPage.value))

const paginatedUsers = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredUsers.value.slice(start, end)
})

// Experts en attente de vérification
const pendingExperts = computed(() => 
  users.value.filter(u => u.is_expert && u.verification_status === 'pending')
)

// Méthodes
const showNotification = (type, title, message = '') => {
  notification.value = {
    show: true,
    type,
    title,
    message
  }
  
  // Masquer la notification après 5 secondes
  setTimeout(() => {
    notification.value.show = false
  }, 5000)
}

// Formater la taille des fichiers
const formatBytes = (bytes, decimals = 2) => {
  if (bytes === 0) return '0 Bytes'
  
  const k = 1024
  const dm = decimals < 0 ? 0 : decimals
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
  
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  
  return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]
}

// Formater une date
const formatDate = (dateString) => {
  if (!dateString) return 'Non spécifiée'
  
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Charger les utilisateurs
const fetchUsers = async () => {
  isLoading.value = true
  
  try {
    // Récupérer les utilisateurs depuis Supabase
    const { data, error } = await supabase
      .from('profiles')
      .select(`
    *
      `)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    // Ajouter des documents fictifs pour les utilisateurs qui n'en ont pas
    users.value = data.map(user => {
      // S'il n'y a pas de documents réels, on ajoute des données fictives pour la démo
      if (!user.documents || user.documents.length === 0 && user.is_expert) {
        return {
          ...user,
          documents: user.verification_status === 'pending' ? [
            { id: 1, name: 'CV_Professionnel.pdf', size: 2345678, url: '#', type: 'pdf' },
            { id: 2, name: 'Diplome_Formation.pdf', size: 1234567, url: '#', type: 'pdf' },
            { id: 3, name: 'Attestation_Experience.pdf', size: 876543, url: '#', type: 'pdf' }
          ] : []
        }
      }
      return user
    })
    
    // Ajouter des compétences pour la démo si l'utilisateur n'en a pas
    users.value = users.value.map(user => {
      if (user.is_expert && (!user.skills || user.skills.length === 0)) {
        return {
          ...user,
          skills: ['Plomberie', 'Électricité', 'Menuiserie', 'Peinture'].slice(0, Math.floor(Math.random() * 4) + 1),
          experience: user.experience || "Plus de 5 ans d'expérience dans le secteur du bâtiment. Spécialiste en rénovation d'intérieur."
        }
      }
      return user
    })
    
    // Mettre à jour les statistiques
    updateStats()
  } catch (err) {
    console.error('Erreur lors du chargement des utilisateurs:', err)
    showNotification('error', 'Erreur', 'Impossible de charger la liste des utilisateurs.')
  } finally {
    isLoading.value = false
  }
}

// Initialisation
onMounted(fetchUsers)

// Réinitialiser la pagination quand les filtres changent
watch([search, roleFilter, verificationFilter], () => {
  currentPage.value = 1
})

// Formater le rôle pour l'affichage
const formatRole = (role) => {
  if (!role) {
    // Déterminer le rôle à partir des booléens
    if (selectedUser.value?.is_admin) return 'Admin'
    if (selectedUser.value?.is_expert) return 'Expert'
    return 'Client'
  }
  
  switch (role) {
    case 'admin': return 'Admin'
    case 'expert': return 'Expert'
    case 'client': return 'Client'
    default: return role
  }
}

// Obtenir la classe CSS pour le rôle
const getRoleClass = (role) => {
  if (!role) {
    // Déterminer le rôle à partir des booléens
    if (selectedUser.value?.is_admin) return 'bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-400'
    if (selectedUser.value?.is_expert) return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'
  }
  
  switch (role) {
    case 'admin':
      return 'bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-400'
    case 'expert':
      return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400'
    case 'client':
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'
  }
}

// Obtenir la classe CSS pour le statut de vérification
const getVerificationStatusClass = (status) => {
  switch (status) {
    case 'approved':
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'pending':
      return 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'
    case 'rejected':
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default:
      return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'
  }
}

// Obtenir la classe CSS pour l'icône de vérification
const getVerificationClass = (status) => {
  switch (status) {
    case 'approved':
      return 'text-green-500 dark:text-green-400'
    case 'pending':
      return 'text-amber-500 dark:text-amber-400'
    case 'rejected':
      return 'text-red-500 dark:text-red-400'
    default:
      return 'text-gray-400 dark:text-gray-500'
  }
}

// Obtenir l'icône de vérification en fonction du statut
const getVerificationIcon = (status) => {
  switch (status) {
    case 'approved':
      return BadgeCheck
    case 'pending':
      return Clock
    case 'rejected':
      return XCircle
    default:
      return HelpCircle
  }
}

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = ''
  roleFilter.value = 'all'
  verificationFilter.value = 'all'
  currentPage.value = 1
}

// Exporter les utilisateurs
const exportData = () => {
  // Implémenter l'export CSV/Excel ici
  alert('La fonctionnalité d\'export sera bientôt disponible')
}

// Rafraîchir les données
const refreshData = async () => {
  await fetchUsers()
  showNotification('success', 'Données actualisées', 'La liste des utilisateurs a été mise à jour.')
}

definePageMeta({
  layout: 'admin',
})
</script>

<style scoped>
/* Pour des styles spécifiques si nécessaire */
</style> 