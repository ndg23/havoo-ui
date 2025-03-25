<template>
  <div class="min-h-screen bg-white">
    <!-- Header -->
    <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
        <div class="flex items-center">
          <NuxtLink 
            to="/account/" 
            class="p-2 -ml-2 rounded-full hover:bg-gray-100 transition-colors"
          >
            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M15 19l-7-7 7-7" />
            </svg>
          </NuxtLink>
          <h1 class="ml-6 text-xl font-bold">Vérification d'identité</h1>
        </div>
      </div>
    </header>

    <!-- Main content -->
    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <svg class="animate-spin h-8 w-8 text-gray-400 mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <p class="text-gray-500">Chargement...</p>
      </div>

      <!-- Error state -->
      <div v-else-if="error" class="bg-red-50 p-4 rounded-lg text-red-700 my-6">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <p>{{ error }}</p>
        </div>
        <button 
          @click="error = null" 
          class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Approved verification -->
      <div v-else-if="verificationStatus === 'approved'" class="text-center py-8">
        <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100 mb-4">
          <svg class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h3 class="text-lg font-medium text-gray-900">Identité vérifiée</h3>
        <p class="mt-2 text-sm text-gray-500">
          Votre identité a été vérifiée avec succès. Vous pouvez maintenant proposer vos services en tant qu'expert.
        </p>
        <div class="mt-6">
          <NuxtLink 
            to="/account/services" 
            class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
          >
            Gérer mes services
          </NuxtLink>
        </div>
      </div>

      <!-- Pending verification -->
      <div v-else-if="verificationStatus === 'pending'" class="text-center py-8">
        <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-yellow-100 mb-4">
          <svg class="h-6 w-6 text-yellow-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <h3 class="text-lg font-medium text-gray-900">Vérification en cours</h3>
        <p class="mt-2 text-sm text-gray-500">
          Votre demande de vérification est en cours de traitement. Nous vous informerons par email dès que votre identité sera vérifiée.
        </p>
        <div v-if="verificationSubmittedAt" class="mt-2 text-xs text-gray-400">
          Soumise le {{ formatDate(verificationSubmittedAt) }}
        </div>
        <div class="mt-6">
          <NuxtLink 
            to="/account/" 
            class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
          >
            Retour au profil
          </NuxtLink>
        </div>
      </div>

      <!-- Rejected verification -->
      <div v-else-if="verificationStatus === 'rejected'" class="py-8">
        <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100 mb-4">
          <svg class="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </div>
        <h3 class="text-lg font-medium text-gray-900 text-center">Vérification refusée</h3>
        <div v-if="rejectionReason" class="mt-4 p-4 bg-red-50 rounded-lg">
          <p class="text-sm text-red-700 font-medium">Motif du refus:</p>
          <p class="text-sm text-red-600 mt-1">{{ rejectionReason }}</p>
        </div>
        <p class="mt-4 text-sm text-gray-500 text-center">
          Vous pouvez soumettre une nouvelle demande en corrigeant les problèmes mentionnés ci-dessus.
        </p>
        <div class="mt-6 text-center">
          <button 
            @click="resetVerification" 
            class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
          >
            Soumettre une nouvelle demande
          </button>
        </div>
      </div>

      <!-- Verification form -->
      <div v-else>
        <div class="bg-blue-50 p-4 rounded-lg mb-6">
          <div class="flex">
            <svg class="h-5 w-5 text-blue-400 mr-3 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <div>
              <p class="text-sm text-blue-700 font-medium">Pourquoi vérifier votre identité ?</p>
              <p class="mt-1 text-sm text-blue-600">
                La vérification d'identité est nécessaire pour devenir expert et proposer vos services. 
                Cela permet de garantir la confiance entre les utilisateurs de la plateforme.
              </p>
            </div>
          </div>
        </div>

        <form @submit.prevent="submitVerification" class="space-y-6">
          <!-- ID Card Upload -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Carte d'identité (recto/verso)
            </label>
            <div 
              class="mt-1 border-2 border-dashed border-gray-300 rounded-lg px-6 pt-5 pb-6 flex flex-col items-center cursor-pointer hover:border-gray-400 transition-colors"
              @click="$refs.idCardInput.click()"
              :class="{'border-red-300': idCardError}"
            >
              <input
                ref="idCardInput"
                type="file"
                accept="image/*,.pdf"
                class="hidden"
                @change="handleIdCardUpload"
                multiple
              />
              
              <div v-if="!idCardFiles.length" class="space-y-1 text-center">
                <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
                  <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                <div class="flex text-sm text-gray-600">
                  <p class="pl-1">Cliquez pour sélectionner des fichiers ou glissez-déposez</p>
                </div>
                <p class="text-xs text-gray-500">
                  PNG, JPG, PDF jusqu'à 10MB
                </p>
              </div>
              
              <div v-else class="w-full">
                <ul class="divide-y divide-gray-200">
                  <li v-for="(file, index) in idCardFiles" :key="index" class="py-3 flex justify-between items-center">
                    <div class="flex items-center">
                      <svg class="h-5 w-5 text-gray-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                      </svg>
                      <span class="text-sm text-gray-900 truncate max-w-xs">{{ file.name }}</span>
                    </div>
                    <button 
                      type="button" 
                      @click.stop="removeIdCardFile(index)" 
                      class="text-red-600 hover:text-red-800"
                    >
                      <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  </li>
                </ul>
                <button 
                  type="button"
                  class="mt-2 text-sm text-blue-600 hover:text-blue-800"
                  @click.stop="$refs.idCardInput.click()"
                >
                  Ajouter plus de fichiers
                </button>
              </div>
            </div>
            <p v-if="idCardError" class="mt-1 text-sm text-red-600">{{ idCardError }}</p>
            <p class="mt-1 text-xs text-gray-500">
              Veuillez fournir une photo ou un scan lisible de votre carte d'identité (recto et verso).
            </p>
          </div>

          <!-- Selfie Upload -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Photo de vous avec votre carte d'identité
            </label>
            <div 
              class="mt-1 border-2 border-dashed border-gray-300 rounded-lg px-6 pt-5 pb-6 flex flex-col items-center cursor-pointer hover:border-gray-400 transition-colors"
              @click="$refs.selfieInput.click()"
              :class="{'border-red-300': selfieError}"
            >
              <input
                ref="selfieInput"
                type="file"
                accept="image/*"
                class="hidden"
                @change="handleSelfieUpload"
              />
              
              <div v-if="!selfieFile" class="space-y-1 text-center">
                <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
                  <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                <div class="flex text-sm text-gray-600">
                  <p class="pl-1">Cliquez pour sélectionner une photo ou glissez-déposez</p>
                </div>
                <p class="text-xs text-gray-500">
                  PNG, JPG jusqu'à 10MB
                </p>
              </div>
              
              <div v-else class="w-full">
                <div class="flex items-center justify-between py-3">
                  <div class="flex items-center">
                    <svg class="h-5 w-5 text-gray-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    <span class="text-sm text-gray-900 truncate max-w-xs">{{ selfieFile.name }}</span>
                  </div>
                  <button 
                    type="button" 
                    @click.stop="removeSelfieFile()" 
                    class="text-red-600 hover:text-red-800"
                  >
                    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
            <p v-if="selfieError" class="mt-1 text-sm text-red-600">{{ selfieError }}</p>
            <p class="mt-1 text-xs text-gray-500">
              Prenez une photo de vous tenant votre carte d'identité. Votre visage doit être clairement visible.
            </p>
          </div>

          <!-- Add identity info fields -->
          <div class="grid grid-cols-1 gap-6 sm:grid-cols-2">
            <div>
              <label for="birthdate" class="block text-sm font-medium text-gray-700">Date de naissance</label>
              <input
                id="birthdate"
                v-model="birthdate"
                type="date"
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-black focus:ring-black sm:text-sm"
              />
            </div>
            <div>
              <label for="address" class="block text-sm font-medium text-gray-700">Adresse</label>
              <input
                id="address"
                v-model="address"
                type="text"
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-black focus:ring-black sm:text-sm"
                placeholder="Votre adresse complète"
              />
            </div>
          </div>

          <!-- Consent -->
          <div class="relative flex items-start">
            <div class="flex items-center h-5">
              <input
                id="consent"
                v-model="consent"
                type="checkbox"
                class="h-4 w-4 text-black focus:ring-black border-gray-300 rounded"
              />
            </div>
            <div class="ml-3 text-sm">
              <label for="consent" class="font-medium text-gray-700">Je consens au traitement de mes données</label>
              <p class="text-gray-500">
                J'accepte que mes documents d'identité soient traités dans le but de vérifier mon identité.
                Ces documents seront conservés de manière sécurisée et ne seront pas partagés avec des tiers.
              </p>
            </div>
          </div>

          <div class="pt-5">
            <button
              type="submit"
              class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-black hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black"
              :disabled="isSubmitting"
            >
              <svg v-if="isSubmitting" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ isSubmitting ? 'Envoi en cours...' : 'Soumettre ma demande de vérification' }}
            </button>
          </div>
        </form>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useSupabaseClient, useSupabaseUser } from '#imports';
import { useRouter } from 'vue-router';
import { format } from 'date-fns';
import { fr } from 'date-fns/locale';

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const router = useRouter();

// État
const isLoading = ref(true);
const isSubmitting = ref(false);
const error = ref(null);
const profile = ref(null);

// Verification status
const verificationStatus = ref(null);
const verificationSubmittedAt = ref(null);
const rejectionReason = ref(null);

// Formulaire
const idCardFiles = ref([]);
const selfieFile = ref(null);
const consent = ref(false);
const idCardError = ref('');
const selfieError = ref('');
const birthdate = ref('');
const address = ref('');

// Format date
const formatDate = (dateString) => {
  try {
    return format(new Date(dateString), "d MMMM yyyy 'à' HH:mm", { locale: fr });
  } catch (e) {
    return dateString;
  }
};

// Récupérer le profil et le statut de vérification
const fetchProfile = async () => {
  if (!user.value) {
    router.push('/auth/login');
    return;
  }
  
  isLoading.value = true;
  
  try {
    // Récupérer le profil
    const { data: profileData, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single();
    
    if (profileError) throw profileError;
    
    profile.value = profileData;
    
    // Pré-remplir les champs du formulaire avec les données du profil
    if (profileData.birthdate) {
      birthdate.value = profileData.birthdate;
    }
    
    if (profileData.address) {
      address.value = profileData.address;
    }
    
    // Récupérer les informations de vérification
    const { data: verificationData, error: verificationError } = await supabase
      .from('verifications')
      .select('*')
      .eq('user_id', user.value.id)
      .order('created_at', { ascending: false })
      .limit(1)
      .single();
    
    if (verificationError) {
      if (verificationError.code !== 'PGRST116') {
        // PGRST116 est l'erreur "No rows found", ce qui est normal si l'utilisateur n'a pas encore demandé de vérification
        throw verificationError;
      }
    } else if (verificationData) {
      verificationStatus.value = verificationData.status;
      verificationSubmittedAt.value = verificationData.created_at;
      rejectionReason.value = verificationData.rejection_reason;
    }
  } catch (err) {
    console.error('Error fetching profile or verification status:', err);
    error.value = "Une erreur est survenue lors du chargement de votre profil.";
  } finally {
    isLoading.value = false;
  }
};

// Gérer l'upload de la carte d'identité
const handleIdCardUpload = (event) => {
  const files = event.target.files;
  if (!files.length) return;
  
  idCardError.value = '';
  
  // Vérifier la taille des fichiers (max 10MB)
  for (let i = 0; i < files.length; i++) {
    if (files[i].size > 10 * 1024 * 1024) {
      idCardError.value = "Un ou plusieurs fichiers dépassent la taille maximale de 10MB.";
      return;
    }
  }
  
  // Ajouter les fichiers à la liste
  for (let i = 0; i < files.length; i++) {
    idCardFiles.value.push(files[i]);
  }
};

// Supprimer un fichier de carte d'identité
const removeIdCardFile = (index) => {
  idCardFiles.value.splice(index, 1);
};

// Gérer l'upload de la photo selfie
const handleSelfieUpload = (event) => {
  const file = event.target.files[0];
  if (!file) return;
  
  selfieError.value = '';
  
  // Vérifier la taille du fichier (max 10MB)
  if (file.size > 10 * 1024 * 1024) {
    selfieError.value = "Le fichier dépasse la taille maximale de 10MB.";
    return;
  }
  
  selfieFile.value = file;
};

// Supprimer la photo selfie
const removeSelfieFile = () => {
  selfieFile.value = null;
};

// Réinitialiser une vérification rejetée
const resetVerification = () => {
  verificationStatus.value = null;
  rejectionReason.value = null;
};

// Soumettre la demande de vérification
const submitVerification = async () => {
  // Validation
  idCardError.value = '';
  selfieError.value = '';
  error.value = null;
  
  if (idCardFiles.value.length === 0) {
    idCardError.value = "Veuillez fournir une copie de votre carte d'identité.";
    return;
  }
  
  if (!selfieFile.value) {
    selfieError.value = "Veuillez fournir une photo de vous avec votre carte d'identité.";
    return;
  }
  
  if (!birthdate.value) {
    error.value = "Veuillez indiquer votre date de naissance.";
    return;
  }
  
  if (!address.value) {
    error.value = "Veuillez indiquer votre adresse.";
    return;
  }
  
  if (!consent.value) {
    error.value = "Vous devez consentir au traitement de vos données pour continuer.";
    return;
  }
  
  isSubmitting.value = true;
  
  try {
    // 1. Mettre à jour le profil avec les informations supplémentaires
    const { error: profileUpdateError } = await supabase
      .from('profiles')
      .update({
        birthdate: birthdate.value,
        address: address.value,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value.id);
    
    if (profileUpdateError) throw profileUpdateError;
    
    // 2. Upload des fichiers
    const idCardUrls = [];
    
    // Upload de chaque fichier de carte d'identité
    for (const file of idCardFiles.value) {
      const filePath = `verifications/${user.value.id}/id_card_${Date.now()}_${file.name}`;
      
      const { error: uploadError } = await supabase.storage
        .from('documents')
        .upload(filePath, file, {
          cacheControl: '3600',
          upsert: false
        });
      
      if (uploadError) throw uploadError;
      
      // Obtenir l'URL publique du fichier
      const { data: { publicUrl } } = supabase.storage
        .from('documents')
        .getPublicUrl(filePath);
      
      idCardUrls.push(publicUrl);
    }
    
    // Upload de la photo selfie
    const selfiePath = `verifications/${user.value.id}/selfie_${Date.now()}_${selfieFile.value.name}`;
    
    const { error: selfieUploadError } = await supabase.storage
      .from('documents')
      .upload(selfiePath, selfieFile.value, {
        cacheControl: '3600',
        upsert: false
      });
    
    if (selfieUploadError) throw selfieUploadError;
    
    // Obtenir l'URL publique du selfie
    const { data: { publicUrl: selfieUrl } } = supabase.storage
      .from('documents')
      .getPublicUrl(selfiePath);
    
    // 3. Créer l'entrée de vérification dans la base de données avec le format JSONB pour les documents
    const documents = {
      id_cards: idCardUrls,
      selfie: selfieUrl
    };
    
    const { data: verificationData, error: verificationError } = await supabase
      .from('verifications')
      .insert({
        user_id: user.value.id,
        status: 'pending',
        documents: documents,
        created_at: new Date().toISOString()
      })
      .select()
      .single();
    
    if (verificationError) throw verificationError;
    
    // 4. Mettre à jour le statut
    verificationStatus.value = 'pending';
    verificationSubmittedAt.value = verificationData.created_at;
    
    // 5. Message de succès
    alert("Votre demande de vérification a été soumise avec succès. Nous l'examinerons dans les plus brefs délais.");
    
  } catch (err) {
    console.error('Error submitting verification:', err);
    error.value = "Une erreur est survenue lors de l'envoi de votre demande. Veuillez réessayer.";
  } finally {
    isSubmitting.value = false;
  }
};

// Initialisation
onMounted(() => {
  fetchProfile();
});

definePageMeta({
  middleware: ['auth'],
  layout: 'account'
})
</script>
