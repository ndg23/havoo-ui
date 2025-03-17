<template>
  <div class="max-w-4xl mx-auto px-4 py-6">
    <div class="flex justify-between items-center mb-5">
      <h1 class="text-xl font-bold">Mes Services</h1>
      <button
        @click="showAddModal = true"
        class="px-4 py-2 bg-primary-600 text-white rounded-full text-sm font-medium"
      >
        Créer
      </button>
    </div>

    <!-- Loading state -->
    <div v-if="isLoading" class="py-10 flex justify-center">
      <svg class="animate-spin h-6 w-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>

    <!-- Empty state -->
    <div v-else-if="services.length === 0" class="py-10 text-center">
      <div class="text-gray-500 mb-3">Vous n'avez pas encore de services</div>
      <button
        @click="showAddModal = true"
        class="px-4 py-2 bg-primary-600 text-white rounded-full text-sm font-medium"
      >
        Créer mon premier service
      </button>
    </div>

    <!-- Services list -->
    <div v-else class="space-y-3">
      <div 
        v-for="service in services" 
        :key="service.id" 
        class="p-4 border border-gray-200 dark:border-gray-700 rounded-xl"
      >
        <div class="flex justify-between items-start">
          <div>
            <div class="font-medium">{{ service.title }}</div>
            <div class="text-sm text-gray-500 mt-1">{{ getCategoryName(service.category_id) }}</div>
          </div>
          <div class="flex items-center">
            <span 
              class="text-xs px-2 py-0.5 rounded-full mr-3"
              :class="service.is_active ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200' : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300'"
            >
              {{ service.is_active ? 'Actif' : 'Brouillon' }}
            </span>
            <div class="relative">
              <button
                @click="toggleMenu(service.id)"
                class="text-gray-400 hover:text-gray-600 dark:text-gray-500 dark:hover:text-gray-300"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                  <path d="M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z" />
                </svg>
              </button>
              <div
                v-if="activeMenu === service.id"
                class="absolute right-0 mt-1 w-36 bg-white dark:bg-gray-800 rounded-md shadow-lg border border-gray-200 dark:border-gray-700 z-10"
              >
                <button
                  @click="editService(service)"
                  class="block w-full text-left px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                >
                  Modifier
                </button>
                <button
                  @click="confirmDelete(service)"
                  class="block w-full text-left px-4 py-2 text-sm text-red-600 dark:text-red-400 hover:bg-gray-100 dark:hover:bg-gray-700"
                >
                  Supprimer
                </button>
              </div>
            </div>
          </div>
        </div>
        <div class="mt-3 text-sm text-gray-500">{{ service.description.substring(0, 120) }}{{ service.description.length > 120 ? '...' : '' }}</div>
        <div class="mt-3 flex justify-between items-center">
          <div class="font-medium">{{ formatPrice(service.price) }}</div>
          <div class="text-sm text-gray-500">Livraison en {{ service.delivery_time }} jours</div>
        </div>
      </div>
    </div>

    <!-- Add/Edit Service Modal -->
    <Teleport to="body">
      <div v-if="showAddModal" class="fixed inset-0 z-50 overflow-y-auto bg-black bg-opacity-50 flex items-center justify-center" @click.self="closeModal">
        <div class="bg-white dark:bg-gray-800 rounded-2xl max-w-lg w-full mx-4">
          <!-- Modal header -->
          <div class="flex justify-between items-center px-5 py-4 border-b border-gray-200 dark:border-gray-700">
            <h3 class="text-lg font-medium">{{ editingService ? 'Modifier le service' : 'Créer un service' }}</h3>
            <button @click="closeModal" class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          
          <div class="p-5">
            <form @submit.prevent="submitService" class="space-y-4">
              <!-- Title -->
              <div>
                <input
                  v-model="serviceForm.title"
                  type="text"
                  placeholder="Titre du service"
                  required
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white"
                />
              </div>
              
              <!-- Category -->
              <div>
                <select
                  v-model="serviceForm.category_id"
                  required
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white"
                >
                  <option value="" disabled>Catégorie</option>
                  <option v-for="category in categories" :key="category.id" :value="category.id">{{ category.name }}</option>
                </select>
              </div>
              
              <!-- Description -->
              <div>
                <textarea
                  v-model="serviceForm.description"
                  rows="3"
                  placeholder="Description du service"
                  required
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white"
                ></textarea>
              </div>
              
              <div class="grid grid-cols-2 gap-4">
                <!-- Price -->
                <div>
                  <input
                    v-model.number="serviceForm.price"
                    type="number"
                    placeholder="Prix (XAF)"
                    min="0"
                    required
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white"
                  />
                </div>
                
                <!-- Delivery Time -->
                <div>
                  <input
                    v-model.number="serviceForm.delivery_time"
                    type="number"
                    placeholder="Délai (jours)"
                    min="1"
                    required
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white"
                  />
                </div>
              </div>
              
              <!-- Skills -->
              <div>
                <div class="text-sm text-gray-500 mb-2">Compétences</div>
                <div class="flex flex-wrap gap-2 mb-2">
                  <div
                    v-for="skill in selectedSkills"
                    :key="skill.id"
                    class="flex items-center bg-gray-100 dark:bg-gray-700 px-2 py-1 rounded-full text-sm"
                  >
                    <span>{{ skill.name }}</span>
                    <button
                      type="button"
                      @click="removeSkill(skill)"
                      class="ml-1 text-gray-500 hover:text-gray-700 dark:text-gray-400"
                    >
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  </div>
                </div>
                <div class="relative">
                  <input
                    v-model="skillSearch"
                    type="text"
                    placeholder="Rechercher des compétences"
                    class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white"
                    @focus="showSkillResults = true"
                  />
                  <div
                    v-if="showSkillResults && filteredSkills.length > 0"
                    class="absolute z-10 mt-1 w-full bg-white dark:bg-gray-700 rounded-lg border border-gray-200 dark:border-gray-600 max-h-40 overflow-auto"
                  >
                    <div
                      v-for="skill in filteredSkills"
                      :key="skill.id"
                      @click="addSkill(skill)"
                      class="px-3 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 cursor-pointer"
                    >
                      {{ skill.name }}
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Status -->
              <div class="flex items-center">
                <input
                  id="is_active"
                  v-model="serviceForm.is_active"
                  type="checkbox"
                  class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                />
                <label for="is_active" class="ml-2 text-sm text-gray-700 dark:text-gray-300">
                  Publier ce service
                </label>
              </div>
              
              <!-- Submit button -->
              <div class="flex justify-end pt-4 border-t border-gray-200 dark:border-gray-700">
                <button
                  type="submit"
                  class="px-4 py-2 bg-primary-600 text-white rounded-full text-sm font-medium flex items-center"
                  :disabled="isSubmitting"
                >
                  <svg v-if="isSubmitting" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  {{ editingService ? 'Enregistrer' : 'Créer' }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </Teleport>

    <!-- Delete Confirmation Modal -->
    <Teleport to="body">
      <div v-if="showDeleteModal" class="fixed inset-0 z-50 overflow-y-auto bg-black bg-opacity-50 flex items-center justify-center" @click.self="showDeleteModal = false">
        <div class="bg-white dark:bg-gray-800 rounded-2xl max-w-md w-full mx-4 p-5">
          <div class="text-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-red-500 mx-auto mb-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
            <h3 class="text-lg font-medium mb-2">Supprimer le service</h3>
            <p class="text-sm text-gray-500 mb-5">
              Êtes-vous sûr de vouloir supprimer ce service ? Cette action est irréversible.
            </p>
            <div class="flex justify-center space-x-3">
              <button
                @click="showDeleteModal = false"
                class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-full text-sm"
              >
                Annuler
              </button>
              <button
                @click="deleteService"
                class="px-4 py-2 bg-red-600 text-white rounded-full text-sm font-medium flex items-center"
                :disabled="isDeleting"
              >
                <svg v-if="isDeleting" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Supprimer
              </button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
// import { useToast } from 'vue-toastification'
import { useSupabaseClient, useSupabaseUser } from '#imports'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const toast = useToast()

// Data
const services = ref([])
const categories = ref([])
const allSkills = ref([])
const selectedSkills = ref([])
const isLoading = ref(true)
const isSubmitting = ref(false)
const isDeleting = ref(false)
const showAddModal = ref(false)
const showDeleteModal = ref(false)
const skillSearch = ref('')
const showSkillResults = ref(false)
const editingService = ref(null)
const serviceToDelete = ref(null)
const activeMenu = ref(null)

// Form
const serviceForm = reactive({
  title: '',
  description: '',
  price: 0,
  delivery_time: 1,
  category_id: '',
  is_active: true
})

// Toggle menu for service actions
function toggleMenu(serviceId) {
  if (activeMenu.value === serviceId) {
    activeMenu.value = null
  } else {
    activeMenu.value = serviceId
  }
}

// Close menu when clicking outside
function closeMenus(event) {
  if (activeMenu.value !== null) {
    activeMenu.value = null
  }
}

// Event listener for clicking outside
onMounted(() => {
  document.addEventListener('click', closeMenus)
})

// Fetch all services for the current user
async function fetchServices() {
  isLoading.value = true
  try {
    const { data, error } = await supabase
      .from('services')
      .select('*')
      .eq('expert_id', user.value.id)
      .order('created_at', { ascending: false })
    
    if (error) throw error
    
    services.value = data
  } catch (error) {
    console.error('Error fetching services:', error)
    toast.error('Erreur lors du chargement des services')
  } finally {
    isLoading.value = false
  }
}

// Fetch all categories
async function fetchCategories() {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .order('name')
    
    if (error) throw error
    
    categories.value = data
  } catch (error) {
    console.error('Error fetching categories:', error)
  }
}

// Fetch all skills
async function fetchSkills() {
  try {
    const { data, error } = await supabase
      .from('skills')
      .select('*')
      .order('name')
    
    if (error) throw error
    
    allSkills.value = data
  } catch (error) {
    console.error('Error fetching skills:', error)
  }
}

// Fetch service skills
async function fetchServiceSkills(serviceId) {
  try {
    const { data, error } = await supabase
      .from('service_skills')
      .select('skill_id, skills(id, name)')
      .eq('service_id', serviceId)
    
    if (error) throw error
    
    selectedSkills.value = data.map(item => item.skills)
  } catch (error) {
    console.error('Error fetching service skills:', error)
  }
}

// Filter skills based on search
const filteredSkills = computed(() => {
  if (!skillSearch.value) return allSkills.value
  
  const search = skillSearch.value.toLowerCase()
  return allSkills.value.filter(skill => {
    const isSelected = selectedSkills.value.some(s => s.id === skill.id)
    if (isSelected) return false
    
    return skill.name.toLowerCase().includes(search)
  })
})

// Add skill
function addSkill(skill) {
  const exists = selectedSkills.value.some(s => s.id === skill.id)
  if (!exists) {
    selectedSkills.value.push(skill)
  }
  skillSearch.value = ''
  showSkillResults.value = false
}

// Remove skill
function removeSkill(skill) {
  selectedSkills.value = selectedSkills.value.filter(s => s.id !== skill.id)
}

// Get category name by ID
function getCategoryName(categoryId) {
  const category = categories.value.find(c => c.id === categoryId)
  return category ? category.name : 'Non catégorisé'
}

// Format price
function formatPrice(price) {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XAF',
    minimumFractionDigits: 0
  }).format(price)
}

// Open modal to edit a service
async function editService(service) {
  editingService.value = service
  activeMenu.value = null
  
  // Reset form and populate with service data
  serviceForm.title = service.title
  serviceForm.description = service.description
  serviceForm.price = service.price
  serviceForm.delivery_time = service.delivery_time
  serviceForm.category_id = service.category_id
  serviceForm.is_active = service.is_active
  
  // Fetch skills for this service
  await fetchServiceSkills(service.id)
  
  showAddModal.value = true
}

// Confirm delete
function confirmDelete(service) {
  serviceToDelete.value = service
  activeMenu.value = null
  showDeleteModal.value = true
}

// Delete service
async function deleteService() {
  if (!serviceToDelete.value) return
  
  isDeleting.value = true
  
  try {
    // Delete skills associations first
    const { error: skillsError } = await supabase
      .from('service_skills')
      .delete()
      .eq('service_id', serviceToDelete.value.id)
    
    if (skillsError) throw skillsError
    
    // Delete the service
    const { error } = await supabase
      .from('services')
      .delete()
      .eq('id', serviceToDelete.value.id)
    
    if (error) throw error
    
    // Update local list
    services.value = services.value.filter(s => s.id !== serviceToDelete.value.id)
    
    toast.success('Service supprimé avec succès')
    showDeleteModal.value = false
  } catch (error) {
    console.error('Error deleting service:', error)
    toast.error('Erreur lors de la suppression du service')
  } finally {
    isDeleting.value = false
    serviceToDelete.value = null
  }
}

// Submit service form (create or update)
async function submitService() {
  isSubmitting.value = true
  
  try {
    const serviceData = {
      expert_id: user.value.id,
      title: serviceForm.title,
      description: serviceForm.description,
      price: serviceForm.price,
      delivery_time: serviceForm.delivery_time,
      category_id: serviceForm.category_id,
      is_active: serviceForm.is_active
    }
    
    let serviceId
    
    if (editingService.value) {
      // Update existing service
      const { data, error } = await supabase
        .from('services')
        .update(serviceData)
        .eq('id', editingService.value.id)
        .select()
      
      if (error) throw error
      
      serviceId = editingService.value.id
      
      // Update local list
      const index = services.value.findIndex(s => s.id === serviceId)
      if (index !== -1) {
        services.value[index] = { ...services.value[index], ...serviceData }
      }
      
      toast.success('Service mis à jour avec succès')
    } else {
      // Create new service
      const { data, error } = await supabase
        .from('services')
        .insert(serviceData)
        .select()
      
      if (error) throw error
      
      serviceId = data[0].id
      
      // Add to local list
      services.value.unshift(data[0])
      
      toast.success('Service créé avec succès')
    }
    
    // Update skills
    if (serviceId) {
      // First delete existing skills
      const { error: deleteError } = await supabase
        .from('service_skills')
        .delete()
        .eq('service_id', serviceId)
      
      if (deleteError) throw deleteError
      
      // Insert new skills
      if (selectedSkills.value.length > 0) {
        const skillsToInsert = selectedSkills.value.map(skill => ({
          service_id: serviceId,
          skill_id: skill.id
        }))
        
        const { error: insertError } = await supabase
          .from('service_skills')
          .insert(skillsToInsert)
        
        if (insertError) throw insertError
      }
    }
    
    // Reset form and close modal
    resetForm()
    showAddModal.value = false
  } catch (error) {
    console.error('Error saving service:', error)
    toast.error('Erreur lors de l\'enregistrement du service')
  } finally {
    isSubmitting.value = false
  }
}

// Reset form
function resetForm() {
  serviceForm.title = ''
  serviceForm.description = ''
  serviceForm.price = 0
  serviceForm.delivery_time = 1
  serviceForm.category_id = ''
  serviceForm.is_active = true
  selectedSkills.value = []
  editingService.value = null
}

// Close modal
function closeModal() {
  showAddModal.value = false
  resetForm()
}

// Lifecycle
onMounted(async () => {
  await Promise.all([
    fetchServices(),
    fetchCategories(),
    fetchSkills()
  ])
})

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
})
</script> 