<template>
  <div class="max-w-3xl mx-auto px-4 py-12">
    <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-700 p-8">
      <!-- En-tête -->
      <div class="flex items-center justify-between mb-8">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Modifier mon profil</h1>
        <NuxtLink 
          to="/account" 
          class="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white flex items-center gap-1"
        >
          <ArrowLeft class="w-4 h-4" />
          <span>Retour au profil</span>
        </NuxtLink>
      </div>
      
      <!-- Photo de profil -->
      <div class="flex flex-col items-center mb-10">
        <div class="relative">
          <div class="w-28 h-28 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center overflow-hidden">
            <img 
              v-if="form.profileImage" 
              :src="form.profileImage" 
              alt="Photo de profil" 
              class="w-full h-full object-cover"
            />
            <User v-else class="w-12 h-12 text-gray-400" />
          </div>
          <button 
            type="button"
            @click="$refs.fileInput.click()"
            class="absolute bottom-0 right-0 w-9 h-9 rounded-full bg-primary-600 flex items-center justify-center border-2 border-white dark:border-gray-800"
          >
            <Camera class="w-5 h-5 text-white" />
          </button>
          <input
            ref="fileInput"
            type="file"
            accept="image/*"
            class="hidden"
            @change="handleFileUpload"
          />
        </div>
        <div class="mt-4 flex gap-3">
          <button 
            type="button"
            @click="$refs.fileInput.click()"
            class="text-sm text-primary-600 dark:text-primary-400 font-medium"
          >
            Changer la photo
          </button>
          <button 
            v-if="form.profileImage"
            type="button"
            @click="removeAvatar"
            class="text-sm text-gray-600 dark:text-gray-400 font-medium"
          >
            Supprimer
          </button>
        </div>
      </div>
      
      <!-- Formulaire -->
      <form @submit.prevent="saveProfile" class="space-y-6">
        <!-- Informations personnelles -->
        <div class="space-y-4">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white">Informations personnelles</h2>
          
          <!-- Nom et prénom -->
          <div class="grid grid-cols-2 gap-4">
            <FloatingInput
              id="firstName"
              label="Prénom"
              :model-value="form.firstName"
              @update:model-value="form.firstName = $event"
              placeholder="Votre prénom"
              :disabled="loading"
              required
            />
            <FloatingInput
              id="lastName"
              label="Nom"
              :model-value="form.lastName"
              @update:model-value="form.lastName = $event"
              placeholder="Votre nom"
              :disabled="loading"
              required
            />
          </div>
          
          <!-- Email et téléphone -->
          <div class="grid grid-cols-2 gap-4">
            <FloatingInput
              id="email"
              label="Email"
              type="email"
              :model-value="form.email"
              @update:model-value="form.email = $event"
              placeholder="votre@email.com"
              :icon="Mail"
              :disabled="true"
            />
            <FloatingInput
              id="phone"
              label="Téléphone"
              type="tel"
              :model-value="form.phone"
              @update:model-value="form.phone = $event"
              placeholder="+229 00 00 00 00"
              :icon="Phone"
              :disabled="loading"
            />
          </div>
          
          <!-- Date de naissance et genre -->
          <div class="grid grid-cols-2 gap-4">
            <FloatingInput
              id="birthdate"
              label="Date de naissance"
              type="date"
              :model-value="form.birthdate"
              @update:model-value="form.birthdate = $event"
              :icon="Calendar"
              :disabled="loading"
            />
            <div class="space-y-2">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Genre</label>
              <div class="flex gap-4">
                <label class="flex items-center gap-2">
                  <input 
                    type="radio" 
                    name="gender" 
                    value="male"
                    v-model="form.gender"
                    class="text-primary-600 focus:ring-primary-500"
                    :disabled="loading"
                  />
                  <span class="text-gray-900 dark:text-gray-100">Homme</span>
                </label>
                <label class="flex items-center gap-2">
                  <input 
                    type="radio" 
                    name="gender" 
                    value="female"
                    v-model="form.gender"
                    class="text-primary-600 focus:ring-primary-500"
                    :disabled="loading"
                  />
                  <span class="text-gray-900 dark:text-gray-100">Femme</span>
                </label>
              </div>
            </div>
          </div>
          
          <!-- Adresse -->
          <div class="space-y-4 pt-4 border-t border-gray-200 dark:border-gray-700">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white">Adresse</h2>
            
            <FloatingInput
              id="address"
              label="Adresse"
              :model-value="form.address"
              @update:model-value="form.address = $event"
              placeholder="Numéro et nom de rue"
              :icon="MapPin"
              :disabled="loading"
            />
            
            <div class="grid grid-cols-2 gap-4">
              <FloatingInput
                id="city"
                label="Ville"
                :model-value="form.city"
                @update:model-value="form.city = $event"
                placeholder="Votre ville"
                :disabled="loading"
              />
              <FloatingInput
                id="country"
                label="Pays"
                :model-value="form.country"
                @update:model-value="form.country = $event"
                placeholder="Votre pays"
                :disabled="loading"
              />
            </div>
          </div>
          
          <!-- Bio -->
          <div class="space-y-4 pt-4 border-t border-gray-200 dark:border-gray-700">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white">À propos de vous</h2>
            
            <FloatingTextarea
              id="bio"
              label="Biographie"
              :model-value="form.bio"
              @update:model-value="form.bio = $event"
              placeholder="Parlez-nous un peu de vous..."
              :disabled="loading"
            />
            
            <p class="text-sm text-gray-500 dark:text-gray-400">
              Cette information sera affichée publiquement, alors soyez prudent avec ce que vous partagez.
            </p>
          </div>
          
          <!-- Préférences de notification -->
          <div class="space-y-4 pt-4 border-t border-gray-200 dark:border-gray-700">
            <h2 class="text-lg font-medium text-gray-900 dark:text-white">Préférences de notification</h2>
            
            <div class="space-y-3">
              <div class="flex items-center justify-between">
                <div>
                  <p class="text-gray-900 dark:text-white">Notifications par email</p>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Recevez des emails concernant vos demandes et messages</p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" v-model="form.emailNotifications" class="sr-only peer" :disabled="loading">
                  <div class="w-11 h-6 bg-gray-200 dark:bg-gray-700 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary-300 dark:peer-focus:ring-primary-800 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600"></div>
                </label>
              </div>
              
              <div class="flex items-center justify-between">
                <div>
                  <p class="text-gray-900 dark:text-white">Notifications push</p>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Recevez des notifications sur votre appareil</p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" v-model="form.pushNotifications" class="sr-only peer" :disabled="loading">
                  <div class="w-11 h-6 bg-gray-200 dark:bg-gray-700 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary-300 dark:peer-focus:ring-primary-800 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600"></div>
                </label>
              </div>
            </div>
          </div>
          
          <!-- Boutons d'action -->
          <div class="pt-6 flex items-center justify-between">
            <button 
              type="button"
              @click="resetForm"
              class="px-6 py-2.5 border border-gray-300 dark:border-gray-600 rounded-xl text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
              :disabled="loading"
            >
              Annuler
            </button>
            
            <button 
              type="submit"
              class="px-6 py-2.5 bg-primary-600 text-white rounded-xl hover:bg-primary-700 transition-colors flex items-center gap-2"
              :disabled="loading"
            >
              <Loader2 v-if="loading" class="w-4 h-4 animate-spin" />
              Enregistrer les modifications
            </button>
          </div>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { useRouter } from 'vue-router'
import { 
  ArrowLeft, User, Camera, Mail, Phone, Calendar, MapPin, Loader2
} from 'lucide-vue-next'
import FloatingInput from '~/components/shared/FloatingInput.vue'
import FloatingTextarea from '~/components/shared/FloatingTextarea.vue'

// Composables
const supabase = useSupabaseClient()
const currentUser = useSupabaseUser()
const router = useRouter()
const fileInput = ref(null)

// État du formulaire et interface
const loading = ref(false)
const form = ref({
  firstName: '',
  lastName: '', 
  email: '',
  phone: '',
  birthdate: '',
  gender: '',
  address: '',
  city: '',
  country: '',
  bio: '',
  profileImage: '',
  emailNotifications: false,
  pushNotifications: false
})
const avatarFile = ref(null)
const initialForm = ref({})

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
    form.value = {
      firstName: data.first_name || '',
      lastName: data.last_name || '',
      email: currentUser.value.email || '',
      phone: data.phone || '',
      birthdate: data.birthdate || '',
      gender: data.gender || 'male',
      address: data.address || '',
      city: data.city || '',
      country: data.country || '',
      bio: data.bio || '',
      profileImage: data.avatar_url || '',
      emailNotifications: data.email_notifications || false,
      pushNotifications: data.push_notifications || false
    }
    
    // Sauvegarder une copie initiale pour la réinitialisation
    initialForm.value = { ...form.value }
    
  } catch (error) {
    console.error('Erreur lors du chargement des données utilisateur:', error)
    alert('Impossible de charger vos informations. Veuillez réessayer.')
  } finally {
    loading.value = false
  }
}

// Gestion du fichier avatar
const handleFileUpload = (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  // Vérifier le type de fichier
  if (!file.type.match('image.*')) {
    alert('Veuillez sélectionner une image.')
    return
  }
  
  // Vérifier la taille du fichier (max 5MB)
  if (file.size > 5 * 1024 * 1024) {
    alert('La taille de l\'image ne doit pas dépasser 5MB.')
    return
  }
  
  avatarFile.value = file
  
  // Création d'une URL pour prévisualiser l'image
  form.value.profileImage = URL.createObjectURL(file)
}

// Supprimer l'avatar
const removeAvatar = () => {
  avatarFile.value = null
  form.value.profileImage = ''
  
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

// Télécharger le fichier avatar
const uploadAvatar = async () => {
  if (!avatarFile.value) return form.value.profileImage
  
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
    if (!form.value.firstName || !form.value.lastName) {
      alert('Veuillez remplir au moins votre prénom et votre nom.')
      return
    }
    
    // Gérer l'avatar s'il a été modifié
    let avatarUrl = form.value.profileImage
    if (avatarFile.value) {
      const newAvatarUrl = await uploadAvatar()
      if (newAvatarUrl) {
        avatarUrl = newAvatarUrl
      }
    }
    
    // Préparer les données à mettre à jour
    const updates = {
      first_name: form.value.firstName,
      last_name: form.value.lastName,
      phone: form.value.phone,
      birthdate: form.value.birthdate,
      gender: form.value.gender,
      address: form.value.address,
      city: form.value.city,
      country: form.value.country,
      bio: form.value.bio,
      avatar_url: avatarUrl,
      email_notifications: form.value.emailNotifications,
      push_notifications: form.value.pushNotifications,
      updated_at: new Date().toISOString()
    }
    
    // Mettre à jour le profil
    const { error } = await supabase
      .from('profiles')
      .update(updates)
      .eq('id', currentUser.value.id)
    
    if (error) throw error
    
    // Mise à jour réussie
    alert('Votre profil a été mis à jour avec succès!')
    
    // Rediriger vers la page de profil
    router.push('/account')
  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil:', error)
    alert('Une erreur est survenue lors de la mise à jour de votre profil. Veuillez réessayer.')
  } finally {
    loading.value = false
  }
}

// Réinitialiser le formulaire
const resetForm = () => {
  // Réinitialiser le formulaire avec les valeurs initiales
  form.value = { ...initialForm.value }
  
  // Réinitialiser l'avatar
  avatarFile.value = null
  if (fileInput.value) {
    fileInput.value.value = ''
  }
  
  // Rediriger vers la page de profil
  router.push('/account')
}

// Initialisation
onMounted(() => {
  fetchUserData()
})
</script> 