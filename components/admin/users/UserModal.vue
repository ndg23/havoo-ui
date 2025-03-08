<template>
  <BaseModal :is-open="isOpen" :title="user ? 'Modifier l\'utilisateur' : 'Nouvel utilisateur'" @close="$emit('close')" >
    <form @submit.prevent="saveUser" class="space-y-6">
      <!-- Informations personnelles -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Informations personnelles</h4>
        <div class="space-y-4">
          <div class="flex items-center space-x-4">
                  <div class="relative">
                    <div v-if="!form.avatar_url && !imagePreview" class="h-16 w-16 bg-primary-100 dark:bg-primary-900/50 text-primary-700 dark:text-primary-300 flex items-center justify-center rounded-full text-xl font-medium">
                      {{ getInitials(form.first_name, form.last_name) }}
                    </div>
                    <img 
                      v-else-if="imagePreview" 
                      :src="imagePreview" 
                      class="h-16 w-16 rounded-full object-cover border border-gray-200 dark:border-gray-700"
                      alt="Avatar preview"
                    />
                    <img 
                      v-else 
                      :src="form.avatar_url" 
                      class="h-16 w-16 rounded-full object-cover border border-gray-200 dark:border-gray-700"
                      alt="Avatar"
                    />
                    
                    <button 
                      type="button"
                      @click="$refs.fileInput.click()"
                      class="absolute -bottom-1 -right-1 p-1 bg-primary-600 text-white rounded-full hover:bg-primary-700 transition-colors shadow-sm"
                    >
                      <Upload class="h-4 w-4" />
                    </button>
                    <input 
                      ref="fileInput" 
                      type="file" 
                      accept="image/*" 
                      class="hidden" 
                      @change="handleFileChange"
                    />
                  </div>
                  
                  <div>
                    <p class="text-sm text-gray-500 dark:text-gray-400">
                      Choisissez une photo de profil pour l'utilisateur
                    </p>
                    <button 
                      v-if="form.avatar_url || imagePreview"
                      type="button" 
                      @click="removeAvatar"
                      class="text-sm text-red-600 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300 mt-1"
                    >
                      Supprimer l'image
                    </button>
                  </div>
                </div>
          
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Prénom</label>
              <input 
                type="text" 
                v-model="form.first_name"
                class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
                placeholder="Jean"
              >
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Nom de famille</label>
              <input 
                type="text" 
                v-model="form.last_name"
                class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
                placeholder="Dupont"
              >
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
              <input 
                type="email" 
                v-model="form.email"
                class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
                placeholder="jean@example.com"
              >
            </div>
            <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Téléphone</label>
            <input type="text" v-model="form.phone" class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500" placeholder="Téléphone">
          </div>
          </div>
        </div>
      </div>
      <div >
      
      </div>

       <!-- Adresse et localisation -->
        <div>
          <h4 class="text-sm font-medium text-gray-700 mb-4">Localisation</h4>
       <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Pays</label>
            <input type="text" v-model="form.country" class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500" placeholder="Pays">
          </div>
                 
                  
                  <div>
                    <label for="city" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Ville
                    </label>
                    <input
                      v-model="form.city"
                      type="text"
                      id="city"
                      class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                    />
                  </div>
                  <div>
                    <label for="address" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Adresse
                    </label>
                    <input
                      v-model="form.address"
                      type="text"
                      id="address"
                      class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                    />
                  </div>
                </div>
                </div>

      <!-- Rôle et Statut -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Rôle et Statut</h4>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Rôle</label>
            <select
                      v-model="form.role"
                      id="role"
                      required
                      class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
                    >
                      <option value="client">Client</option>
                      <option value="expert">Expert</option>
                      <option value="admin">Administrateur</option>
                    </select>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Statut</label>
            <select 
              v-model="form.status"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
              <option value="active">Actif</option>
              <option value="inactive">Inactif</option>
              <option value="banned">Banni</option>
            </select>
          </div>

            <div>
                    <label for="verification_status" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Statut de vérification
                    </label>
                    <select
                      v-model="form.verification_status"
                      id="verification_status"
                      class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
                    >
                      <option value="none">Non vérifié</option>
                      <option value="pending">En attente</option>
                      <option value="verified">Vérifié</option>
                      <option value="rejected">Rejeté</option>
                    </select>
                  </div>
                  
                  <div class="flex items-end">
                    <label class="flex items-center space-x-2 cursor-pointer">
                      <div class="relative">
                        <input 
                          v-model="form.is_blocked" 
                          type="checkbox" 
                          class="sr-only"
                        />
                        <div class="block bg-gray-200 dark:bg-gray-700 w-10 h-6 rounded-full"></div>
                        <div 
                          class="dot absolute left-1 top-1 w-4 h-4 rounded-full transition-transform duration-300 ease-in-out" 
                          :class="form.is_blocked ? 'bg-red-500 transform translate-x-4' : 'bg-gray-400'"
                        ></div>
                      </div>
                      <span class="text-sm font-medium text-gray-700 dark:text-gray-300">
                        {{ form.is_blocked ? 'Compte bloqué' : 'Compte actif' }}
                      </span>
                    </label>
                  </div>
        </div>
      </div>

         
                <!-- Informations supplémentaires (uniquement pour les experts) -->
                <div v-if="form.role === 'expert'" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label for="hourly_rate" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Tarif horaire (€)
                    </label>
                    <input
                      v-model.number="form.hourly_rate"
                      type="number"
                      id="hourly_rate"
                      min="0"
                      step="1"
                      class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                    />
                  </div>
                  
                  <div>
                    <label for="availability_status" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Disponibilité
                    </label>
                    <select
                      v-model="form.availability_status"
                      id="availability_status"
                      class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none bg-no-repeat"
                    >
                      <option value="available">Disponible</option>
                      <option value="busy">Occupé</option>
                      <option value="unavailable">Indisponible</option>
                    </select>
                  </div>
                </div>

      <!-- Actions -->
      <div class="flex justify-end gap-3 pt-4">
        <button 
          type="button"
          @click="close"
          class="px-4 py-2 text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
        >
          Annuler
        </button>
        <button 
          type="submit"
          :disabled="isLoading"
          :class="{ 'opacity-50 cursor-not-allowed': isLoading }"
          class="px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600"
        >
          {{ user ? 'Modifier' : 'Créer' }}
        </button>
      </div>
    </form>
  </BaseModal>
</template>

<script setup>
import { ref, watch, computed, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'
import { Loader2, X, Upload } from 'lucide-vue-next'
import BaseModal from '@/components/admin/BaseModal.vue'
const props = defineProps({
  isOpen: {
    type: Boolean,
    default: false
  },
  user: {
    type: Object,
    default: () => null
  }
})

const emit = defineEmits(['close', 'saved'])

// État
const fileInput = ref(null)
const imageFile = ref(null)
const imagePreview = ref(null)
const isLoading = ref(false)
const supabase = useSupabaseClient()

// Formulaire
const defaultForm = {
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  address: '',
  city: '',
  country: 'Sénégal',
  role: 'client',
  is_blocked: false,
  verification_status: 'none',
  verification_notes: '',
  bio: '',
  avatar_url: '',
  hourly_rate: 0,
  availability_status: 'available'
}

const form = ref({...defaultForm})

// Surveiller les changements d'utilisateur
watch(() => props.user, (newUser) => {
  if (newUser) {
    form.value = { 
      ...defaultForm,
      ...newUser,
      hourly_rate: newUser.hourly_rate || 0
    }
  } else {
    form.value = { ...defaultForm }
  }
  
  // Réinitialiser l'aperçu de l'image
  imagePreview.value = null
  imageFile.value = null
}, { immediate: true })

// Gérer le changement de fichier
const handleFileChange = (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  imageFile.value = file
  
  // Créer un aperçu
  const reader = new FileReader()
  reader.onload = (e) => {
    imagePreview.value = e.target.result
  }
  reader.readAsDataURL(file)
}

// Supprimer l'avatar
const removeAvatar = () => {
  form.value.avatar_url = null
  imagePreview.value = null
  imageFile.value = null
  if (fileInput.value) fileInput.value.value = ''
}

// Télécharger l'avatar
const uploadAvatar = async () => {
  if (!imageFile.value) return form.value.avatar_url
  
  try {
    const fileExt = imageFile.value.name.split('.').pop()
    const fileName = `${Date.now()}.${fileExt}`
    const filePath = `avatars/${fileName}`
    
    const { error: uploadError } = await supabase.storage
      .from('avatars')
      .upload(filePath, imageFile.value)
    
    if (uploadError) throw uploadError
    
    // Obtenir l'URL publique
    const { data } = supabase.storage
      .from('avatars')
      .getPublicUrl(filePath)
    
    return data.publicUrl
  } catch (error) {
    console.error('Erreur lors du téléchargement de l\'avatar:', error)
    return form.value.avatar_url
  }
}

// Enregistrer l'utilisateur
const saveUser = async () => {
  isLoading.value = true
  
  try {
    // Télécharger l'avatar si nécessaire
    if (imageFile.value) {
      form.value.avatar_url = await uploadAvatar()
    }
    
    if (props.user && props.user.id) {
      // Mettre à jour l'utilisateur existant
      const { error } = await supabase
        .from('profiles')
        .update({
          first_name: form.value.first_name,
          last_name: form.value.last_name,
          phone: form.value.phone,
          address: form.value.address,
          city: form.value.city,
          country: form.value.country,
          role: form.value.role,
          is_blocked: form.value.is_blocked,
          verification_status: form.value.verification_status,
          verification_notes: form.value.verification_notes,
          bio: form.value.bio,
          avatar_url: form.value.avatar_url,
          hourly_rate: form.value.hourly_rate,
          availability_status: form.value.availability_status,
          updated_at: new Date().toISOString()
        })
        .eq('id', props.user.id)
      
      if (error) throw error
      
      // Mettre à jour l'email de l'utilisateur (si nécessaire)
      if (form.value.email !== props.user.email) {
        // Notez que cette opération peut nécessiter des autorisations spéciales
        const { error: emailError } = await supabase.auth.admin.updateUserById(
          props.user.id,
          { email: form.value.email }
        )
        
        if (emailError) {
          console.warn('Impossible de mettre à jour l\'email:', emailError)
        }
      }
    } else {
      // Créer un nouvel utilisateur
      // Cette opération nécessite généralement une logique spéciale côté serveur
      console.warn('La création de nouveaux utilisateurs via l\'interface d\'administration n\'est pas encore implémentée')
    }
    
    // Émettre l'événement saved
    emit('saved')
    
    // Fermer le modal
    emit('close')
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'utilisateur:', error)
    alert(`Erreur: ${error.message}`)
  } finally {
    isLoading.value = false
  }
}

// Utilitaire pour les initiales
const getInitials = (firstName, lastName) => {
  let initials = ''
  if (firstName) initials += firstName.charAt(0).toUpperCase()
  if (lastName) initials += lastName.charAt(0).toUpperCase()
  return initials || '?'
}
</script>

<style scoped>
/* Style pour les sélecteurs avec flèche dropdown */
select {
  background-position: right 1rem center;
  background-repeat: no-repeat;
  background-size: 1em;
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>');
}

/* Style pour le toggle */
.dot {
  transition: transform 0.3s ease, background-color 0.3s ease;
}
</style> 