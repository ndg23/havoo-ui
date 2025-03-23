<template>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
      <!-- En-tête avec navigation et actions -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div class="flex items-center gap-4">
          <NuxtLink to="/admin/requests" class="btn-outline rounded-xl flex items-center gap-2 transition-all hover:scale-105">
            <ArrowLeft class="h-4 w-4" />
            <span>Retour</span>
          </NuxtLink>
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white tracking-tight">Détails de la demande</h1>
        </div>
        
        <div class="flex flex-wrap gap-3">
          <button 
            v-if="request && request.status === 'open'"
            @click="openAssignModal"
            class="btn-primary rounded-xl flex items-center gap-2 transition-all hover:scale-105"
            :disabled="isLoading"
          >
            <UserPlus class="h-4 w-4" />
            <span>Assigner un expert</span>
          </button>
          
          <button 
            v-if="request && ['open', 'assigned'].includes(request.status)"
            @click="cancelRequest"
            class="btn-danger rounded-xl flex items-center gap-2 transition-all hover:scale-105"
            :disabled="isLoading"
          >
            <XCircle class="h-4 w-4" />
            <span>Annuler la demande</span>
          </button>
          
          <button 
            @click="refreshData"
            class="btn-outline rounded-xl flex items-center gap-2 transition-all hover:scale-105"
            :disabled="isLoading"
          >
            <RefreshCw class="h-4 w-4" />
            <span>Actualiser</span>
          </button>
        </div>
      </div>
  
      <!-- Notification avec animation -->
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
  
      <!-- État de chargement avec animation -->
      <div v-if="isLoading" class="flex justify-center py-16">
        <div class="inline-block h-12 w-12 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
      </div>
  
      <!-- Message d'erreur avec illustration -->
      <div v-else-if="error" class="bg-red-50 dark:bg-red-900/20 p-8 rounded-2xl text-center border border-red-100 dark:border-red-800/30 shadow-sm">
        <div class="inline-flex items-center justify-center h-20 w-20 rounded-full bg-red-100 dark:bg-red-800/30 mb-6">
          <AlertTriangle class="h-10 w-10 text-red-500 dark:text-red-400" />
        </div>
        <h2 class="text-xl font-bold text-red-700 dark:text-red-400 mb-2">Une erreur est survenue</h2>
        <p class="text-red-600 dark:text-red-300 mb-6 max-w-md mx-auto">{{ error }}</p>
        <button 
          @click="fetchRequest" 
          class="px-6 py-3 bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-xl shadow-sm transition-colors flex items-center gap-2 mx-auto"
        >
          <RefreshCw class="h-4 w-4" />
          <span>Réessayer</span>
        </button>
      </div>
  
      <!-- Message demande non trouvée -->
      <div v-else-if="!request" class="bg-amber-50 dark:bg-amber-900/20 p-8 rounded-2xl text-center border border-amber-100 dark:border-amber-800/30 shadow-sm">
        <div class="inline-flex items-center justify-center h-20 w-20 rounded-full bg-amber-100 dark:bg-amber-800/30 mb-6">
          <FileX class="h-10 w-10 text-amber-500 dark:text-amber-400" />
        </div>
        <h2 class="text-xl font-bold text-amber-700 dark:text-amber-400 mb-2">Demande non trouvée</h2>
        <p class="text-amber-600 dark:text-amber-300 mb-6 max-w-md mx-auto">La demande demandée n'existe pas ou a été supprimée.</p>
        <NuxtLink 
          to="/admin/requests" 
          class="px-6 py-3 bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-xl shadow-sm transition-colors flex items-center gap-2 mx-auto inline-flex"
        >
          <ArrowLeft class="h-4 w-4" />
          <span>Retour à la liste</span>
        </NuxtLink>
      </div>
  
      <!-- Contenu principal -->
      <div v-else class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Informations principales -->
        <div class="lg:col-span-2 space-y-6">
          <!-- Carte de la demande -->
          <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
            <div class="p-6 border-b border-gray-100 dark:border-gray-700 flex justify-between items-center">
              <div class="flex items-center gap-4">
                <div 
                  class="h-12 w-12 rounded-xl flex items-center justify-center"
                  :class="getCategoryColorClass(request.category_id)"
                >
                  <component :is="getCategoryIcon(request.category_id)" class="h-6 w-6 text-white" />
                </div>
                <div>
                  <h2 class="text-xl font-bold text-gray-900 dark:text-white">{{ request.title }}</h2>
                  <p class="text-sm text-gray-500 dark:text-gray-400">{{ getCategoryName(request.category_id) }}</p>
                </div>
              </div>
              <span 
                class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium"
                :class="getStatusClass(request.status)"
              >
                <span class="w-2 h-2 rounded-full mr-2" :class="getStatusDotClass(request.status)"></span>
                {{ formatStatus(request.status) }}
              </span>
            </div>
            
            <div class="p-6 space-y-6">
              <div>
                <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Description</h3>
                <p class="text-gray-700 dark:text-gray-300 whitespace-pre-line">{{ request.description }}</p>
              </div>
              
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Client</h3>
                  <div class="flex items-center gap-3">
                    <div class="h-10 w-10 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center text-gray-500 dark:text-gray-400">
                      <User class="h-5 w-5" />
                    </div>
                    <div>
                      <p class="font-medium text-gray-900 dark:text-white">{{ client?.first_name }} {{ client?.last_name }}</p>
                      <p class="text-sm text-gray-500 dark:text-gray-400">{{ client?.email }}</p>
                    </div>
                  </div>
                </div>
                
                <div v-if="expert">
                  <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Expert assigné</h3>
                  <div class="flex items-center gap-3">
                    <div class="h-10 w-10 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center text-gray-500 dark:text-gray-400">
                      <UserCheck class="h-5 w-5" />
                    </div>
                    <div>
                      <p class="font-medium text-gray-900 dark:text-white">{{ expert.first_name }} {{ expert.last_name }}</p>
                      <p class="text-sm text-gray-500 dark:text-gray-400">{{ expert.email }}</p>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div>
                  <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Date de création</h3>
                  <p class="text-gray-700 dark:text-gray-300">{{ formatDate(request.created_at) }}</p>
                </div>
                
                <div>
                  <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Date limite</h3>
                  <p class="text-gray-700 dark:text-gray-300">{{ formatDate(request.deadline) }}</p>
                </div>
                
                <div>
                  <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Budget</h3>
                  <p class="text-gray-700 dark:text-gray-300">{{ request.budget ? `${request.budget} FCFA` : 'Non spécifié' }}</p>
                </div>
              </div>
              
              <div v-if="request.attachments && request.attachments.length > 0">
                <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Pièces jointes</h3>
                <div class="flex flex-wrap gap-3">
                  <a 
                    v-for="(attachment, index) in request.attachments" 
                    :key="index"
                    :href="attachment.url"
                    target="_blank"
                    class="flex items-center gap-2 px-3 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
                  >
                    <Paperclip class="h-4 w-4 text-gray-500 dark:text-gray-400" />
                    <span class="text-sm text-gray-700 dark:text-gray-300">{{ attachment.name || `Pièce jointe ${index + 1}` }}</span>
                  </a>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Historique des actions -->
          <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
            <div class="p-6 border-b border-gray-100 dark:border-gray-700">
              <h2 class="text-lg font-bold text-gray-900 dark:text-white">Historique</h2>
            </div>
            
            <div class="p-6">
              <div class="relative">
                <div class="absolute top-0 bottom-0 left-3 w-0.5 bg-gray-200 dark:bg-gray-700"></div>
                
                <div v-if="history.length === 0" class="text-center py-6 text-gray-500 dark:text-gray-400">
                  Aucun historique disponible
                </div>
                
                <div 
                  v-for="(item, index) in history" 
                  :key="index"
                  class="relative pl-10 pb-6 last:pb-0"
                >
                  <div class="absolute left-0 top-1 h-6 w-6 rounded-full flex items-center justify-center" :class="getHistoryIconBg(item.type)">
                    <component :is="getHistoryIcon(item.type)" class="h-3 w-3 text-white" />
                  </div>
                  <div>
                    <p class="font-medium text-gray-900 dark:text-white">{{ item.title }}</p>
                    <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">{{ item.description }}</p>
                    <p class="text-xs text-gray-400 dark:text-gray-500 mt-1">{{ formatDate(item.date) }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Sidebar avec informations complémentaires -->
        <div class="space-y-6">
          <!-- Statut et progression -->
          <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
            <div class="p-6 border-b border-gray-100 dark:border-gray-700">
              <h2 class="text-lg font-bold text-gray-900 dark:text-white">Progression</h2>
            </div>
            
            <div class="p-6">
              <div class="space-y-4">
                <div>
                  <div class="flex justify-between items-center mb-2">
                    <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Statut actuel</span>
                    <span 
                      class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
                      :class="getStatusClass(request.status)"
                    >
                      {{ formatStatus(request.status) }}
                    </span>
                  </div>
                  
                  <div class="relative pt-1">
                    <div class="flex mb-2 items-center justify-between">
                      <div>
                        <span class="text-xs font-semibold inline-block py-1 px-2 uppercase rounded-full" :class="getProgressTextClass(request.status)">
                          {{ getProgressText(request.status) }}
                        </span>
                      </div>
                    </div>
                    <div class="flex h-2 mb-4 overflow-hidden rounded bg-gray-200 dark:bg-gray-700">
                      <div
                        :style="`width: ${getProgressPercentage(request.status)}%`"
                        class="flex flex-col justify-center rounded"
                        :class="getProgressBarClass(request.status, request.status)"
                      ></div>
                    </div>
                  </div>
                </div>
                
                <div v-if="request.status === 'completed'" class="flex items-center gap-2 text-green-600 dark:text-green-400">
                  <CheckCircle class="h-5 w-5" />
                  <span class="font-medium">Demande terminée</span>
                </div>
                
                <div v-else-if="request.status === 'cancelled'" class="flex items-center gap-2 text-red-600 dark:text-red-400">
                  <XCircle class="h-5 w-5" />
                  <span class="font-medium">Demande annulée</span>
                </div>
                
                <div v-else-if="isOverdue" class="flex items-center gap-2 text-red-600 dark:text-red-400">
                  <AlertTriangle class="h-5 w-5" />
                  <span class="font-medium">Date limite dépassée</span>
                </div>
                
                <div v-else-if="isDueSoon" class="flex items-center gap-2 text-amber-600 dark:text-amber-400">
                  <Clock class="h-5 w-5" />
                  <span class="font-medium">Date limite proche</span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Propositions -->
          <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
            <div class="p-6 border-b border-gray-100 dark:border-gray-700">
              <h2 class="text-lg font-bold text-gray-900 dark:text-white">Propositions</h2>
            </div>
            
            <div class="p-6">
              <div v-if="proposals.length === 0" class="text-center py-6 text-gray-500 dark:text-gray-400">
                Aucune proposition pour cette demande
              </div>
              
              <div v-else class="space-y-4">
                <div 
                  v-for="proposal in proposals" 
                  :key="proposal.id"
                  class="p-4 border border-gray-100 dark:border-gray-700 rounded-xl"
                >
                  <div class="flex justify-between items-start">
                    <div class="flex items-center gap-3">
                      <div class="h-10 w-10 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center text-gray-500 dark:text-gray-400">
                        <User class="h-5 w-5" />
                      </div>
                      <div>
                        <p class="font-medium text-gray-900 dark:text-white">{{ proposal.expert?.first_name }} {{ proposal.expert?.last_name }}</p>
                        <p class="text-xs text-gray-500 dark:text-gray-400">{{ formatDate(proposal.created_at) }}</p>
                      </div>
                    </div>
                    <span 
                      class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
                      :class="{
                        'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400': proposal.status === 'pending',
                        'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400': proposal.status === 'accepted',
                        'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400': proposal.status === 'rejected'
                      }"
                    >
                      {{ formatProposalStatus(proposal.status) }}
                    </span>
                  </div>
                  
                  <div class="mt-3 space-y-2">
                    <div class="flex justify-between">
                      <span class="text-sm text-gray-500 dark:text-gray-400">Prix proposé:</span>
                      <span class="font-medium text-gray-900 dark:text-white">{{ proposal.price }} FCFA</span>
                    </div>
                    
                    <div v-if="proposal.message">
                      <p class="text-sm text-gray-700 dark:text-gray-300 mt-2">{{ proposal.message }}</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal d'assignation -->
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
                <div v-if="request" class="mb-6">
                  <h4 class="text-lg font-bold text-gray-900 dark:text-white">{{ request.title }}</h4>
                  <p class="text-gray-500 dark:text-gray-400">{{ getCategoryName(request.category_id) }}</p>
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
  import { ref, computed, onMounted } from 'vue';
  import { useRoute, useRouter } from 'vue-router';
  import { 
    ArrowLeft, User, UserCheck, UserPlus, FileX, XCircle, CheckCircle, 
    AlertTriangle, RefreshCw, X, Info, Clock, Paperclip, Loader2
  } from 'lucide-vue-next';
  import { useSupabaseClient } from '#imports';
  
  const supabase = useSupabaseClient();
  const route = useRoute();
  const router = useRouter();
  const requestId = route.params.id;
  
  // État
  const request = ref(null);
  const client = ref(null);
  const expert = ref(null);
  const categories = ref([]);
  const proposals = ref([]);
  const history = ref([]);
  const experts = ref([]);
  const isLoading = ref(true);
  const error = ref(null);
  const showAssignModal = ref(false);
  const selectedExpertId = ref('');
  const assignmentNotes = ref('');
  const isAssigning = ref(false);
  
  // Notification
  const notification = ref({
    show: false,
    type: 'info',
    title: '',
    message: ''
  });
  
  // Récupérer les données de la demande
  const fetchRequest = async () => {
    isLoading.value = true;
    error.value = null;
    
    try {
      // Récupérer la demande
      const { data, error: requestError } = await supabase
        .from('requests')
        .select('*')
        .eq('id', requestId)
        .single();
      
      if (requestError) throw requestError;
      
      if (!data) {
        error.value = "Demande non trouvée";
        return;
      }
      
      request.value = data;
      
      // Récupérer les données associées
      await Promise.all([
        fetchClient(),
        fetchExpert(),
        fetchCategories(),
        fetchProposals(),
        fetchHistory(),
        fetchExperts()
      ]);
      
    } catch (err) {
      console.error('Erreur lors de la récupération de la demande:', err);
      error.value = "Impossible de charger les données de la demande";
    } finally {
      isLoading.value = false;
    }
  };
  
  // Récupérer le client
  const fetchClient = async () => {
    if (!request.value || !request.value.client_id) return;
    
    try {
      const { data, error: clientError } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', request.value.client_id)
        .single();
      
      if (clientError) throw clientError;
      
      client.value = data;
    } catch (err) {
      console.error('Erreur lors de la récupération du client:', err);
    }
  };
  
  // Récupérer l'expert
  const fetchExpert = async () => {
    if (!request.value || !request.value.expert_id) return;
    
    try {
      const { data, error: expertError } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', request.value.expert_id)
        .single();
      
      if (expertError) throw expertError;
      
      expert.value = data;
    } catch (err) {
      console.error('Erreur lors de la récupération de l\'expert:', err);
    }
  };
  
  // Récupérer les catégories
  const fetchCategories = async () => {
    try {
      const { data, error: categoriesError } = await supabase
        .from('categories')
        .select('*')
        .order('name');
      
      if (categoriesError) throw categoriesError;
      
      categories.value = data || [];
    } catch (err) {
      console.error('Erreur lors de la récupération des catégories:', err);
    }
  };
  
  // Récupérer les propositions
  const fetchProposals = async () => {
    if (!request.value) return;
    
    try {
      const { data, error: proposalsError } = await supabase
        .from('proposals')
        .select('*, expert:profiles(*)')
        .eq('request_id', requestId)
        .order('created_at', { ascending: false });
      
      if (proposalsError) throw proposalsError;
      
      proposals.value = data || [];
    } catch (err) {
      console.error('Erreur lors de la récupération des propositions:', err);
    }
  };
  
  // Récupérer l'historique
  const fetchHistory = async () => {
    if (!request.value) return;
    
    try {
      const { data, error: historyError } = await supabase
        .from('request_history')
        .select('*, user:profiles(*)')
        .eq('request_id', requestId)
        .order('created_at', { ascending: false });
      
      if (historyError) throw historyError;
      
      history.value = data || [];
    } catch (err) {
      console.error('Erreur lors de la récupération de l\'historique:', err);
    }
  };
  
  // Récupérer les experts disponibles
  const fetchExperts = async () => {
    try {
      const { data, error: expertsError } = await supabase
        .from('profiles')
        .select('*')
        .eq('role', 'expert')
        .eq('is_active', true)
        .order('first_name');
      
      if (expertsError) throw expertsError;
      
      experts.value = data || [];
    } catch (err) {
      console.error('Erreur lors de la récupération des experts:', err);
    }
  };
  
  // Formater la date
  const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('fr-FR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    }).format(date);
  };
  
  // Obtenir le nom de la catégorie
  const getCategoryName = (categoryId) => {
    const category = categories.value.find(c => c.id === categoryId);
    return category ? category.name : 'Catégorie inconnue';
  };
  
  // Obtenir l'icône de la catégorie
  const getCategoryIcon = (categoryId) => {
    const category = categories.value.find(c => c.id === categoryId);
    return category?.icon || 'FileText';
  };
  
  // Obtenir la classe de couleur de la catégorie
  const getCategoryColorClass = (categoryId) => {
    const category = categories.value.find(c => c.id === categoryId);
    return category?.color_class || 'bg-gray-500';
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
  
  // Formater le statut d'une proposition
  const formatProposalStatus = (status) => {
    const statusMap = {
      pending: 'En attente',
      accepted: 'Acceptée',
      rejected: 'Rejetée'
    };
    return statusMap[status] || status;
  };
  
  // Ouvrir la modal d'assignation
  const openAssignModal = () => {
    selectedExpertId.value = '';
    assignmentNotes.value = '';
    showAssignModal.value = true;
  };
  
  // Assigner un expert à la demande
  const assignExpert = async () => {
    if (!request.value || !selectedExpertId.value) return;
    
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
        .eq('id', requestId);
      
      if (updateError) throw updateError;
      
      // Ajouter une entrée dans l'historique
      const { error: historyError } = await supabase
        .from('request_history')
        .insert({
          request_id: requestId,
          action: 'assign',
          details: {
            expert_id: selectedExpertId.value,
            notes: assignmentNotes.value || null
          },
          user_id: (await supabase.auth.getUser()).data.user?.id
        });
      
      if (historyError) throw historyError;
      
      // Rafraîchir les données
      await fetchRequest();
      
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
  
  // Annuler la demande
  const cancelRequest = async () => {
    if (!request.value) return;
    
    if (!confirm('Êtes-vous sûr de vouloir annuler cette demande ?')) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Mettre à jour la demande
      const { error: updateError } = await supabase
        .from('requests')
        .update({
          status: 'cancelled',
          updated_at: new Date().toISOString()
        })
        .eq('id', requestId);
      
      if (updateError) throw updateError;
      
      // Ajouter une entrée dans l'historique
      const { error: historyError } = await supabase
        .from('request_history')
        .insert({
          request_id: requestId,
          action: 'cancel',
          details: {
            reason: 'Annulée par l\'administrateur'
          },
          user_id: (await supabase.auth.getUser()).data.user?.id
        });
      
      if (historyError) throw historyError;
      
      // Rafraîchir les données
      await fetchRequest();
      
      // Afficher une notification
      showNotification(
        'success',
        'Demande annulée',
        'La demande a été annulée avec succès.'
      );
      
    } catch (err) {
      console.error('Erreur lors de l\'annulation de la demande:', err);
      showNotification(
        'error',
        'Erreur',
        'Impossible d\'annuler la demande.'
      );
    } finally {
      isLoading.value = false;
    }
  };
  
  // Rafraîchir les données
  const refreshData = () => {
    fetchRequest();
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
  
  // Obtenir les initiales d'un nom
  const getInitials = (name) => {
    if (!name) return '';
    return name
      .split(' ')
      .map(word => word.charAt(0))
      .join('')
      .toUpperCase();
  };
  
  // Obtenir la classe de texte pour la barre de progression
  const getProgressTextClass = (status) => {
    const textClasses = {
      open: 'text-blue-600 dark:text-blue-400',
      assigned: 'text-amber-600 dark:text-amber-400',
      in_progress: 'text-purple-600 dark:text-purple-400',
      completed: 'text-green-600 dark:text-green-400',
      cancelled: 'text-red-600 dark:text-red-400'
    };
    return textClasses[status] || 'text-gray-600 dark:text-gray-400';
  };
  
  // Obtenir la classe de fond pour la barre de progression
  const getProgressBgClass = (status) => {
    const bgClasses = {
      open: 'bg-blue-500',
      assigned: 'bg-amber-500',
      in_progress: 'bg-purple-500',
      completed: 'bg-green-500',
      cancelled: 'bg-red-500'
    };
    return bgClasses[status] || 'bg-gray-500';
  };
  
  // Obtenir le pourcentage de progression
  const getProgressPercentage = (status) => {
    const percentages = {
      open: 25,
      assigned: 50,
      in_progress: 75,
      completed: 100,
      cancelled: 100
    };
    return percentages[status] || 0;
  };
  
  // Obtenir le texte de progression
  const getProgressText = (status) => {
    const progressTexts = {
      open: 'Demande ouverte',
      assigned: 'Expert assigné',
      in_progress: 'En cours de traitement',
      completed: 'Demande terminée',
      cancelled: 'Demande annulée'
    };
    return progressTexts[status] || 'Statut inconnu';
  };
  
  // Obtenir la classe pour la barre de progression
  const getProgressBarClass = (status, currentStep) => {
    // Définir l'ordre des étapes
    const steps = ['open', 'assigned', 'in_progress', 'completed'];
    
    // Si la demande est annulée, utiliser un style spécifique
    if (status === 'cancelled') {
      return currentStep === 'cancelled' ? 'bg-red-500' : 'bg-gray-200 dark:bg-gray-700';
    }
    
    // Trouver l'index de l'étape actuelle et de l'étape en cours
    const statusIndex = steps.indexOf(status);
    const stepIndex = steps.indexOf(currentStep);
    
    // Si l'étape en cours est avant ou égale à l'étape actuelle, elle est active
    if (stepIndex <= statusIndex) {
      const bgClasses = {
        open: 'bg-blue-500',
        assigned: 'bg-amber-500',
        in_progress: 'bg-purple-500',
        completed: 'bg-green-500'
      };
      return bgClasses[currentStep] || 'bg-gray-500';
    }
    
    // Sinon, elle est inactive
    return 'bg-gray-200 dark:bg-gray-700';
  };
  
  // Initialisation
  onMounted(() => {
    fetchRequest();
  });
  
  definePageMeta({
    layout: 'admin'
  });
  </script>
  