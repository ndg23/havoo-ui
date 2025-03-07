<template>
    <div class="max-w-3xl mx-auto">
      <div class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-700 shadow-sm">
        <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700">
          <h2 class="font-semibold text-lg text-gray-900 dark:text-white">Modifier mon profil</h2>
        </div>
        
        <form @submit.prevent="saveProfile" class="p-6">
          <!-- Informations personnelles -->
          <div class="mb-6">
            <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-4">Informations personnelles</h3>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-4">
              <div>
                <label for="first_name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prénom</label>
                <input 
                  id="first_name"
                  v-model="form.first_name"
                  type="text" 
                  class="w-full rounded-lg border-gray-300 dark:border-gray-700 dark:bg-gray-800 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                />
              </div>
              
              <div>
                <label for="last_name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom</label>
                <input 
                  id="last_name"
                  v-model="form.last_name"
                  type="text" 
                  class="w-full rounded-lg border-gray-300 dark:border-gray-700 dark:bg-gray-800 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                />
              </div>
            </div>
            
            <div class="mb-4">
              <label for="location" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Localisation</label>
              <input 
                id="location"
                v-model="form.location"
                type="text" 
                placeholder="Ville, pays"
                class="w-full rounded-lg border-gray-300 dark:border-gray-700 dark:bg-gray-800 shadow-sm focus:border-primary-500 focus:ring-primary-500"
              />
            </div>
            
            <div>
              <label for="bio" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Bio</label>
              <textarea 
                id="bio"
                v-model="form.bio"
                rows="4" 
                placeholder="Quelques mots à propos de vous..."
                class="w-full rounded-lg border-gray-300 dark:border-gray-700 dark:bg-gray-800 shadow-sm focus:border-primary-500 focus:ring-primary-500"
              ></textarea>
            </div>
          </div>
          
          <!-- Photo de profil -->
          <div class="mb-6">
            <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-4">Photo de profil</h3>
            
            <div class="flex items-center">
              <div class="relative mr-4">
                <div class="h-20 w-20 rounded-full bg-gray-100 dark:bg-gray-700 overflow-hidden">
                  <img 
                    v-if="avatarPreview || form.avatar_url" 
                    :src="avatarPreview || form.avatar_url" 
                    alt="Photo de profil"
                    class="h-full w-full object-cover"
                  />
                  <div v-else class="h-full w-full flex items-center justify-center">
                    <User class="h-8 w-8 text-gray-400" />
                  </div>
                </div>
              </div>
              
              <div>
                <input
                  ref="fileInput"
                  type="file"
                  accept="image/*"
                  class="hidden"
                  @change="handleFileUpload"
                />
                
                <div class="flex space-x-2">
                  <button
                    type="button"
                    @click="$refs.fileInput.click()"
                    class="px-3 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md hover:bg-gray-50 dark:hover:bg-gray-600"
                  >
                    Changer
                  </button>
                  
                  <button
                    v-if="avatarPreview || form.avatar_url"
                    type="button"
                    @click="removeAvatar"
                    class="px-3 py-2 text-sm font-medium text-red-600 dark:text-red-400 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md hover:bg-red-50 dark:hover:bg-red-900/10"
                  >
                    Supprimer
                  </button>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Configuration expert (si applicable) -->
          <div v-if="form.is_expert" class="mb-6">
            <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-4">Configuration Expert</h3>
            
            <div class="mb-4">
              <label for="hourly_rate" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Tarif horaire (€/h)</label>
              <div class="relative mt-1 rounded-md shadow-sm">
                <input 
                  id="hourly_rate"
                  v-model="form.hourly_rate"
                  type="number" 
                  min="1"
                  class="w-full rounded-lg border-gray-300 dark:border-gray-700 dark:bg-gray-800 shadow-sm focus:border-primary-500 focus:ring-primary-500 pr-12"
                />
                <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                  <span class="text-gray-500 dark:text-gray-400">€/h</span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Boutons d'action -->
          <div class="flex justify-end space-x-3 pt-4 border-t border-gray-100 dark:border-gray-700">
            <NuxtLink 
              to="/account" 
              class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md hover:bg-gray-50 dark:hover:bg-gray-600"
            >
              Annuler
            </NuxtLink>
            
            <button 
              type="submit"
              :disabled="loading"
              class="px-4 py-2 text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <div v-if="loading" class="flex items-center">
                <Loader2 class="animate-spin h-4 w-4 mr-2" />
                Enregistrement...
              </div>
              <span v-else>Enregistrer</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, reactive, onMounted } from 'vue'
  import { useSupabaseClient, useSupabaseUser } from '#imports'
  import { useRouter } from 'vue-router'
  import {
    User, Camera, Loader2
  } from 'lucide-vue-next'
  
  // Composables
  const supabase = useSupabaseClient()
  const currentUser = useSupabaseUser()
  const router = useRouter()
  
  // États
  const loading = ref(false)
  const avatarPreview = ref(null)
  const fileInput = ref(null)
  const avatarFile = ref(null)
  
  // Formulaire
  const form = reactive({
    first_name: '',
    last_name: '',
    email: '',
    location: '',
    bio: '',
    avatar_url: '',
    hourly_rate: 25,
    is_expert: false
  })
  
  // Récupérer les données utilisateur
  const fetchUserData = async () => {
    try {
      loading.value = true
      
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', currentUser.value.id)
        .single()
      
      if (error) throw error
      
      // Remplir le formulaire avec les données existantes
      form.first_name = data.first_name || ''
      form.last_name = data.last_name || ''
      form.email = data.email || ''
      form.location = data.location || ''
      form.bio = data.bio || ''
      form.avatar_url = data.avatar_url || ''
      form.hourly_rate = data.hourly_rate || 25
      form.is_expert = data.is_expert || false
      
    } catch (error) {
      console.error('Erreur lors du chargement des données utilisateur:', error)
    } finally {
      loading.value = false
    }
  }
  
  // Gestion du fichier avatar
  const handleFileUpload = (event) => {
    const file = event.target.files[0]
    if (!file) return
    
    avatarFile.value = file
    
    // Création d'une URL pour prévisualiser l'image
    avatarPreview.value = URL.createObjectURL(file)
  }
  
  // Supprimer l'avatar
  const removeAvatar = () => {
    avatarPreview.value = null
    avatarFile.value = null
    form.avatar_url = ''
    
    if (fileInput.value) {
      fileInput.value.value = ''
    }
  }
  
  // Télécharger le fichier avatar
  const uploadAvatar = async () => {
    if (!avatarFile.value) return form.avatar_url
    
    try {
      // Créer un nom de fichier unique
      const fileExt = avatarFile.value.name.split('.').pop()
      const fileName = `${currentUser.value.id}-${Date.now()}.${fileExt}`
      const filePath = `avatars/${fileName}`
      
      // Télécharger le fichier
      const { error: uploadError } = await supabase.storage
        .from('profiles')
        .upload(filePath, avatarFile.value)
      
      if (uploadError) throw uploadError
      
      // Récupérer l'URL publique
      const { data } = supabase.storage
        .from('profiles')
        .getPublicUrl(filePath)
      
      return data.publicUrl
    } catch (error) {
      console.error('Erreur lors du téléchargement de l\'avatar:', error)
      return null
    }
  }
  
  // Sauvegarder le profil
  const saveProfile = async () => {
    try {
      loading.value = true
      
      // Validation de base
      if (!form.first_name || !form.last_name) {
        alert('Veuillez remplir au moins votre prénom et votre nom.')
        return
      }
      
      // Gérer l'avatar s'il a été modifié
      if (avatarFile.value) {
        const avatarUrl = await uploadAvatar()
        if (avatarUrl) {
          form.avatar_url = avatarUrl
        }
      }
      
      // Mettre à jour le profil
      const { error } = await supabase
        .from('profiles')
        .update({
          first_name: form.first_name,
          last_name: form.last_name,
          location: form.location,
          bio: form.bio,
          avatar_url: form.avatar_url,
          hourly_rate: form.is_expert ? form.hourly_rate : null
        })
        .eq('id', currentUser.value.id)
      
      if (error) throw error
      
      // Rediriger vers la page de profil
      router.push('/account')
    } catch (error) {
      console.error('Erreur lors de la sauvegarde du profil:', error)
      alert('Une erreur est survenue lors de la sauvegarde de votre profil.')
    } finally {
      loading.value = false
    }
  }
  
  // Initialisation
  onMounted(() => {
    fetchUserData()
  })
  </script>