<template>
  <div class="relative">
    <label 
      :for="id" 
      class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
    >
      {{ label }} <span v-if="required" class="text-red-500">*</span>
    </label>
    
    <div 
      class="relative"
      @click="toggleDropdown"
    >
      <div 
        :id="id"
        class="block w-full rounded-md border border-gray-300 dark:border-gray-700 py-2 px-3 shadow-sm focus:border-primary-500 focus:ring-primary-500 dark:bg-gray-800 dark:text-white sm:text-sm cursor-pointer"
      >
        <div v-if="!modelValue || modelValue.length === 0" class="text-gray-500 dark:text-gray-400">
          {{ placeholder }}
        </div>
        <div v-else class="flex flex-wrap gap-1">
          <span 
            v-for="(item, index) in selectedItems" 
            :key="index"
            class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-primary-100 dark:bg-primary-900/30 text-primary-800 dark:text-primary-300"
          >
            {{ item.label }}
            <button 
              type="button"
              @click.stop="removeItem(item.value)"
              class="ml-1 text-primary-500 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-200"
            >
              <X class="h-3 w-3" />
            </button>
          </span>
        </div>
      </div>
      
      <div class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
        <ChevronDown 
          class="h-4 w-4 text-gray-400 dark:text-gray-500"
          :class="{ 'transform rotate-180': isOpen }"
        />
      </div>
    </div>
    
    <!-- Dropdown -->
    <div 
      v-if="isOpen" 
      class="absolute z-10 mt-1 w-full bg-white dark:bg-gray-800 shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm"
    >
      <div class="sticky top-0 z-10 bg-white dark:bg-gray-800 p-1">
        <input
          v-model="searchQuery"
          type="text"
          class="w-full border-gray-300 dark:border-gray-700 rounded-md shadow-sm focus:border-primary-500 focus:ring-primary-500 dark:bg-gray-700 dark:text-white sm:text-sm"
          placeholder="Rechercher..."
          @click.stop
        />
      </div>
      
      <div v-if="filteredOptions.length === 0" class="px-4 py-2 text-sm text-gray-500 dark:text-gray-400">
        Aucun résultat trouvé
      </div>
      
      <div 
        v-for="option in filteredOptions" 
        :key="option.value"
        class="cursor-pointer select-none relative py-2 pl-3 pr-9 hover:bg-gray-100 dark:hover:bg-gray-700"
        @click.stop="toggleItem(option.value)"
      >
        <div class="flex items-center">
          <input
            type="checkbox"
            class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 dark:border-gray-700 rounded"
            :checked="isSelected(option.value)"
            @click.stop
          />
          <span class="ml-3 block truncate">{{ option.label }}</span>
        </div>
        
        <span 
          v-if="isSelected(option.value)" 
          class="absolute inset-y-0 right-0 flex items-center pr-4 text-primary-600 dark:text-primary-400"
        >
          <Check class="h-4 w-4" />
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, onBeforeUnmount } from 'vue'
import { X, ChevronDown, Check } from 'lucide-vue-next'

const props = defineProps({
  id: {
    type: String,
    required: true
  },
  modelValue: {
    type: Array,
    default: () => []
  },
  options: {
    type: Array,
    required: true
  },
  label: {
    type: String,
    required: true
  },
  placeholder: {
    type: String,
    default: 'Sélectionner des options'
  },
  required: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue'])

const isOpen = ref(false)
const searchQuery = ref('')

// Filtrer les options en fonction de la recherche
const filteredOptions = computed(() => {
  if (!searchQuery.value) return props.options
  
  const query = searchQuery.value.toLowerCase()
  return props.options.filter(option => 
    option.label.toLowerCase().includes(query)
  )
})

// Obtenir les éléments sélectionnés
const selectedItems = computed(() => {
  return props.options.filter(option => 
    props.modelValue.includes(option.value)
  )
})

// Vérifier si une option est sélectionnée
const isSelected = (value) => {
  return props.modelValue.includes(value)
}

// Ajouter ou supprimer une option
const toggleItem = (value) => {
  const newValue = [...props.modelValue]
  const index = newValue.indexOf(value)
  
  if (index === -1) {
    newValue.push(value)
  } else {
    newValue.splice(index, 1)
  }
  
  emit('update:modelValue', newValue)
}

// Supprimer une option
const removeItem = (value) => {
  const newValue = props.modelValue.filter(v => v !== value)
  emit('update:modelValue', newValue)
}

// Ouvrir/fermer le dropdown
const toggleDropdown = () => {
  isOpen.value = !isOpen.value
  if (isOpen.value) {
    searchQuery.value = ''
  }
}

// Fermer le dropdown en cliquant ailleurs
const handleClickOutside = (event) => {
  if (isOpen.value && !event.target.closest(`#${props.id}`)) {
    isOpen.value = false
  }
}

// Lifecycle hooks
onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script> 