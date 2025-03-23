<template>
    <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- En-tête avec style moderne -->
      <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Demandes de service</h1>
          <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les demandes de service et assignez des experts</p>
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
            @click="refreshData"
            class="btn-primary flex items-center gap-2"
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
              placeholder="Rechercher une demande..."
              class="pl-12 pr-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl w-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
            />
          </div>
          
          <div class="flex flex-wrap gap-3 items-center">
            <!-- Filtre de statut -->
            <select 
              v-model="statusFilter"
              class="px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-none"
            >
              <option value="all">Tous les statuts</option>
              <option value="open">Nouvelles</option>
              <option value="assigned">Assignées</option>
              <option value="in_progress">En cours</option>
              <option value="completed">Terminées</option>
              <option value="cancelled">Annulées</option>
            </select>
            
            <!-- Filtre de catégorie -->
            <select 
              v-model="categoryFilter"
              class="px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
            >
              <option value="all">Toutes les catégories</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
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
      <div v-else-if="filteredRequests && filteredRequests.length === 0" class="bg-white dark:bg-gray-800 rounded-2xl p-12 text-center border border-gray-100 dark:border-gray-700 shadow-sm">
        <div class="inline-flex items-center justify-center h-20 w-20 rounded-full bg-gray-100 dark:bg-gray-700 mb-6">
          <FileText class="h-10 w-10 text-gray-500 dark:text-gray-400" />
        </div>
        <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Aucune demande trouvée</h3>
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
      
      <!-- Liste des demandes avec design moderne -->
      <div v-else class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 overflow-hidden shadow-sm">
        <!-- En-tête du tableau -->
        <div class="grid grid-cols-6 gap-4 px-6 py-4 bg-gray-50 dark:bg-gray-800/80 border-b border-gray-100 dark:border-gray-700 text-sm font-medium text-gray-500 dark:text-gray-400">
          <div>Service</div>
          <div>Client</div>
          <div>Budget</div>
          <div>Date limite</div>
          <div>Statut</div>
          <div class="text-right">Actions</div>
        </div>
        
        <!-- Lignes du tableau avec hover effect -->
        <div class="divide-y divide-gray-100 dark:divide-gray-700">
          <div 
            v-for="request in paginatedRequests" 
            :key="request.id"
            class="grid grid-cols-6 gap-4 px-6 py-5 items-center hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
          >
            <!-- Service avec icône -->
            <div class="flex items-center gap-3">
              <div 
                class="h-12 w-12 rounded-xl flex items-center justify-center"
                :class="getCategoryColorClass(request.category_id)"
              >
                <component :is="getCategoryIcon(request.category_id)" class="h-6 w-6 text-white" />
              </div>
              <div>
                <p class="text-sm font-medium text-gray-900 dark:text-white line-clamp-1">{{ request.title }}</p>
                <p class="text-xs text-gray-500 dark:text-gray-400">{{ getCategoryName(request.category_id) }}</p>
              </div>
            </div>
            
            <!-- Client avec localisation -->
            <div>
              <p class="text-sm font-medium text-gray-900 dark:text-white">{{ request.client_name }}</p>
              <div class="flex items-center text-xs text-gray-500 dark:text-gray-400 mt-1">
                <MapPin class="h-3 w-3 mr-1" /> 
                {{ request.location || 'Non spécifié' }}
              </div>
            </div>
            
            <!-- Budget avec badge -->
            <div>
              <span class="inline-flex items-center px-3 py-1.5 bg-primary-50 dark:bg-primary-900/20 text-primary-700 dark:text-primary-400 rounded-full text-xs font-bold">
                {{ request.budget ? `${request.budget}FCFA` : 'Non défini' }}
              </span>
            </div>
            
            <!-- Date limite -->
            <div class="text-sm text-gray-600 dark:text-gray-400">
              {{ formatDate(request.deadline) }}
            </div>
            
            <!-- Statut avec badge et indicateur -->
            <div>
              <span 
                class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
                :class="getStatusClass(request.status)"
              >
                <span class="w-2 h-2 rounded-full mr-2" :class="getStatusDotClass(request.status)"></span>
                {{ formatStatus(request.status) }}
              </span>
            </div>
            
            <!-- Actions avec boutons modernes -->
            <div class="flex justify-end gap-2">
              <button 
                @click="viewRequestDetails(request)"
                class="p-2 text-gray-500 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 hover:bg-primary-50 dark:hover:bg-primary-900/20 rounded-lg transition-colors"
                title="Voir les détails"
              >
                <Eye class="h-5 w-5" />
              </button>
              <button 
                v-if="request.status === 'open'"
                @click="openAssignModal(request)"
                class="p-2 text-gray-500 dark:text-gray-400 hover:text-blue-600 dark:hover:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-900/20 rounded-lg transition-colors"
                title="Assigner un expert"
              >
                <UserPlus class="h-5 w-5" />
              </button>
              <button 
                v-if="['open', 'assigned'].includes(request.status)"
                @click="cancelRequest(request)"
                class="p-2 text-gray-500 dark:text-gray-400 hover:text-red-600 dark:hover:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
                title="Annuler la demande"
              >
                <X class="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>
        
        <!-- Pagination moderne -->
        <div class="px-6 py-4 bg-gray-50 dark:bg-gray-800/80 border-t border-gray-100 dark:border-gray-700 flex justify-between items-center">
          <div class="text-sm text-gray-500 dark:text-gray-400">
            Affichage de <span class="font-medium">{{ (currentPage - 1) * itemsPerPage + 1 }}</span> à <span class="font-medium">{{ Math.min(currentPage * itemsPerPage, filteredRequests.length) }}</span> sur <span class="font-medium">{{ filteredRequests.length }}</span> demandes
          </div>
          
          <div class="flex items-center gap-2">
            <button 
              @click="currentPage--"
              :disabled="currentPage === 1"
              class="p-2 rounded-lg border border-gray-200 dark:border-gray-600 text-gray-500 dark:text-gray-400 disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
            >
              <ChevronLeft class="h-5 w-5" />
            </button>
            
            <div class="flex items-center gap-1">
              <button 
                v-for="page in totalPages"
                :key="page"
                @click="currentPage = page"
                class="h-8 w-8 flex items-center justify-center rounded-lg text-sm font-medium transition-colors"
                :class="currentPage === page ? 'bg-primary-600 text-white' : 'text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700'"
              >
                {{ page }}
              </button>
            </div>
            
            <button 
              @click="currentPage++"
              :disabled="currentPage === totalPages"
              class="p-2 rounded-lg border border-gray-200 dark:border-gray-600 text-gray-500 dark:text-gray-400 disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
            >
              <ChevronRight class="h-5 w-5" />
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal de détails avec design moderne -->
    <Teleport to="body">
      <Transition
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="opacity-0"
        enter-to-class="opacity-100"
        leave-active-class="transition duration-200 ease-in"
        leave-from-class="opacity-100"
        leave-to-class="opacity-0"
      >
        <div v-if="showDetailsModal" class="fixed inset-0 bg-black/50 dark:bg-black/70 flex items-center justify-center p-4 z-50">
          <Transition
            enter-active-class="transition duration-300 ease-out"
            enter-from-class="opacity-0 scale-95"
            enter-to-class="opacity-100 scale-100"
            leave-active-class="transition duration-200 ease-in"
            leave-from-class="opacity-100 scale-100"
            leave-to-class="opacity-0 scale-95"
          >
            <div 
              v-if="showDetailsModal" 
              class="bg-white dark:bg-gray-800 rounded-2xl shadow-xl max-w-3xl w-full max-h-[90vh] overflow-hidden"
              @click.stop
            >
              <div class="flex justify-between items-center p-6 border-b border-gray-100 dark:border-gray-700">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">Détails de la demande</h3>
                <button 
                  @click="showDetailsModal = false"
                  class="p-2 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full transition-colors"
                >
                  <X class="h-5 w-5" />
                </button>
              </div>
              
              <div class="p-6 overflow-y-auto max-h-[calc(90vh-120px)]">
                <div v-if="selectedRequest" class="space-y-6">
                  <!-- En-tête avec statut -->
                  <div class="flex justify-between items-start">
                    <div>
                      <h4 class="text-lg font-bold text-gray-900 dark:text-white">{{ selectedRequest.title }}</h4>
                      <p class="text-gray-500 dark:text-gray-400 mt-1">{{ getCategoryName(selectedRequest.category_id) }}</p>
                    </div>
                    <span 
                      class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
                      :class="getStatusClass(selectedRequest.status)"
                    >
                      <span class="w-2 h-2 rounded-full mr-2" :class="getStatusDotClass(selectedRequest.status)"></span>
                      {{ formatStatus(selectedRequest.status) }}
                    </span>
                  </div>
                  
                  <!-- Informations principales -->
                  <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <h5 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Détails du client</h5>
                      <div class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-4 space-y-3">
                        <div class="flex items-center">
                          <User class="h-5 w-5 text-gray-400 mr-3" />
                          <span class="text-gray-900 dark:text-white">{{ selectedRequest.client_name }}</span>
                        </div>
                        <div class="flex items-center">
                          <Mail class="h-5 w-5 text-gray-400 mr-3" />
                          <span class="text-gray-900 dark:text-white">{{ selectedRequest.client_email }}</span>
                        </div>
                        <div class="flex items-center">
                          <Phone class="h-5 w-5 text-gray-400 mr-3" />
                          <span class="text-gray-900 dark:text-white">{{ selectedRequest.client_phone || 'Non renseigné' }}</span>
                        </div>
                        <div class="flex items-center">
                          <MapPin class="h-5 w-5 text-gray-400 mr-3" />
                          <span class="text-gray-900 dark:text-white">{{ selectedRequest.location || 'Non spécifié' }}</span>
                        </div>
                      </div>
                    </div>
                    
                    <div>
                      <h5 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Informations de la demande</h5>
                      <div class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-4 space-y-3">
                        <div class="flex items-center">
                          <Calendar class="h-5 w-5 text-gray-400 mr-3" />
                          <span class="text-gray-900 dark:text-white">Créée le {{ formatDate(selectedRequest.created_at) }}</span>
                        </div>
                        <div class="flex items-center">
                          <Clock class="h-5 w-5 text-gray-400 mr-3" />
                          <span class="text-gray-900 dark:text-white">Date limite: {{ formatDate(selectedRequest.deadline) }}</span>
                        </div>
                        <div class="flex items-center">
                          <DollarSign class="h-5 w-5 text-gray-400 mr-3" />
                          <span class="text-gray-900 dark:text-white">Budget: {{ selectedRequest.budget ? `${selectedRequest.budget}FCFA` : 'Non défini' }}</span>
                        </div>
                        <div v-if="selectedRequest.expert_id" class="flex items-center">
                          <Award class="h-5 w-5 text-gray-400 mr-3" />
                          <span class="text-gray-900 dark:text-white">Expert assigné: {{ getExpertName(selectedRequest.expert_id) }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <!-- Description -->
                  <div>
                    <h5 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Description</h5>
                    <div class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-4">
                      <p class="text-gray-900 dark:text-white whitespace-pre-line">{{ selectedRequest.description }}</p>
                    </div>
                  </div>
                  
                  <!-- Notes d'administration -->
                  <div v-if="selectedRequest.admin_notes">
                    <h5 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Notes d'administration</h5>
                    <div class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-4">
                      <p class="text-gray-900 dark:text-white whitespace-pre-line">{{ selectedRequest.admin_notes }}</p>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="p-6 border-t border-gray-100 dark:border-gray-700 flex justify-end">
                <button 
                  @click="showDetailsModal = false"
                  class="px-4 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 font-medium rounded-xl transition-colors"
                >
                  Fermer
                </button>
              </div>
            </div>
          </Transition>
        </div>
      </Transition>
    </Teleport>
    
    <!-- Modal d'assignation avec design moderne -->
    <Teleport to="body">
      <Transition
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="opacity-0"
        enter-to-class="opacity-100"
        leave-active-class="transition duration-200 ease-in"
        leave-from-class="opacity-100"
        leave-to-class="opacity-0"
      >
        <div v-if="showAssignModal" class="fixed inset-0 bg-black/50 dark:bg-black/70 flex items-center justify-center p-4 z-50">
          <Transition
            enter-active-class="transition duration-300 ease-out"
            enter-from-class="opacity-0 scale-95"
            enter-to-class="opacity-100 scale-100"
            leave-active-class="transition duration-200 ease-in"
            leave-from-class="opacity-100 scale-100"
            leave-to-class="opacity-0 scale-95"
          >
            <div 
              v-if="showAssignModal" 
              class="bg-white dark:bg-gray-800 rounded-2xl shadow-xl max-w-lg w-full"
              @click.stop
            >
              <div class="flex justify-between items-center p-6 border-b border-gray-100 dark:border-gray-700">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">Assigner un expert</h3>
                <button 
                  @click="showAssignModal = false"
                  class="p-2 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full transition-colors"
                >
                  <X class="h-5 w-5" />
                </button>
              </div>
              
              <div class="p-6 space-y-6">
                <div v-if="selectedRequest" class="mb-6">
                  <h4 class="text-lg font-bold text-gray-900 dark:text-white">{{ selectedRequest.title }}</h4>
                  <p class="text-gray-500 dark:text-gray-400">{{ getCategoryName(selectedRequest.category_id) }}</p>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Sélectionner un expert</label>
                  <select 
                    v-model="selectedExpertId"
                    class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                  >
                    <option value="" disabled>Choisir un expert</option>
                    <option v-for="expert in experts" :key="expert.id" :value="expert.id">
                      {{ expert.first_name }} {{ expert.last_name }} - {{ expert.specialties ? expert.specialties.join(', ') : 'Généraliste' }}
                    </option>
                  </select>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Notes (optionnel)</label>
                  <textarea 
                    v-model="assignmentNotes"
                    rows="4"
                    placeholder="Ajouter des notes ou instructions pour l'expert..."
                    class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-xl focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                  ></textarea>
                </div>
              </div>
              
              <div class="p-6 border-t border-gray-100 dark:border-gray-700 flex justify-end gap-3">
                <button 
                  @click="showAssignModal = false"
                  class="px-4 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 font-medium rounded-xl transition-colors"
                >
                  Annuler
                </button>
                <button 
                  @click="assignExpert"
                  :disabled="!selectedExpertId || isAssigning"
                  class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-xl shadow-sm transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
                >
                  <Loader2 v-if="isAssigning" class="h-4 w-4 animate-spin" />
                  <UserPlus v-else class="h-4 w-4" />
                  <span>Assigner</span>
                </button>
              </div>
            </div>
          </Transition>
        </div>
      </Transition>
    </Teleport>
  </template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { debounce } from 'lodash';
// Importation alternative des icônes
import * as LucideIcons from 'lucide-vue-next';
import DataTable from '~/components/admin/DataTable.vue';
import { useSupabaseClient } from '#imports';

// Extraction des icônes spécifiques
const { RefreshCw, Plus, Search, Eye, Edit, Trash2, X, Info, CheckCircle, AlertTriangle, FileText, UserPlus, Loader2, Download, MapPin, ChevronLeft, ChevronRight, Clock, Users } = LucideIcons;

const supabase = useSupabaseClient();
const router = useRouter();

// État des données
const requests = ref([]);
const categories = ref([]);
const experts = ref([]);
const isLoading = ref(true);
const showAssignModal = ref(false);
const selectedRequest = ref(null);
const selectedExpertId = ref('');
const assignmentNotes = ref('');
const isAssigning = ref(false);

// Notification avec initialisation correcte
const notification = ref({
  show: false,
  type: 'info',
  title: '',
  message: ''
});

// Filtres
const search = ref('');
const statusFilter = ref('all');
const categoryFilter = ref('all');

// Statistiques
const stats = ref([
  {
    label: 'Total demandes',
    value: 0,
    icon: FileText,
    colorClass: 'bg-primary-500'
  },
  {
    label: 'En attente',
    value: 0,
    icon: Clock,
    colorClass: 'bg-blue-500'
  },
  {
    label: 'En cours',
    value: 0,
    icon: Users,
    colorClass: 'bg-amber-500'
  },
  {
    label: 'Terminées',
    value: 0,
    icon: CheckCircle,
    colorClass: 'bg-green-500'
  }
]);

// Pagination
const currentPage = ref(1);
const itemsPerPage = ref(10);
const totalItems = ref(0);

// Computed properties
const filteredRequests = computed(() => {
  if (!requests.value) return [];
  
  let result = [...requests.value];
  
  // Filtre par recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase();
    result = result.filter(req => 
      req.title?.toLowerCase().includes(searchLower) || 
      req.client_name?.toLowerCase().includes(searchLower)
    );
  }
  
  // Filtre par statut
  if (statusFilter.value !== 'all') {
    result = result.filter(req => req.status === statusFilter.value);
  }
  
  // Filtre par catégorie
  if (categoryFilter.value !== 'all') {
    result = result.filter(req => req.category_id === categoryFilter.value);
  }
  
  return result;
});

// Pagination des résultats filtrés
const paginatedRequests = computed(() => {
  if (!filteredRequests.value) return [];
  
  const start = (currentPage.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  
  return filteredRequests.value.slice(start, end);
});

// Total des pages
const totalPages = computed(() => {
  if (!filteredRequests.value) return 1;
  return Math.ceil(filteredRequests.value.length / itemsPerPage.value);
});

// Charger les données
const loadData = async () => {
  isLoading.value = true;
  
  try {
    // Charger les demandes
    const { data: requestsData, error: requestsError } = await supabase
      .from('requests')
      .select(`*`)
      .order('created_at', { ascending: false });
    
    if (requestsError) throw requestsError;
    
    // Transformer les données pour l'affichage
    requests.value = (requestsData || []).map(req => ({
      ...req,
      client_name: 'Client', // Valeur par défaut
      expert_name: req.expert_id ? 'Expert assigné' : 'Non assigné'
    }));
    
    // Charger les catégories
    const { data: categoriesData, error: categoriesError } = await supabase
      .from('categories')
      .select('*')
      .order('name');
    
    if (categoriesError) throw categoriesError;
    
    categories.value = categoriesData || [];
    
    // Mettre à jour les statistiques
    updateStats();
    
  } catch (error) {
    console.error('Erreur lors du chargement des données:', error);
    showNotification('error', 'Erreur', 'Impossible de charger les demandes');
  } finally {
    isLoading.value = false;
  }
};

// Mettre à jour les statistiques
const updateStats = () => {
  if (!requests.value) return;
  
  // Total des demandes
  stats.value[0].value = requests.value.length;
  
  // Demandes en attente (open)
  stats.value[1].value = requests.value.filter(req => req.status === 'open').length;
  
  // Demandes en cours (assigned + in_progress)
  stats.value[2].value = requests.value.filter(req => 
    req.status === 'assigned' || req.status === 'in_progress'
  ).length;
  
  // Demandes terminées
  stats.value[3].value = requests.value.filter(req => req.status === 'completed').length;
};

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = '';
  statusFilter.value = 'all';
  categoryFilter.value = 'all';
  currentPage.value = 1;
};

// Obtenir le nom de la catégorie
const getCategoryName = (categoryId) => {
  if (!categories.value) return 'Non catégorisé';
  const category = categories.value.find(cat => cat.id === categoryId);
  return category ? category.name : 'Non catégorisé';
};

// Obtenir l'icône de la catégorie
const getCategoryIcon = (categoryId) => {
  // Utiliser une icône par défaut
  return FileText;
};

// Obtenir la classe de couleur pour la catégorie
const getCategoryColorClass = (categoryId) => {
  const colors = [
    'bg-blue-500',
    'bg-green-500',
    'bg-purple-500',
    'bg-amber-500',
    'bg-red-500',
    'bg-indigo-500',
    'bg-pink-500',
    'bg-teal-500'
  ];
  
  // Utiliser l'ID de la catégorie pour choisir une couleur
  const index = categoryId ? parseInt(categoryId) % colors.length : 0;
  return colors[index];
};

// Formater le statut
const formatStatus = (status) => {
  const statusMap = {
    open: 'Ouverte',
    assigned: 'Assignée',
    in_progress: 'En cours',
    completed: 'Terminée',
    cancelled: 'Annulée'
  };
  return statusMap[status] || status;
};

// Obtenir la classe de style pour le statut
const getStatusClass = (status) => {
  const statusClasses = {
    open: 'bg-blue-50 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400',
    assigned: 'bg-amber-50 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400',
    in_progress: 'bg-purple-50 text-purple-800 dark:bg-purple-900/30 dark:text-purple-400',
    completed: 'bg-green-50 text-green-800 dark:bg-green-900/30 dark:text-green-400',
    cancelled: 'bg-red-50 text-red-800 dark:bg-red-900/30 dark:text-red-400'
  };
  return statusClasses[status] || 'bg-gray-50 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400';
};

// Obtenir la classe de style pour le point de statut
const getStatusDotClass = (status) => {
  const dotClasses = {
    open: 'bg-blue-500',
    assigned: 'bg-amber-500',
    in_progress: 'bg-purple-500',
    completed: 'bg-green-500',
    cancelled: 'bg-red-500'
  };
  return dotClasses[status] || 'bg-gray-500';
};

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return 'Non définie';
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('fr-FR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  }).format(date);
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

// Ouvrir la modal d'assignation
const openAssignModal = async (request) => {
  selectedRequest.value = request;
  selectedExpertId.value = '';
  assignmentNotes.value = '';
  
  // Charger les experts disponibles
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('role', 'expert')
      .eq('is_active', true)
      .order('first_name');
    
    if (error) throw error;
    
    experts.value = data || [];
    showAssignModal.value = true;
    
  } catch (err) {
    console.error('Erreur lors du chargement des experts:', err);
    showNotification('error', 'Erreur', 'Impossible de charger la liste des experts');
  }
};

// Assigner un expert
const assignExpert = async () => {
  if (!selectedRequest.value || !selectedExpertId.value) return;
  
  isAssigning.value = true;
  
  try {
    // Mettre à jour la demande
    const { error: updateError } = await supabase
      .from('requests')
      .update({
        expert_id: selectedExpertId.value,
        status: 'assigned',
        updated_at: new Date().toISOString()
      })
      .eq('id', selectedRequest.value.id);
    
    if (updateError) throw updateError;
    
    // Ajouter une entrée dans l'historique
    const { error: historyError } = await supabase
      .from('request_history')
      .insert({
        request_id: selectedRequest.value.id,
        action: 'assign',
        details: {
          expert_id: selectedExpertId.value,
          notes: assignmentNotes.value || null
        },
        user_id: (await supabase.auth.getUser()).data.user?.id
      });
    
    if (historyError) throw historyError;
    
    // Rafraîchir les données
    await loadData();
    
    // Fermer la modal et afficher une notification
    showAssignModal.value = false;
    showNotification(
      'success',
      'Expert assigné',
      'L\'expert a été assigné à la demande avec succès.'
    );
    
  } catch (err) {
    console.error('Erreur lors de l\'assignation de l\'expert:', err);
    showNotification(
      'error',
      'Erreur',
      'Impossible d\'assigner l\'expert à la demande.'
    );
  } finally {
    isAssigning.value = false;
  }
};

// Voir les détails d'une demande
const viewRequestDetails = (request) => {
  router.push(`/admin/requests/${request.id}`);
};

// Exporter les données
const exportData = async () => {
  try {
    if (!requests.value || requests.value.length === 0) {
      showNotification('info', 'Information', 'Aucune donnée à exporter');
      return;
    }
    
    // Transformer les données pour l'export
    const exportData = requests.value.map(request => ({
      ID: request.id,
      Titre: request.title,
      Description: request.description,
      Catégorie: getCategoryName(request.category_id),
      Client: request.client_name,
      Expert: request.expert_name,
      Statut: formatStatus(request.status),
      Budget: request.budget ? `${request.budget}FCFA` : 'Non défini',
      'Date limite': formatDate(request.deadline),
      'Date de création': formatDate(request.created_at),
      'Dernière mise à jour': formatDate(request.updated_at)
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
    link.setAttribute('download', `demandes_${new Date().toISOString().split('T')[0]}.csv`);
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

// Rafraîchir les données
const refreshData = () => {
  loadData();
};

// Charger les données au montage du composant
onMounted(() => {
  loadData();
});
</script> 