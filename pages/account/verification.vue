<template>
  <div class="max-w-3xl mx-auto px-4 sm:px-6 py-8">
    <AccountHeader title="Devenir un expert" subtitle="Envoyez une photo de votre pièce d'identité pour obtenir le statut d'expert vérifié" />
    
    <!-- Vérification en cours -->
    <div v-if="loading" class="flex justify-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
    </div>
    
    <!-- Erreur -->
    <div v-else-if="error" class="bg-red-50 dark:bg-red-900/20 p-4 rounded-lg text-red-700 dark:text-red-400 my-6">
      <div class="flex">
        <svg class="h-5 w-5 text-red-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p>{{ error }}</p>
      </div>
      <button 
        @click="fetchVerificationStatus" 
        class="mt-3 text-sm font-medium text-red-600 dark:text-red-400 hover:text-red-500"
      >
        Réessayer
      </button>
    </div>
    
    <!-- Vérification en attente -->
    <div v-else-if="verificationStatus === 'pending'" class="bg-gray-50 dark:bg-gray-800 rounded-xl p-6 my-6 border border-gray-200 dark:border-gray-700">
      <div class="flex flex-col items-center text-center">
        <div class="flex items-center justify-center w-14 h-14 bg-yellow-100 dark:bg-yellow-900/30 rounded-full mb-4">
          <svg class="h-8 w-8 text-yellow-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <h3 class="text-lg font-medium text-gray-900 dark:text-white">Vérification en cours</h3>
        <p class="mt-2 text-gray-600 dark:text-gray-300">
          Votre demande de vérification est en cours d'examen. Vous recevrez une notification dès qu'elle sera traitée.
        </p>
      </div>
    </div>
    
    <!-- Vérification approuvée -->
    <div v-else-if="verificationStatus === 'approved'" class="bg-gray-50 dark:bg-gray-800 rounded-xl p-6 my-6 border border-gray-200 dark:border-gray-700">
      <div class="flex flex-col items-center text-center">
        <div class="flex items-center justify-center w-14 h-14 bg-green-100 dark:bg-green-900/30 rounded-full mb-4">
          <svg class="h-8 w-8 text-green-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <h3 class="text-lg font-medium text-gray-900 dark:text-white">Expert vérifié</h3>
        <p class="mt-2 text-gray-600 dark:text-gray-300">
          Félicitations ! Votre statut d'expert a été approuvé. Vous pouvez maintenant créer des services et répondre aux demandes.
        </p>
        <div class="mt-4">
          <NuxtLink 
            to="/account/services/create" 
            class="inline-flex items-center px-4 py-2 border border-transparent rounded-full text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 transition-colors"
          >
            Créer un service
          </NuxtLink>
        </div>
      </div>
    </div>
    
    <!-- Vérification rejetée -->
    <div v-else-if="verificationStatus === 'rejected'" class="bg-gray-50 dark:bg-gray-800 rounded-xl p-6 my-6 border border-gray-200 dark:border-gray-700">
      <div class="flex flex-col items-center text-center">
        <div class="flex items-center justify-center w-14 h-14 bg-red-100 dark:bg-red-900/30 rounded-full mb-4">
          <svg class="h-8 w-8 text-red-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <h3 class="text-lg font-medium text-gray-900 dark:text-white">Vérification refusée</h3>
        <p class="mt-2 text-gray-600 dark:text-gray-300">
          Votre demande de vérification a été refusée. Raison : {{ rejectionReason || 'Non spécifiée' }}
        </p>
        <button 
          @click="resetForm" 
          class="mt-4 inline-flex items-center px-4 py-2 border border-transparent rounded-full text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 transition-colors"
        >
          Faire une nouvelle demande
        </button>
      </div>
    </div>
    
    <!-- Formulaire de demande -->
    <div v-else class="bg-white dark:bg-gray-800 shadow-sm rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden my-6">
      <!-- Section informative -->
      <div class="bg-primary-50 dark:bg-primary-900/10 p-4 border-b border-gray-200 dark:border-gray-700">
        <h4 class="text-sm font-medium text-primary-700 dark:text-primary-300 mb-2">Vérification d'expert</h4>
        <p class="text-sm text-primary-600 dark:text-primary-400">
          Pour devenir un expert vérifié, prenez une photo de votre pièce d'identité (CNI) et complétez votre profil.
        </p>
      </div>
      
      <div class="p-6">
        <div class="space-y-6">
          <!-- Documents à télécharger -->
          <div>
            <div class="flex items-center justify-between mb-2">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Pièce d'identité (CNI)</label>
              <span class="text-xs font-medium text-primary-600">Obligatoire</span>
            </div>
            <div class="border border-gray-200 dark:border-gray-700 rounded-xl overflow-hidden">
              <div v-if="idDocumentPreview" class="w-full">
                <div class="aspect-square w-full h-52 relative bg-gray-50 dark:bg-gray-900">
                  <img 
                    :src="idDocumentPreview" 
                    alt="Aperçu de la pièce d'identité" 
                    class="w-full h-full object-contain"
                  />
                </div>
                <div class="p-3 flex justify-between items-center border-t border-gray-200 dark:border-gray-700">
                  <span class="text-xs text-gray-500 dark:text-gray-400">
                    {{ idDocumentFile?.name || 'Carte d\'identité' }}
                  </span>
                  <button 
                    type="button"
                    @click="removeIdDocument"
                    class="text-red-600 dark:text-red-400 text-sm font-medium hover:text-red-500 focus:outline-none"
                  >
                    Supprimer
                  </button>
                </div>
              </div>
              <div v-else class="p-8 bg-gray-50 dark:bg-gray-900/30">
                <div class="flex flex-col items-center justify-center">
                  <div class="w-16 h-16 mb-4 flex items-center justify-center rounded-full bg-primary-100 dark:bg-primary-900/30">
                    <svg class="h-8 w-8 text-primary-600 dark:text-primary-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2" />
                    </svg>
                  </div>
                  
                  <h3 class="text-base font-medium text-gray-900 dark:text-white mb-2">
                    Téléchargez votre CNI
                  </h3>
                  
                  <p class="text-sm text-center text-gray-500 dark:text-gray-400 mb-4 max-w-xs">
                    Prenez une photo claire de votre carte nationale d'identité où toutes les informations sont lisibles
                  </p>
                  
                  <div class="flex flex-col sm:flex-row gap-3">
                    <button
                      type="button"
                      @click="capturePhoto"
                      class="flex items-center justify-center px-4 py-2 bg-primary-600 border border-transparent rounded-full shadow-sm text-sm font-medium text-white hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
                    >
                      <svg class="-ml-1 mr-2 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                      </svg>
                      Prendre une photo
                    </button>
                    <div>
                      <input 
                        id="id-document" 
                        ref="idDocumentInput"
                        type="file" 
                        accept="image/*"
                        capture="environment"
                        class="sr-only"
                        @change="handleIdDocumentUpload"
                      />
                      <label 
                        for="id-document" 
                        class="flex items-center justify-center px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-full shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 cursor-pointer"
                      >
                        <svg class="-ml-1 mr-2 h-4 w-4 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0l-4 4m4-4v12" />
                        </svg>
                        Importer une image
                      </label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Compétences -->
          <!-- <div>
            <div class="flex items-center justify-between mb-2">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Vos compétences</label>
              <span class="text-xs text-primary-600 font-medium">Obligatoire (3 min.)</span>
            </div>
            
            <div class="mb-2">
              <input
                type="text"
                v-model="skillSearch"
                placeholder="Rechercher une compétence..."
                class="block w-full rounded-lg border-gray-300 dark:border-gray-700 shadow-sm bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
              />
            </div>
            
            <div class="flex flex-wrap gap-2 mb-3">
              <div 
                v-for="skill in selectedSkills" 
                :key="skill.id"
                class="inline-flex items-center px-2.5 py-1 rounded-full text-sm font-medium bg-primary-100 dark:bg-primary-900/30 text-primary-800 dark:text-primary-200 border border-primary-200 dark:border-primary-800"
              >
                {{ skill.name }}
                <button 
                  type="button"
                  @click="removeSkill(skill)"
                  class="ml-1.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-600 dark:text-primary-400 hover:bg-primary-200 dark:hover:bg-primary-800"
                >
                  <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
            </div>
            
            <div v-if="filteredSkills.length && skillSearch" class="mt-2 max-h-48 overflow-y-auto border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm">
              <ul class="divide-y divide-gray-200 dark:divide-gray-700">
                <li 
                  v-for="skill in filteredSkills" 
                  :key="skill.id"
                  class="px-4 py-2 hover:bg-gray-50 dark:hover:bg-gray-700 cursor-pointer"
                  @click="addSkill(skill)"
                >
                  {{ skill.name }}
                </li>
              </ul>
            </div>
          </div> -->
          
          <!-- Description -->
          <!-- <div>
            <div class="flex items-center justify-between mb-2">
              <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300">Description professionnelle</label>
              <span class="text-xs text-primary-600 font-medium">Obligatoire</span>
            </div>
            <textarea
              id="description"
              v-model="description"
              rows="3"
              placeholder="Décrivez votre expérience professionnelle, vos domaines d'expertise et vos réalisations..."
              class="block w-full rounded-lg border-gray-300 dark:border-gray-700 shadow-sm bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-primary-500 focus:border-primary-500 sm:text-sm"
            ></textarea>
            <div class="flex justify-between mt-1">
              <p class="text-xs text-gray-500 dark:text-gray-400">
                Minimum 100 caractères
              </p>
              <p class="text-xs text-gray-500 dark:text-gray-400">
                {{ description.length }}/500
              </p>
            </div>
          </div> -->
          
          <!-- Bouton de soumission -->
          <div class="flex justify-center">
            <button 
              type="button"
              @click="submitVerification"
              :disabled="isSubmitDisabled || submitting || uploadingToCloudinary"
              class="w-full sm:w-auto inline-flex items-center justify-center px-6 py-3 border border-transparent rounded-full shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              <svg v-if="submitting || uploadingToCloudinary" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ submitting ? 'Envoi en cours...' : 'Envoyer ma demande' }}
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Modal pour la prise de photo -->
    <div v-if="showCamera" class="fixed inset-0 z-50 overflow-y-auto">
      <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 transition-opacity" aria-hidden="true">
          <div class="absolute inset-0 bg-gray-500 dark:bg-gray-900 opacity-75"></div>
        </div>
        
        <div class="inline-block align-bottom bg-white dark:bg-gray-800 rounded-xl text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
          <div class="bg-white dark:bg-gray-800 px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <div class="sm:flex sm:items-start">
              <div class="mt-3 text-center sm:mt-0 sm:text-left w-full">
                <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-white">
                  Prendre une photo
                </h3>
                
                <div class="mt-4">
                  <video ref="video" class="w-full h-auto rounded-lg" autoplay playsinline></video>
                </div>
              </div>
            </div>
          </div>
          
          <div class="bg-gray-50 dark:bg-gray-700 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
            <button type="button" @click="takePhoto" class="w-full inline-flex justify-center rounded-full border border-transparent shadow-sm px-4 py-2 bg-primary-600 text-base font-medium text-white hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 sm:ml-3 sm:w-auto sm:text-sm">
              Capturer
            </button>
            <button type="button" @click="closeCamera" class="mt-3 w-full inline-flex justify-center rounded-full border border-gray-300 dark:border-gray-600 shadow-sm px-4 py-2 bg-white dark:bg-gray-800 text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
              Annuler
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { useSupabaseClient, useSupabaseUser } from '#imports';
import AccountHeader from '~/components/account/AccountHeader.vue';

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const toast = useToast();

// États
const loading = ref(true);
const error = ref(null);
const verificationStatus = ref(null);
const rejectionReason = ref('');
const submitting = ref(false);
const uploadingToCloudinary = ref(false);
const showCamera = ref(false);

// Caméra
const video = ref(null);
const stream = ref(null);

// Documents
const idDocumentFile = ref(null);
const idDocumentPreview = ref(null);
const idDocumentInput = ref(null);
const cloudinaryUrl = ref(null);
const cloudinaryPublicId = ref(null);

// Configuration Cloudinary
const cloudinaryConfig = {
  cloudName: 'havoo-ui',  // Remplacer par votre cloud_name Cloudinary
  uploadPreset: 'verification_docs',  // Remplacer par votre upload_preset (non-signé)
  apiEndpoint: 'https://api.cloudinary.com/v1_1/havoo-ui/upload'  // Remplacer par votre cloud_name
};

// Compétences
const allSkills = ref([]);
const selectedSkills = ref([]);
const skillSearch = ref('');

// Description
const description = ref('');

// Calculer si le formulaire est valide
const isSubmitDisabled = computed(() => {
  return !idDocumentFile.value
});

// Compétences filtrées
const filteredSkills = computed(() => {
  if (!skillSearch.value) return [];
  
  return allSkills.value.filter(skill => 
    skill.name.toLowerCase().includes(skillSearch.value.toLowerCase()) && 
    !selectedSkills.value.some(s => s.id === skill.id)
  ).slice(0, 10);
});

// Récupérer le statut de vérification
const fetchVerificationStatus = async () => {
  if (!user.value) return;
  
  loading.value = true;
  error.value = null;
  
  try {
    // Vérifier si l'utilisateur est déjà un expert
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('is_expert, is_verified')
      .eq('id', user.value.id)
      .single();
    
    if (profileError) throw profileError;
    
    if (profile.is_expert && profile.is_verified) {
      verificationStatus.value = 'approved';
      return;
    }
    
    // Récupérer la demande de vérification
    const { data: verification, error: verificationError } = await supabase
      .from('verifications')
      .select('status, rejection_reason')
      .eq('user_id', user.value.id)
      .maybeSingle();
    
    if (verificationError) throw verificationError;
    
    if (verification) {
      verificationStatus.value = verification.status;
      rejectionReason.value = verification.rejection_reason || '';
    } else {
      verificationStatus.value = null;
    }
  } catch (err) {
    console.error('Error fetching verification status:', err);
    error.value = 'Impossible de récupérer votre statut de vérification.';
  } finally {
    loading.value = false;
  }
};

// Récupérer les compétences
const fetchSkills = async () => {
  try {
    const { data: skills, error: skillsError } = await supabase
      .from('skills')
      .select('id, name, category_id');
    
    if (skillsError) throw skillsError;
    
    allSkills.value = skills || [];
  } catch (err) {
    console.error('Error fetching skills:', err);
    toast.error('Impossible de récupérer les compétences');
  }
};

// Gérer l'upload des documents
const handleIdDocumentUpload = (event) => {
  const file = event.target.files[0];
  if (!file) return;
  
  if (file.size > 5 * 1024 * 1024) {
    toast.error('Le fichier est trop volumineux (max 5MB)');
    return;
  }
  
  idDocumentFile.value = file;
  
  const reader = new FileReader();
  reader.onload = (e) => {
    idDocumentPreview.value = e.target.result;
  };
  reader.readAsDataURL(file);
};

const removeIdDocument = () => {
  idDocumentFile.value = null;
  idDocumentPreview.value = null;
  cloudinaryUrl.value = null;
  cloudinaryPublicId.value = null;
  if (idDocumentInput.value) {
    idDocumentInput.value.value = '';
  }
};

// Fonctions de la caméra
const capturePhoto = async () => {
  try {
    stream.value = await navigator.mediaDevices.getUserMedia({ 
      video: { facingMode: 'environment' }
    });
    
    showCamera.value = true;
    
    // Attendre que le DOM soit mis à jour
    await nextTick();
    
    if (video.value) {
      video.value.srcObject = stream.value;
    }
  } catch (err) {
    console.error('Erreur d\'accès à la caméra:', err);
    toast.error('Impossible d\'accéder à votre caméra. Vérifiez les permissions.');
  }
};

const takePhoto = () => {
  const canvas = document.createElement('canvas');
  const videoElem = video.value;
  
  if (!videoElem) return;
  
  // Définir les dimensions du canvas pour correspondre à la vidéo
  canvas.width = videoElem.videoWidth;
  canvas.height = videoElem.videoHeight;
  
  // Dessiner l'image de la vidéo sur le canvas
  const ctx = canvas.getContext('2d');
  ctx.drawImage(videoElem, 0, 0, canvas.width, canvas.height);
  
  // Convertir le canvas en blob
  canvas.toBlob((blob) => {
    // Créer un fichier à partir du blob
    const file = new File([blob], 'photo-cni.jpg', { type: 'image/jpeg' });
    
    // Mettre à jour les références
    idDocumentFile.value = file;
    idDocumentPreview.value = URL.createObjectURL(blob);
    
    // Fermer la caméra
    closeCamera();
  }, 'image/jpeg', 0.9);
};

const closeCamera = () => {
  if (stream.value) {
    stream.value.getTracks().forEach(track => track.stop());
    stream.value = null;
  }
  showCamera.value = false;
};

// Gérer les compétences
const addSkill = (skill) => {
  if (!selectedSkills.value.some(s => s.id === skill.id)) {
    selectedSkills.value.push(skill);
    skillSearch.value = '';
  }
};

const removeSkill = (skill) => {
  selectedSkills.value = selectedSkills.value.filter(s => s.id !== skill.id);
};

// Uploader sur Cloudinary
const uploadToCloudinary = async (file) => {
  uploadingToCloudinary.value = true;
  
  try {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('upload_preset', cloudinaryConfig.uploadPreset);
    formData.append('folder', `verifications/${user.value.id}`);
    formData.append('public_id', `cni-${Date.now()}`);
    
    const response = await fetch(cloudinaryConfig.apiEndpoint, {
      method: 'POST',
      body: formData
    });
    
    if (!response.ok) {
      throw new Error('Erreur lors du téléchargement vers Cloudinary');
    }
    
    const data = await response.json();
    cloudinaryUrl.value = data.secure_url;
    cloudinaryPublicId.value = data.public_id;
    
    return {
      url: data.secure_url,
      publicId: data.public_id,
      format: data.format,
      resource_type: data.resource_type
    };
  } catch (err) {
    console.error('Erreur Cloudinary:', err);
    toast.error('Échec du téléchargement sur Cloudinary');
    throw err;
  } finally {
    uploadingToCloudinary.value = false;
  }
};

// Réinitialiser le formulaire
const resetForm = () => {
  idDocumentFile.value = null;
  idDocumentPreview.value = null;
  cloudinaryUrl.value = null;
  cloudinaryPublicId.value = null;
  selectedSkills.value = [];
  description.value = '';
  verificationStatus.value = null;
};

// Soumettre la demande
const submitVerification = async () => {
  if (isSubmitDisabled.value) return;
  
  submitting.value = true;
  
  try {
    // 1. Upload de la pièce d'identité sur Cloudinary
    const cloudinaryResult = await uploadToCloudinary(idDocumentFile.value);
    
    // 2. Préparer les données des documents
    const documentsData = {
      identity_document: {
        url: cloudinaryResult.url,
        public_id: cloudinaryResult.publicId,
        format: cloudinaryResult.format,
        type: cloudinaryResult.resource_type,
        uploaded_at: new Date().toISOString()
      },
      skills: selectedSkills.value.map(s => ({ id: s.id, name: s.name })),
      description: description.value
    };
    
    // 3. Soumettre la demande avec la fonction simplifiée
    const { error: requestError } = await supabase.rpc(
      'request_expert_verification',
      {
        p_documents: documentsData
      }
    );
    
    if (requestError) throw requestError;
    
    // 4. Mettre à jour la bio du profil
    const { error: profileError } = await supabase
      .from('profiles')
      .update({ bio: description.value })
      .eq('id', user.value.id);
    
    if (profileError) {
      console.error('Error updating profile bio:', profileError);
      // Non-critical error, continue
    }
    
    toast.success('Votre demande de vérification a été soumise avec succès');
    verificationStatus.value = 'pending';
  } catch (err) {
    console.error('Error submitting verification:', err);
    toast.error(`Une erreur est survenue: ${err.message || 'Erreur inconnue'}`);
  } finally {
    submitting.value = false;
  }
};

// Nettoyer les ressources de la caméra lors de la destruction du composant
onUnmounted(() => {
  closeCamera();
});

onMounted(() => {
  fetchVerificationStatus();
  fetchSkills();
});

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
});
</script> 