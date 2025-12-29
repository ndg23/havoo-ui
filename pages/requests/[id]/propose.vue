<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Header avec retour -->
    <div class="sticky top-0 z-20 bg-white/95 dark:bg-gray-900/95 backdrop-blur-lg border-b border-gray-200 dark:border-gray-700 shadow-sm">
      <div class="max-w-5xl mx-auto px-4 sm:px-6 py-4">
        <div class="flex items-center gap-4">
          <button 
            @click="router.back()"
            class="p-2 -ml-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
          >
            <UIcon name="i-heroicons-arrow-left" class="w-5 h-5" />
          </button>
          <div>
            <h1 class="text-xl font-bold text-gray-900 dark:text-white">Faire une proposition</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400">
              Proposez vos services pour cette mission
            </p>
          </div>
        </div>
      </div>
    </div>

    <div class="max-w-5xl mx-auto px-4 sm:px-6 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Formulaire de proposition -->
        <div class="lg:col-span-2 space-y-8">
          <div v-if="error" class="bg-red-50 dark:bg-red-900/20 text-red-700 dark:text-red-400 p-4 rounded-lg">
            {{ error }}
          </div>

          <form @submit.prevent="submitProposal" class="space-y-6">
            <!-- Prix proposé -->
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Prix proposé
              </label>
              <div class="relative">
                <input
                  v-model="form.price"
                  type="number"
                  min="0"
                  required
                  class="block w-full pl-12 pr-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-green-500 focus:border-transparent"
                  placeholder="0"
                />
                <div class="absolute inset-y-0 left-0 flex items-center pl-4 pointer-events-none">
                  <span class="text-gray-500">€</span>
                </div>
              </div>
              <p class="mt-1 text-sm text-gray-500">Prix total pour la mission, TTC</p>
            </div>

            <!-- Durée estimée -->
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Durée estimée (en jours)
              </label>
              <input
                v-model="form.duration"
                type="number"
                min="1"
                required
                class="block w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-green-500 focus:border-transparent"
                placeholder="1"
              />
              <p class="mt-1 text-sm text-gray-500">Temps nécessaire pour réaliser la mission</p>
            </div>

            <!-- Description de la proposition -->
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Description de votre proposition
              </label>
              <textarea
                v-model="form.description"
                rows="6"
                required
                class="block w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-green-500 focus:border-transparent resize-none"
                placeholder="Décrivez en détail votre proposition..."
              ></textarea>
              <p class="mt-1 text-sm text-gray-500">
                Expliquez comment vous comptez réaliser la mission, votre expérience, etc.
              </p>
            </div>

            <!-- Disponibilités -->
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Vos disponibilités
              </label>
              <div class="space-y-3">
                <div class="flex items-center gap-3">
                  <input
                    v-model="form.start_date"
                    type="date"
                    required
                    class="flex-1 px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg text-gray-900 dark:text-white focus:ring-2 focus:ring-green-500 focus:border-transparent"
                  />
                  <span class="text-gray-500">au</span>
                  <input
                    v-model="form.end_date"
                    type="date"
                    required
                    class="flex-1 px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg text-gray-900 dark:text-white focus:ring-2 focus:ring-green-500 focus:border-transparent"
                  />
                </div>
                <textarea
                  v-model="form.availability_details"
                  rows="2"
                  class="block w-full px-4 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-green-500 focus:border-transparent resize-none"
                  placeholder="Précisions sur vos disponibilités (optionnel)"
                ></textarea>
              </div>
            </div>

            <!-- Boutons d'action -->
            <div class="flex items-center justify-end gap-4 pt-6">
              <button
                type="button"
                @click="router.back()"
                class="px-6 py-3 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 rounded-lg transition-colors"
              >
                Annuler
              </button>
              <button
                type="submit"
                :disabled="isSubmitting"
                class="px-6 py-3 bg-green-600 hover:bg-green-700 disabled:opacity-50 disabled:hover:bg-green-600 text-white font-medium rounded-lg shadow-sm transition-colors flex items-center gap-2"
              >
                <span v-if="isSubmitting" class="w-4 h-4 border-2 border-white/60 border-t-white rounded-full animate-spin"></span>
                {{ isSubmitting ? 'Envoi en cours...' : 'Envoyer ma proposition' }}
              </button>
            </div>
          </form>
        </div>

        <!-- Détails de la mission -->
        <div class="space-y-6">
          <div class="bg-gray-50 dark:bg-gray-800 rounded-xl p-6">
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Détails de la mission
            </h2>
            
            <div v-if="isLoading" class="py-8 flex justify-center">
              <div class="w-8 h-8 border-2 border-green-600/30 border-t-green-600 rounded-full animate-spin"></div>
            </div>

            <div v-else-if="mission" class="space-y-4">
              <h3 class="text-xl font-bold text-gray-900 dark:text-white">
                {{ mission.title }}
              </h3>

              <div class="flex items-center gap-2 text-sm">
                <span 
                  class="px-2 py-1 rounded-full text-xs font-medium"
                  :class="getStatusColor(mission.status)"
                >
                  {{ getStatusLabel(mission.status) }}
                </span>
                <span 
                  v-if="mission.is_urgent"
                  class="bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400 px-2 py-1 rounded-full text-xs font-medium"
                >
                  Urgent
                </span>
              </div>

              <div class="pt-2 space-y-3 text-sm text-gray-600 dark:text-gray-300">
                <p class="flex items-center gap-2">
                  <UIcon name="i-heroicons-banknotes" class="w-5 h-5 text-gray-400" />
                  <span class="font-medium">Budget :</span>
                  {{ formatPrice(mission.budget) }}
                </p>
                <p class="flex items-center gap-2">
                  <UIcon name="i-heroicons-academic-cap" class="w-5 h-5 text-gray-400" />
                  <span class="font-medium">Catégorie :</span>
                  {{ mission.profession?.name }}
                </p>
                <p class="flex items-center gap-2">
                  <UIcon name="i-heroicons-map-pin" class="w-5 h-5 text-gray-400" />
                  <span class="font-medium">Localisation :</span>
                  {{ mission.location || 'À distance' }}
                </p>
                <p class="flex items-center gap-2">
                  <UIcon name="i-heroicons-clock" class="w-5 h-5 text-gray-400" />
                  <span class="font-medium">Deadline :</span>
                  {{ mission.deadline ? formatDate(mission.deadline) : 'Non spécifiée' }}
                </p>
              </div>

              <div class="pt-4">
                <h4 class="font-medium text-gray-900 dark:text-white mb-2">Description</h4>
                <p class="text-sm text-gray-600 dark:text-gray-300 whitespace-pre-line">
                  {{ mission.description }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'

const route = useRoute()
const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// États
const mission = ref(null)
const isLoading = ref(true)
const isSubmitting = ref(false)
const error = ref(null)

// Formulaire
const form = ref({
  price: '',
  duration: 1,
  description: '',
  start_date: '',
  end_date: '',
  availability_details: ''
})

// Charger les détails de la mission
const fetchMission = async () => {
  try {
    const { data, error: fetchError } = await supabase
      .from('missions')
      .select(`
        *,
        client:profiles(*),
        profession:professions(*)
      `)
      .eq('id', route.params.id)
      .single()

    if (fetchError) throw fetchError
    if (!data) throw new Error('Mission non trouvée')

    // Vérifier si l'utilisateur peut faire une proposition
    if (!user.value) {
      router.push('/login')
      return
    }

    if (data.client_id === user.value.id) {
      router.push(`/requests/${route.params.id}`)
      return
    }

    if (data.status !== 'open') {
      router.push(`/requests/${route.params.id}`)
      return
    }

    mission.value = data
  } catch (err) {
    console.error('Error fetching mission:', err)
    error.value = "Impossible de charger les détails de la mission"
  } finally {
    isLoading.value = false
  }
}

// Soumettre la proposition
const submitProposal = async () => {
  try {
    isSubmitting.value = true
    error.value = null

    // Validation de base
    if (!form.value.price || !form.value.duration || !form.value.description) {
      throw new Error('Veuillez remplir tous les champs obligatoires')
    }

    if (new Date(form.value.start_date) > new Date(form.value.end_date)) {
      throw new Error('La date de début doit être antérieure à la date de fin')
    }

    // Créer la proposition
    const { error: insertError } = await supabase
      .from('deals')
      .insert({
        mission_id: route.params.id,
        expert_id: user.value.id,
        price: form.value.price,
        duration: form.value.duration,
        description: form.value.description,
        start_date: form.value.start_date,
        end_date: form.value.end_date,
        availability_details: form.value.availability_details || null,
        status: 'pending'
      })

    if (insertError) throw insertError

    // Rediriger vers la page de la mission
    router.push(`/requests/${route.params.id}?proposal=success`)

  } catch (err) {
    console.error('Error submitting proposal:', err)
    error.value = err.message || "Une erreur est survenue lors de l'envoi de votre proposition"
  } finally {
    isSubmitting.value = false
  }
}

// Fonctions utilitaires
const formatPrice = (price) => {
  if (!price) return 'Sur devis'
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(price)
}

const formatDate = (date) => {
  if (!date) return 'Non spécifié'
  return format(new Date(date), 'dd MMM yyyy', { locale: fr })
}

const getStatusLabel = (status) => {
  const labels = {
    'open': 'Nouvelle',
    'in_progress': 'En cours',
    'completed': 'Terminée',
    'cancelled': 'Annulée'
  }
  return labels[status] || status
}

const getStatusColor = (status) => {
  const colors = {
    'open': 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400',
    'in_progress': 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400',
    'completed': 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300',
    'cancelled': 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400'
  }
  return colors[status] || colors.open
}

// Initialisation
onMounted(() => {
  fetchMission()
})
</script> 