<template>
  <div>
    <!-- En-tête de la section -->
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-900 dark:text-white">Vérification du profil</h2>
      
      <!-- Statut global de vérification -->
      <div 
        class="px-3 py-1.5 rounded-full text-sm font-medium flex items-center"
        :class="getVerificationStatusClasses(userData?.verification_status)"
      >
        <component 
          :is="getVerificationStatusIcon(userData?.verification_status)" 
          class="h-4 w-4 mr-2"
        />
        {{ formatVerificationStatus(userData?.verification_status) }}
      </div>
    </div>
    
    <!-- Explication -->
    <div class="bg-blue-50 dark:bg-blue-900/20 border border-blue-100 dark:border-blue-800/30 rounded-xl p-4 mb-6">
      <div class="flex">
        <Shield class="h-5 w-5 text-blue-500 dark:text-blue-400 mr-3 flex-shrink-0" />
        <div>
          <p class="text-sm text-blue-800 dark:text-blue-300">
            La vérification de votre identité renforce la confiance des utilisateurs et améliore vos chances 
            d'obtenir des demandes ou des propositions. Les profils vérifiés sont mis en avant dans les recherches.
          </p>
        </div>
      </div>
    </div>
    
    <!-- Liste des vérifications -->
    <div class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-700 shadow-sm mb-6">
      <div class="divide-y divide-gray-100 dark:divide-gray-700">
        <!-- Email -->
        <div class="p-4 flex items-center justify-between">
          <div class="flex items-start">
            <div class="p-2 rounded-full bg-green-100 dark:bg-green-900/30 mr-3">
              <Mail class="h-5 w-5 text-green-600 dark:text-green-400" />
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-900 dark:text-white">Email</h3>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                {{ userData?.email }}
              </p>
            </div>
          </div>
          <div class="flex items-center text-sm font-medium text-green-600 dark:text-green-400">
            <CheckCircle class="h-4 w-4 mr-1.5" />
            Vérifié
          </div>
        </div>
        
        <!-- Téléphone -->
        <div class="p-4 flex items-center justify-between">
          <div class="flex items-start">
            <div class="p-2 rounded-full bg-yellow-100 dark:bg-yellow-900/30 mr-3">
              <Phone class="h-5 w-5 text-yellow-600 dark:text-yellow-400" />
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-900 dark:text-white">Téléphone</h3>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                {{ userData?.phone || '+33 6 xx xx xx xx' }}
              </p>
            </div>
          </div>
          <button 
            v-if="!userData?.phone_verified"
            @click="verifyPhone" 
            class="text-sm font-medium text-primary-600 dark:text-primary-400 hover:underline"
          >
            Vérifier maintenant
          </button>
          <div 
            v-else
            class="flex items-center text-sm font-medium text-green-600 dark:text-green-400"
          >
            <CheckCircle class="h-4 w-4 mr-1.5" />
            Vérifié
          </div>
        </div>
        
        <!-- Pièce d'identité -->
        <div class="p-4 flex items-center justify-between">
          <div class="flex items-start">
            <div class="p-2 rounded-full bg-gray-100 dark:bg-gray-700 mr-3">
              <CreditCard class="h-5 w-5 text-gray-600 dark:text-gray-400" />
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-900 dark:text-white">Pièce d'identité</h3>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                Carte d'identité ou passeport
              </p>
            </div>
          </div>
          
          <div v-if="uploadStatus.id === 'verified'" class="flex items-center text-sm font-medium text-green-600 dark:text-green-400">
            <CheckCircle class="h-4 w-4 mr-1.5" />
            Vérifié
          </div>
          <div v-else-if="uploadStatus.id === 'pending'" class="flex items-center text-sm font-medium text-amber-600 dark:text-amber-400">
            <Clock class="h-4 w-4 mr-1.5" />
            En cours de vérification
          </div>
          <div v-else-if="uploadStatus.id === 'rejected'" class="flex items-center text-sm font-medium text-red-600 dark:text-red-400">
            <XCircle class="h-4 w-4 mr-1.5" />
            Rejeté
            <button 
              @click="openIdUpload"
              class="ml-2 text-primary-600 dark:text-primary-400 hover:underline"
            >
              Réessayer
            </button>
          </div>
          <button 
            v-else
            @click="openIdUpload" 
            class="text-sm font-medium text-primary-600 dark:text-primary-400 hover:underline"
          >
            Ajouter
          </button>
        </div>
        
        <!-- Justificatif de domicile -->
        <div class="p-4 flex items-center justify-between">
          <div class="flex items-start">
            <div class="p-2 rounded-full bg-gray-100 dark:bg-gray-700 mr-3">
              <Home class="h-5 w-5 text-gray-600 dark:text-gray-400" />
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-900 dark:text-white">Justificatif de domicile</h3>
              <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                Facture récente (moins de 3 mois)
              </p>
            </div>
          </div>
          
          <div v-if="uploadStatus.address === 'verified'" class="flex items-center text-sm font-medium text-green-600 dark:text-green-400">
            <CheckCircle class="h-4 w-4 mr-1.5" />
            Vérifié
          </div>
          <div v-else-if="uploadStatus.address === 'pending'" class="flex items-center text-sm font-medium text-amber-600 dark:text-amber-400">
            <Clock class="h-4 w-4 mr-1.5" />
            En cours de vérification
          </div>
          <div v-else-if="uploadStatus.address === 'rejected'" class="flex items-center text-sm font-medium text-red-600 dark:text-red-400">
            <XCircle class="h-4 w-4 mr-1.5" />
            Rejeté
            <button 
              @click="openAddressUpload"
              class="ml-2 text-primary-600 dark:text-primary-400 hover:underline"
            >
              Réessayer
            </button>
          </div>
          <button 
            v-else
            @click="openAddressUpload" 
            class="text-sm font-medium text-primary-600 dark:text-primary-400 hover:underline"
          >
            Ajouter
          </button>
        </div>
      </div>
    </div>
    
    <!-- Badge de profil vérifié (visible si complètement vérifié) -->
    <div v-if="userData?.verification_status === 'verified'" class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-700 shadow-sm p-4 mb-6">
      <div class="flex items-center">
        <div class="h-12 w-12 bg-green-100 dark:bg-green-900/30 rounded-full flex items-center justify-center mr-4">
          <Award class="h-6 w-6 text-green-600 dark:text-green-400" />
        </div>
        <div>
          <h3 class="text-lg font-medium text-gray-900 dark:text-white">Profil vérifié</h3>
          <p class="text-sm text-gray-600 dark:text-gray-400">
            Félicitations ! Votre profil est entièrement vérifié. Vos informations seront mises en avant sur la plateforme.
          </p>
        </div>
      </div>
    </div>
    
    <!-- Modaux d'upload -->
    <div v-if="showIdUploadModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div class="bg-white dark:bg-gray-800 rounded-xl p-6 max-w-md w-full">
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Pièce d'identité</h3>
        
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Carte d'identité (recto)
          </label>
          <div 
            @click="triggerFileInput('idFront')"
            class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-4 text-center cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
          >
            <Upload class="h-8 w-8 text-gray-400 mx-auto mb-2" />
            <p class="text-sm text-gray-500 dark:text-gray-400">
              Cliquez pour télécharger
            </p>
            <input 
              ref="idFrontInput"
              type="file" 
              accept="image/*,.pdf" 
              class="hidden"
              @change="handleFileChange('idFront', $event)"
            />
          </div>
          <div v-if="idFiles.front" class="mt-2 text-sm text-gray-700 dark:text-gray-300">
            {{ idFiles.front.name }}
          </div>
        </div>
        
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Carte d'identité (verso)
          </label>
          <div 
            @click="triggerFileInput('idBack')"
            class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-4 text-center cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
          >
            <Upload class="h-8 w-8 text-gray-400 mx-auto mb-2" />
            <p class="text-sm text-gray-500 dark:text-gray-400">
              Cliquez pour télécharger
            </p>
            <input 
              ref="idBackInput"
              type="file" 
              accept="image/*,.pdf" 
              class="hidden"
              @change="handleFileChange('idBack', $event)"
            />
          </div>
          <div v-if="idFiles.back" class="mt-2 text-sm text-gray-700 dark:text-gray-300">
            {{ idFiles.back.name }}
          </div>
        </div>
        
        <div class="flex justify-end gap-3 mt-6">
          <button 
            @click="showIdUploadModal = false"
            class="px-4 py-2 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-md text-sm font-medium hover:bg-gray-200 dark:hover:bg-gray-600"
          >
            Annuler
          </button>
          <button 
            @click="uploadIdentityFiles"
            :disabled="!idFiles.front || !idFiles.back || uploading"
            class="px-4 py-2 bg-primary-600 text-white rounded-md text-sm font-medium hover:bg-primary-700 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Loader2 v-if="uploading" class="h-4 w-4 mr-2 inline animate-spin" />
            Envoyer
          </button>
        </div>
      </div>
    </div>
    
    <div v-if="showAddressUploadModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div class="bg-white dark:bg-gray-800 rounded-xl p-6 max-w-md w-full">
        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Justificatif de domicile</h3>
        
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Facture récente (moins de 3 mois)
          </label>
          <div 
            @click="triggerFileInput('address')"
            class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-4 text-center cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
          >
            <Upload class="h-8 w-8 text-gray-400 mx-auto mb-2" />
            <p class="text-sm text-gray-500 dark:text-gray-400">
              Cliquez pour télécharger un document
            </p>
            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
              Facture d'électricité, de gaz, d'eau, de téléphone, quittance de loyer...
            </p>
            <input 
              ref="addressInput"
              type="file" 
              accept="image/*,.pdf" 
              class="hidden"
              @change="handleFileChange('address', $event)"
            />
          </div>
          <div v-if="addressFile" class="mt-2 text-sm text-gray-700 dark:text-gray-300">
            {{ addressFile.name }}
          </div>
        </div>
        
        <div class="flex justify-end gap-3 mt-6">
          <button 
            @click="showAddressUploadModal = false"
            class="px-4 py-2 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-md text-sm font-medium hover:bg-gray-200 dark:hover:bg-gray-600"
          >
            Annuler
          </button>
          <button 
            @click="uploadAddressFile"
            :disabled="!addressFile || uploading"
            class="px-4 py-2 bg-primary-600 text-white rounded-md text-sm font-medium hover:bg-primary-700 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Loader2 v-if="uploading" class="h-4 w-4 mr-2 inline animate-spin" />
            Envoyer
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { v4 as uuidv4 } from 'uuid'
import {
  Mail, Phone, CreditCard, Home, Shield, CheckCircle, Clock, XCircle, 
  Award, Upload, Loader2
} from 'lucide-vue-next'

// Composables
const supabase = useSupabaseClient()
const currentUser = useSupabaseUser()

// États
const userData = ref(null)
const showIdUploadModal = ref(false)
const showAddressUploadModal = ref(false)
const idFrontInput = ref(null)
const idBackInput = ref(null)
const addressInput = ref(null)
const idFiles = ref({ front: null, back: null })
const addressFile = ref(null)
const uploading = ref(false)
const uploadStatus = ref({
  id: 'none', // none, pending, verified, rejected
  address: 'none'
})

// Méthodes
const fetchUserData = async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', currentUser.value.id)
      .single()
    
    if (error) throw error
    
    userData.value = data
    
    // Déterminer le statut des uploads
    if (data.id_front && data.id_back) {
      uploadStatus.value.id = data.id_verification_status || 'pending'
    }
    
    if (data.proof_address) {
      uploadStatus.value.address = data.address_verification_status || 'pending'
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des données utilisateur:', error)
  }
}

// Formatter le statut de vérification
const formatVerificationStatus = (status) => {
  switch (status) {
    case 'verified': return 'Profil vérifié'
    case 'pending': return 'Vérification en cours'
    case 'rejected': return 'Vérification refusée'
    default: return 'Non vérifié'
  }
}

// Obtenir l'icône correspondant au statut
const getVerificationStatusIcon = (status) => {
  switch (status) {
    case 'verified': return CheckCircle
    case 'pending': return Clock
    case 'rejected': return XCircle
    default: return Shield
  }
}

// Obtenir les classes CSS pour le statut
const getVerificationStatusClasses = (status) => {
  switch (status) {
    case 'verified': 
      return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
    case 'pending': 
      return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400'
    case 'rejected': 
      return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
    default: 
      return 'bg-gray-100 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400'
  }
}

// Ouvrir le modal d'upload de carte d'identité
const openIdUpload = () => {
  showIdUploadModal.value = true
}

// Ouvrir le modal d'upload de justificatif de domicile
const openAddressUpload = () => {
  showAddressUploadModal.value = true
}

// Déclencher le clic sur l'input file
const triggerFileInput = (type) => {
  if (type === 'idFront' && idFrontInput.value) {
    idFrontInput.value.click()
  } else if (type === 'idBack' && idBackInput.value) {
    idBackInput.value.click()
  } else if (type === 'address' && addressInput.value) {
    addressInput.value.click()
  }
}

// Gérer le changement de fichier
const handleFileChange = (type, event) => {
  const file = event.target.files[0]
  if (!file) return
  
  if (type === 'idFront') {
    idFiles.value.front = file
  } else if (type === 'idBack') {
    idFiles.value.back = file
  } else if (type === 'address') {
    addressFile.value = file
  }
}

// Télécharger les fichiers d'identité
const uploadIdentityFiles = async () => {
  if (!idFiles.value.front || !idFiles.value.back) return
  
  uploading.value = true
  
  try {
    // Télécharger le recto
    const frontFileName = `id_front_${currentUser.value.id}_${uuidv4()}`
    const frontExt = idFiles.value.front.name.split('.').pop()
    
    const { data: frontData, error: frontError } = await supabase.storage
      .from('id_documents')
      .upload(`${currentUser.value.id}/${frontFileName}.${frontExt}`, idFiles.value.front)
    
    if (frontError) throw frontError
    
    // Télécharger le verso
    const backFileName = `id_back_${currentUser.value.id}_${uuidv4()}`
    const backExt = idFiles.value.back.name.split('.').pop()
    
    const { data: backData, error: backError } = await supabase.storage
      .from('id_documents')
      .upload(`${currentUser.value.id}/${backFileName}.${backExt}`, idFiles.value.back)
    
    if (backError) throw backError
    
    // Mettre à jour le profil
    const { data, error } = await supabase
      .from('profiles')
      .update({
        id_front: frontData.path,
        id_back: backData.path,
        id_verification_status: 'pending',
        verification_status: 'pending'
      })
      .eq('id', currentUser.value.id)
    
    if (error) throw error
    
    // Mise à jour des états
    uploadStatus.value.id = 'pending'
    showIdUploadModal.value = false
    
    // Rafraîchir les données
    fetchUserData()
  } catch (error) {
    console.error('Erreur lors du téléchargement des documents:', error)
    alert('Une erreur est survenue lors du téléchargement. Veuillez réessayer.')
  } finally {
    uploading.value = false
  }
}

// Télécharger le justificatif de domicile
const uploadAddressFile = async () => {
  if (!addressFile.value) return
  
  uploading.value = true
  
  try {
    // Télécharger le fichier
    const fileName = `address_proof_${currentUser.value.id}_${uuidv4()}`
    const ext = addressFile.value.name.split('.').pop()
    
    const { data: fileData, error: fileError } = await supabase.storage
      .from('address_documents')
      .upload(`${currentUser.value.id}/${fileName}.${ext}`, addressFile.value)
    
    if (fileError) throw fileError
    
    // Mettre à jour le profil
    const { data, error } = await supabase
      .from('profiles')
      .update({
        proof_address: fileData.path,
        address_verification_status: 'pending',
        verification_status: 'pending'
      })
      .eq('id', currentUser.value.id)
    
    if (error) throw error
    
    // Mise à jour des états
    uploadStatus.value.address = 'pending'
    showAddressUploadModal.value = false
    
    // Rafraîchir les données
    fetchUserData()
  } catch (error) {
    console.error('Erreur lors du téléchargement du justificatif:', error)
    alert('Une erreur est survenue lors du téléchargement. Veuillez réessayer.')
  } finally {
    uploading.value = false
  }
}

// Vérifier le téléphone (simulé)
const verifyPhone = () => {
  // Cette fonction pourrait déclencher un SMS de vérification
  alert('Un code a été envoyé par SMS pour vérifier votre numéro de téléphone.')
}

// Initialisation
onMounted(() => {
  fetchUserData()
})


// Vous pouvez ajouter ce bloc en haut de chaque fichier
definePageMeta({
  layout: 'account'
})
</script> 