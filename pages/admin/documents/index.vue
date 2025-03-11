<template>
  <div class="space-y-6 max-w-7xl mx-auto">
    <!-- En-tête avec style Twitter -->
    <div class="px-4 py-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Documents</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les documents téléchargés par les utilisateurs</p>
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
              placeholder="Rechercher un document..."
              class="pl-10 pr-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white w-60"
            />
          </div>
          
          <!-- Filtre de type -->
          <select 
            v-model="typeFilter"
            class="px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
          >
            <option value="all">Tous les types</option>
            <option value="image">Images</option>
            <option value="pdf">PDF</option>
            <option value="document">Documents</option>
          </select>
        </div>
        
        <!-- Actions -->
        <div class="flex items-center gap-2">
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
    
    <!-- Message en cours de développement -->
    <div class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-100 dark:border-gray-700">
      <div class="inline-flex items-center justify-center h-16 w-16 rounded-full bg-primary-100 dark:bg-primary-900/30 mb-4">
        <FileText class="h-8 w-8 text-primary-600 dark:text-primary-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Module en développement</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-4 max-w-md mx-auto">
        Le module de gestion des documents est en cours de développement et sera bientôt disponible.
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { 
  FileText, Search, RefreshCw, X, CheckCircle, AlertTriangle, Info
} from 'lucide-vue-next'

// État
const notification = ref({ show: false, type: '', title: '', message: '' })
const search = ref('')
const typeFilter = ref('all')

// Statistiques fictives pour la démo
const stats = ref([
  { 
    label: 'Total documents', 
    value: '0', 
    icon: FileText, 
    colorClass: 'bg-primary-500 dark:bg-primary-600' 
  },
  { 
    label: 'Images', 
    value: '0', 
    icon: FileText, 
    colorClass: 'bg-green-500 dark:bg-green-600' 
  },
  { 
    label: 'PDF', 
    value: '0', 
    icon: FileText, 
    colorClass: 'bg-blue-500 dark:bg-blue-600' 
  },
  { 
    label: 'Espace utilisé', 
    value: '0 MB', 
    icon: FileText, 
    colorClass: 'bg-amber-500 dark:bg-amber-600' 
  }
])

// Rafraîchir les données (à implémenter)
const refreshData = () => {
  // Cette fonction sera implémentée plus tard
  notification.value = {
    show: true,
    type: 'info',
    title: 'Module en développement',
    message: 'Cette fonctionnalité sera bientôt disponible.'
  }
  
  // Masquer la notification après 5 secondes
  setTimeout(() => {
    notification.value.show = false
  }, 5000)
}

definePageMeta({
  layout: 'admin'
})
</script> 