<template>
  <AdminModal :show="show" :title="modalTitle" @close="$emit('close')">
    <template #icon>
      <UserCircle v-if="mode === 'view'" class="mr-2 h-5 w-5 text-primary-500" />
      <UserPlus v-else-if="mode === 'add'" class="mr-2 h-5 w-5 text-green-500" />
      <UserCog v-else class="mr-2 h-5 w-5 text-blue-500" />
    </template>
    
    <!-- Onglets pour navigation interne -->
    <div v-if="mode === 'view'" class="px-6 pt-4 border-b border-gray-200 dark:border-gray-800">
      <div class="flex space-x-6">
        <button 
          v-for="tab in tabs" 
          :key="tab.id"
          @click="activeTab = tab.id"
          class="pb-3 text-sm font-medium relative"
          :class="activeTab === tab.id 
            ? 'text-primary-600 dark:text-primary-400' 
            : 'text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'"
        >
          {{ tab.label }}
          <div 
            v-if="activeTab === tab.id"
            class="absolute bottom-0 inset-x-0 h-0.5 bg-primary-500 rounded-full"
          ></div>
        </button>
      </div>
    </div>
    
    <!-- Vue détaillée de l'utilisateur -->
    <div v-if="mode === 'view'" class="divide-y divide-gray-200 dark:divide-gray-800">
      <!-- Profil -->
      <div v-if="activeTab === 'profile'" class="p-6 space-y-6">
        <!-- Informations principales -->
        <div class="flex items-start space-x-4">
          <div class="relative group">
            <div class="w-20 h-20 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700 ring-4 ring-white dark:ring-gray-900">
              <img 
                v-if="user?.avatar_url" 
                :src="user.avatar_url" 
                alt="Avatar" 
                class="h-full w-full object-cover"
              />
              <UserCircle v-else class="h-full w-full text-gray-400" />
            </div>
            <button 
              class="absolute bottom-0 right-0 bg-gray-100 dark:bg-gray-800 p-1.5 rounded-full border border-gray-300 dark:border-gray-700 
              opacity-0 group-hover:opacity-100 transition-opacity"
              title="Changer l'avatar"
            >
              <Camera size="14" class="text-gray-500 dark:text-gray-400" />
            </button>
          </div>
          
          <div class="flex-1">
            <h3 class="text-xl font-bold text-gray-900 dark:text-white">
              {{ user?.first_name }} {{ user?.last_name }}
            </h3>
            <p class="text-gray-500 dark:text-gray-400">{{ user?.email }}</p>
            
            <div class="mt-2 flex items-center space-x-2">
              <span 
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                :class="getRoleBadgeClass(user?.role)"
              >
                {{ getRoleLabel(user?.role) }}
              </span>
              
              <span 
                class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                :class="getStatusBadgeClass(user?.status)"
              >
                {{ getStatusLabel(user?.status) }}
              </span>
            </div>
          </div>
          
          <div class="flex space-x-2">
            <button 
              @click="switchToEdit"
              class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-500 dark:text-gray-400"
              title="Modifier"
            >
              <Edit size="16" />
            </button>
            
            <button 
              v-if="user?.status !== 'blocked'"
              @click="toggleUserStatus('blocked')"
              class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-500 dark:text-gray-400"
              title="Bloquer"
            >
              <ShieldOff size="16" />
            </button>
            
            <button 
              v-else
              @click="toggleUserStatus('active')"
              class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-500 dark:text-gray-400"
              title="Réactiver"
            >
              <ShieldCheck size="16" />
            </button>
          </div>
        </div>
        
        <!-- Statistiques -->
        <div class="grid grid-cols-4 gap-4 py-4 px-6 bg-gray-50 dark:bg-gray-900/50 rounded-xl">
          <div class="text-center">
            <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ stats.missions || 0 }}</div>
            <div class="text-xs text-gray-500 dark:text-gray-400">Demandes</div>
          </div>
          
          <div class="text-center">
            <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ stats.proposals || 0 }}</div>
            <div class="text-xs text-gray-500 dark:text-gray-400">Propositions</div>
          </div>
          
          <div class="text-center">
            <div class="text-2xl font-bold text-gray-900 dark:text-white">
              <template v-if="stats.rating">{{ stats.rating }}</template>
              <template v-else>-</template>
            </div>
            <div class="text-xs text-gray-500 dark:text-gray-400">Note moyenne</div>
          </div>
          
          <div class="text-center">
            <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ stats.completed || 0 }}</div>
            <div class="text-xs text-gray-500 dark:text-gray-400">Complétés</div>
          </div>
        </div>
        
        <!-- Informations personnelles -->
        <div>
          <h4 class="text-sm font-medium text-gray-900 dark:text-white mb-3">Informations personnelles</h4>
          <dl class="grid grid-cols-2 gap-x-4 gap-y-4">
            <div class="col-span-1">
              <dt class="text-xs text-gray-500 dark:text-gray-400">Téléphone</dt>
              <dd class="mt-1 text-sm text-gray-900 dark:text-white">{{ user?.phone || '—' }}</dd>
            </div>
            
            <div class="col-span-1">
              <dt class="text-xs text-gray-500 dark:text-gray-400">Code postal</dt>
              <dd class="mt-1 text-sm text-gray-900 dark:text-white">{{ user?.zip_code || '—' }}</dd>
            </div>
            
            <div class="col-span-1">
              <dt class="text-xs text-gray-500 dark:text-gray-400">Inscription</dt>
              <dd class="mt-1 text-sm text-gray-900 dark:text-white">{{ formatDate(user?.created_at) }}</dd>
            </div>
            
            <div class="col-span-1">
              <dt class="text-xs text-gray-500 dark:text-gray-400">Dernière connexion</dt>
              <dd class="mt-1 text-sm text-gray-900 dark:text-white">{{ formatDate(user?.last_login) || 'Jamais' }}</dd>
            </div>
          </dl>
        </div>
        
        <!-- Bio -->
        <div v-if="user?.bio">
          <h4 class="text-sm font-medium text-gray-900 dark:text-white mb-3">Biographie</h4>
          <p class="text-sm text-gray-700 dark:text-gray-300 bg-gray-50 dark:bg-gray-800 p-4 rounded-lg">
            {{ user.bio }}
          </p>
        </div>
      </div>
      
      <!-- Activité -->
      <div v-else-if="activeTab === 'activity'" class="p-6">
        <div class="flex items-center justify-between mb-4">
          <h4 class="font-medium text-gray-900 dark:text-white">Activité récente</h4>
          <button class="text-sm text-primary-600 dark:text-primary-400 hover:underline">
            Voir tout
          </button>
        </div>
        
        <div class="space-y-4">
          <div v-if="activity.length === 0" class="text-center py-8">
            <FileSearch class="h-12 w-12 mx-auto text-gray-400" />
            <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">Aucune activité récente</p>
          </div>
          
          <div 
            v-for="(item, index) in activity" 
            :key="index"
            class="flex items-start space-x-3 py-3 border-b border-gray-200 dark:border-gray-800 last:border-0"
          >
            <div class="p-2 rounded-full bg-gray-100 dark:bg-gray-800">
              <component :is="item.icon" class="h-4 w-4 text-gray-500 dark:text-gray-400" />
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-sm text-gray-900 dark:text-white">
                {{ item.description }}
              </p>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                {{ formatDate(item.date) }}
              </p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Services (pour les experts) -->
      <div v-else-if="activeTab === 'services' && user?.role === 'expert'" class="p-6">
        <div class="flex items-center justify-between mb-4">
          <h4 class="font-medium text-gray-900 dark:text-white">Services proposés</h4>
          <button class="text-sm text-primary-600 dark:text-primary-400 px-3 py-1 rounded-full border border-primary-600 dark:border-primary-400 hover:bg-primary-50 dark:hover:bg-gray-800">
            <PlusCircle class="h-3.5 w-3.5 inline mr-1" />
            Ajouter
          </button>
        </div>
        
        <div v-if="services.length === 0" class="text-center py-8">
          <Package class="h-12 w-12 mx-auto text-gray-400" />
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">Aucun service proposé</p>
        </div>
        
        <div 
          v-for="service in services" 
          :key="service.id"
          class="flex items-center justify-between py-3 border-b border-gray-200 dark:border-gray-800 last:border-0"
        >
          <div class="flex items-center space-x-3">
            <div class="p-2 rounded-full bg-gray-100 dark:bg-gray-800 text-center">
              <span>{{ service.icon }}</span>
            </div>
            <div>
              <p class="text-sm font-medium text-gray-900 dark:text-white">{{ service.name }}</p>
              <p class="text-xs text-gray-500 dark:text-gray-400">{{ service.category }}</p>
            </div>
          </div>
          <div class="flex items-center">
            <span class="text-sm font-medium text-gray-900 dark:text-white mr-4">
              {{ formatPrice(service.price) }}
            </span>
            <Menu class="h-4 w-4 text-gray-500 dark:text-gray-400 cursor-pointer" />
          </div>
        </div>
      </div>
    </div>
    
    <!-- Formulaire d'ajout/modification -->
    <form v-else @submit.prevent="saveUser" class="p-6 space-y-6">
      <div class="flex flex-col sm:flex-row gap-4">
        <div class="flex-1">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prénom</label>
          <input 
            v-model="formData.first_name"
            type="text" 
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm 
                  dark:bg-gray-800 focus:ring-primary-500 focus:border-primary-500"
            required
          />
        </div>
        
        <div class="flex-1">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom</label>
          <input 
            v-model="formData.last_name"
            type="text" 
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm 
                  dark:bg-gray-800 focus:ring-primary-500 focus:border-primary-500"
            required
          />
        </div>
      </div>
      
      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Email</label>
        <input 
          v-model="formData.email"
          type="email" 
          class="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm 
                dark:bg-gray-800 focus:ring-primary-500 focus:border-primary-500"
          required
        />
      </div>
      
      <div class="flex flex-col sm:flex-row gap-4">
        <div class="flex-1">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Téléphone</label>
          <input 
            v-model="formData.phone"
            type="tel" 
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm 
                  dark:bg-gray-800 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
        
        <div class="flex-1">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Code postal</label>
          <input 
            v-model="formData.zip_code"
            type="text" 
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm 
                  dark:bg-gray-800 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
      </div>
      
      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Rôle</label>
        <select 
          v-model="formData.role"
          class="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm 
                dark:bg-gray-800 focus:ring-primary-500 focus:border-primary-500"
        >
          <option value="user">Utilisateur</option>
          <option value="expert">Expert</option>
          <option value="admin">Administrateur</option>
        </select>
      </div>
      
      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Biographie</label>
        <textarea 
          v-model="formData.bio"
          rows="3" 
          class="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm 
                dark:bg-gray-800 focus:ring-primary-500 focus:border-primary-500"
        ></textarea>
      </div>
      
      <div v-if="mode === 'add'">
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Mot de passe</label>
        <input 
          v-model="formData.password"
          type="password" 
          class="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm 
                dark:bg-gray-800 focus:ring-primary-500 focus:border-primary-500"
          :required="mode === 'add'"
        />
        <p class="mt-1 text-xs text-gray-500">
          Le mot de passe doit contenir au moins 8 caractères
        </p>
      </div>
    </form>
    
    <!-- Footer avec boutons d'action -->
    <template #footer>
      <div class="flex justify-end space-x-3">
        <button 
          type="button"
          @click="$emit('close')"
          class="px-4 py-2 border border-gray-300 dark:border-gray-700 rounded-lg text-sm font-medium 
                 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800"
        >
          Annuler
        </button>
        
        <button 
          v-if="mode !== 'view'"
          type="button"
          @click="saveUser"
          class="px-4 py-2 bg-primary-600 text-white rounded-lg text-sm font-medium 
                 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
          :class="{ 'opacity-75 cursor-not-allowed': saving }"
          :disabled="saving"
        >
          <Loader2 v-if="saving" class="animate-spin h-4 w-4 mr-1.5 inline" />
          {{ mode === 'add' ? 'Créer l\'utilisateur' : 'Enregistrer' }}
        </button>
      </div>
    </template>
  </AdminModal>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import AdminModal from './AdminModal.vue'
import { 
  UserCircle, UserPlus, UserCog, Edit, ShieldOff, ShieldCheck, Camera, Menu,
  FileSearch, PlusCircle, Package, Loader2
} from 'lucide-vue-next'

const props = defineProps({
  show: Boolean,
  mode: {
    type: String,
    default: 'view', // 'view', 'edit', 'add'
    validator: (value) => ['view', 'edit', 'add'].includes(value)
  },
  user: {
    type: Object,
    default: () => ({})
  }
})

const emit = defineEmits(['close', 'save', 'update-status'])

// Onglets pour la vue détaillée
const tabs = [
  { id: 'profile', label: 'Profil' },
  { id: 'activity', label: 'Activité' },
  { id: 'services', label: 'Services' }
]
const activeTab = ref('profile')

// État du formulaire
const formData = ref({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  zip_code: '',
  role: 'user',
  bio: '',
  password: ''
})

// Stats fictives pour la démo
const stats = ref({
  missions: 12,
  proposals: 5,
  rating: 4.8,
  completed: 8
})

// Activité fictive pour la démo
const activity = ref([
  {
    date: '2023-06-15T10:30:00Z',
    description: 'A créé une nouvelle demande de service',
    icon: PlusCircle
  },
  {
    date: '2023-06-10T14:22:00Z',
    description: 'A évalué l\'expert Marc Dupont (5 étoiles)',
    icon: ShieldCheck
  },
  {
    date: '2023-05-28T09:15:00Z',
    description: 'A modifié son profil',
    icon: Edit
  }
])

// Services fictifs pour la démo (experts)
const services = ref([
  {
    id: 1,
    name: 'Nettoyage complet',
    category: 'Ménage',
    icon: '🧹',
    price: 3500
  },
  {
    id: 2,
    name: 'Repassage',
    category: 'Ménage',
    icon: '👔',
    price: 2000
  }
])

// État de chargement
const saving = ref(false)

// Initialisation du formulaire
watch(() => props.user, (newUser) => {
  if (newUser && Object.keys(newUser).length > 0) {
    formData.value = { ...newUser, password: '' }
  } else {
    formData.value = {
      first_name: '',
      last_name: '',
      email: '',
      phone: '',
      zip_code: '',
      role: 'user',
      bio: '',
      password: ''
    }
  }
}, { immediate: true })

const modalTitle = computed(() => {
  if (props.mode === 'add') return 'Ajouter un utilisateur'
  if (props.mode === 'edit') return 'Modifier l\'utilisateur'
  return `${props.user?.first_name || ''} ${props.user?.last_name || ''}`
})

// Fonctions utilitaires
function formatDate(dateString) {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

function formatPrice(price) {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR',
    minimumFractionDigits: 0
  }).format(price / 100)
}

function getRoleBadgeClass(role) {
  switch(role) {
    case 'admin': return 'bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-300'
    case 'expert': return 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300'
    default: return 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-300'
  }
}

function getStatusBadgeClass(status) {
  switch(status) {
    case 'active': return 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300'
    case 'blocked': return 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300'
    case 'inactive': return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300'
    default: return 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-300'
  }
}

function getRoleLabel(role) {
  switch(role) {
    case 'admin': return 'Administrateur'
    case 'expert': return 'Expert'
    default: return 'Utilisateur'
  }
}

function getStatusLabel(status) {
  switch(status) {
    case 'active': return 'Actif'
    case 'blocked': return 'Bloqué'
    case 'inactive': return 'Inactif'
    default: return 'Inconnu'
  }
}

// Actions
function saveUser() {
  saving.value = true
  
  // Simuler une sauvegarde
  setTimeout(() => {
    emit('save', formData.value)
    saving.value = false
  }, 800)
}

function switchToEdit() {
  emit('close')
  // Utiliser nextTick pour éviter les problèmes d'animation
  setTimeout(() => {
    emit('edit', props.user)
  }, 300)
}

function toggleUserStatus(newStatus) {
  emit('update-status', {
    id: props.user.id,
    status: newStatus
  })
}
</script> 