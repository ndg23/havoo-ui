<template>
  <div class="profession-tree">
    <!-- Arbre des professions -->
    <div class="space-y-4">
      <template v-for="profession in topLevelProfessions" :key="profession.id">
        <!-- Catégorie principale -->
        <div class="profession-category">
          <div 
            class="flex items-center justify-between p-4 bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 hover:border-primary-500 dark:hover:border-primary-500 transition-colors cursor-pointer"
            @click="toggleCategory(profession.id)"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
                <UIcon 
                  :name="profession.icon || 'i-heroicons-briefcase'" 
                  class="w-5 h-5 text-primary-600 dark:text-primary-400"
                />
              </div>
              <div>
                <h3 class="font-medium text-gray-900 dark:text-white">
                  {{ profession.name }}
                </h3>
                <p class="text-sm text-gray-500 dark:text-gray-400">
                  {{ profession.description }}
                </p>
              </div>
            </div>
            <UIcon
              :name="expandedCategories[profession.id] ? 'i-heroicons-chevron-up' : 'i-heroicons-chevron-down'"
              class="w-5 h-5 text-gray-400"
            />
          </div>

          <!-- Sous-catégories -->
          <div 
            v-if="expandedCategories[profession.id]"
            class="mt-2 ml-6 space-y-2"
          >
            <div 
              v-for="subcategory in getSubcategories(profession.id)" 
              :key="subcategory.id"
              class="flex items-center gap-3 p-3 bg-gray-50 dark:bg-gray-800/50 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700/50 transition-colors cursor-pointer"
              @click="selectProfession(subcategory)"
            >
              <div class="w-8 h-8 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
                <UIcon 
                  :name="subcategory.icon || 'i-heroicons-rectangle-stack'" 
                  class="w-4 h-4 text-gray-600 dark:text-gray-400"
                />
              </div>
              <div>
                <h4 class="font-medium text-gray-800 dark:text-gray-200">
                  {{ subcategory.name }}
                </h4>
                <p class="text-xs text-gray-500 dark:text-gray-400">
                  {{ subcategory.description }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'

const supabase = useSupabaseClient()

// États
const professions = ref([])
const expandedCategories = ref({})
const isLoading = ref(true)

// Computed
const topLevelProfessions = computed(() => {
  return professions.value.filter(p => !p.parent_id)
})

// Méthodes
const loadProfessions = async () => {
  try {
    const { data, error } = await supabase
      .from('professions')
      .select('*')
      .order('sort_order', { ascending: true })
      .order('name', { ascending: true })

    if (error) throw error
    professions.value = data || []
  } catch (error) {
    console.error('Error loading professions:', error)
  } finally {
    isLoading.value = false
  }
}

const getSubcategories = (parentId) => {
  return professions.value.filter(p => p.parent_id === parentId)
}

const toggleCategory = (id) => {
  expandedCategories.value[id] = !expandedCategories.value[id]
}

const selectProfession = (profession) => {
  emit('select', profession)
}

// Émissions
const emit = defineEmits(['select'])

// Props
defineProps({
  modelValue: {
    type: String,
    default: null
  }
})

// Initialisation
onMounted(() => {
  loadProfessions()
})
</script>

<style scoped>
.profession-tree {
  @apply max-w-3xl mx-auto;
}
</style> 