<template>
  <div class="max-w-4xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête de la demande -->
    <div class="bg-white dark:bg-gray-800 rounded-xl p-5 shadow-sm mb-6">
      <div class="flex justify-between items-start">
        <div>
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white">{{ request.title }}</h1>
          <div class="flex items-center mt-2">
            <Calendar class="h-4 w-4 text-gray-500 mr-1.5" />
            <span class="text-gray-600 dark:text-gray-400 text-sm">Publiée le {{ formatDate(request.created_at) }}</span>
          </div>
        </div>
        
        <div class="bg-blue-50 dark:bg-blue-900/20 px-3 py-1 rounded-full">
          <span class="text-blue-600 dark:text-blue-400 text-sm font-medium">{{ request.status }}</span>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <!-- Détails de la demande -->
      <div class="md:col-span-2">
        <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden mb-6">
          <!-- Description -->
          <div class="p-5">
            <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-3">Description du projet</h2>
            <div class="text-gray-700 dark:text-gray-300 space-y-3">
              <p>{{ request.description }}</p>
            </div>
          </div>
          
          <!-- Spécifications -->
          <div class="border-t border-gray-200 dark:border-gray-700 p-5">
            <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-3">Spécifications</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="flex items-start">
                <Calendar class="h-5 w-5 text-gray-500 mr-2 mt-0.5" />
                <div>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Délai souhaité</p>
                  <p class="font-medium text-gray-900 dark:text-white">
                    {{ request.deadline || 'Flexible' }}
                  </p>
                </div>
              </div>
              
              <div class="flex items-start">
                <DollarSign class="h-5 w-5 text-gray-500 mr-2 mt-0.5" />
                <div>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Budget</p>
                  <p class="font-medium text-gray-900 dark:text-white">
                    {{ request.budget ? request.budget + '€' : 'À discuter' }}
                  </p>
                </div>
              </div>
              
              <div class="flex items-start">
                <MapPin class="h-5 w-5 text-gray-500 mr-2 mt-0.5" />
                <div>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Localisation</p>
                  <p class="font-medium text-gray-900 dark:text-white">
                    {{ request.location || 'À distance' }}
                  </p>
                </div>
              </div>
              
              <div class="flex items-start">
                <CheckCircle class="h-5 w-5 text-gray-500 mr-2 mt-0.5" />
                <div>
                  <p class="text-sm text-gray-500 dark:text-gray-400">Type de projet</p>
                  <p class="font-medium text-gray-900 dark:text-white">
                    {{ request.project_type }}
                  </p>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Compétences requises -->
          <div class="border-t border-gray-200 dark:border-gray-700 p-5">
            <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-3">Compétences requises</h2>
            <div class="flex flex-wrap gap-2">
              <span 
                v-for="skill in request.skills" 
                :key="skill"
                class="bg-gray-100 dark:bg-gray-700 px-3 py-1 rounded-full text-gray-800 dark:text-gray-200 text-sm"
              >
                {{ skill }}
              </span>
            </div>
          </div>
          
          <!-- Client -->
          <div class="border-t border-gray-200 dark:border-gray-700 p-5">
            <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-3">À propos du client</h2>
            <div class="flex items-center">
              <img 
                :src="request.client.avatar_url || '/img/default-avatar.png'" 
                class="w-12 h-12 rounded-full mr-3 object-cover" 
                alt="Avatar du client"
              />
              <div>
                <p class="font-medium text-gray-900 dark:text-white">
                  {{ request.client.name }}
                </p>
                <div class="flex items-center mt-1">
                  <Star class="h-4 w-4 text-amber-500 fill-amber-500 mr-1" />
                  <span class="text-gray-700 dark:text-gray-300 text-sm">
                    {{ request.client.rating }} · {{ request.client.projects_count }} projets
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Section action (soumettre une proposition) -->
      <div class="md:col-span-1">
        <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 sticky top-6">
          <div class="p-5">
            <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-4">Faire une proposition</h2>
            
            <div v-if="!isExpert" class="text-center py-4">
              <Shield class="h-12 w-12 text-gray-400 mx-auto mb-3" />
              <p class="text-gray-700 dark:text-gray-300 mb-4">
                Vous devez être en mode expert pour répondre à cette demande.
              </p>
              <NuxtLink to="/account" class="text-blue-600 dark:text-blue-400 font-medium hover:underline">
                Activer le mode expert
              </NuxtLink>
            </div>
            
            <div v-else-if="hasProposed" class="text-center py-4">
              <CheckCircle class="h-12 w-12 text-green-500 mx-auto mb-3" />
              <p class="text-gray-700 dark:text-gray-300 mb-2">
                Vous avez déjà envoyé une proposition pour cette demande.
              </p>
              <div class="mt-4">
                <NuxtLink to="/account/proposals" class="text-blue-600 dark:text-blue-400 font-medium hover:underline">
                  Voir mes propositions
                </NuxtLink>
              </div>
            </div>
            
            <div v-else>
              <form @submit.prevent="submitProposal">
                <div class="space-y-4">
                  <!-- Tarif -->
                  <div>
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Votre tarif (€)
                    </label>
                    <div class="relative">
                      <input 
                        type="number" 
                        v-model="proposal.price"
                        class="w-full px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg"
                        placeholder="Montant"
                        min="1"
                      />
                      <span class="absolute right-3 top-2 text-gray-500">€</span>
                    </div>
                  </div>
                  
                  <!-- Délai -->
                  <div>
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Délai d'exécution (jours)
                    </label>
                    <input 
                      type="number" 
                      v-model="proposal.days"
                      class="w-full px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg"
                      placeholder="Nombre de jours"
                      min="1"
                    />
                  </div>
                  
                  <!-- Message -->
                  <div>
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                      Votre message
                    </label>
                    <textarea 
                      v-model="proposal.message"
                      rows="5"
                      class="w-full px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg"
                      placeholder="Décrivez votre approche pour ce projet..."
                    ></textarea>
                    <p class="text-xs text-gray-500 mt-1">
                      {{ 1000 - proposal.message.length }} caractères restants
                    </p>
                  </div>
                  
                  <!-- Submit -->
                  <button 
                    type="submit"
                    class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-lg transition-colors"
                    :disabled="!canSubmit"
                  >
                    Envoyer ma proposition
                  </button>
                  
                  <p class="text-xs text-gray-500 text-center">
                    En soumettant votre proposition, vous acceptez les conditions de service de Havoo.
                  </p>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { 
  Calendar, DollarSign, MapPin, CheckCircle, 
  Star, Shield, CheckIcon
} from 'lucide-vue-next'

// Données de la demande (mock)
const request = ref({
  id: '123',
  title: 'Création d\'un site e-commerce responsive',
  status: 'Ouverte',
  created_at: '2023-08-15T10:00:00',
  description: `Je recherche un développeur expérimenté pour créer un site e-commerce responsive pour ma boutique de vêtements. Le site doit être facile à naviguer, avec un design moderne et épuré. Il doit être optimisé pour le mobile et inclure un système de paiement sécurisé.`,
  deadline: '30 jours',
  budget: 2500,
  location: 'À distance',
  project_type: 'Site web complet',
  skills: ['Wordpress', 'WooCommerce', 'HTML/CSS', 'Responsive Design', 'SEO'],
  client: {
    name: 'Marie Dubois',
    avatar_url: 'https://randomuser.me/api/portraits/women/42.jpg',
    rating: 4.8,
    projects_count: 7
  }
})

// État de l'utilisateur
const isExpert = ref(true)
const hasProposed = ref(false)

// État de la proposition
const proposal = ref({
  price: '',
  days: '',
  message: ''
})

// Validations
const canSubmit = computed(() => {
  return proposal.value.price > 0 && 
         proposal.value.days > 0 && 
         proposal.value.message.length > 20 &&
         proposal.value.message.length <= 1000
})

// Formatage de la date
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

// Soumettre la proposition
const submitProposal = () => {
  if (!canSubmit.value) return
  
  // Simuler une soumission réussie
  setTimeout(() => {
    hasProposed.value = true
    // Redirection ou notification ici
  }, 1000)
}

definePageMeta({
  layout: 'default'
})
</script> 