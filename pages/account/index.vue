<template>
  <div class="min-h-screen bg-white">
    <!-- Navigation du compte - style Uber -->
    <div class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 z-40 md:relative md:border-t-0 md:border-b md:mb-8">
      <div class="max-w-4xl mx-auto px-2 md:px-5">
        <div class="flex justify-between items-center overflow-x-auto no-scrollbar">
          <NuxtLink 
            v-for="item in navItems" 
            :key="item.path"
            :to="item.path"
            class="flex flex-col items-center py-3 px-3 min-w-[72px] md:min-w-0 md:flex-row md:py-4"
            :class="$route.path === item.path ? 'text-black' : 'text-gray-400 hover:text-gray-600'"
          >
            <component :is="item.icon" class="h-6 w-6 mb-1 md:mr-2 md:mb-0" />
            <span class="text-xs md:text-sm font-medium">{{ item.name }}</span>
          </NuxtLink>
        </div>
      </div>
    </div>

    <!-- En-tête principale -->
    <div class="relative bg-black text-white">
      <!-- Bannière -->
      <div class="relative h-40 md:h-56 overflow-hidden">
        <img 
          v-if="profile.banner_image_url" 
          :src="profile.banner_image_url" 
          alt="Bannière du profil"
          class="w-full h-full object-cover"
        />
        <div 
          v-else 
          class="w-full h-full bg-gradient-to-r from-gray-800 to-gray-900"
        ></div>
        
        <!-- Bouton modifier la bannière -->
        <label 
          v-if="isEditing" 
          class="absolute right-4 top-4 bg-black/50 hover:bg-black/70 text-white rounded-full p-2 cursor-pointer transition-colors"
        >
          <Upload class="h-5 w-5" />
          <input 
            type="file" 
            class="sr-only" 
            accept="image/*"
            @change="uploadBannerImage"
          />
        </label>
      </div>
      
      <!-- Photo de profil et bouton d'édition -->
      <div class="absolute left-0 right-0 -bottom-16 px-5">
        <div class="max-w-4xl mx-auto flex justify-between">
        <div class="relative">
            <div class="h-32 w-32 rounded-full border-4 border-white overflow-hidden bg-gray-100 shadow-lg">
            <img 
                v-if="profile.profile_image_url" 
                :src="profile.profile_image_url" 
              alt="Photo de profil"
              class="w-full h-full object-cover"
            />
              <div v-else class="w-full h-full flex items-center justify-center bg-gray-200">
                <User class="h-14 w-14 text-gray-400" />
        </div>
        
              <!-- Upload button (edit mode) -->
              <label 
                v-if="isEditing" 
                class="absolute inset-0 flex items-center justify-center bg-black/50 cursor-pointer"
              >
                <Camera class="h-8 w-8 text-white" />
                <input 
                  type="file" 
                  class="sr-only" 
                  accept="image/*"
                  @change="uploadProfileImage"
                />
              </label>
            </div>
        </div>
        
          <button 
            v-if="!isEditing" 
            @click="isEditing = true"
            class="bg-black text-white px-5 py-2.5 rounded-full font-medium flex items-center h-min hover:bg-gray-800 transition-colors"
          >
            <Edit class="h-4 w-4 mr-2" />
            Modifier
          </button>
        </div>
      </div>
    </div>
    
    <!-- Contenu du profil -->
    <div class="max-w-4xl mx-auto px-5 pt-24 pb-24 md:pb-16 mt-4">
      <!-- État de chargement -->
      <div v-if="loading" class="flex justify-center py-12">
        <Loader2 class="h-8 w-8 text-gray-400 animate-spin" />
      </div>
      
      <!-- Contenu du profil -->
      <div v-else class="space-y-10">
        <!-- Informations personnelles -->
              <div>
          <div v-if="!isEditing" class="space-y-2">
            <h1 class="text-3xl font-bold text-black">
              {{ profile.first_name }} {{ profile.last_name }}
            </h1>
            <div class="flex flex-wrap items-center gap-x-4 gap-y-2 text-gray-600">
              <div class="flex items-center">
                <Mail class="h-4 w-4 mr-1.5" />
                {{ profile.email }}
              </div>
              <div v-if="profile.phone" class="flex items-center">
                <Phone class="h-4 w-4 mr-1.5" />
                {{ profile.phone }}
              </div>
              <div v-if="profile.city" class="flex items-center">
                <MapPin class="h-4 w-4 mr-1.5" />
                {{ profile.city }}{{ profile.country ? ', ' + profile.country : '' }}
              </div>
              <div v-if="profile.birthdate" class="flex items-center">
                <CalendarDays class="h-4 w-4 mr-1.5" />
                {{ formatDate(profile.birthdate) }}
              </div>
            </div>
            
            <p v-if="profile.bio" class="mt-4 text-lg text-gray-700 whitespace-pre-line">
              {{ profile.bio }}
            </p>
          </div>
          
          <div v-else class="space-y-6">
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label for="first_name" class="block text-sm font-medium text-gray-700 mb-1">
                  Prénom <span class="text-red-500">*</span>
                </label>
                <input
                  id="first_name"
                  v-model="editedProfile.first_name"
                  type="text"
                  required
                  class="w-full p-3 text-lg border-2 border-gray-200 rounded-lg focus:border-black focus:outline-none transition-colors"
                />
              </div>
              <div>
                <label for="last_name" class="block text-sm font-medium text-gray-700 mb-1">
                  Nom <span class="text-red-500">*</span>
                </label>
                <input
                  id="last_name"
                  v-model="editedProfile.last_name"
                  type="text"
                  required
                  class="w-full p-3 text-lg border-2 border-gray-200 rounded-lg focus:border-black focus:outline-none transition-colors"
                />
              </div>
            </div>
            
              <div>
              <label for="bio" class="block text-sm font-medium text-gray-700 mb-1">
                Biographie
              </label>
              <textarea
                id="bio"
                v-model="editedProfile.bio"
                rows="4"
                placeholder="Parlez-nous un peu de vous..."
                class="w-full p-3 text-base border-2 border-gray-200 rounded-lg focus:border-black focus:outline-none transition-colors"
              ></textarea>
            </div>
          </div>
        </div>
        
        <!-- Coordonnées -->
        <div>
          <h2 class="text-xl font-bold text-black mb-6 flex items-center">
            <AtSign class="h-5 w-5 mr-2" />
            Coordonnées
          </h2>
          
          <div v-if="!isEditing" class="grid grid-cols-1 sm:grid-cols-2 gap-6">
            <div>
              <p class="text-sm font-medium text-gray-600">Téléphone</p>
              <p class="text-lg">{{ profile.phone || '—' }}</p>
              </div>
            <div>
              <p class="text-sm font-medium text-gray-600">Adresse email</p>
              <p class="text-lg">{{ profile.email }}</p>
            </div>
            </div>
            
          <div v-else class="space-y-4">
            <div>
              <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">
                Téléphone
              </label>
              <div class="relative">
                <Phone class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
                <input
                  id="phone"
                  v-model="editedProfile.phone"
                  type="tel"
                  placeholder="+33 6 12 34 56 78"
                  class="w-full p-3 pl-10 text-base border-2 border-gray-200 rounded-lg focus:border-black focus:outline-none transition-colors"
                />
              </div>
            </div>
            
            <div>
              <p class="text-sm font-medium text-gray-700">
                Adresse email <span class="text-xs text-gray-500">(non modifiable)</span>
              </p>
              <div class="mt-1 p-3 bg-gray-100 rounded-lg text-gray-600">
                {{ profile.email }}
              </div>
            </div>
          </div>
        </div>
        
        <!-- Adresse -->
        <div>
          <h2 class="text-xl font-bold text-black mb-6 flex items-center">
            <MapPin class="h-5 w-5 mr-2" />
            Localisation
          </h2>
          
          <div v-if="!isEditing" class="grid grid-cols-1 sm:grid-cols-2 gap-6">
            <div>
              <p class="text-sm font-medium text-gray-600">Adresse</p>
              <p class="text-lg">{{ profile.address || '—' }}</p>
              </div>
            <div>
              <p class="text-sm font-medium text-gray-600">Ville</p>
              <p class="text-lg">{{ profile.city || '—' }}</p>
              </div>
            <div>
              <p class="text-sm font-medium text-gray-600">Pays</p>
              <p class="text-lg">{{ profile.country || '—' }}</p>
      </div>
          </div>
          
          <div v-else class="space-y-4">
                    <div>
              <label for="address" class="block text-sm font-medium text-gray-700 mb-1">
                Adresse
              </label>
              <input
                id="address"
                v-model="editedProfile.address"
                type="text"
                placeholder="Numéro et nom de rue"
                class="w-full p-3 text-base border-2 border-gray-200 rounded-lg focus:border-black focus:outline-none transition-colors"
              />
            </div>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label for="city" class="block text-sm font-medium text-gray-700 mb-1">
                  Ville
                </label>
                <input
                  id="city"
                  v-model="editedProfile.city"
                  type="text"
                  class="w-full p-3 text-base border-2 border-gray-200 rounded-lg focus:border-black focus:outline-none transition-colors"
                />
              </div>
              
              <div>
                <label for="country" class="block text-sm font-medium text-gray-700 mb-1">
                  Pays
                </label>
                <input
                  id="country"
                  v-model="editedProfile.country"
                  type="text"
                  class="w-full p-3 text-base border-2 border-gray-200 rounded-lg focus:border-black focus:outline-none transition-colors"
                />
              </div>
            </div>
          </div>
        </div>
        
        <!-- Boutons d'action (édition) -->
        <div v-if="isEditing" class="fixed bottom-20 left-0 right-0 z-30 bg-white border-t border-gray-200 p-4 md:static md:p-0 md:bg-transparent md:border-0">
          <div class="max-w-4xl mx-auto flex gap-3">
            <button
              @click="saveProfile"
              :disabled="isSaving"
              class="flex-1 py-3.5 bg-black text-white font-medium rounded-xl 
                disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center justify-center"
            >
              <Loader2 v-if="isSaving" class="animate-spin -ml-1 mr-2 h-5 w-5" />
              {{ isSaving ? 'Enregistrement...' : 'Enregistrer' }}
            </button>
            
            <button
              @click="cancelEdit"
              class="py-3.5 px-6 border-2 border-gray-200 text-gray-700 font-medium rounded-xl 
                hover:bg-gray-50 transition-colors"
            >
              Annuler
            </button>
          </div>
        </div>
        
        <!-- Déconnexion -->
        <button 
          v-if="!isEditing" 
          @click="logout" 
          class="mt-12 text-red-600 font-medium flex items-center hover:text-red-800 transition-colors"
        >
          <LogOut class="h-5 w-5 mr-2" />
          Se déconnecter
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { 
  User, Edit, Loader2, Mail, Phone, MapPin, Calendar, 
  Camera, Upload, LogOut, Home, Settings, FileText, 
  ShoppingBag, CalendarDays, AtSign, CreditCard
} from 'lucide-vue-next'

const router = useRouter()
const client = useSupabaseClient()

// États
const loading = ref(true)
const isEditing = ref(false)
const isSaving = ref(false)
const profile = ref({})
const editedProfile = reactive({})

// Menu de navigation
const navItems = [
  { name: 'Profil', path: '/account', icon: User },
  { name: 'Demandes', path: '/account/my-demands', icon: FileText },
  { name: 'Services', path: '/account/my-services', icon: ShoppingBag },
  { name: 'Paiements', path: '/account/payments', icon: CreditCard },
  { name: 'Paramètres', path: '/account/settings', icon: Settings },
]

// Formater la date
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// Récupérer les données du profil
const fetchProfile = async () => {
  try {
    loading.value = true
    
    // Récupérer l'utilisateur authentifié
    const { data: { user }, error: authError } = await client.auth.getUser()
    if (authError) throw authError
    if (!user) {
      // Rediriger vers la page de connexion si non authentifié
      router.push('/auth/login')
      return
    }
    
    // Récupérer les données du profil
    const { data, error } = await client
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single()
    
    if (error) throw error
    
    profile.value = data || {}
    
    // Initialiser le formulaire d'édition
    Object.keys(profile.value).forEach(key => {
      editedProfile[key] = profile.value[key]
    })
  } catch (error) {
    console.error('Erreur lors de la récupération du profil:', error)
  } finally {
    loading.value = false
  }
}

// Sauvegarder les modifications du profil
const saveProfile = async () => {
  try {
    // Validation des champs obligatoires
    if (!editedProfile.first_name?.trim() || !editedProfile.last_name?.trim()) {
      alert('Le prénom et le nom sont obligatoires')
      return
    }
    
    isSaving.value = true
    
    const { data: { user } } = await client.auth.getUser()
    if (!user) throw new Error('Non authentifié')
    
    const { error } = await client
      .from('profiles')
      .update({
        first_name: editedProfile.first_name,
        last_name: editedProfile.last_name,
        phone: editedProfile.phone,
        address: editedProfile.address,
        city: editedProfile.city,
        country: editedProfile.country,
        birthdate: editedProfile.birthdate,
        bio: editedProfile.bio,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.id)
    
    if (error) throw error
    
    // Mettre à jour l'état local
    Object.keys(editedProfile).forEach(key => {
      profile.value[key] = editedProfile[key]
    })
    
    // Quitter le mode édition
    isEditing.value = false
  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil:', error)
    alert('Une erreur est survenue lors de la mise à jour du profil')
  } finally {
    isSaving.value = false
  }
}

// Annuler les modifications
const cancelEdit = () => {
  // Réinitialiser les valeurs du formulaire
  Object.keys(profile.value).forEach(key => {
    editedProfile[key] = profile.value[key]
  })
  isEditing.value = false
}

// Télécharger une nouvelle image de profil
const uploadProfileImage = async (event) => {
  try {
    const file = event.target.files[0]
    if (!file) return
    
    const { data: { user } } = await client.auth.getUser()
    if (!user) throw new Error('Non authentifié')
    
    // Générer un nom de fichier unique
    const fileExt = file.name.split('.').pop()
    const fileName = `profile-${user.id}-${Date.now()}.${fileExt}`
    const filePath = `profile-images/${fileName}`
    
    // Télécharger le fichier
    const { error: uploadError } = await client.storage
      .from('avatars')
      .upload(filePath, file)
    
    if (uploadError) throw uploadError
    
    // Obtenir l'URL publique
    const { data } = client.storage
      .from('avatars')
      .getPublicUrl(filePath)
    
    const publicUrl = data.publicUrl
    
    // Mettre à jour le profil avec la nouvelle URL
    const { error: updateError } = await client
      .from('profiles')
      .update({ profile_image_url: publicUrl })
      .eq('id', user.id)
    
    if (updateError) throw updateError
    
    // Mettre à jour l'état local
    profile.value.profile_image_url = publicUrl
    editedProfile.profile_image_url = publicUrl
  } catch (error) {
    console.error('Erreur lors du téléchargement de l\'image:', error)
    alert('Une erreur est survenue lors du téléchargement de l\'image')
  }
}

// Télécharger une nouvelle image de bannière
const uploadBannerImage = async (event) => {
  try {
    const file = event.target.files[0]
    if (!file) return
    
    const { data: { user } } = await client.auth.getUser()
    if (!user) throw new Error('Non authentifié')
    
    // Générer un nom de fichier unique
    const fileExt = file.name.split('.').pop()
    const fileName = `banner-${user.id}-${Date.now()}.${fileExt}`
    const filePath = `banner-images/${fileName}`
    
    // Télécharger le fichier
    const { error: uploadError } = await client.storage
      .from('avatars')
      .upload(filePath, file)
    
    if (uploadError) throw uploadError
    
    // Obtenir l'URL publique
    const { data } = client.storage
      .from('avatars')
      .getPublicUrl(filePath)
    
    const publicUrl = data.publicUrl
    
    // Mettre à jour le profil avec la nouvelle URL
    const { error: updateError } = await client
      .from('profiles')
      .update({ banner_image_url: publicUrl })
      .eq('id', user.id)
    
    if (updateError) throw updateError
    
    // Mettre à jour l'état local
    profile.value.banner_image_url = publicUrl
    editedProfile.banner_image_url = publicUrl
  } catch (error) {
    console.error('Erreur lors du téléchargement de la bannière:', error)
    alert('Une erreur est survenue lors du téléchargement de la bannière')
  }
}

// Déconnexion
const logout = async () => {
  try {
    const { error } = await client.auth.signOut()
    if (error) throw error
    
    // Rediriger vers la page d'accueil
    router.push('/')
  } catch (error) {
    console.error('Erreur lors de la déconnexion:', error)
  }
}

// Charger les données lors du montage du composant
onMounted(fetchProfile)

definePageMeta({
  layout: 'default',
  auth: true
})
</script> 

<style scoped>
/* Masquer la barre de défilement tout en permettant le défilement */
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style> 