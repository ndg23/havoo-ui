<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- Header -->
    <div class="flex items-center mb-6">
      <NuxtLink to="/account" class="mr-4 p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors">
        <ArrowLeft class="w-5 h-5 text-gray-700 dark:text-gray-300" />
      </NuxtLink>
      <h1 class="text-xl font-bold">Vérification de profil</h1>
    </div>

    <!-- Progression - simplifiée à une seule étape -->
    <div class="mb-6 bg-white dark:bg-gray-800 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-700">
      <div class="p-5">
        <div class="flex items-center justify-between mb-2">
          <h2 class="font-bold text-lg">Votre progression</h2>
          <span class="text-sm font-medium bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400 px-3 py-1 rounded-full">
            {{ isVerified ? '1/1' : '0/1' }} étape
          </span>
        </div>
        
        <div class="h-2 bg-gray-100 dark:bg-gray-700 rounded-full overflow-hidden">
          <div class="h-full bg-blue-500 rounded-full" :style="`width: ${isVerified ? 100 : 0}%`"></div>
        </div>
      </div>
    </div>

    <!-- Vérification de la CNI uniquement -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden"
         :class="isVerified ? 'border-green-200 dark:border-green-800' : ''">
      <div class="p-5">
        <div class="flex items-start">
          <div class="flex-shrink-0 mr-4">
            <div 
              class="w-8 h-8 rounded-full flex items-center justify-center" 
              :class="isVerified ? 'bg-green-500' : 'bg-gray-200 dark:bg-gray-700'"
            >
              <CheckIcon v-if="isVerified" class="w-5 h-5 text-white" />
              <span v-else class="text-gray-700 dark:text-gray-300 font-bold">1</span>
            </div>
          </div>
          
          <div class="flex-1">
            <h3 class="font-bold text-base flex items-center">
              Vérification d'identité
              <BadgeCheckIcon v-if="isVerified" class="ml-2 w-5 h-5 text-green-500" />
            </h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm mt-1">
              Pour vérifier votre profil, nous avons besoin de votre carte d'identité
            </p>
            
            <!-- Contenu pour upload de CNI -->
            <div v-if="!isVerified" class="mt-4 space-y-4">
              <div class="flex justify-center gap-4">
                <button 
                  @click="openUploadModal('id_front')"
                  class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-4 flex flex-col items-center hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
                  :class="uploads.id_front ? 'border-green-300 dark:border-green-700 bg-green-50 dark:bg-green-900/20' : ''"
                >
                  <div class="w-32 h-20 bg-gray-100 dark:bg-gray-700 rounded flex items-center justify-center mb-2">
                    <div v-if="uploads.id_front" class="relative w-full h-full">
                      <div class="absolute inset-0 flex items-center justify-center bg-black bg-opacity-60 rounded">
                        <CheckCircle class="w-8 h-8 text-green-400" />
                      </div>
                      <CreditCard class="w-8 h-8 text-gray-400 absolute inset-0 m-auto" />
                    </div>
                    <CreditCard v-else class="w-8 h-8 text-gray-400" />
                  </div>
                  <span class="text-sm font-medium">Recto</span>
                </button>
                
                <button 
                  @click="openUploadModal('id_back')"
                  class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-4 flex flex-col items-center hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
                  :class="uploads.id_back ? 'border-green-300 dark:border-green-700 bg-green-50 dark:bg-green-900/20' : ''"
                >
                  <div class="w-32 h-20 bg-gray-100 dark:bg-gray-700 rounded flex items-center justify-center mb-2">
                    <div v-if="uploads.id_back" class="relative w-full h-full">
                      <div class="absolute inset-0 flex items-center justify-center bg-black bg-opacity-60 rounded">
                        <CheckCircle class="w-8 h-8 text-green-400" />
                      </div>
                      <CreditCard class="w-8 h-8 text-gray-400 absolute inset-0 m-auto" />
                    </div>
                    <CreditCard v-else class="w-8 h-8 text-gray-400" />
                  </div>
                  <span class="text-sm font-medium">Verso</span>
                </button>
              </div>
              
              <p class="text-sm text-center text-gray-500">
                Importez une pièce d'identité valide (Carte d'identité, passeport ou permis de conduire)
              </p>
              
              <div class="bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-lg p-3 text-sm text-amber-800 dark:text-amber-400">
                <div class="flex">
                  <ShieldAlert class="w-5 h-5 mr-2 flex-shrink-0" />
                  <p>Vos documents sont traités de manière sécurisée et confidentielle, conformément à notre politique de confidentialité.</p>
                </div>
              </div>
              
              <!-- Bouton de validation -->
              <div class="mt-5 flex justify-end">
                <button 
                  @click="verifyIdentity"
                  class="bg-black text-white px-4 py-2 rounded-full font-bold text-sm hover:bg-gray-800 transition-colors"
                  :disabled="!canSubmit"
                >
                  Valider ma vérification
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Confirmation finale -->
    <div 
      v-if="isVerified" 
      class="mt-6 bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-xl p-5 text-center"
    >
      <BadgeCheck class="w-12 h-12 text-green-500 mx-auto mb-3" />
      <h3 class="font-bold text-lg text-green-800 dark:text-green-400">Vérification soumise avec succès !</h3>
      <p class="text-green-700 dark:text-green-400 my-2">
        Votre pièce d'identité a été envoyée. Nous traiterons votre demande sous 24-48h.
      </p>
      <NuxtLink 
        to="/account" 
        class="mt-3 inline-block bg-green-600 hover:bg-green-700 text-white px-5 py-2 rounded-full font-bold text-sm transition-colors"
      >
        Retour au profil
      </NuxtLink>
    </div>
  </div>
</template>

<script setup>
import { 
  ArrowLeft, CheckIcon, CreditCard, 
  BadgeCheck, BadgeCheckIcon, ShieldAlert,
  CheckCircle
} from 'lucide-vue-next'
import { ref, computed } from 'vue'

// États
const isVerified = ref(false)
const uploads = ref({
  id_front: null,
  id_back: null
})

// Computed
const canSubmit = computed(() => {
  return !!uploads.value.id_front && !!uploads.value.id_back
})

// Méthodes
function openUploadModal(type) {
  // Simulons une fonction d'upload réussie
  setTimeout(() => {
    if (type === 'id_front' || type === 'id_back') {
      uploads.value[type] = `document_${type}_uploaded.jpg`
    }
  }, 1000)
}

function verifyIdentity() {
  if (canSubmit.value) {
    // Simuler une vérification réussie
    setTimeout(() => {
      isVerified.value = true
    }, 1500)
  }
}

definePageMeta({
  layout: 'default'
})
</script> 