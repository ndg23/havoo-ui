<template>
  <div class="min-h-screen bg-white flex flex-col justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md mx-auto w-full">
      <div class="bg-white py-8 px-6 shadow-sm border border-gray-100 rounded-2xl text-center">
        <!-- Icône de succès -->
        <div class="flex justify-center mb-6">
          <div class="w-20 h-20 rounded-full bg-green-100 flex items-center justify-center">
            <CheckCircle class="h-10 w-10 text-green-600" />
          </div>
        </div>
        
        <!-- Titre et description -->
        <h2 class="text-2xl font-bold text-gray-900 mb-4">
          Compte créé avec succès
        </h2>
        <p class="text-gray-600 mb-6">
          Un email de confirmation a été envoyé à <span class="font-medium text-gray-900">{{ email }}</span>.<br>
          Veuillez cliquer sur le lien dans l'email pour activer votre compte.
        </p>
        
        <!-- Progression du profil -->
        <div class="mb-6">
          <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-700">Complétion du profil</span>
            <span class="text-sm font-medium text-gray-700">{{ profileCompletion }}%</span>
          </div>
          <div class="w-full bg-gray-200 rounded-full h-2.5">
            <div class="bg-primary-600 h-2.5 rounded-full" :style="{ width: `${profileCompletion}%` }"></div>
          </div>
          <p class="mt-2 text-xs text-gray-500">Complétez votre profil pour augmenter vos chances d'être visible.</p>
        </div>
        
        <div class="space-y-4">
          <!-- Compléter le profil -->
          <NuxtLink 
            to="/account" 
            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-full text-base font-medium text-white bg-black hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-black transition-colors"
          >
            Compléter mon profil
          </NuxtLink>
          
          <!-- Renvoyer l'email -->
          <button 
            @click="resendEmail" 
            class="w-full flex justify-center py-3 px-4 border border-gray-300 rounded-full shadow-sm bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
            :disabled="isResending"
          >
            <span v-if="isResending" class="flex items-center">
              <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-gray-700" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Envoi en cours...
            </span>
            <span v-else>Renvoyer l'email de confirmation</span>
          </button>
        </div>
        
        <!-- Prochaines étapes -->
        <div class="mt-8 pt-6 border-t border-gray-200">
          <h3 class="text-base font-medium text-gray-900 mb-4">Prochaines étapes</h3>
          
          <div class="space-y-4">
            <div class="flex items-start">
              <div class="flex-shrink-0 h-6 w-6 flex items-center justify-center rounded-full bg-primary-100 text-primary-600 font-medium text-sm">1</div>
              <div class="ml-3">
                <h4 class="text-sm font-medium text-gray-900">Vérifiez votre email</h4>
                <p class="text-xs text-gray-500">Cliquez sur le lien de confirmation dans l'email que nous vous avons envoyé.</p>
              </div>
            </div>
            
            <div class="flex items-start">
              <div class="flex-shrink-0 h-6 w-6 flex items-center justify-center rounded-full bg-primary-100 text-primary-600 font-medium text-sm">2</div>
              <div class="ml-3">
                <h4 class="text-sm font-medium text-gray-900">Complétez votre profil</h4>
                <p class="text-xs text-gray-500">Ajoutez une photo, une bio et d'autres informations pour vous présenter.</p>
              </div>
            </div>
            
            <div class="flex items-start">
              <div class="flex-shrink-0 h-6 w-6 flex items-center justify-center rounded-full bg-primary-100 text-primary-600 font-medium text-sm">3</div>
              <div class="ml-3">
                <h4 class="text-sm font-medium text-gray-900">{{ accountType === 'expert' ? 'Ajoutez vos compétences' : 'Publiez votre première demande' }}</h4>
                <p class="text-xs text-gray-500">{{ accountType === 'expert' ? 'Indiquez vos domaines d\'expertise pour être visible auprès des clients.' : 'Décrivez votre besoin pour trouver l\'expert qui vous convient.' }}</p>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Informations supplémentaires -->
        <div class="mt-6 pt-4 border-t border-gray-200">
          <p class="text-sm text-gray-500">
            Vous n'avez pas reçu l'email ? Vérifiez votre dossier spam ou <a href="#" class="text-primary-600 hover:underline font-medium">contactez notre support</a>.
          </p>
        </div>
        
        <!-- Retour à l'accueil -->
        <div class="mt-6">
          <NuxtLink to="/" class="inline-flex items-center text-sm font-medium text-primary-600 hover:underline">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Retour à l'accueil
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { CheckCircle } from 'lucide-vue-next';

// Récupération des informations depuis le localStorage
const email = ref('');
const accountType = ref('client');
const isResending = ref(false);
const profileCompletion = ref(20); // Valeur par défaut

onMounted(() => {
  email.value = localStorage.getItem('signupEmail') || 'votre@email.com';
  accountType.value = localStorage.getItem('accountType') || 'client';
  
  // Simuler la récupération du pourcentage de complétion du profil
  // Dans une application réelle, vous récupéreriez cette valeur depuis l'API
  // profileCompletion.value = await getProfileCompletionPercentage();
});

// Fonction pour renvoyer l'email de confirmation
const resendEmail = async () => {
  isResending.value = true;
  
  try {
    // Simulation d'une requête pour renvoyer l'email
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    // Ici, vous implémenteriez l'appel API pour renvoyer l'email
    // await resendConfirmationEmail(email.value);
    
    // Afficher une notification de succès (si vous avez un système de notification)
    // showNotification({ message: 'Email envoyé avec succès', type: 'success' });
    
    // Feedback visuel temporaire
    const originalText = document.querySelector('button:disabled').textContent;
    document.querySelector('button:disabled').textContent = 'Email envoyé !';
    setTimeout(() => {
      document.querySelector('button').textContent = originalText;
    }, 2000);
    
  } catch (error) {
    console.error('Erreur lors de l\'envoi de l\'email:', error);
    // Gérer l'erreur (afficher un message, etc.)
  } finally {
    isResending.value = false;
  }
};
</script>

<style scoped>
.animate-spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style> 