<template>
  <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
      <div>
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Compétences</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les compétences de la plateforme</p>
      </div>
      
      <div class="flex items-center gap-3">
        <UButton 
          icon="i-heroicons-arrow-down-tray" 
          color="gray" 
          variant="ghost" 
          @click="exportData"
        >
          Exporter
        </UButton>
        <UButton 
          icon="i-heroicons-plus" 
          @click="openModal()"
        >
          Ajouter
        </UButton>
      </div>
    </div>

    <!-- Table -->
    <UCard>
      <UTable
        :rows="rows"
        :columns="columns"
        :loading="isLoading"
        :search-value="search"
        @update:search-value="search = $event"
      >
        <!-- Skill cell -->
        <template #skill-data="{ row }">
          <div class="flex items-center gap-3">
            <div class="h-10 w-10 rounded-lg bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center text-primary-700 dark:text-primary-400">
              <UIcon :name="row.icon || 'i-heroicons-code-bracket'" class="h-5 w-5" />
            </div>
            <div>
              <p class="text-sm font-medium text-gray-900 dark:text-white">
                {{ row.name }}
              </p>
              <p class="text-xs text-gray-500 dark:text-gray-400">
                {{ row.slug }}
              </p>
            </div>
          </div>
        </template>

        <!-- Category cell -->
        <template #category-data="{ row }">
          <UBadge
            color="gray"
            variant="subtle"
            size="sm"
          >
            {{ row.category || 'Non catégorisé' }}
          </UBadge>
        </template>

        <!-- Status cell -->
        <template #status-data="{ row }">
          <UBadge
            :color="row.is_active ? 'green' : 'red'"
            variant="subtle"
            size="sm"
          >
            <div class="flex items-center gap-1">
              <div 
                class="w-1.5 h-1.5 rounded-full"
                :class="row.is_active ? 'bg-green-500' : 'bg-red-500'"
              />
              {{ row.is_active ? 'Active' : 'Inactive' }}
            </div>
          </UBadge>
        </template>

        <!-- Date cell -->
        <template #created_at-data="{ row }">
          {{ formatDate(row.created_at) }}
        </template>

        <!-- Actions cell -->
        <template #actions-data="{ row }">
          <UDropdown
            :items="[
              [
                {
                  label: 'Modifier',
                  icon: 'i-heroicons-pencil-square',
                  click: () => openModal(row)
                }
              ],
              [
                {
                  label: row.is_active ? 'Désactiver' : 'Activer',
                  icon: row.is_active ? 'i-heroicons-lock-closed' : 'i-heroicons-lock-open',
                  click: () => toggleStatus(row)
                }
              ]
            ]"
          >
            <UButton
              color="gray"
              variant="ghost"
              icon="i-heroicons-ellipsis-horizontal"
            />
          </UDropdown>
        </template>
      </UTable>
    </UCard>

    <!-- Pagination -->
    <div class="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6">
      <div class="flex flex-1 justify-between sm:hidden">
        <UButton
          :disabled="currentPage === 1"
          @click="currentPage--"
          color="gray"
          variant="ghost"
        >
          Précédent
        </UButton>
        <UButton
          :disabled="currentPage >= totalPages"
          @click="currentPage++"
          color="gray"
          variant="ghost"
        >
          Suivant
        </UButton>
      </div>
      <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
        <div>
          <p class="text-sm text-gray-700">
            Affichage de
            <span class="font-medium">{{ startIndex + 1 }}</span>
            à
            <span class="font-medium">{{ endIndex }}</span>
            sur
            <span class="font-medium">{{ totalItems }}</span>
            résultats
          </p>
        </div>
        <div>
          <nav class="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
            <UButton
              :disabled="currentPage === 1"
              @click="currentPage = 1"
              color="gray"
              variant="ghost"
              icon="i-heroicons-chevron-double-left-20-solid"
            />
            <UButton
              :disabled="currentPage === 1"
              @click="currentPage--"
              color="gray"
              variant="ghost"
              icon="i-heroicons-chevron-left-20-solid"
            />
            
            <div class="flex items-center">
              <input
                v-model="currentPage"
                type="number"
                min="1"
                :max="totalPages"
                class="w-16 rounded-lg border-gray-300 text-center text-sm focus:border-primary-500 focus:ring-primary-500"
              />
              <span class="mx-2 text-gray-500">sur {{ totalPages }}</span>
            </div>

            <UButton
              :disabled="currentPage >= totalPages"
              @click="currentPage++"
              color="gray"
              variant="ghost"
              icon="i-heroicons-chevron-right-20-solid"
            />
            <UButton
              :disabled="currentPage >= totalPages"
              @click="currentPage = totalPages"
              color="gray"
              variant="ghost"
              icon="i-heroicons-chevron-double-right-20-solid"
            />
          </nav>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <TransitionRoot appear :show="showModal" as="template">
      <Dialog as="div" @close="showModal = false" class="relative z-50">
        <TransitionChild
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/30" />
        </TransitionChild>

        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full items-center justify-center p-4">
            <TransitionChild
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel class="w-full max-w-2xl transform overflow-hidden rounded-3xl bg-white p-8 border border-gray-100 shadow-xl transition-all">
                <DialogTitle as="h3" class="text-xl font-semibold text-gray-900">
                  {{ editMode ? 'Modifier la compétence' : 'Ajouter une compétence' }}
                </DialogTitle>

                <form @submit.prevent="saveSkill" class="mt-8">
                  <div class="space-y-8">
                    <!-- Nom -->
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">
                        Nom
                      </label>
                      <input
                        type="text"
                        v-model="form.name"
                        required
                        class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                          focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-lg"
                        placeholder="ex: React.js"
                      />
                      <p class="mt-2 text-sm text-gray-500">
                        Le nom de la compétence
                      </p>
                    </div>

                    <!-- Description -->
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">
                        Description
                      </label>
                      <textarea
                        v-model="form.description"
                        rows="4"
                        class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                          focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-lg"
                        placeholder="Description de la compétence..."
                      />
                      <p class="mt-2 text-sm text-gray-500">
                        Une brève description de la compétence
                      </p>
                    </div>

                    <!-- Catégorie -->
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">
                        Catégorie
                      </label>
                      <select
                        v-model="form.category"
                        class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                          focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-lg"
                      >
                        <option value="">Sélectionnez une catégorie</option>
                        <option v-for="cat in categories" :key="cat.value" :value="cat.value">
                          {{ cat.label }}
                        </option>
                      </select>
                      <p class="mt-2 text-sm text-gray-500">
                        La catégorie à laquelle appartient cette compétence
                      </p>
                    </div>

                    <!-- Icône -->
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">
                        Icône
                      </label>
                      <input
                        type="text"
                        v-model="form.icon"
                        class="block w-full px-4 py-3.5 text-gray-900 border border-gray-200 rounded-2xl 
                          focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors text-lg"
                        placeholder="ex: i-heroicons-code-bracket"
                      />
                      <p class="mt-2 text-sm text-gray-500">
                        L'icône qui représente cette compétence
                      </p>
                    </div>

                    <!-- Statut -->
                    <div>
                      <label class="block text-base font-semibold text-gray-900 mb-2">
                        Statut
                      </label>
                      <div class="flex items-center bg-gray-50 p-4 rounded-2xl">
                        <Switch
                          v-model="form.is_active"
                          :class="[form.is_active ? 'bg-blue-600' : 'bg-gray-200']"
                          class="relative inline-flex h-7 w-14 flex-shrink-0 cursor-pointer rounded-full border-2 
                            border-transparent transition-colors duration-200 ease-in-out"
                        >
                          <span
                            :class="[form.is_active ? 'translate-x-7' : 'translate-x-0']"
                            class="pointer-events-none relative inline-block h-6 w-6 transform rounded-full 
                              bg-white shadow ring-0 transition duration-200 ease-in-out"
                          />
                        </Switch>
                        <span class="ml-3 text-base text-gray-700">
                          {{ form.is_active ? 'Compétence active' : 'Compétence inactive' }}
                        </span>
                      </div>
                      <p class="mt-2 text-sm text-gray-500">
                        Définit si la compétence est disponible sur la plateforme
                      </p>
                    </div>
                  </div>

                  <div class="mt-8 flex justify-end space-x-4">
                    <button
                      type="button"
                      class="px-6 py-4 text-base font-semibold text-gray-700 hover:bg-gray-50 
                        rounded-2xl focus:outline-none focus:ring-2 focus:ring-gray-200 transition-all"
                      @click="showModal = false"
                    >
                      Annuler
                    </button>
                    <button
                      type="submit"
                      class="px-6 py-4 bg-blue-600 text-white rounded-2xl font-semibold
                        hover:bg-blue-700 focus:ring-4 focus:ring-blue-500/50 transition-all
                        disabled:opacity-50 disabled:hover:bg-blue-600 flex items-center justify-center gap-2 text-base"
                      :disabled="isSaving"
                    >
                      <Icon 
                        v-if="isSaving"
                        name="heroicons:arrow-path" 
                        class="w-5 h-5 animate-spin"
                      />
                      <Icon 
                        v-else
                        name="heroicons:code-bracket" 
                        class="w-5 h-5"
                      />
                      {{ isSaving ? 'Enregistrement en cours...' : (editMode ? 'Enregistrer les modifications' : 'Ajouter la compétence') }}
                    </button>
                  </div>
                </form>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { useSupabaseClient } from '#imports'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild, Switch } from '@headlessui/vue'

const supabase = useSupabaseClient()
const search = ref('')
const isLoading = ref(true)
const isSaving = ref(false)
const showModal = ref(false)
const skills = ref([])
const editMode = ref(false)

// Predefined categories - you might want to make this dynamic
const categories = [
  { label: 'Frontend', value: 'frontend' },
  { label: 'Backend', value: 'backend' },
  { label: 'DevOps', value: 'devops' },
  { label: 'Mobile', value: 'mobile' },
  { label: 'Design', value: 'design' },
  { label: 'Base de données', value: 'database' },
]

const form = ref({
  name: '',
  description: '',
  category: '',
  icon: '',
  is_active: true
})

// Table columns configuration
const columns = [
  {
    key: 'skill',
    label: 'Compétence',
    sortable: true
  },
  {
    key: 'category',
    label: 'Catégorie',
    sortable: true
  },
  {
    key: 'status',
    label: 'Statut',
    sortable: true
  },
  {
    key: 'created_at',
    label: 'Date de création',
    sortable: true
  },
  {
    key: 'actions',
    label: '',
    sortable: false
  }
]

// Helper functions
const formatDate = (dateString) => {
  if (!dateString) return '-'
  return format(new Date(dateString), 'dd MMM yyyy', { locale: fr })
}

// Actions
const openModal = (skill = null) => {
  if (skill) {
    form.value = { ...skill }
    editMode.value = true
  } else {
    form.value = {
      name: '',
      description: '',
      category: '',
      icon: '',
      is_active: true
    }
    editMode.value = false
  }
  showModal.value = true
}

const toggleStatus = async (skill) => {
  try {
    const { error } = await supabase
      .from('skills')
      .update({ is_active: !skill.is_active })
      .eq('id', skill.id)

    if (error) throw error
    
    loadData()
  } catch (error) {
    console.error('Error toggling status:', error)
  }
}

const saveSkill = async () => {
  isSaving.value = true
  try {
    const { error } = editMode.value
      ? await supabase
          .from('skills')
          .update(form.value)
          .eq('id', form.value.id)
      : await supabase
          .from('skills')
          .insert([form.value])

    if (error) throw error
    
    showModal.value = false
    loadData()
  } catch (error) {
    console.error('Error saving skill:', error)
  } finally {
    isSaving.value = false
  }
}

const exportData = () => {
  // Implement your export logic here
}

// Load data
const loadData = async () => {
  isLoading.value = true
  try {
    const { data, error } = await supabase
      .from('skills')
      .select('*')
      .order('created_at', { ascending: false })
    
    if (error) throw error
    skills.value = data || []
  } catch (error) {
    console.error('Error loading skills:', error)
  } finally {
    isLoading.value = false
  }
}

// Initial load
onMounted(() => {
  loadData()
})

// Add these to your existing refs
const itemsPerPage = ref(10)
const currentPage = ref(1)

// Add these computed properties
const totalItems = computed(() => skills.value.length)
const totalPages = computed(() => Math.ceil(totalItems.value / itemsPerPage.value))
const startIndex = computed(() => (currentPage.value - 1) * itemsPerPage.value)
const endIndex = computed(() => Math.min(startIndex.value + itemsPerPage.value, totalItems.value))

// Modify your existing data loading to use pagination
const paginatedSkills = computed(() => {
  return skills.value.slice(startIndex.value, endIndex.value)
})

// Update your table to use paginatedSkills instead of skills
const rows = computed(() => paginatedSkills.value)

// Watch for page changes to reload data if needed
watch(currentPage, () => {
  // If you're loading from an API, you might want to fetch new data here
  // loadData()
})

definePageMeta({
  layout: 'admin'
})
</script>
