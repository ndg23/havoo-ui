<template>
  <div class="max-w-4xl mx-auto px-4 py-6">
    <h1 class="text-2xl font-bold mb-8">Paramètres du compte</h1>

    <!-- Profile completion progress - More prominent -->
    <div v-if="profile" class="mb-8 border-2 border-primary-200 dark:border-primary-900 bg-primary-50 dark:bg-primary-900/20 rounded-xl p-5">
      <div class="flex justify-between items-center mb-3">
        <div class="font-medium text-primary-800 dark:text-primary-300">Complétude du profil</div>
        <div class="text-primary-700 dark:text-primary-400 font-bold text-lg">{{ profile.profile_completion_percentage }}%</div>
      </div>
      <div class="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-3">
        <div 
          class="bg-primary-600 h-3 rounded-full transition-all duration-500" 
          :style="{ width: `${profile.profile_completion_percentage}%` }"
        ></div>
      </div>
      <div v-if="profile.profile_completion_percentage < 100" class="mt-3 text-sm text-primary-700 dark:text-primary-400 flex items-center">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
        </svg>
        Complétez votre profil pour augmenter vos chances d'être contacté
      </div>
    </div>

    <!-- Loading state -->
    <div v-if="isLoading" class="py-10 flex justify-center">
      <svg class="animate-spin h-8 w-8 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>

    <div v-else class="space-y-8">
      <!-- Profile information - More prominent -->
      <div class="border border-gray-200 dark:border-gray-700 rounded-xl overflow-hidden shadow-sm">
        <div class="px-5 py-4 bg-gray-50 dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
          <h2 class="font-medium text-lg flex items-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2 text-primary-500" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
            </svg>
            Informations personnelles
          </h2>
        </div>
        
        <div class="p-5">
          <!-- Avatar - Larger and more prominent -->
          <div class="flex items-center mb-8">
            <div class="relative">
              <img 
                :src="avatarPreview || profile?.avatar_url || '/images/default-avatar.png'" 
                alt="Avatar" 
                class="w-24 h-24 rounded-full object-cover border-2 border-gray-200 dark:border-gray-700"
              />
              <button 
                type="button"
                @click="$refs.avatarInput.click()"
                class="absolute bottom-0 right-0 bg-primary-600 hover:bg-primary-700 text-white border border-white dark:border-gray-800 rounded-full p-2 shadow-md"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                  <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                </svg>
              </button>
              <input 
                ref="avatarInput"
                type="file"
                accept="image/*"
                class="hidden"
                @change="handleAvatarChange"
              />
            </div>
            <div class="ml-5">
              <div class="font-medium text-lg">Photo de profil</div>
              <div class="text-sm text-gray-500">JPG ou PNG. 2MB max.</div>
              <button 
                v-if="avatarPreview" 
                @click="cancelAvatarUpload" 
                class="mt-2 text-sm text-red-600 hover:text-red-700 dark:text-red-400 dark:hover:text-red-300"
              >
                Annuler
              </button>
            </div>
          </div>

          <!-- Name and Contact Info -->
          <div class="space-y-5">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prénom et Nom</label>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <input
                  v-model="formData.first_name"
                  type="text"
                  placeholder="Prénom"
                  required
                  class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-xl dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
                />
                
                <input
                  v-model="formData.last_name"
                  type="text"
                  placeholder="Nom"
                  required
                  class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-xl dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
                />
              </div>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Email</label>
              <input
                v-model="formData.email"
                type="email"
                placeholder="Email"
                disabled
                class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-xl bg-gray-50 dark:bg-gray-800 text-gray-500 dark:text-gray-400"
              />
              <p class="mt-1 text-xs text-gray-500">L'email ne peut pas être modifié car il est lié à votre compte.</p>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Téléphone</label>
              <input
                v-model="formData.phone"
                type="tel"
                placeholder="Téléphone (optionnel)"
                class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-xl dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Bio</label>
              <textarea
                v-model="formData.bio"
                rows="4"
                placeholder="Parlez un peu de vous..."
                class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-xl dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
              ></textarea>
              <p class="mt-1 text-xs text-gray-500">Une bio personnelle aide à créer la confiance avec les clients potentiels.</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Expert Mode Settings - More prominent -->
      <div class="border border-gray-200 dark:border-gray-700 rounded-xl overflow-hidden shadow-sm">
        <div class="px-5 py-4 bg-gray-50 dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
          <h2 class="font-medium text-lg flex items-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2 text-primary-500" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zM10 13a3 3 0 100-6 3 3 0 000 6z" clip-rule="evenodd" />
            </svg>
            Mode Expert
          </h2>
        </div>
        
        <div class="p-5">
          <div class="flex items-center justify-between mb-6 bg-gray-50 dark:bg-gray-800/50 p-4 rounded-xl">
            <div>
              <h3 class="font-medium text-gray-900 dark:text-white">Activer le mode Expert</h3>
              <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
                Proposez vos services et recevez des missions
              </p>
            </div>
            
            <label class="relative inline-flex items-center cursor-pointer">
              <input 
                type="checkbox" 
                v-model="formData.is_expert" 
                class="sr-only peer"
              >
              <div class="w-12 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-6 peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-primary-600"></div>
            </label>
          </div>
          
          <!-- Skills Section - Only show when expert mode is on -->
          <div v-if="formData.is_expert" class="space-y-5">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Compétences <span class="text-gray-500">(obligatoire pour les experts)</span>
              </label>
              
              <!-- Skills Input -->
              <div class="relative">
                <input
                  v-model="skillSearchQuery"
                  type="text"
                  placeholder="Rechercher une compétence..."
                  class="w-full px-4 py-2.5 border border-gray-300 dark:border-gray-600 rounded-xl dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
                  @input="searchSkills"
                  @focus="showSkillResults = true"
                />
                
                <!-- Skills dropdown results -->
                <div 
                  v-if="showSkillResults && filteredSkills.length > 0" 
                  class="absolute z-10 mt-1 w-full bg-white dark:bg-gray-800 shadow-lg rounded-xl border border-gray-200 dark:border-gray-700 max-h-60 overflow-auto"
                >
                  <div 
                    v-for="skill in filteredSkills" 
                    :key="skill.id"
                    @click="addSkill(skill)"
                    class="px-4 py-2.5 hover:bg-gray-100 dark:hover:bg-gray-700 cursor-pointer text-gray-800 dark:text-gray-200"
                  >
                    {{ skill.name }}
                  </div>
                </div>
              </div>
              
              <!-- Selected skills -->
              <div v-if="selectedSkills.length > 0" class="mt-3 flex flex-wrap gap-2">
                <span 
                  v-for="skill in selectedSkills" 
                  :key="skill.id"
                  class="inline-flex items-center px-3 py-1.5 rounded-full text-sm font-medium bg-primary-100 text-primary-800 dark:bg-primary-900/30 dark:text-primary-300"
                >
                  {{ skill.name }}
                  <button 
                    type="button" 
                    @click="removeSkill(skill)"
                    class="ml-1.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-600 dark:text-primary-400 hover:bg-primary-200 dark:hover:bg-primary-800"
                  >
                    <svg class="h-3 w-3" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                      <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                    </svg>
                  </button>
                </span>
              </div>
              
              <p v-else-if="formData.is_expert" class="mt-2 text-sm text-yellow-600 dark:text-yellow-400 flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                </svg>
                Ajoutez au moins une compétence pour compléter votre profil
              </p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Submit Button - More prominent -->
      <div class="flex justify-end">
        <button 
          @click="updateProfile" 
          :disabled="isSubmitting"
          class="px-5 py-3 bg-primary-600 hover:bg-primary-700 text-white rounded-xl text-lg font-medium shadow-sm transition-all hover:shadow-md flex items-center justify-center min-w-[200px]"
          :class="{ 'opacity-75 cursor-not-allowed': isSubmitting }"
        >
          <svg v-if="isSubmitting" class="animate-spin -ml-1 mr-2 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          {{ isSubmitting ? 'Enregistrement...' : 'Enregistrer les modifications' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
// import { useToast } from 'vue-toastification'
import { useSupabaseClient, useSupabaseUser } from '#imports'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const toast = useToast()

// State
const profile = ref(null)
const allSkills = ref([])
const selectedSkills = ref([])
const isLoading = ref(true)
const isSubmitting = ref(false)
const skillSearch = ref('')
const showSkillResults = ref(false)
const avatarFile = ref(null)
const avatarPreview = ref(null)

// Form data
const formData = reactive({
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  bio: '',
  is_expert: false
})

// Fetch current user profile
async function fetchProfile() {
  isLoading.value = true
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()
    
    if (error) throw error
    
    profile.value = data
    
    // Populate form with profile data
    formData.first_name = data.first_name || ''
    formData.last_name = data.last_name || ''
    formData.email = data.email || ''
    formData.phone = data.phone || ''
    formData.bio = data.bio || ''
    formData.is_expert = data.is_expert || false
    
    // If user is expert, fetch their skills
    if (data.is_expert) {
      await fetchUserSkills()
    }
  } catch (error) {
    console.error('Error fetching profile:', error)
    toast.error('Erreur lors du chargement du profil')
  } finally {
    isLoading.value = false
  }
}

// Fetch user skills
async function fetchUserSkills() {
  try {
    const { data, error } = await supabase
      .from('user_skills')
      .select('skill_id, skills(id, name)')
      .eq('user_id', user.value.id)
    
    if (error) throw error
    
    selectedSkills.value = data.map(item => item.skills)
  } catch (error) {
    console.error('Error fetching user skills:', error)
  }
}

// Fetch all available skills
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

// Add skill to selected skills
function addSkill(skill) {
  const exists = selectedSkills.value.some(s => s.id === skill.id)
  if (!exists) {
    selectedSkills.value.push(skill)
  }
  skillSearch.value = ''
  showSkillResults.value = false
}

// Remove skill from selected skills
function removeSkill(skill) {
  selectedSkills.value = selectedSkills.value.filter(s => s.id !== skill.id)
}

// Handle avatar image change
function handleAvatarChange(event) {
  const file = event.target.files[0]
  if (!file) return
  
  // Basic validation
  if (file.size > 2 * 1024 * 1024) {
    toast.error('L\'image est trop volumineuse (max 2MB)')
    return
  }
  
  avatarFile.value = file
  
  // Create preview
  const reader = new FileReader()
  reader.onload = e => {
    avatarPreview.value = e.target.result
  }
  reader.readAsDataURL(file)
}

// Upload avatar to storage
async function uploadAvatar() {
  if (!avatarFile.value) return null
  
  try {
    const fileExt = avatarFile.value.name.split('.').pop()
    const filePath = `avatars/${user.value.id}-${Date.now()}.${fileExt}`
    
    const { error: uploadError } = await supabase.storage
      .from('profiles')
      .upload(filePath, avatarFile.value)
    
    if (uploadError) throw uploadError
    
    const { data } = supabase.storage
      .from('profiles')
      .getPublicUrl(filePath)
    
    return data.publicUrl
  } catch (error) {
    console.error('Error uploading avatar:', error)
    toast.error('Erreur lors de l\'upload de l\'avatar')
    return null
  }
}

// Update user profile
async function updateProfile() {
  isSubmitting.value = true
  
  try {
    // Upload avatar if changed
    let avatarUrl = profile.value?.avatar_url
    if (avatarFile.value) {
      const newAvatarUrl = await uploadAvatar()
      if (newAvatarUrl) {
        avatarUrl = newAvatarUrl
      }
    }
    
    // Update profile
    const { error: profileError } = await supabase
      .from('profiles')
      .update({
        first_name: formData.first_name,
        last_name: formData.last_name,
        phone: formData.phone,
        bio: formData.bio,
        avatar_url: avatarUrl,
        is_expert: formData.is_expert,
        updated_at: new Date()
      })
      .eq('id', user.value.id)
    
    if (profileError) throw profileError
    
    // Update skills if user is expert
    if (formData.is_expert) {
      // First delete all existing skills
      const { error: deleteError } = await supabase
        .from('user_skills')
        .delete()
        .eq('user_id', user.value.id)
      
      if (deleteError) throw deleteError
      
      // Then insert new skills
      if (selectedSkills.value.length > 0) {
        const skillsToInsert = selectedSkills.value.map(skill => ({
          user_id: user.value.id,
          skill_id: skill.id
        }))
        
        const { error: insertError } = await supabase
          .from('user_skills')
          .insert(skillsToInsert)
        
        if (insertError) throw insertError
      }
    }
    
    // Refresh profile data
    await fetchProfile()
    
    toast.success('Profil mis à jour avec succès')
  } catch (error) {
    console.error('Error updating profile:', error)
    toast.error('Erreur lors de la mise à jour du profil')
  } finally {
    isSubmitting.value = false
  }
}

// Close dropdown when clicking outside
function handleClickOutside(event) {
  if (showSkillResults.value) {
    showSkillResults.value = false
  }
}

// Initialize
onMounted(async () => {
  document.addEventListener('click', handleClickOutside)
  await fetchProfile()
  await fetchSkills()
})

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
})
</script>

<style scoped>
/* Animation des composants avec transitions plus douces */
.space-y-6 > div {
  animation: fadeIn 0.5s ease;
  animation-fill-mode: both;
  transition: all 0.2s ease;
}

/* Animation séquentielle pour chaque section avec délais plus courts */
.space-y-6 > div:nth-child(1) { animation-delay: 0.05s; }
.space-y-6 > div:nth-child(2) { animation-delay: 0.1s; }
.space-y-6 > div:nth-child(3) { animation-delay: 0.15s; }
.space-y-6 > div:nth-child(4) { animation-delay: 0.2s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(6px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Improved input styling */
input, select, textarea {
  transition: all 0.2s ease;
}

input:focus, select:focus, textarea:focus {
  outline: none;
  box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.2);
}

/* Improved button hover effects */
button {
  transition: all 0.2s ease;
}

/* Custom styling for form elements */
.form-input {
  @apply w-full px-4 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-gray-900 dark:text-white;
  transition: all 0.2s ease;
}

.form-input:focus {
  @apply ring-2 ring-primary-500 border-primary-500;
}

/* Dark mode adjustments for better contrast */
.dark .form-input {
  background-color: rgba(31, 41, 55, 0.8);
}
</style> 