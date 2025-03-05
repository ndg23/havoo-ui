<template>
  <div class="max-w-3xl mx-auto px-4 py-12">
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8">
      <!-- En-tête -->
      <div class="flex items-center justify-between mb-8">
        <h1 class="text-2xl font-bold text-gray-900">Modifier mon profil</h1>
        <NuxtLink 
          to="/account" 
          class="text-sm text-gray-600 hover:text-gray-900 flex items-center gap-1"
        >
          <ArrowLeft class="w-4 h-4" />
          <span>Retour au profil</span>
        </NuxtLink>
      </div>
      
      <!-- Photo de profil -->
      <div class="flex flex-col items-center mb-10">
        <div class="relative">
          <div class="w-28 h-28 rounded-full bg-gray-100 flex items-center justify-center overflow-hidden">
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
            class="absolute bottom-0 right-0 w-9 h-9 rounded-full bg-primary-600 flex items-center justify-center border-2 border-white"
          >
            <Camera class="w-5 h-5 text-white" />
          </button>
        </div>
        <div class="mt-4 flex gap-3">
          <button 
            type="button"
            class="text-sm text-primary-600 font-medium"
          >
            Changer la photo
          </button>
          <button 
            v-if="form.profileImage"
            type="button"
            class="text-sm text-gray-600 font-medium"
          >
            Supprimer
          </button>
        </div>
      </div>
      
      <!-- Formulaire -->
      <form @submit.prevent="saveProfile" class="space-y-6">
        <!-- Informations personnelles -->
        <div class="space-y-4">
          <h2 class="text-lg font-medium text-gray-900">Informations personnelles</h2>
          
          <!-- Nom et prénom -->
          <div class="grid grid-cols-2 gap-4">
            <FloatingInput
              id="firstName"
              label="Prénom"
              :model-value="form.firstName"
              @update:model-value="form.firstName = $event"
              placeholder="Votre prénom"
            />
            <FloatingInput
              id="lastName"
              label="Nom"
              :model-value="form.lastName"
              @update:model-value="form.lastName = $event"
              placeholder="Votre nom"
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
            />
            <FloatingInput
              id="phone"
              label="Téléphone"
              type="tel"
              :model-value="form.phone"
              @update:model-value="form.phone = $event"
              placeholder="+229 00 00 00 00"
              :icon="Phone"
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
            />
            <div class="space-y-2">
              <label class="block text-sm font-medium text-gray-700">Genre</label>
              <div class="flex gap-4">
                <label class="flex items-center gap-2">
                  <input 
                    type="radio" 
                    name="gender" 
                    value="male"
                    v-model="form.gender"
                    class="text-primary-600 focus:ring-primary-500"
                  />
                  <span class="text-gray-900">Homme</span>
                </label>
                <label class="flex items-center gap-2">
                  <input 
                    type="radio" 
                    name="gender" 
                    value="female"
                    v-model="form.gender"
                    class="text-primary-600 focus:ring-primary-500"
                  />
                  <span class="text-gray-900">Femme</span>
                </label>
                <label class="flex items-center gap-2">
                  <input 
                    type="radio" 
                    name="gender" 
                    value="other"
                    v-model="form.gender"
                    class="text-primary-600 focus:ring-primary-500"
                  />
                  <span class="text-gray-900">Autre</span>
                </label>
              </div>
            </div>
          </div>
          
          <!-- Adresse -->
          <FloatingInput
            id="address"
            label="Adresse"
            :model-value="form.address"
            @update:model-value="form.address = $event"
            placeholder="Votre adresse complète"
            :icon="MapPin"
          />
          
          <!-- Ville et pays -->
          <div class="grid grid-cols-2 gap-4">
            <FloatingInput
              id="city"
              label="Ville"
              :model-value="form.city"
              @update:model-value="form.city = $event"
              placeholder="Votre ville"
            />
            <FloatingInput
              id="country"
              label="Pays"
              :model-value="form.country"
              @update:model-value="form.country = $event"
              placeholder="Votre pays"
            />
          </div>
        </div>
        
        <!-- Bio -->
        <div class="space-y-4 pt-4 border-t border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">À propos de vous</h2>
          
          <FloatingTextarea
            id="bio"
            label="Biographie"
            :model-value="form.bio"
            @update:model-value="form.bio = $event"
            placeholder="Parlez-nous un peu de vous..."
            
          />
          
          <p class="text-sm text-gray-500">
            Cette information sera affichée publiquement, alors soyez prudent avec ce que vous partagez.
          </p>
        </div>
        
        <!-- Préférences de notification -->
        <div class="space-y-4 pt-4 border-t border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">Préférences de notification</h2>
          
          <div class="space-y-3">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-900">Notifications par email</p>
                <p class="text-sm text-gray-500">Recevez des emails concernant vos demandes et messages</p>
              </div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" v-model="form.emailNotifications" class="sr-only peer">
                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600"></div>
              </label>
            </div>
            
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-900">Notifications push</p>
                <p class="text-sm text-gray-500">Recevez des notifications sur votre appareil</p>
              </div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" v-model="form.pushNotifications" class="sr-only peer">
                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary-600"></div>
              </label>
            </div>
          </div>
        </div>
        
        <!-- Boutons d'action -->
        <div class="pt-6 flex items-center justify-between">
          <button 
            type="button"
            @click="resetForm"
            class="px-6 py-2.5 border border-gray-300 rounded-xl text-gray-700 hover:bg-gray-50 transition-colors"
          >
            Annuler
          </button>
          
          <button 
            type="submit"
            class="px-6 py-2.5 bg-primary-600 text-white rounded-xl hover:bg-primary-700 transition-colors"
          >
            Enregistrer les modifications
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ArrowLeft, User, Camera, Mail, Phone, Calendar, MapPin } from 'lucide-vue-next'
import FloatingInput from '~/components/shared/FloatingInput.vue'
import FloatingTextarea from '~/components/shared/FloatingTextarea.vue'

// État du formulaire
const form = ref({
  profileImage: 'https://randomuser.me/api/portraits/men/32.jpg',
  firstName: 'Thomas',
  lastName: 'Kouadio',
  email: 'thomas.kouadio@example.com',
  phone: '+229 97 12 34 56',
  birthdate: '1990-05-15',
  gender: 'male',
  address: '123 Rue Principale',
  city: 'Cotonou',
  country: 'Bénin',
  bio: 'Passionné par les nouvelles technologies et le développement personnel.',
  emailNotifications: true,
  pushNotifications: false
})

// Copie initiale pour réinitialiser
const initialForm = { ...form.value }

// Méthodes
const saveProfile = async () => {
  try {
    // Simuler l'envoi des données
    console.log('Données soumises:', form.value)
    
    // Afficher un message de succès
    alert('Profil mis à jour avec succès')
    
    // Rediriger vers la page de profil
    navigateTo('/account')
  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil:', error)
  }
}

const resetForm = () => {
  // Réinitialiser le formulaire
  form.value = { ...initialForm }
  
  // Rediriger vers la page de profil
  navigateTo('/account')
}
</script> 