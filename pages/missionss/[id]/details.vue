<template>
    <div class="min-h-screen bg-white dark:bg-black">
      <!-- Page de suivi de service -->
      <section class="max-w-4xl mx-auto px-4 py-12">
        <!-- En-tête avec informations essentielles -->
        <div class="mb-8 border-b border-gray-200 dark:border-gray-800 pb-8">
          <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">
            <div>
              <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">Service de jardinage</h1>
              <p class="text-lg text-primary-600 dark:text-primary-400 font-medium">Ref: #JD-2856</p>
            </div>
            
            <!-- Statut du service -->
            <div class="flex items-center px-4 py-2 bg-blue-50 dark:bg-blue-900/30 rounded-full border border-blue-200 dark:border-blue-800">
              <div class="w-3 h-3 bg-blue-500 rounded-full mr-2"></div>
              <span class="text-blue-700 dark:text-blue-400 font-medium">Service en cours de réalisation</span>
            </div>
          </div>
          
          <!-- Barre de progression -->
          <div class="mt-8">
            <div class="flex justify-between mb-2">
              <span class="text-sm text-gray-600 dark:text-gray-400">Progression</span>
              <span class="text-sm font-medium text-primary-600 dark:text-primary-400">65%</span>
            </div>
            <div class="w-full bg-gray-200 dark:bg-gray-800 rounded-full h-2">
              <div class="bg-primary-600 dark:bg-primary-500 h-2 rounded-full" style="width: 65%"></div>
            </div>
          </div>
        </div>
  
        <!-- Grille principale -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Colonne gauche: Infos service -->
          <div class="md:col-span-2 space-y-6">
            <!-- Étapes du service -->
            <div class="bg-white dark:bg-gray-900 rounded-2xl p-6 shadow-lg shadow-gray-200/50 dark:shadow-gray-900/30 border border-gray-100 dark:border-gray-800">
              <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-6">Suivi du service</h2>
              
              <div class="space-y-8">
                <!-- Étape 1: Mise en relation -->
                <div class="relative flex items-start">
                  <div class="flex flex-col items-center mr-4">
                    <div class="flex items-center justify-center w-8 h-8 rounded-full bg-green-100 dark:bg-green-900 border-2 border-green-500 dark:border-green-600">
                      <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-green-600 dark:text-green-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                      </svg>
                    </div>
                    <div class="w-0.5 h-full bg-gray-200 dark:bg-gray-700 mt-3"></div>
                  </div>
                  <div class="pb-8">
                    <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Mise en relation établie</h3>
                    <p class="text-gray-600 dark:text-gray-400 mt-1">15 avril 2025 - 09:30</p>
                    <div class="mt-2 text-sm text-gray-600 dark:text-gray-400">
                      Michel et vous êtes maintenant en contact pour réaliser ce service ensemble.
                    </div>
                  </div>
                </div>
                
                <!-- Étape 2: Réalisation -->
                <div class="relative flex items-start">
                  <div class="flex flex-col items-center mr-4">
                    <div class="flex items-center justify-center w-8 h-8 rounded-full bg-blue-100 dark:bg-blue-900/50 border-2 border-blue-500 dark:border-blue-600">
                      <div class="w-2 h-2 bg-blue-500 rounded-full"></div>
                    </div>
                    <div class="w-0.5 h-full bg-gray-200 dark:bg-gray-700 mt-3"></div>
                  </div>
                  <div class="pb-8">
                    <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Service en cours de réalisation</h3>
                    <p class="text-gray-600 dark:text-gray-400 mt-1">15 avril 2025 - 10:15</p>
                    <div class="mt-2 text-sm text-gray-600 dark:text-gray-400">
                      Michel s'occupe actuellement de votre jardin avec soin.
                    </div>
                    
                    <!-- Photos de progression -->
                    <div class="mt-4 flex space-x-3">
                      <div class="w-20 h-20 rounded-lg overflow-hidden">
                      </div>
                      <div class="w-20 h-20 rounded-lg overflow-hidden">
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- Étape 3: Finalisation -->
                <div class="relative flex items-start">
                  <div class="flex flex-col items-center mr-4">
                    <div class="flex items-center justify-center w-8 h-8 rounded-full bg-gray-100 dark:bg-gray-800 border-2 border-gray-300 dark:border-gray-700">
                      <span class="text-gray-500 dark:text-gray-400 text-sm font-medium">3</span>
                    </div>
                  </div>
                  <div>
                    <h3 class="text-lg font-semibold text-gray-700 dark:text-gray-300">Finalisation du service</h3>
                    <p class="text-gray-500 dark:text-gray-500 mt-1">Prévu à 15:30</p>
                    <div class="mt-2 text-sm text-gray-500 dark:text-gray-500">
                      Michel terminera le service et vous pourrez échanger sur le résultat.
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Zone de communication -->
            <div class="bg-white dark:bg-gray-900 rounded-2xl p-6 shadow-lg shadow-gray-200/50 dark:shadow-gray-900/30 border border-gray-100 dark:border-gray-800">
              <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-6">Messages</h2>
              
              <!-- Liste de messages -->
              <div class="space-y-6 mb-6">
                <!-- Message expert -->
                <div class="flex items-start">
                  <div class="flex-shrink-0 mr-3">
                    <div class="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900 flex items-center justify-center">
                      <span class="text-blue-600 dark:text-blue-400 font-medium">ML</span>
                    </div>
                  </div>
                  <div>
                    <div class="flex items-center mb-1">
                      <h4 class="font-medium text-gray-900 dark:text-white">Michel Lambert</h4>
                      <span class="ml-2 text-xs text-gray-500 dark:text-gray-400">10:30</span>
                    </div>
                    <div class="bg-gray-100 dark:bg-gray-800 p-3 rounded-lg max-w-sm">
                      <p class="text-gray-700 dark:text-gray-300">Bonjour, je suis arrivé comme prévu. J'ai commencé par la taille des haies du fond du jardin.</p>
                    </div>
                  </div>
                </div>
                
                <!-- Message client -->
                <div class="flex items-start justify-end">
                  <div>
                    <div class="flex items-center justify-end mb-1">
                      <span class="mr-2 text-xs text-gray-500 dark:text-gray-400">10:35</span>
                      <h4 class="font-medium text-gray-900 dark:text-white">Vous</h4>
                    </div>
                    <div class="bg-primary-100 dark:bg-primary-900/40 p-3 rounded-lg max-w-sm">
                      <p class="text-primary-800 dark:text-primary-300">Merci pour votre message. Pourriez-vous également vous occuper des rosiers près de la terrasse ?</p>
                    </div>
                  </div>
                  <div class="flex-shrink-0 ml-3">
                    <div class="w-10 h-10 rounded-full bg-primary-100 dark:bg-primary-900/40 flex items-center justify-center">
                      <span class="text-primary-600 dark:text-primary-400 font-medium">VC</span>
                    </div>
                  </div>
                </div>
                
                <!-- Message expert -->
                <div class="flex items-start">
                  <div class="flex-shrink-0 mr-3">
                    <div class="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900 flex items-center justify-center">
                      <span class="text-blue-600 dark:text-blue-400 font-medium">ML</span>
                    </div>
                  </div>
                  <div>
                    <div class="flex items-center mb-1">
                      <h4 class="font-medium text-gray-900 dark:text-white">Michel Lambert</h4>
                      <span class="ml-2 text-xs text-gray-500 dark:text-gray-400">10:45</span>
                    </div>
                    <div class="bg-gray-100 dark:bg-gray-800 p-3 rounded-lg max-w-sm">
                      <p class="text-gray-700 dark:text-gray-300">Bien sûr, je m'en occupe tout de suite. Je vous enverrai une photo une fois terminé.</p>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Formulaire de message -->
              <div class="relative">
                <input type="text" placeholder="Tapez votre message..." class="w-full py-3 px-4 bg-gray-100 dark:bg-gray-800 border-none rounded-full text-gray-800 dark:text-gray-200 focus:ring-2 focus:ring-primary-500 focus:outline-none" />
                <button class="absolute right-1 top-1 bg-primary-600 dark:bg-primary-500 text-white p-2 rounded-full">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                  </svg>
                </button>
              </div>
            </div>
          </div>
          
          <!-- Colonne droite: Détails et actions -->
          <div class="space-y-6">
            <!-- Détails de l'expert -->
            <div class="bg-white dark:bg-gray-900 rounded-2xl p-6 shadow-lg shadow-gray-200/50 dark:shadow-gray-900/30 border border-gray-100 dark:border-gray-800">
              <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">Votre expert</h2>
              
              <div class="flex items-center mb-4">
                <div class="w-16 h-16 rounded-full bg-blue-100 dark:bg-blue-900 flex items-center justify-center mr-4">
                  <span class="text-blue-600 dark:text-blue-400 font-medium text-xl">ML</span>
                </div>
                <div>
                  <h3 class="font-semibold text-gray-900 dark:text-white">Michel Lambert</h3>
                  <div class="flex items-center mt-1">
                    <div class="flex">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-yellow-400" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
                      </svg>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-yellow-400" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
                      </svg>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-yellow-400" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
                      </svg>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-yellow-400" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
                      </svg>
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-yellow-400" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z" />
                      </svg>
                    </div>
                    <span class="ml-1 text-sm text-gray-600 dark:text-gray-400">4.96 (128 avis)</span>
                  </div>
                </div>
              </div>
              
              <div class="flex justify-between gap-2 mt-6">
                <button class="flex-1 py-2 px-4 bg-white dark:bg-gray-800 text-blue-600 dark:text-blue-400 border border-blue-200 dark:border-blue-800 rounded-lg hover:bg-blue-50 dark:hover:bg-blue-900/30 transition-colors">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                  </svg>
                </button>
                <button class="flex-1 py-2 px-4 bg-blue-600 dark:bg-blue-500 text-white rounded-lg hover:bg-blue-700 dark:hover:bg-blue-600 transition-colors">
                  Échanger
                </button>
              </div>
            </div>
            
            <!-- Détails du service -->
            <div class="bg-white dark:bg-gray-900 rounded-2xl p-6 shadow-lg shadow-gray-200/50 dark:shadow-gray-900/30 border border-gray-100 dark:border-gray-800">
              <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">Détails du service</h2>
              
              <div class="space-y-4">
                <div>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Date</p>
                  <p class="font-medium text-gray-900 dark:text-white">15 avril 2025</p>
                </div>
                
                <div>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Horaire</p>
                  <p class="font-medium text-gray-900 dark:text-white">09:30 - 16:30</p>
                </div>
                
                <div>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Durée estimée</p>
                  <p class="font-medium text-gray-900 dark:text-white">7 heures</p>
                </div>
                
                <div>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Adresse</p>
                  <p class="font-medium text-gray-900 dark:text-white">24 Avenue des Lilas, 75020 Paris</p>
                </div>
                
                <div>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Montant</p>
                  <p class="font-medium text-gray-900 dark:text-white">180 €</p>
                </div>
              </div>
            </div>
            
            <!-- Actions -->
            <div class="bg-white dark:bg-gray-900 rounded-2xl p-6 shadow-lg shadow-gray-200/50 dark:shadow-gray-900/30 border border-gray-100 dark:border-gray-800">
              <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">Actions</h2>
              
              <div class="space-y-3">
                <button class="w-full py-3 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 border border-gray-200 dark:border-gray-700 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors text-left px-4 flex items-center">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3 text-gray-500 dark:text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  Modifier le rendez-vous
                </button>
                
                <button class="w-full py-3 bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 border border-gray-200 dark:border-gray-700 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors text-left px-4 flex items-center">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3 text-gray-500 dark:text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                  </svg>
                  Détails de facturation
                </button>
                
                <button class="w-full py-3 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 border border-red-200 dark:border-red-800 rounded-lg hover:bg-red-100 dark:hover:bg-red-900/30 transition-colors text-left px-4 flex items-center">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                  Annuler le service
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>
      
      <!-- Barre de navigation fixe sur mobile -->
      <div class="md:hidden fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-900 border-t border-gray-200 dark:border-gray-800 p-3 flex justify-around">
        <button class="flex flex-col items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-primary-600 dark:text-primary-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
          </svg>
          <span class="text-xs mt-1 text-gray-600 dark:text-gray-400">Accueil</span>
        </button>
        
        <button class="flex flex-col items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-500 dark:text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
          </svg>
          <span class="text-xs mt-1 text-gray-600 dark:text-gray-400">Services</span>
        </button>
        
        <button class="flex flex-col items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-500 dark:text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
          </svg>
          <span class="text-xs mt-1 text-gray-600 dark:text-gray-400">Messages</span>
        </button>
        
        <button class="flex flex-col items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-500 dark:text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
          </svg>
          <span class="text-xs mt-1 text-gray-600 dark:text-gray-400">Profil</span>
        </button>
      </div>
      
      <!-- Notifications mobiles -->
      <div class="fixed bottom-20 right-4 z-50 hidden">
        <div class="bg-white dark:bg-gray-900 rounded-lg shadow-lg p-4 border border-gray-200 dark:border-gray-800 max-w-xs">
          <div class="flex items-start">
            <div class="flex-shrink-0 mr-3">
              <div class="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900 flex items-center justify-center">
                <span class="text-blue-600 dark:text-blue-400 font-medium">ML</span>
              </div>
            </div>
            <div>
              <h4 class="font-medium text-gray-900 dark:text-white">Michel Lambert</h4>
              <p class="text-sm text-gray-600 dark:text-gray-400 mt-1">A envoyé une photo de progression</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  </script>