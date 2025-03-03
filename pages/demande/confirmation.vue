<template>
  <div class="min-h-screen bg-gray-50 flex items-center justify-center px-4">
    <div class="max-w-md w-full text-center">
      <!-- Success Icon -->
      <div class="w-20 h-20 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-8">
        <svg class="w-10 h-10 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
        </svg>
      </div>

      <h1 class="text-3xl font-bold text-gray-900 mb-4">
        Demande envoyée !
      </h1>
      
      <p class="text-gray-500 text-lg mb-8">
        Nous avons bien reçu votre demande. Nos experts vous contacteront très prochainement avec leurs propositions.
      </p>

      <div class="bg-white rounded-2xl shadow-lg p-6 mb-8">
        <div class="flex items-center justify-center gap-2 text-primary-600 mb-4">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <span class="font-medium">Prochaines étapes</span>
        </div>
        <ul class="space-y-4 text-left">
          <li class="flex items-start gap-3">
            <span class="text-primary-500 font-medium">1.</span>
            <p class="text-gray-600">Vous recevrez un email de confirmation dans quelques minutes</p>
          </li>
          <li class="flex items-start gap-3">
            <span class="text-primary-500 font-medium">2.</span>
            <p class="text-gray-600">Les experts examineront votre demande et prépareront leurs devis</p>
          </li>
          <li class="flex items-start gap-3">
            <span class="text-primary-500 font-medium">3.</span>
            <p class="text-gray-600">Vous pourrez comparer les propositions et choisir votre expert</p>
          </li>
        </ul>
      </div>

      <NuxtLink 
        to="/" 
        class="inline-flex items-center text-primary-600 hover:text-primary-700"
      >
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
        </svg>
        Retour à l'accueil
      </NuxtLink>
    </div>
  </div>
</template> 