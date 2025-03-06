<template>
    <div class="w-full bg-white dark:bg-gray-800 rounded-2xl overflow-hidden shadow-sm border border-gray-100 dark:border-gray-700">
      <!-- Table header with actions -->
      <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 flex items-center justify-between">
        <div class="flex items-center gap-2" v-if="selectable">
          <Checkbox 
            :checked="allSelected"
            @change="toggleSelectAll"
            class="h-5 w-5 rounded-md text-blue-500 focus:ring-blue-500 dark:bg-gray-700"
          />
          <span class="text-sm font-medium text-gray-700 dark:text-gray-300">
            {{ selectedItems.length > 0 ? `${selectedItems.length} sélectionné${selectedItems.length > 1 ? 's' : ''}` : 'Sélectionner' }}
          </span>
        </div>
        <div v-else class="text-sm font-medium text-gray-700 dark:text-gray-300">
          {{ totalItems }} {{ entityLabel }}{{ totalItems > 1 ? 's' : '' }}
        </div>
        
        <!-- Bulk actions -->
        <div v-if="selectable && selectedItems.length > 0" class="flex items-center gap-2">
          <slot name="bulkActions" :selected="selectedItems">
            <button 
              v-for="action in bulkActions" 
              :key="action.label"
              @click="() => action.handler(selectedItems)"
              class="text-sm flex items-center px-3 py-1.5 rounded-full transition-colors"
              :class="action.danger 
                ? 'text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20' 
                : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
            >
              <component :is="action.icon" v-if="action.icon" class="h-4 w-4 mr-1.5" />
              {{ action.label }}
            </button>
          </slot>
        </div>
        
        <!-- Table additional actions / controls -->
        <div v-else class="flex items-center gap-2">
          <slot name="actions"></slot>
        </div>
      </div>
      
      <!-- Table content -->
      <div class="overflow-x-auto">
        <table class="w-full table-auto">
          <thead>
            <tr class="text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
              <!-- Selection column -->
              <th v-if="selectable" class="px-6 py-3 w-10">
                <span class="sr-only">Sélectionner</span>
              </th>
              
              <!-- Data columns -->
              <th 
                v-for="column in columns" 
                :key="column.key"
                class="px-6 py-3 whitespace-nowrap"
                :class="[
                  column.width ? column.width : '',
                  column.sortable ? 'cursor-pointer hover:text-gray-700 dark:hover:text-gray-300' : ''
                ]"
                @click="column.sortable && sort(column.key)"
              >
                <div class="flex items-center">
                  {{ column.label }}
                  <span v-if="column.sortable" class="ml-1">
                    <ChevronUp 
                      v-if="sortKey === column.key && sortOrder === 'asc'"
                      class="h-4 w-4 text-blue-500"
                    />
                    <ChevronDown 
                      v-else-if="sortKey === column.key && sortOrder === 'desc'"
                      class="h-4 w-4 text-blue-500"
                    />
                    <ChevronUpDown 
                      v-else
                      class="h-4 w-4 text-gray-400"
                    />
                  </span>
                </div>
              </th>
              
              <!-- Actions column -->
              <th v-if="hasRowActions" class="px-6 py-3 w-24">
                <span class="sr-only">Actions</span>
              </th>
            </tr>
          </thead>
          
          <tbody class="divide-y divide-gray-100 dark:divide-gray-700">
            <tr 
              v-if="loading" 
              class="bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
            >
              <td :colspan="getColspan()" class="px-6 py-20 text-center">
                <div class="flex flex-col items-center">
                  <Loader2 class="h-8 w-8 text-blue-500 animate-spin mb-2" />
                  <span class="text-sm text-gray-500 dark:text-gray-400">Chargement...</span>
                </div>
              </td>
            </tr>
            
            <tr 
              v-else-if="!loading && items.length === 0" 
              class="bg-white dark:bg-gray-800"
            >
              <td :colspan="getColspan()" class="px-6 py-16 text-center">
                <div class="flex flex-col items-center">
                  <component :is="emptyIcon || SearchX" class="h-12 w-12 text-gray-300 dark:text-gray-600 mb-3" />
                  <p class="text-gray-500 dark:text-gray-400 mb-1">{{ emptyMessage || 'Aucun résultat trouvé' }}</p>
                  <p v-if="emptyDescription" class="text-sm text-gray-400 dark:text-gray-500 max-w-md mx-auto">
                    {{ emptyDescription }}
                  </p>
                  <slot name="emptyState"></slot>
                </div>
              </td>
            </tr>
            
            <tr 
              v-for="(item, index) in items" 
              :key="item.id || index"
              class="bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
              :class="isSelected(item) ? 'bg-blue-50 dark:bg-blue-900/20' : ''"
            >
              <!-- Selection cell -->
              <td v-if="selectable" class="px-6 py-4 w-10">
                <Checkbox 
                  :checked="isSelected(item)"
                  @change="() => toggleSelect(item)"
                  class="h-5 w-5 rounded-md text-blue-500 focus:ring-blue-500 dark:bg-gray-700"
                />
              </td>
              
              <!-- Data cells -->
              <td 
                v-for="column in columns" 
                :key="column.key"
                class="px-6 py-4 whitespace-nowrap"
              >
                <slot 
                  :name="`cell-${column.key}`" 
                  :item="item" 
                  :value="getItemValue(item, column.key)"
                  :column="column"
                >
                  <div v-if="column.template" v-html="column.template(item)"></div>
                  <div v-else>
                    {{ formatValue(getItemValue(item, column.key), column.format) }}
                  </div>
                </slot>
              </td>
              
              <!-- Actions cell -->
              <td v-if="hasRowActions" class="px-6 py-4 whitespace-nowrap text-right">
                <div class="relative">
                  <div class="flex items-center gap-1 justify-end">
                    <slot name="rowActions" :item="item" :index="index"></slot>
                    
                    <button 
                      v-if="rowActions.length > 0"
                      @click="toggleActions(item.id || index)"
                      class="p-1.5 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                    >
                      <MoreVertical class="h-4 w-4 text-gray-500" />
                    </button>
                  </div>
                  
                  <!-- Dropdown for more actions -->
                  <div 
                    v-if="activeDropdown === (item.id || index) && rowActions.length > 0"
                    class="absolute right-0 z-10 mt-1 bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 py-1 min-w-[180px]"
                  >
                    <button 
                      v-for="action in rowActions" 
                      :key="action.label"
                      @click="() => handleAction(action, item)"
                      class="flex w-full items-center px-4 py-2 text-sm text-left transition-colors"
                      :class="action.danger 
                        ? 'text-red-600 hover:bg-red-50 dark:hover:bg-red-900/10' 
                        : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'"
                    >
                      <component :is="action.icon" v-if="action.icon" class="h-4 w-4 mr-3" />
                      {{ action.label }}
                    </button>
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <!-- Pagination controls -->
      <div v-if="pagination" class="px-6 py-4 border-t border-gray-100 dark:border-gray-700 flex items-center justify-between">
        <div class="text-sm text-gray-500 dark:text-gray-400">
          Affichage de {{ paginationInfo.from }}-{{ paginationInfo.to }} sur {{ totalItems }} éléments
        </div>
        
        <div class="flex gap-1">
          <button 
            @click="goToPage(currentPage - 1)"
            :disabled="currentPage === 1"
            class="p-2 rounded-full text-gray-500 dark:text-gray-400 transition-colors"
            :class="currentPage === 1 
              ? 'opacity-50 cursor-not-allowed' 
              : 'hover:bg-gray-100 dark:hover:bg-gray-700'"
          >
            <ChevronLeft class="h-5 w-5" />
          </button>
          
          <button 
            v-for="page in visiblePageNumbers" 
            :key="page"
            @click="goToPage(page)"
            class="min-w-[40px] h-10 rounded-full flex items-center justify-center text-sm font-medium transition-colors"
            :class="page === currentPage 
              ? 'bg-blue-500 text-white' 
              : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'"
          >
            {{ page }}
          </button>
          
          <button 
            @click="goToPage(currentPage + 1)"
            :disabled="currentPage === totalPages"
            class="p-2 rounded-full text-gray-500 dark:text-gray-400 transition-colors"
            :class="currentPage === totalPages 
              ? 'opacity-50 cursor-not-allowed' 
              : 'hover:bg-gray-100 dark:hover:bg-gray-700'"
          >
            <ChevronRight class="h-5 w-5" />
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
  import {
    ChevronDown, ChevronUp, ChevronLeft, ChevronRight, MoreVertical, Loader2,
    SearchX, ChevronUpDown
  } from 'lucide-vue-next'
  
  const props = defineProps({
    // Data & columns
    items: {
      type: Array,
      required: true
    },
    columns: {
      type: Array,
      required: true
    },
    
    // Selection
    selectable: {
      type: Boolean,
      default: false
    },
    selectedItems: {
      type: Array,
      default: () => []
    },
    
    // Pagination
    pagination: {
      type: Boolean,
      default: false
    },
    currentPage: {
      type: Number,
      default: 1
    },
    perPage: {
      type: Number,
      default: 10
    },
    totalItems: {
      type: Number,
      default: 0
    },
    
    // Sorting
    sortable: {
      type: Boolean,
      default: false
    },
    defaultSortKey: {
      type: String,
      default: ''
    },
    defaultSortOrder: {
      type: String,
      default: 'asc'
    },
    
    // Actions
    rowActions: {
      type: Array,
      default: () => []
    },
    bulkActions: {
      type: Array,
      default: () => []
    },
    
    // UI state
    loading: {
      type: Boolean,
      default: false
    },
    emptyMessage: {
      type: String,
      default: 'Aucun résultat trouvé'
    },
    emptyDescription: {
      type: String,
      default: ''
    },
    emptyIcon: {
      type: Object,
      default: null
    },
    entityLabel: {
      type: String,
      default: 'élément'
    }
  })
  
  const emit = defineEmits([
    'update:selectedItems',
    'update:currentPage',
    'sort',
    'action',
    'select-all',
    'deselect-all'
  ])
  
  // Sorting
  const sortKey = ref(props.defaultSortKey)
  const sortOrder = ref(props.defaultSortOrder)
  
  // Selection management
  const allSelected = computed(() => {
    return props.items.length > 0 && props.selectedItems.length === props.items.length
  })
  
  // Dropdown management
  const activeDropdown = ref(null)
  
  // Computed values
  const hasRowActions = computed(() => {
    return props.rowActions.length > 0 || !!$slots.rowActions
  })
  
  const totalPages = computed(() => {
    return Math.ceil(props.totalItems / props.perPage)
  })
  
  const visiblePageNumbers = computed(() => {
    const pages = []
    const maxVisiblePages = 5
    
    if (totalPages.value <= maxVisiblePages) {
      // Show all pages if total pages is less than max visible
      for (let i = 1; i <= totalPages.value; i++) {
        pages.push(i)
      }
    } else {
      // Always show first page
      pages.push(1)
      
      // Calculate middle range
      let startPage = Math.max(2, props.currentPage - 1)
      let endPage = Math.min(totalPages.value - 1, props.currentPage + 1)
      
      // Adjust if at edges
      if (props.currentPage <= 2) {
        endPage = 4
      } else if (props.currentPage >= totalPages.value - 1) {
        startPage = totalPages.value - 3
      }
      
      // Add ellipsis after first page if needed
      if (startPage > 2) {
        pages.push('...')
      }
      
      // Add middle pages
      for (let i = startPage; i <= endPage; i++) {
        pages.push(i)
      }
      
      // Add ellipsis before last page if needed
      if (endPage < totalPages.value - 1) {
        pages.push('...')
      }
      
      // Always show last page
      pages.push(totalPages.value)
    }
    
    return pages
  })
  
  const paginationInfo = computed(() => {
    const from = props.totalItems === 0 ? 0 : (props.currentPage - 1) * props.perPage + 1
    const to = Math.min(from + props.perPage - 1, props.totalItems)
    return { from, to }
  })
  
  // Methods
  function toggleSelectAll() {
    if (allSelected.value) {
      emit('update:selectedItems', [])
      emit('deselect-all')
    } else {
      emit('update:selectedItems', [...props.items])
      emit('select-all', props.items)
    }
  }
  
  function toggleSelect(item) {
    const isCurrentlySelected = isSelected(item)
    
    if (isCurrentlySelected) {
      emit('update:selectedItems', props.selectedItems.filter(i => i.id !== item.id))
    } else {
      emit('update:selectedItems', [...props.selectedItems, item])
    }
  }
  
  function isSelected(item) {
    return props.selectedItems.some(i => i.id === item.id)
  }
  
  function sort(key) {
    if (!props.sortable) return
    
    if (sortKey.value === key) {
      // Toggle sort order
      sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
    } else {
      // New sort key
      sortKey.value = key
      sortOrder.value = 'asc'
    }
    
    emit('sort', { key: sortKey.value, order: sortOrder.value })
  }
  
  function goToPage(page) {
    if (page < 1 || page > totalPages.value || page === props.currentPage) return
    emit('update:currentPage', page)
  }
  
  function toggleActions(id) {
    activeDropdown.value = activeDropdown.value === id ? null : id
  }
  
  function handleAction(action, item) {
    activeDropdown.value = null
    
    if (typeof action.handler === 'function') {
      action.handler(item)
    } else {
      emit('action', { action: action.key || action.label, item })
    }
  }
  
  function getItemValue(item, key) {
    // Handle nested keys with dot notation (e.g., 'user.name')
    if (key.includes('.')) {
      return key.split('.').reduce((obj, path) => obj && obj[path], item)
    }
    return item[key]
  }
  
  function formatValue(value, formatter) {
    if (!value) return ''
    
    if (formatter) {
      if (typeof formatter === 'function') {
        return formatter(value)
      }
      
      // Built-in formatters
      switch (formatter) {
        case 'date':
          return new Date(value).toLocaleDateString('fr-FR')
        case 'datetime':
          return new Date(value).toLocaleString('fr-FR')
        case 'currency':
          return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(value)
        case 'number':
          return new Intl.NumberFormat('fr-FR').format(value)
        case 'percentage':
          return new Intl.NumberFormat('fr-FR', { style: 'percent', maximumFractionDigits: 2 }).format(value / 100)
        default:
          return value
      }
    }
    
    return value
  }
  
  function getColspan() {
    let span = props.columns.length
    if (props.selectable) span++
    if (hasRowActions.value) span++
    return span
  }
  
  // Close dropdown when clicking outside
  function handleClickOutside(event) {
    if (activeDropdown.value !== null) {
      activeDropdown.value = null
    }
  }
  
  // Lifecycle hooks
  onMounted(() => {
    document.addEventListener('click', handleClickOutside)
  })
  
  onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside)
  })
  </script>
  
  <style scoped>
  .fade-enter-active,
  .fade-leave-active {
    transition: opacity 0.15s ease-out;
  }
  
  .fade-enter-from,
  .fade-leave-to {
    opacity: 0;
  }
  </style> 