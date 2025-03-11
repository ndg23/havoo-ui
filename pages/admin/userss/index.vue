<template>
  <div class="max-w-7xl mx-auto px-4 py-8">
    <!-- En-tête de la page -->
    <div class="flex justify-between items-center mb-8">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Gestion des utilisateurs</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Vérification des comptes experts et modération des utilisateurs</p>
      </div>
    </div>
    
    <!-- Alerte de statut -->
    <!-- <ErrorAlert 
      v-if="statusMessage.show"
      :type="statusMessage.type"
      :message="statusMessage.message"
      dismissible
      @dismiss="statusMessage.show = false"
      class="mb-6"
    /> -->
    
    <!-- Filtres et recherche -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-6 mb-8 shadow-sm">
      <div class="flex flex-wrap gap-4 items-end">
        <div class="flex-1 min-w-[250px]">
          <label for="search" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Rechercher</label>
          <div class="relative">
            <input
              v-model="search"
              type="text"
              id="search"
              placeholder="Nom, email, ville..."
              class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white pl-10"
            />
            <Search class="absolute left-3 top-3 h-4 w-4 text-gray-400" />
          </div>
        </div>
        
        <div class="w-44">
          <label for="role" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Rôle</label>
          <select
            v-model="roleFilter"
            id="role"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="all">Tous les rôles</option>
            <option value="client">Clients</option>
            <option value="expert">Experts</option>
            <option value="admin">Administrateurs</option>
          </select>
        </div>
        
        <div class="w-48">
          <label for="status" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Statut</label>
          <select
            v-model="statusFilter"
            id="status"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="all">Tous les statuts</option>
            <option value="active">Actifs</option>
            <option value="pending">En attente de vérification</option>
            <option value="blocked">Bloqués</option>
            <option value="unverified">Non vérifiés</option>
          </select>
        </div>
        
        <div class="w-52">
          <label for="sort" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Trier par</label>
          <select
            v-model="sortOption"
            id="sort"
            class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
          >
            <option value="recent">Plus récents</option>
            <option value="oldest">Plus anciens</option>
            <option value="name">Nom (A-Z)</option>
            <option value="name_desc">Nom (Z-A)</option>
          </select>
        </div>
      </div>
    </div>
    
    <!-- Section de chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 animate-pulse shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement des utilisateurs...</p>
      </div>
    </div>
    
    <!-- Message si aucun résultat -->
    <div v-else-if="filteredUsers.length === 0" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 text-center shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <UserX class="h-12 w-12 text-gray-400 mb-3" />
        <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">Aucun utilisateur trouvé</h3>
        <p class="text-gray-600 dark:text-gray-400">
          {{ search ? `Aucun résultat pour "${search}"` : 'Aucun utilisateur disponible avec ces filtres' }}
        </p>
      </div>
    </div>
    
    <!-- Listes des utilisateurs -->
    <div v-if="!isLoading && filteredUsers.length > 0" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
      <!-- En-tête du tableau -->
      <div class="bg-gray-50 dark:bg-gray-700 px-6 py-3 border-b border-gray-200 dark:border-gray-700 grid grid-cols-12 gap-4 text-left">
        <div class="col-span-5 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
          Utilisateur
        </div>
        <div class="col-span-2 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
          Rôle
        </div>
        <div class="col-span-2 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
          Statut
        </div>
        <div class="col-span-3 text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider text-right">
          Actions
        </div>
      </div>
      
      <!-- Liste des utilisateurs -->
      <div class="divide-y divide-gray-200 dark:divide-gray-700">
        <div 
          v-for="user in paginatedUsers" 
          :key="user.id"
          class="px-6 py-4 grid grid-cols-12 gap-4 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
        >
          <!-- Colonne utilisateur -->
          <div class="col-span-5 flex items-center">
            <div class="flex-shrink-0 relative">
              <div v-if="!user.avatar_url" class="h-10 w-10 bg-primary-100 dark:bg-primary-900/50 text-primary-700 dark:text-primary-300 flex items-center justify-center rounded-full">
                {{ getInitials(user.first_name, user.last_name) }}
              </div>
              <img 
                v-else 
                :src="user.avatar_url" 
                :alt="user.first_name + ' ' + user.last_name"
                class="h-10 w-10 rounded-full object-cover"
              />
              <div 
                v-if="user.is_online" 
                class="absolute -bottom-0.5 -right-0.5 h-3 w-3 bg-green-500 rounded-full border-2 border-white dark:border-gray-800"
              ></div>
            </div>
            <div class="ml-4">
              <div class="font-medium text-gray-900 dark:text-white">
                {{ user.first_name }} {{ user.last_name }}
              </div>
              <div class="text-sm text-gray-500 dark:text-gray-400">
                {{ user.email }}
              </div>
            </div>
          </div>
          
          <!-- Rôle -->
          <div class="col-span-2 flex items-center">
            <span 
              :class="[
                'px-2.5 py-1 rounded-full text-xs font-medium',
                user.role === 'admin' ? 'bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-300' : '',
                user.role === 'expert' ? 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-300' : '',
                user.role === 'client' || !user.role ? 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300' : '',
              ]"
            >
              {{ formatRole(user.role || 'client') }}
            </span>
          </div>
          
          <!-- Vérification -->
          <div class="col-span-2 flex items-center">
            <span 
              :class="[
                'px-2.5 py-1 rounded-full text-xs font-medium',
                user.verification_status === 'verified' ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-300' : '',
                user.verification_status === 'pending' ? 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-300' : '',
                user.verification_status === 'rejected' ? 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-300' : '',
                !user.verification_status ? 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300' : '',
              ]"
            >
              {{ formatVerificationStatus(user.verification_status || 'none') }}
            </span>
          </div>
          
          <!-- Statut -->
          <div class="col-span-1 flex items-center">
            <span 
              :class="[
                'flex items-center text-sm font-medium',
                user.is_blocked ? 'text-red-600 dark:text-red-400' : 'text-green-600 dark:text-green-400'
              ]"
            >
              <div 
                class="h-2 w-2 rounded-full mr-1.5"
                :class="user.is_blocked ? 'bg-red-500' : 'bg-green-500'"
              ></div>
              {{ user.is_blocked ? 'Bloqué' : 'Actif' }}
            </span>
          </div>
          
          <!-- Actions -->
          <div class="col-span-3 flex items-center justify-end space-x-2">
            <!-- Voir le profil -->
            <button 
              @click="viewProfile(user.id)"
              class="p-1.5 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
              title="Voir le profil"
            >
              <User class="h-5 w-5" />
            </button>
            
            <!-- Vérifier le compte (pour les experts en attente) -->
            <button 
              v-if="user.role === 'expert' && user.verification_status === 'pending'"
              @click="openVerificationModal(user)"
              class="p-1.5 text-blue-500 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 rounded-full hover:bg-blue-50 dark:hover:bg-blue-900/30 transition-colors"
              title="Vérifier le compte"
            >
              <CheckCircle class="h-5 w-5" />
            </button>
            
            <!-- Modifier l'utilisateur -->
            <button 
              @click="editUser(user)"
              class="p-1.5 text-indigo-500 dark:text-indigo-400 hover:text-indigo-700 dark:hover:text-indigo-300 rounded-full hover:bg-indigo-50 dark:hover:bg-indigo-900/30 transition-colors"
              title="Modifier"
            >
              <Edit class="h-5 w-5" />
            </button>
            
            <!-- Bloquer/Débloquer l'utilisateur -->
            <button 
              v-if="user.is_blocked"
              @click="confirmUnblock(user)"
              class="p-1.5 text-green-500 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300 rounded-full hover:bg-green-50 dark:hover:bg-green-900/30 transition-colors"
              title="Débloquer l'utilisateur"
            >
              <Unlock class="h-5 w-5" />
            </button>
            <button 
              v-else
              @click="confirmBlock(user)"
              class="p-1.5 text-orange-500 dark:text-orange-400 hover:text-orange-700 dark:hover:text-orange-300 rounded-full hover:bg-orange-50 dark:hover:bg-orange-900/30 transition-colors"
              title="Bloquer l'utilisateur"
            >
              <Lock class="h-5 w-5" />
            </button>
            
            <!-- Supprimer l'utilisateur -->
            <button 
              @click="confirmDelete(user)"
              class="p-1.5 text-red-500 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300 rounded-full hover:bg-red-50 dark:hover:bg-red-900/30 transition-colors"
              title="Supprimer"
            >
              <Trash class="h-5 w-5" />
            </button>
          </div>
        </div>
      </div>
      
      <!-- Pagination -->
      <div class="bg-gray-50 dark:bg-gray-700 px-6 py-4 border-t border-gray-200 dark:border-gray-700 flex items-center justify-between">
        <div class="text-sm text-gray-700 dark:text-gray-300">
          Affichage de <span class="font-medium">{{ startItem }}</span> à <span class="font-medium">{{ endItem }}</span> sur <span class="font-medium">{{ filteredUsers.length }}</span> utilisateurs
        </div>
        
        <div class="flex space-x-2">
          <button 
            @click="currentPage--"
            :disabled="currentPage === 1"
            class="px-3 py-1.5 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-full text-sm text-gray-700 dark:text-gray-300 font-medium disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Précédent
          </button>
          
          <button 
            @click="currentPage++"
            :disabled="currentPage >= totalPages"
            class="px-3 py-1.5 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-full text-sm text-gray-700 dark:text-gray-300 font-medium disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Suivant
          </button>
        </div>
      </div>
    </div>
    <UserModal 
        :isOpen="showUserModal"
        :user="userToEdit"
        @close="showUserModal = false"
      />
    <!-- Modal de vérification d'expert -->
    <Teleport to="body">
      <div v-if="showVerificationModal" class="fixed inset-0 bg-black/50 dark:bg-gray-900/70 flex items-center justify-center z-50 p-4">
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg max-w-4xl w-full max-h-[90vh] overflow-y-auto">
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center sticky top-0 bg-white dark:bg-gray-800 z-10">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white">Vérification du compte expert</h3>
            <button @click="showVerificationModal = false" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
              <X class="h-5 w-5" />
            </button>
          </div>
          
          <div class="p-6">
            <div v-if="selectedUser" class="space-y-6">
              <!-- Informations de base -->
              <div class="flex flex-col md:flex-row gap-6">
                <div class="w-24 h-24 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700 flex-shrink-0 mx-auto md:mx-0">
                  <img v-if="selectedUser.avatar_url" :src="selectedUser.avatar_url" alt="" class="h-full w-full object-cover">
                  <div v-else class="h-full w-full flex items-center justify-center bg-primary-100 dark:bg-primary-900/40 text-primary-700 dark:text-primary-300 text-2xl font-medium">
                    {{ getInitials(selectedUser.first_name, selectedUser.last_name) }}
                  </div>
                </div>
                
                <div class="flex-1 text-center md:text-left">
                  <h4 class="text-xl font-semibold text-gray-900 dark:text-white">
                    {{ selectedUser.first_name }} {{ selectedUser.last_name }}
                  </h4>
                  <p class="text-gray-600 dark:text-gray-400">{{ selectedUser.email }}</p>
                  <p class="text-gray-600 dark:text-gray-400 mt-1">
                    {{ selectedUser.phone || 'Aucun téléphone' }} • {{ selectedUser.city || 'N/A' }}, {{ selectedUser.country || 'N/A' }}
                  </p>
                  
                  <div class="mt-3 flex flex-wrap gap-2 justify-center md:justify-start">
                    <span class="px-2.5 py-1 bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-300 rounded-full text-xs font-medium">
                      {{ formatRole(selectedUser.role) }}
                    </span>
                    <span class="px-2.5 py-1 bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-300 rounded-full text-xs font-medium">
                      En attente de vérification
                    </span>
                  </div>
                </div>
              </div>
              
              <!-- Bio -->
              <div class="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-4">
                <h5 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">À propos</h5>
                <p class="text-gray-600 dark:text-gray-400 text-sm whitespace-pre-line">{{ selectedUser.bio || 'Aucune biographie fournie.' }}</p>
              </div>
              
              <!-- Documents de vérification -->
              <div>
                <h5 class="text-base font-medium text-gray-900 dark:text-white mb-3">Documents d'identité</h5>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <!-- Pièce d'identité (recto) -->
                  <div class="border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden">
                    <div class="px-3 py-2 bg-gray-50 dark:bg-gray-700 border-b border-gray-200 dark:border-gray-700 text-xs font-medium text-gray-700 dark:text-gray-300">
                      Pièce d'identité (recto)
                    </div>
                    <div class="p-2 bg-white dark:bg-gray-800">
                      <div v-if="selectedUser.id_front" class="aspect-[4/3] overflow-hidden rounded bg-gray-100 dark:bg-gray-700">
                        <img :src="selectedUser.id_front" alt="ID recto" class="w-full h-full object-cover hover:scale-150 transition-all cursor-zoom-in" />
                      </div>
                      <div v-else class="aspect-[4/3] flex items-center justify-center bg-gray-100 dark:bg-gray-700 text-gray-400 dark:text-gray-500 text-sm">
                        Non fourni
                      </div>
                    </div>
                  </div>
                  
                  <!-- Pièce d'identité (verso) -->
                  <div class="border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden">
                    <div class="px-3 py-2 bg-gray-50 dark:bg-gray-700 border-b border-gray-200 dark:border-gray-700 text-xs font-medium text-gray-700 dark:text-gray-300">
                      Pièce d'identité (verso)
                    </div>
                    <div class="p-2 bg-white dark:bg-gray-800">
                      <div v-if="selectedUser.id_back" class="aspect-[4/3] overflow-hidden rounded bg-gray-100 dark:bg-gray-700">
                        <img :src="selectedUser.id_back" alt="ID verso" class="w-full h-full object-cover hover:scale-150 transition-all cursor-zoom-in" />
                      </div>
                      <div v-else class="aspect-[4/3] flex items-center justify-center bg-gray-100 dark:bg-gray-700 text-gray-400 dark:text-gray-500 text-sm">
                        Non fourni
                      </div>
                    </div>
                  </div>
                  
                  <!-- Justificatif de domicile -->
                  <div class="border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden">
                    <div class="px-3 py-2 bg-gray-50 dark:bg-gray-700 border-b border-gray-200 dark:border-gray-700 text-xs font-medium text-gray-700 dark:text-gray-300">
                      Justificatif de domicile
                    </div>
                    <div class="p-2 bg-white dark:bg-gray-800">
                      <div v-if="selectedUser.proof_address" class="aspect-[4/3] overflow-hidden rounded bg-gray-100 dark:bg-gray-700">
                        <img :src="selectedUser.proof_address" alt="Justificatif de domicile" class="w-full h-full object-cover hover:scale-150 transition-all cursor-zoom-in" />
                      </div>
                      <div v-else class="aspect-[4/3] flex items-center justify-center bg-gray-100 dark:bg-gray-700 text-gray-400 dark:text-gray-500 text-sm">
                        Non fourni
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Notes de vérification -->
              <div>
                <label for="verificationNotes" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                  Notes de vérification
                </label>
                <textarea
                  v-model="verificationNotes"
                  id="verificationNotes"
                  rows="3"
                  class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                  placeholder="Ajoutez des notes concernant cette vérification..."
                ></textarea>
              </div>
              
              <!-- Actions -->
              <div class="flex justify-end space-x-3 border-t border-gray-200 dark:border-gray-700 pt-4">
                <button 
                  @click="rejectVerification" 
                  class="px-5 py-2.5 bg-red-600 hover:bg-red-700 text-white text-sm font-medium rounded-full transition-colors"
                  :disabled="isProcessing"
                >
                  <div v-if="isRejecting" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                  {{ isRejecting ? 'Refus en cours...' : 'Refuser' }}
                </button>
                
                <button 
                  @click="approveVerification" 
                  class="px-5 py-2.5 bg-green-600 hover:bg-green-700 text-white text-sm font-medium rounded-full transition-colors flex items-center"
                  :disabled="isProcessing"
                >
                  <div v-if="isApproving" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                  {{ isApproving ? 'Approbation en cours...' : 'Approuver' }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
    
    <!-- Modal de blocage d'utilisateur -->
    <Teleport to="body">
      <div v-if="showBlockModal" class="fixed inset-0 bg-black/50 dark:bg-gray-900/70 flex items-center justify-center z-50 p-4">
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg max-w-lg w-full">
          <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
            <h3 class="text-lg font-medium text-gray-900 dark:text-white">Bloquer l'utilisateur</h3>
            <button @click="showBlockModal = false" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
              <X class="h-5 w-5" />
            </button>
          </div>
          
          <div class="p-6">
            <div v-if="selectedUser" class="text-center mb-6">
              <div class="w-16 h-16 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700 mx-auto mb-3">
                <img v-if="selectedUser.avatar_url" :src="selectedUser.avatar_url" alt="" class="h-full w-full object-cover">
                <div v-else class="h-full w-full flex items-center justify-center bg-primary-100 dark:bg-primary-900/40 text-primary-700 dark:text-primary-300 text-xl font-medium">
                  {{ getInitials(selectedUser.first_name, selectedUser.last_name) }}
                </div>
              </div>
              
              <h4 class="text-lg font-medium text-gray-900 dark:text-white">
                {{ selectedUser.first_name }} {{ selectedUser.last_name }}
              </h4>
              <p class="text-gray-600 dark:text-gray-400 text-sm">{{ selectedUser.email }}</p>
            </div>
            
            <div class="bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-900/40 text-yellow-800 dark:text-yellow-300 p-4 rounded-lg mb-4 text-sm">
              <div class="flex">
                <AlertTriangle class="h-5 w-5 text-yellow-600 dark:text-yellow-500 mr-2 flex-shrink-0" />
                <div>
                  <strong>Attention :</strong> Bloquer cet utilisateur l'empêchera de se connecter à son compte et d'utiliser les services de la plateforme.
                </div>
              </div>
            </div>
            
            <div class="mb-4">
              <label for="blockReason" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">
                Raison du blocage
              </label>
              <textarea
                v-model="blockReason"
                id="blockReason"
                rows="3"
                class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                placeholder="Précisez la raison du blocage..."
              ></textarea>
            </div>
            
            <div class="flex justify-end space-x-3">
              <button 
                @click="showBlockModal = false" 
                class="px-5 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors"
              >
                Annuler
              </button>
              
              <button 
                @click="blockUser" 
                class="px-5 py-2.5 bg-red-600 hover:bg-red-700 text-white text-sm font-medium rounded-full transition-colors flex items-center"
                :disabled="isBlocking"
              >
                <div v-if="isBlocking" class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                {{ isBlocking ? 'Blocage en cours...' : 'Bloquer l\'utilisateur' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient } from '#imports'
import {
  Search, User, UserX, Edit, Trash, Lock, Unlock, CheckCircle,
  Mail, Bell, X, AlertCircle, Info, ChevronLeft, ChevronRight,
  ChevronsLeft, ChevronsRight, Loader2
} from 'lucide-vue-next'

import UserModal from '@/components/admin/users/UserModal.vue'
const router = useRouter()
const supabase = useSupabaseClient()

const selectedUser = ref(null)
const verificationNotes = ref('')
const showVerificationModal = ref(false)
const blockReason = ref('')
const showBlockModal = ref(false)
// const showStatusMessage = ref(null)
const search = ref('')
const roleFilter = ref('all')
const statusFilter = ref('all')
const sortOption = ref('recent')
const currentPage = ref(1)
const users = ref([])
const isApproving = ref(false)
const isRejecting = ref(false)
const isBlocking = ref(false)
const isUnblocking = ref(false)
const isLoading = ref(false)
const showUserModal = ref(false)
const userToEdit = ref(null)
const editMode = ref(false)

// Ouvrir le modal de vérification
const openVerificationModal = (user) => {
  selectedUser.value = user
  verificationNotes.value = user.verification_notes || ''
  showVerificationModal.value = true
}

// Ouvrir le modal de blocage
const openBlockModal = (user) => {
  selectedUser.value = user
  blockReason.value = user.block_reason || ''
  showBlockModal.value = true
}

// Voir le profil complet
const viewProfile = (userId) => {
  router.push(`/admin/users/${userId}`)
}

// Chargement des données
const fetchUsers = async () => {
  isLoading.value = true
  
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
    
    if (error) throw error
    
    if (Array.isArray(data)) {
      users.value = data
      console.log('Utilisateurs chargés:', users.value.length)
    } else {
      console.error('Données invalides:', data)
      users.value = []
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des utilisateurs:', error)
    showStatusMessage('error', 'Erreur lors de la récupération des utilisateurs')
    users.value = []
  } finally {
    isLoading.value = false
  }
}

// Réinitialiser la pagination quand les filtres changent
watch([search, roleFilter, statusFilter], () => {
  currentPage.value = 1
})

// Modifier un utilisateur
const editUser = (user) => {
  userToEdit.value = user
  editMode.value = true
  showUserModal.value = true
}

// Fonction pour confirmer le blocage d'un utilisateur
const confirmBlock = (user) => {
  selectedUser.value = user
  showBlockModal.value = true
}

// Fonction pour confirmer le déblocage d'un utilisateur
const confirmUnblock = (user) => {
  selectedUser.value = user
  showUnblockModal.value = true
}
const confirmDelete = (user) => {
  selectedUser.value = user
  showDeleteModal.value = true
}


// Approuver un expert
const approveExpert = async () => {
  if (!selectedUser.value) return
  
  isApproving.value = true
  
  try {
    // Capturer l'ID avant de réinitialiser
    const userId = selectedUser.value.id
    
    const { error } = await supabase
      .from('profiles')
      .update({
        verification_status: 'verified',
        verification_notes: verificationNotes.value,
        verified_at: new Date().toISOString(),
        is_expert: true
      })
      .eq('id', userId)
    
    if (error) throw error
    
    // Mise à jour dans le state local
    const index = users.value.findIndex(u => u.id === userId)
    if (index !== -1) {
      users.value[index] = {
        ...users.value[index],
        verification_status: 'verified',
        verification_notes: verificationNotes.value,
        verified_at: new Date().toISOString(),
        is_expert: true
      }
    }
    
    showStatusMessage('success', 'Compte expert approuvé avec succès')
    
    // Fermer le modal
    showVerificationModal.value = false
    selectedUser.value = null
    verificationNotes.value = ''
    
    // Notification APRÈS réinitialisation
    await sendNotification(
      userId, // Utiliser userId au lieu de selectedUser.value.id
      'Votre compte expert a été approuvé',
      'Félicitations ! Votre demande de compte expert a été approuvée.'
    )
  } catch (error) {
    console.error('Erreur lors de l\'approbation du compte expert:', error)
    showStatusMessage('error', 'Erreur lors de l\'approbation du compte expert')
  } finally {
    isApproving.value = false
  }
}

// Rejeter un expert
const rejectExpert = async () => {
  if (!selectedUser.value) return
  
  isRejecting.value = true
  
  try {
    const { error } = await supabase
      .from('profiles')
      .update({
        verification_status: 'rejected',
        verification_notes: verificationNotes.value
      })
      .eq('id', selectedUser.value.id)
    
    if (error) throw error
    
    // Mise à jour dans le state local
    const index = users.value.findIndex(u => u.id === selectedUser.value.id)
    if (index !== -1) {
      users.value[index] = {
        ...users.value[index],
        verification_status: 'rejected',
        verification_notes: verificationNotes.value
      }
    }
    
    showStatusMessage('success', 'Demande de compte expert rejetée')
    
    // Fermer le modal
    showVerificationModal.value = false
    selectedUser.value = null
    verificationNotes.value = ''
    
    // Notification à l'utilisateur
    await sendNotification(
      selectedUser.value.id,
      'Votre demande de compte expert a été rejetée',
      `Votre demande de compte expert n'a pas été approuvée pour la raison suivante: ${verificationNotes.value || 'Non spécifiée'}. Vous pouvez contacter notre équipe pour plus d'informations.`
    )
  } catch (error) {
    console.error('Erreur lors du rejet du compte expert:', error)
    showStatusMessage('error', 'Erreur lors du rejet du compte expert')
  } finally {
    isRejecting.value = false
  }
}

// Bloquer un utilisateur
const blockUser = async () => {
  if (!selectedUser.value) return
  
  isBlocking.value = true
  
  try {
    // Capturer l'ID de l'utilisateur avant de réinitialiser
    const userId = selectedUser.value.id
    const reasonText = blockReason.value || 'Non spécifiée'
    
    const { error } = await supabase
      .from('profiles')
      .update({
        is_blocked: true,
        block_reason: blockReason.value,
        blocked_at: new Date().toISOString()
      })
      .eq('id', userId)
    
    if (error) throw error
    
    // Mise à jour dans le state local
    const index = users.value.findIndex(u => u.id === userId)
    if (index !== -1) {
      users.value[index] = {
        ...users.value[index],
        is_blocked: true,
        block_reason: blockReason.value,
        blocked_at: new Date().toISOString()
      }
    }
    
    showStatusMessage('success', 'Utilisateur bloqué avec succès')
    
    // Fermer le modal
    showBlockModal.value = false
    selectedUser.value = null
    blockReason.value = ''
    
    // Notification à l'utilisateur APRÈS avoir réinitialisé
    await sendNotification(
      userId,
      'Votre compte a été suspendu',
      `Votre compte a été temporairement suspendu pour la raison suivante: ${reasonText}. Veuillez contacter notre équipe de support pour plus d'informations.`
    )
  } catch (error) {
    console.error('Erreur lors du blocage de l\'utilisateur:', error)
    showStatusMessage('error', 'Erreur lors du blocage de l\'utilisateur')
  } finally {
    isBlocking.value = false
  }
}

// Débloquer un utilisateur
const unblockUser = async (user) => {
  isUnblocking.value = true
  
  try {
    const { error } = await supabase
      .from('profiles')
      .update({
        is_blocked: false,
        block_reason: null,
        blocked_at: null
      })
      .eq('id', user.id)
    
    if (error) throw error
    
    // Mise à jour dans le state local
    const index = users.value.findIndex(u => u.id === user.id)
    if (index !== -1) {
      users.value[index] = {
        ...users.value[index],
        is_blocked: false,
        block_reason: null,
        blocked_at: null
      }
    }
    
    showStatusMessage('success', 'Utilisateur débloqué avec succès')
    
    // Notification à l'utilisateur
    await sendNotification(
      user.id,
      'Votre compte a été réactivé',
      'Votre compte a été débloqué et vous pouvez à nouveau accéder à toutes les fonctionnalités de la plateforme.'
    )
  } catch (error) {
    console.error('Erreur lors du déblocage de l\'utilisateur:', error)
    showStatusMessage('error', 'Erreur lors du déblocage de l\'utilisateur')
  } finally {
    isUnblocking.value = false
  }
}

// Envoyer une notification à un utilisateur
const sendNotification = async (userId, title, message) => {
  try {
    const { error } = await supabase
      .from('notifications')
      .insert([
        { 
          user_id: userId,
          title,
          message,
          type: 'system',
          is_read: false
        }
      ])
    
    if (error) throw error
    
    return true
  } catch (error) {
    console.error('Erreur lors de l\'envoi de la notification:', error)
    return false
  }
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

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = ''
  roleFilter.value = 'all'
  statusFilter.value = 'all'
  sortOption.value = 'recent'
  currentPage.value = 1
}

// Pagination
const goToPage = (page) => {
  currentPage.value = page
}

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return '-'
  
  return new Date(dateString).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

// Réinitialiser la page quand les filtres changent
watch([search, roleFilter, statusFilter, sortOption], () => {
  currentPage.value = 1
})

// Correction des filtres et de la pagination
const paginatedUsers = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredUsers.value.slice(start, end)
})

// Vérifiez que ces variables sont bien définies
const itemsPerPage = ref(10) // Nombre d'utilisateurs par page

// Correction du filteredUsers computed
const filteredUsers = computed(() => {
  let filtered = [...users.value]
  
  // Filtre par recherche
  if (search.value) {
    const query = search.value.toLowerCase()
    filtered = filtered.filter(user => 
      (user.first_name && user.first_name.toLowerCase().includes(query)) ||
      (user.last_name && user.last_name.toLowerCase().includes(query)) ||
      (user.email && user.email.toLowerCase().includes(query))
    )
  }
  
  // Filtre par rôle
  if (roleFilter.value !== 'all') {
    filtered = filtered.filter(user => user.role === roleFilter.value)
  }
  
  // Filtre par statut
  if (statusFilter.value !== 'all') {
    switch (statusFilter.value) {
      case 'active':
        filtered = filtered.filter(user => !user.is_blocked)
        break
      case 'blocked':
        filtered = filtered.filter(user => user.is_blocked)
        break
      case 'pending':
        filtered = filtered.filter(user => user.verification_status === 'pending')
        break
      case 'unverified':
        filtered = filtered.filter(user => !user.verification_status || user.verification_status === 'none')
        break
    }
  }
  
  // Tri
  switch (sortOption.value) {
    case 'recent':
      filtered.sort((a, b) => new Date(b.created_at || 0) - new Date(a.created_at || 0))
      break
    case 'oldest':
      filtered.sort((a, b) => new Date(a.created_at || 0) - new Date(b.created_at || 0))
      break
    case 'name':
      filtered.sort((a, b) => {
        const nameA = `${a.first_name || ''} ${a.last_name || ''}`.trim()
        const nameB = `${b.first_name || ''} ${b.last_name || ''}`.trim()
        return nameA.localeCompare(nameB)
      })
      break
  }
  
  return filtered
})

// Obtenir les initiales de l'utilisateur pour l'avatar
const getInitials = (firstName, lastName) => {
  let initials = ''
  if (firstName) initials += firstName.charAt(0).toUpperCase()
  if (lastName) initials += lastName.charAt(0).toUpperCase()
  return initials || '?'  // Renvoyer '?' si aucune initiale n'est disponible
}

// Formater le rôle de l'utilisateur
const formatRole = (role) => {
  switch (role) {
    case 'admin':
      return 'Administrateur'
    case 'expert':
      return 'Expert'
    case 'client':
      return 'Client'
    default:
      return 'Client'
  }
}

// Formater le statut de vérification
const formatVerificationStatus = (status) => {
  switch (status) {
    case 'verified':
      return 'Vérifié'
    case 'pending':
      return 'En attente'
    case 'rejected':
      return 'Rejeté'
    case 'none':
    default:
      return 'Non vérifié'
  }
}

// Initialisation
onMounted(() => {
  fetchUsers()
})
definePageMeta({
  layout: 'admin'
})
</script>

<style scoped>
/* Style pour les sélecteurs avec flèche dropdown */
select {
  background-position: right 1rem center;
  background-repeat: no-repeat;
  background-size: 1em;
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>');
}

/* Animation pour le modal */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.25s ease, transform 0.25s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style> 