<template>
  <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
    <!-- En-tête du tableau avec colonnes dynamiques -->
    <div 
      class="bg-gray-50 dark:bg-gray-700 px-6 py-3 border-b border-gray-200 dark:border-gray-700 grid gap-4 text-left"
      :style="{ gridTemplateColumns: gridTemplateColumns }"
    >
      <div 
        v-for="column in columns" 
        :key="column.key"
        class="text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider cursor-pointer"
        :class="{ 'text-right': column.align === 'right' }"
        @click="$emit('sort', column.key)"
      >
        {{ column.label }}
        <span v-if="sortKey === column.key" class="ml-1">
          {{ sortOrder === 'asc' ? '↑' : '↓' }}
        </span>
      </div>
    </div>
    
    <!-- Message de chargement -->
    <div v-if="isLoading" class="p-16 flex flex-col items-center justify-center">
      <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
      <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement des données...</p>
    </div>
    
    <!-- Message si aucun résultat -->
    <div v-else-if="items.length === 0" class="p-16 text-center">
      <div class="flex flex-col items-center justify-center">
        <div v-if="typeof emptyIcon === 'string'" class="h-12 w-12 text-gray-400 mb-3">
          <component :is="emptyIcon" />
        </div>
        <div v-else class="h-12 w-12 text-gray-400 mb-3">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
            <polyline points="14 2 14 8 20 8"/>
            <line x1="9.5" y1="12.5" x2="14.5" y2="17.5"/>
            <line x1="14.5" y1="12.5" x2="9.5" y2="17.5"/>
          </svg>
        </div>
        <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">{{ emptyTitle }}</h3>
        <p class="text-gray-600 dark:text-gray-400">
          {{ emptyMessage }}
        </p>
        <slot name="empty-actions"></slot>
      </div>
    </div>
    
    <!-- Lignes du tableau -->
    <div v-else class="divide-y divide-gray-200 dark:divide-gray-700">
      <div 
        v-for="(item, index) in items" 
        :key="getItemKey(item, index)"
        class="grid gap-4 px-6 py-4 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors items-center"
        :style="{ gridTemplateColumns: gridTemplateColumns }"
        @click="$emit('select-item', item)"
      >
        <template v-for="column in columns" :key="column.key">
          <!-- Rendu personnalisé par slot nommé -->
          <div v-if="hasSlot(`cell-${column.key}`)">
            <slot 
              :name="`cell-${column.key}`" 
              :item="item" 
              :value="getItemValue(item, column.key)"
            ></slot>
          </div>
          
          <!-- Rendu par défaut -->
          <div v-else :class="{ 'text-right': column.align === 'right' }">
            {{ formatValue(getItemValue(item, column.key), column.format) }}
          </div>
        </template>
      </div>
    </div>
    
    <!-- Pagination -->
    <div v-if="!isLoading && items.length > 0 && totalItems > itemsPerPage" class="px-6 py-4 border-t border-gray-200 dark:border-gray-700 flex flex-wrap justify-between items-center gap-4">
      <div class="text-sm text-gray-500 dark:text-gray-400">
        Affichage de {{ (currentPage - 1) * itemsPerPage + 1 }} à {{ Math.min(currentPage * itemsPerPage, totalItems) }} sur {{ totalItems }} éléments
      </div>
      
      <div class="flex space-x-2">
        <button 
          @click="$emit('page-change', Math.max(1, currentPage - 1))"
          :disabled="currentPage === 1"
          class="p-2 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 dark:text-gray-400 disabled:opacity-50 disabled:pointer-events-none"
          aria-label="Page précédente"
        >
          <!-- Remplacement de l'import Lucide par du SVG inline -->
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="m15 18-6-6 6-6"/>
          </svg>
        </button>
        
        <button 
          v-for="page in visiblePageNumbers" 
          :key="page"
          @click="$emit('page-change', page)"
          :class="[
            'px-3.5 py-2 rounded-md text-sm font-medium',
            page === currentPage 
              ? 'bg-primary-500 text-white' 
              : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
          ]"
        >
          {{ page }}
        </button>
        
        <button 
          @click="$emit('page-change', Math.min(totalPages, currentPage + 1))"
          :disabled="currentPage === totalPages"
          class="p-2 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-500 dark:text-gray-400 disabled:opacity-50 disabled:pointer-events-none"
          aria-label="Page suivante"
        >
          <!-- Remplacement de l'import Lucide par du SVG inline -->
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="m9 18 6-6-6-6"/>
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, useSlots } from 'vue'

// Props
const props = defineProps({
  // Structure du tableau
  columns: {
    type: Array,
    required: true,
    // Chaque colonne a : { key, label, width (optionnel), align (optionnel), format (optionnel) }
  },
  
  // Données
  items: {
    type: Array,
    default: () => []
  },
  
  // ID unique pour chaque élément
  itemKey: {
    type: String,
    default: 'id'
  },
  
  // Chargement
  isLoading: {
    type: Boolean,
    default: false
  },
  
  // État vide
  emptyIcon: {
    type: [String, Object],
    default: null
  },
  emptyTitle: {
    type: String,
    default: 'Aucun élément trouvé'
  },
  emptyMessage: {
    type: String,
    default: 'Aucun élément ne correspond à vos critères de recherche.'
  },
  
  // Pagination
  currentPage: {
    type: Number,
    default: 1
  },
  itemsPerPage: {
    type: Number,
    default: 10
  },
  totalItems: {
    type: Number,
    default: 0
  },
  
  // Tri
  sortKey: {
    type: String,
    default: ''
  },
  sortOrder: {
    type: String,
    default: 'asc',
    validator: (value) => ['asc', 'desc'].includes(value)
  }
})

// Événements
defineEmits(['page-change', 'sort', 'select-item', 'action'])

// Slots
const slots = useSlots()

// Vérifier si un slot existe
const hasSlot = (name) => {
  return !!slots[name]
}

// Styles de grille pour les colonnes
const gridTemplateColumns = computed(() => {
  return props.columns.map(column => column.width || '1fr').join(' ')
})

// Pagination
const totalPages = computed(() => {
  return Math.max(1, Math.ceil(props.totalItems / props.itemsPerPage))
})

// Afficher un nombre limité de pages dans la pagination
const visiblePageNumbers = computed(() => {
  const maxVisiblePages = 5
  const current = props.currentPage
  const total = totalPages.value
  
  if (total <= maxVisiblePages) {
    return Array.from({ length: total }, (_, i) => i + 1)
  }
  
  let startPage = Math.max(1, current - Math.floor(maxVisiblePages / 2))
  let endPage = startPage + maxVisiblePages - 1
  
  if (endPage > total) {
    endPage = total
    startPage = Math.max(1, endPage - maxVisiblePages + 1)
  }
  
  return Array.from({ length: endPage - startPage + 1 }, (_, i) => startPage + i)
})

// Obtenir la clé unique pour un élément
const getItemKey = (item, index) => {
  return item[props.itemKey] || index
}

// Obtenir la valeur d'une propriété (supporte la notation par points)
const getItemValue = (item, key) => {
  if (!key || typeof key !== 'string') {
    return null
  }
  
  if (!key.includes('.')) {
    return item[key]
  }
  
  return key.split('.').reduce((obj, prop) => {
    return obj && obj[prop] !== undefined ? obj[prop] : null
  }, item)
}

// Formater la valeur en fonction du type spécifié
const formatValue = (value, format) => {
  if (value === null || value === undefined) {
    return ''
  }
  
  if (!format) {
    return value
  }
  
  switch (format) {
    case 'date':
      return new Date(value).toLocaleDateString()
    case 'datetime':
      return new Date(value).toLocaleString()
    case 'currency':
      return typeof value === 'number' 
        ? value.toLocaleString('fr-FR', { style: 'currency', currency: 'EUR' })
        : value
    case 'number':
      return typeof value === 'number' 
        ? value.toLocaleString('fr-FR')
        : value
    case 'percentage':
      return typeof value === 'number' 
        ? `${value.toLocaleString('fr-FR')}%`
        : value
    default:
      return value
  }
}
</script>