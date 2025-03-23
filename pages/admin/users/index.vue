<template>
  <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- En-tête avec style moderne -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Utilisateurs</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les utilisateurs de la plateforme</p>
      </div>
      
      <!-- Actions principales -->
      <div class="flex items-center gap-3">
        <button 
          @click="exportData"
          class="btn-outline flex items-center gap-2"
        >
          <Download class="h-4 w-4" />
          <span>Exporter</span>
        </button>
        <button 
          @click="openAddUserModal"
          class="btn-primary flex items-center gap-2"
        >
          <UserPlus class="h-4 w-4" />
          <span>Ajouter</span>
        </button>
        <button 
          @click="refreshData"
          class="btn-outline flex items-center gap-2"
        >
          <RefreshCw class="h-4 w-4" />
          <span>Actualiser</span>
        </button>
      </div>
    </div>
    
    <!-- Notifications avec animation -->
    <Transition
      enter-active-class="transform transition duration-300 ease-out"
      enter-from-class="translate-y-2 opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transform transition duration-200 ease-in"
      leave-from-class="translate-y-0 opacity-100"
      leave-to-class="translate-y-2 opacity-0"
    >
      <div 
        v-if="notification?.show" 
        class="p-4 rounded-2xl flex items-start gap-3 shadow-sm"
        :class="[
          notification.type === 'success' ? 'bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400 border border-green-200 dark:border-green-800/30' : 
          notification.type === 'error' ? 'bg-red-50 text-red-800 dark:bg-red-900/30 dark:text-red-400 border border-red-200 dark:border-red-800/30' : 
          'bg-blue-50 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400 border border-blue-200 dark:border-blue-800/30'
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
    </Transition>
    
    <!-- Statistiques avec cartes modernes -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
      <div 
        v-for="stat in stats" 
        :key="stat.label"
        class="bg-white dark:bg-gray-800 p-6 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm hover:shadow-md transition-shadow duration-200"
      >
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-medium text-gray-500 dark:text-gray-400">{{ stat.label }}</p>
            <p class="text-3xl font-bold text-gray-900 dark:text-white mt-1">{{ stat.value }}</p>
          </div>
          <div 
            class="h-14 w-14 rounded-2xl flex items-center justify-center"
            :class="stat.colorClass"
          >
            <component :is="stat.icon" class="h-7 w-7 text-white" />
          </div>
        </div>
      </div>
    </div>
    
    <!-- Filtres avec design épuré -->
    <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 p-5 shadow-sm">
      <div class="flex flex-col md:flex-row md:items-center gap-4">
        <!-- Recherche -->
        <div class="relative flex-grow max-w-md">
          <Search class="absolute left-4 top-3.5 h-5 w-5 text-gray-400" />
          <input 
            v-model="search"
            type="text"
            placeholder="Rechercher un utilisateur..."
            class="pl-12 pr-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl w-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
          />
        </div>
        
        <div class="flex flex-wrap gap-3 items-center">
          <!-- Filtre de rôle -->
          <select 
            v-model="roleFilter"
            class="px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-none"
          >
            <option value="all">Tous les rôles</option>
            <option value="client">Clients</option>
            <option value="expert">Experts</option>
            <option value="admin">Administrateurs</option>
          </select>
          
          <!-- Filtre de statut -->
          <select 
            v-model="statusFilter"
            class="px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
          >
            <option value="all">Tous les statuts</option>
            <option value="active">Actifs</option>
            <option value="inactive">Bloqués</option>
          </select>
          
          <!-- Réinitialiser -->
          <button 
            @click="resetFilters"
            class="flex items-center gap-2 px-4 py-3 text-gray-700 dark:text-gray-300 bg-gray-100 dark:bg-gray-700 rounded-xl hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
          >
            <RefreshCw class="h-4 w-4" />
            <span>Réinitialiser</span>
          </button>
        </div>
      </div>
    </div>
    
    <!-- État de chargement avec animation -->
    <div v-if="isLoading" class="flex justify-center p-12">
      <div class="inline-block h-10 w-10 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
    </div>
    
    <!-- État vide avec illustration -->
    <div v-else-if="filteredUsers && filteredUsers.length === 0" class="bg-white dark:bg-gray-800 rounded-2xl p-12 text-center border border-gray-100 dark:border-gray-700 shadow-sm">
      <div class="inline-flex items-center justify-center h-20 w-20 rounded-full bg-gray-100 dark:bg-gray-700 mb-6">
        <Users class="h-10 w-10 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Aucun utilisateur trouvé</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-md mx-auto">
        Essayez de modifier vos filtres ou d'effectuer une nouvelle recherche.
      </p>
      <button 
        @click="resetFilters"
        class="px-6 py-3 bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-xl shadow-sm transition-colors"
      >
        Réinitialiser les filtres
      </button>
    </div>
    
    <!-- Tableau des utilisateurs avec UTable -->
    <div v-else>
      <!-- Version tableau pour écrans moyens et grands -->
      <div class="hidden md:block">
        <UTable
          :columns="columns"
          :rows="paginatedUsers"
          :loading="isLoading"
          class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden shadow-sm"
        >
          <!-- Colonne Utilisateur -->
          <template #user-data="{ row }">
            <div class="flex items-center gap-3">
              <div class="h-10 w-10 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center text-primary-700 dark:text-primary-400 font-medium">
                {{ getInitials(row.first_name + ' ' + row.last_name) }}
              </div>
              <div>
                <p class="text-sm font-medium text-gray-900 dark:text-white">{{ row.first_name }} {{ row.last_name }}</p>
                <p class="text-xs text-gray-500 dark:text-gray-400">{{ row.email }}</p>
              </div>
            </div>
          </template>
          
          <!-- Colonne Rôle -->
          <template #role-data="{ row }">
            <span 
              class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
              :class="getRoleClass(row.role)"
            >
              {{ formatRole(row.role) }}
            </span>
          </template>
          
          <!-- Colonne Statut -->
          <template #status-data="{ row }">
            <span 
              class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
              :class="getStatusClass(row.is_active)"
            >
              <span class="w-2 h-2 rounded-full mr-2" :class="getStatusDotClass(row.is_active)"></span>
              {{ row.is_active ? 'Actif' : 'Bloqué' }}
            </span>
          </template>
          
          <!-- Colonne Vérifié (pour les experts) -->
          <template #verified-data="{ row }">
            <div v-if="row.role === 'expert'">
              <span 
                class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
                :class="row.is_verified ? 'bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400' : 'bg-amber-50 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'"
              >
                <span class="w-2 h-2 rounded-full mr-2" :class="row.is_verified ? 'bg-green-500' : 'bg-amber-500'"></span>
                {{ row.is_verified ? 'Certifié' : 'Non certifié' }}
              </span>
            </div>
            <div v-else>-</div>
          </template>
          
          <!-- Colonne Date d'inscription -->
          <template #created-at-data="{ row }">
            <div class="text-sm text-gray-600 dark:text-gray-400">
              {{ formatDate(row.created_at) }}
            </div>
          </template>
          
          <!-- Colonne Actions -->
          <template #actions-data="{ row }">
            <div class="flex justify-end gap-2">
              <button 
                @click="editUser(row)"
                class="p-2 text-gray-500 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-lg transition-colors"
                title="Modifier l'utilisateur"
              >
                <Edit class="h-5 w-5" />
              </button>
              <button 
                @click="viewUser(row)"
                class="p-2 text-gray-500 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-lg transition-colors"
                title="Voir le profil"
              >
                <Eye class="h-5 w-5" />
              </button>
              <button 
                @click="toggleUserStatus(row)"
                class="p-2 text-gray-500 dark:text-gray-400 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
                :title="row.is_active ? 'Bloquer l\'utilisateur' : 'Débloquer l\'utilisateur'"
              >
                <component :is="row.is_active ? 'Ban' : 'UserCheck'" class="h-5 w-5" />
              </button>
            </div>
          </template>
        </UTable>
      </div>
      
      <!-- Vue responsive pour petits écrans (mobile) -->
      <div class="block md:hidden space-y-4">
        <div 
          v-for="row in paginatedUsers" 
          :key="row.id" 
          class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden"
        >
          <!-- En-tête avec l'utilisateur -->
          <div class="p-4 border-b border-gray-100 dark:border-gray-700">
            <div class="flex items-center gap-3">
              <div class="h-12 w-12 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center text-primary-700 dark:text-primary-400 font-medium text-lg">
                {{ getInitials(row.first_name + ' ' + row.last_name) }}
              </div>
              <div>
                <p class="text-base font-medium text-gray-900 dark:text-white">{{ row.first_name }} {{ row.last_name }}</p>
                <p class="text-sm text-gray-500 dark:text-gray-400">{{ row.email }}</p>
              </div>
            </div>
          </div>
          
          <!-- Informations -->
          <div class="p-4 space-y-3">
            <div class="grid grid-cols-2 gap-3">
              <div>
                <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Rôle</p>
                <span 
                  class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
                  :class="getRoleClass(row.role)"
                >
                  {{ formatRole(row.role) }}
                </span>
              </div>
              
              <div>
                <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Statut</p>
                <span 
                  class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
                  :class="getStatusClass(row.is_active)"
                >
                  <span class="w-2 h-2 rounded-full mr-2" :class="getStatusDotClass(row.is_active)"></span>
                  {{ row.is_active ? 'Actif' : 'Bloqué' }}
                </span>
              </div>
            </div>
            
            <!-- Certification (pour experts) -->
            <div v-if="row.role === 'expert'">
              <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Certification</p>
              <span 
                class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
                :class="row.is_verified ? 'bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400' : 'bg-amber-50 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'"
              >
                <span class="w-2 h-2 rounded-full mr-2" :class="row.is_verified ? 'bg-green-500' : 'bg-amber-500'"></span>
                {{ row.is_verified ? 'Certifié' : 'Non certifié' }}
              </span>
            </div>
            
            <!-- Date d'inscription -->
            <div>
              <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Inscription</p>
              <p class="text-sm text-gray-700 dark:text-gray-300">{{ formatDate(row.created_at) }}</p>
            </div>
          </div>
          
          <!-- Actions -->
          <div class="px-4 py-3 bg-gray-50 dark:bg-gray-700/50 border-t border-gray-100 dark:border-gray-700 flex justify-end gap-2">
            <button 
              @click="editUser(row)"
              class="px-3 py-1.5 flex items-center gap-1.5 text-sm text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-lg transition-colors"
            >
              <Edit class="h-4 w-4" />
              <span>Modifier</span>
            </button>
            <button 
              @click="viewUser(row)"
              class="px-3 py-1.5 flex items-center gap-1.5 text-sm text-gray-700 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-lg transition-colors"
            >
              <Eye class="h-4 w-4" />
              <span>Profil</span>
            </button>
            <button 
              @click="toggleUserStatus(row)"
              class="px-3 py-1.5 flex items-center gap-1.5 text-sm text-gray-700 dark:text-gray-300 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
            >
              <component :is="row.is_active ? 'Ban' : 'UserCheck'" class="h-4 w-4" />
              <span>{{ row.is_active ? 'Bloquer' : 'Activer' }}</span>
            </button>
          </div>
        </div>
      </div>
      
      <!-- Pagination responsive -->
      <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4 mt-6">
        <div class="text-sm text-gray-600 dark:text-gray-400 order-2 sm:order-1 text-center sm:text-left">
          Affichage de {{ paginatedUsers.length }} sur {{ filteredUsers.length }} utilisateurs
        </div>
        <div class="flex items-center justify-center gap-2 bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-1 shadow-sm order-1 sm:order-2">
          <button 
            @click="currentPage > 1 ? currentPage-- : null"
            :disabled="currentPage === 1"
            class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 disabled:opacity-50 disabled:hover:bg-transparent dark:disabled:hover:bg-transparent transition-colors"
          >
            <ChevronLeft class="h-5 w-5" />
          </button>
          <span class="px-2 text-sm text-gray-600 dark:text-gray-400">
            Page {{ currentPage }} sur {{ totalPages }}
          </span>
          <button 
            @click="currentPage < totalPages ? currentPage++ : null"
            :disabled="currentPage === totalPages"
            class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400 disabled:opacity-50 disabled:hover:bg-transparent dark:disabled:hover:bg-transparent transition-colors"
          >
            <ChevronRight class="h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Modal d'ajout/modification d'utilisateur -->
  <UModal v-model="showUserModal" :ui="{ width: 'sm:max-w-xl' }">
    <div class="p-6">
      <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">
        {{ editMode ? 'Modifier l\'utilisateur' : 'Ajouter un utilisateur' }}
      </h2>
      
      <form @submit.prevent="saveUser" class="space-y-4">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <!-- Prénom -->
          <div>
            <label for="first_name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prénom</label>
            <input 
              id="first_name"
              v-model="userForm.first_name"
              type="text"
              required
              class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              placeholder="Prénom"
            />
          </div>
          
          <!-- Nom -->
          <div>
            <label for="last_name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom</label>
            <input 
              id="last_name"
              v-model="userForm.last_name"
              type="text"
              required
              class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
              placeholder="Nom"
            />
          </div>
        </div>
        
        <!-- Email -->
        <div>
          <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Email</label>
          <input 
            id="email"
            v-model="userForm.email"
            type="email"
            required
            :disabled="editMode"
            class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white disabled:opacity-60 disabled:cursor-not-allowed"
            placeholder="exemple@email.com"
          />
          <p v-if="editMode" class="text-xs text-gray-500 mt-1">L'email ne peut pas être modifié</p>
        </div>
        
        <!-- Téléphone -->
        <div>
          <label for="phone" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Téléphone</label>
          <input 
            id="phone"
            v-model="userForm.phone"
            type="tel"
            class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            placeholder="+123456789"
          />
        </div>
        
        <!-- Mot de passe (uniquement pour la création) -->
        <div v-if="!editMode">
          <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Mot de passe</label>
          <input 
            id="password"
            v-model="userForm.password"
            type="password"
            required
            class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            placeholder="Minimum 8 caractères"
            minlength="8"
          />
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <!-- Rôle -->
          <div>
            <label for="role" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Rôle</label>
            <select 
              id="role"
              v-model="userForm.role"
              required
              class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            >
              <option value="client">Client</option>
              <option value="expert">Expert</option>
              <option value="admin">Administrateur</option>
            </select>
          </div>
          
          <!-- Statut -->
          <div class="flex items-center h-full pt-6">
            <input 
              id="is_active"
              v-model="userForm.is_active"
              type="checkbox"
              class="h-5 w-5 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
            />
            <label for="is_active" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
              Utilisateur actif
            </label>
          </div>
        </div>
        
        <!-- Statut de vérification pour les experts -->
        <div v-if="userForm.role === 'expert'">
          <div class="flex items-center">
            <input 
              id="is_verified"
              v-model="userForm.is_verified"
              type="checkbox"
              class="h-5 w-5 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
            />
            <label for="is_verified" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">
              Expert certifié
            </label>
          </div>
        </div>
        
        <!-- Adresse -->
        <div>
          <label for="address" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Adresse</label>
          <textarea 
            id="address"
            v-model="userForm.address"
            rows="2"
            class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            placeholder="Adresse complète"
          ></textarea>
        </div>
        
        <!-- Actions -->
        <div class="flex justify-end gap-3 pt-4">
          <button 
            type="button"
            @click="showUserModal = false"
            class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-xl text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            Annuler
          </button>
          <button 
            type="submit"
            class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-xl"
            :disabled="isSaving"
          >
            <span v-if="isSaving" class="flex items-center gap-2">
              <Loader2 class="h-4 w-4 animate-spin" />
              Enregistrement...
            </span>
            <span v-else>
              {{ editMode ? 'Mettre à jour' : 'Ajouter' }}
            </span>
          </button>
        </div>
      </form>
    </div>
  </UModal>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { debounce } from 'lodash';
import { 
  Plus, Search, Edit, Trash2, RefreshCw, X, CheckCircle, AlertTriangle, 
  Info, Users, ChevronLeft, ChevronRight, Eye, EyeOff, User, Download,
  UserPlus, UserCheck, UserX, Shield, Mail, Ban, Loader2
} from 'lucide-vue-next';
import { useSupabaseClient } from '#imports';

const supabase = useSupabaseClient();
const router = useRouter();

// État des données
const users = ref([]);
const isLoading = ref(true);
const search = ref('');
const roleFilter = ref('all');
const statusFilter = ref('all');
const currentPage = ref(1);
const itemsPerPage = ref(10);
const notification = ref({
  show: false,
  type: 'info',
  title: '',
  message: ''
});

// Statistiques
const stats = ref([
  {
    label: 'Utilisateurs',
    value: 0,
    icon: Users,
    colorClass: 'bg-blue-500'
  },
  {
    label: 'Clients',
    value: 0,
    icon: User,
    colorClass: 'bg-green-500'
  },
  {
    label: 'Experts',
    value: 0,
    icon: UserCheck,
    colorClass: 'bg-purple-500'
  },
  {
    label: 'Administrateurs',
    value: 0,
    icon: Shield,
    colorClass: 'bg-amber-500'
  }
]);

// Colonnes pour UTable
const columns = [
  {
    key: 'user',
    label: 'Utilisateur',
    sortable: true
  },
  {
    key: 'email',
    label: 'Email',
    sortable: true
  },
  {
    key: 'role',
    label: 'Rôle',
    sortable: true
  },
  {
    key: 'status',
    label: 'Statut',
    sortable: true
  },
  {
    key: 'created_at',
    label: 'Date d\'inscription',
    sortable: true
  },
  {
    key: 'actions',
    label: 'Actions',
    sortable: false
  }
];

// Computed properties
const filteredUsers = computed(() => {
  if (!users.value) return [];
  
  let result = [...users.value];
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase();
    result = result.filter(user => 
      user.first_name?.toLowerCase().includes(searchLower) || 
      user.last_name?.toLowerCase().includes(searchLower) ||
      user.email?.toLowerCase().includes(searchLower) ||
      user.phone?.toLowerCase().includes(searchLower)
    );
  }
  
  // Filtre de rôle
  if (roleFilter.value !== 'all') {
    result = result.filter(user => user.role === roleFilter.value);
  }
  
  // Filtre de statut
  if (statusFilter.value !== 'all') {
    const isActive = statusFilter.value === 'active';
    result = result.filter(user => user.is_active === isActive);
  }
  
  return result;
});

// Pagination
const totalPages = computed(() => {
  return Math.ceil(filteredUsers.value.length / itemsPerPage.value);
});

const paginatedUsers = computed(() => {
  const startIndex = (currentPage.value - 1) * itemsPerPage.value;
  const endIndex = startIndex + itemsPerPage.value;
  return filteredUsers.value.slice(startIndex, endIndex);
});

// Charger les données
const loadData = async () => {
  isLoading.value = true;
  
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .order('created_at', { ascending: false });
    
    if (error) throw error;
    
    users.value = data || [];
    
    // Mettre à jour les statistiques
    updateStats();
    
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error);
    showNotification('error', 'Erreur', 'Impossible de charger les utilisateurs');
  } finally {
    isLoading.value = false;
  }
};

// Mettre à jour les statistiques
const updateStats = () => {
  if (!users.value) return;
  
  stats.value[0].value = users.value.length;
  stats.value[1].value = users.value.filter(u => u.role === 'client').length;
  stats.value[2].value = users.value.filter(u => u.role === 'expert').length;
  stats.value[3].value = users.value.filter(u => u.role === 'admin').length;
};

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = '';
  roleFilter.value = 'all';
  statusFilter.value = 'all';
  currentPage.value = 1;
};

// Voir les détails d'un utilisateur
const viewUser = (user) => {
  router.push(`/admin/users/${user.id}`);
};

// Formater le rôle
const formatRole = (role) => {
  const roleMap = {
    client: "Client",
    expert: "Expert",
    admin: "Administrateur"
  };
  return roleMap[role] || "Non défini";
};

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return '-';
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('fr-FR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  }).format(date);
};

// Changer le statut d'un utilisateur
const toggleUserStatus = async (user) => {
  const newStatus = !user.is_active;
  const action = newStatus ? 'activer' : 'désactiver';
  
  if (!confirm(`Êtes-vous sûr de vouloir ${action} cet utilisateur ?`)) {
    return;
  }
  
  try {
    const { error } = await supabase
      .from('profiles')
      .update({ 
        is_active: newStatus,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.id);
    
    if (error) throw error;
    
    // Mettre à jour l'utilisateur localement
    user.is_active = newStatus;
    
    showNotification(
      'success', 
      'Statut modifié', 
      `L'utilisateur a été ${newStatus ? 'activé' : 'désactivé'} avec succès.`
    );
    
  } catch (error) {
    console.error('Erreur lors de la modification du statut:', error);
    showNotification(
      'error', 
      'Erreur', 
      `Impossible de ${action} l'utilisateur.`
    );
  }
};

// Exporter les données
const exportData = async () => {
  try {
    if (!users.value || users.value.length === 0) {
      showNotification('info', 'Information', 'Aucune donnée à exporter');
      return;
    }
    
    // Transformer les données pour l'export
    const exportData = users.value.map(user => ({
      ID: user.id,
      Prénom: user.first_name,
      Nom: user.last_name,
      Email: user.email,
      Téléphone: user.phone || '-',
      Rôle: formatRole(user.role),
      Statut: user.is_active ? 'Actif' : 'Bloqué',
      Certifié: user.role === 'expert' ? (user.is_verified ? 'Oui' : 'Non') : '-',
      'Date d\'inscription': formatDate(user.created_at)
    }));
    
    // Convertir en CSV
    const headers = Object.keys(exportData[0]).join(',');
    const rows = exportData.map(row => Object.values(row).map(value => `"${value}"`).join(','));
    const csv = [headers, ...rows].join('\n');
    
    // Créer un blob et télécharger
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.setAttribute('href', url);
    link.setAttribute('download', `utilisateurs_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    showNotification('success', 'Export réussi', 'Les données ont été exportées avec succès');
    
  } catch (error) {
    console.error('Erreur lors de l\'export:', error);
    showNotification('error', 'Erreur', 'Impossible d\'exporter les données');
  }
};

// Afficher une notification
const showNotification = (type, title, message) => {
  if (!notification.value) {
    notification.value = {
      show: false,
      type: 'info',
      title: '',
      message: ''
    };
  }
  
  notification.value.show = true;
  notification.value.type = type;
  notification.value.title = title;
  notification.value.message = message;
  
  // Masquer automatiquement après 5 secondes
  setTimeout(() => {
    if (notification.value) {
      notification.value.show = false;
    }
  }, 5000);
};

// Rafraîchir les données
const refreshData = () => {
  loadData();
};

// Charger les données au montage du composant
onMounted(() => {
  loadData();
});

// Réinitialiser la pagination quand les filtres changent
watch([search, roleFilter, statusFilter], () => {
  currentPage.value = 1;
});

// Obtenir les initiales
const getInitials = (name) => {
  if (!name) return '';
  return name
    .split(' ')
    .map(word => word.charAt(0))
    .join('')
    .toUpperCase();
};

// Obtenir la classe pour le rôle
const getRoleClass = (role) => {
  const roleClasses = {
    client: 'bg-blue-50 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400',
    expert: 'bg-amber-50 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400',
    admin: 'bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400'
  };
  return roleClasses[role] || 'bg-gray-50 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400';
};

// Obtenir la classe pour le statut
const getStatusClass = (isActive) => {
  return isActive 
    ? 'bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400' 
    : 'bg-red-50 text-red-800 dark:bg-red-900/30 dark:text-red-400';
};

// Obtenir la classe pour le point de statut
const getStatusDotClass = (isActive) => {
  return isActive ? 'bg-green-500' : 'bg-red-500';
};

// Modal state and form
const showUserModal = ref(false);
const editMode = ref(false);
const isSaving = ref(false);
const userForm = ref({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  password: '',
  role: 'client',
  is_active: true,
  is_verified: false,
  address: ''
});

// Ouvrir la modal d'ajout d'utilisateur
const openAddUserModal = () => {
  editMode.value = false;
  userForm.value = {
    first_name: '',
    last_name: '',
    email: '',
    phone: '',
    password: '',
    role: 'client',
    is_active: true,
    is_verified: false,
    address: ''
  };
  showUserModal.value = true;
};

// Modifier un utilisateur
const editUser = (user) => {
  editMode.value = true;
  userForm.value = {
    id: user.id,
    first_name: user.first_name || '',
    last_name: user.last_name || '',
    email: user.email || '',
    phone: user.phone || '',
    role: user.role || 'client',
    is_active: user.is_active !== false, // Default to true if undefined
    is_verified: user.is_verified || false,
    address: user.address || ''
  };
  showUserModal.value = true;
};

// Enregistrer un utilisateur
const saveUser = async () => {
  // Validation basique
  if (!userForm.value.email) {
    showNotification('error', 'Erreur', 'L\'email est requis');
    return;
  }
  
  if (!editMode.value && !userForm.value.password) {
    showNotification('error', 'Erreur', 'Le mot de passe est requis pour la création d\'un utilisateur');
    return;
  }
  
  isSaving.value = true;
  
  try {
    if (editMode.value) {
      // Mettre à jour un utilisateur existant
      const { error } = await supabase
        .from('profiles')
        .update({
          first_name: userForm.value.first_name,
          last_name: userForm.value.last_name,
          phone: userForm.value.phone,
          role: userForm.value.role,
          is_active: userForm.value.is_active,
          is_verified: userForm.value.role === 'expert' ? userForm.value.is_verified : false,
          address: userForm.value.address,
          updated_at: new Date().toISOString()
        })
        .eq('id', userForm.value.id);
      
      if (error) throw error;
      
      showNotification('success', 'Utilisateur mis à jour', 'L\'utilisateur a été mis à jour avec succès');
    } else {
      // Créer un nouvel utilisateur avec auth
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: userForm.value.email,
        password: userForm.value.password,
        options: {
          data: {
            first_name: userForm.value.first_name,
            last_name: userForm.value.last_name,
            role: userForm.value.role
          }
        }
      });
      
      if (authError) throw authError;
      
      if (!authData.user) {
        throw new Error('Erreur lors de la création du compte utilisateur');
      }
      
      // Mettre à jour le profil avec des informations supplémentaires
      const { error: profileError } = await supabase
        .from('profiles')
        .update({
          phone: userForm.value.phone,
          is_active: userForm.value.is_active,
          is_verified: userForm.value.role === 'expert' ? userForm.value.is_verified : false,
          address: userForm.value.address
        })
        .eq('id', authData.user.id);
      
      if (profileError) throw profileError;
      
      showNotification('success', 'Utilisateur créé', 'L\'utilisateur a été créé avec succès');
    }
    
    // Fermer la modal et rafraîchir les données
    showUserModal.value = false;
    await loadData();
    
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'utilisateur:', error);
    showNotification('error', 'Erreur', error.message || 'Impossible d\'enregistrer l\'utilisateur');
  } finally {
    isSaving.value = false;
  }
};

definePageMeta({
  layout: 'admin'
});
</script> 
