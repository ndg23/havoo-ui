<template>
  <div class="min-h-screen bg-white dark:bg-black">
    <section class="max-w-4xl mx-auto px-4 py-12">
      <!-- En-tête avec informations essentielles -->
      <div class="mb-8 border-b border-gray-200 dark:border-gray-800 pb-8">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">
          <div>
            <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">
              Aide pour déplacer un canapé lourd
            </h1>
            
            <!-- Distance et évaluations -->
            <div class="flex items-center gap-4 text-gray-600 dark:text-gray-400">
              <div class="flex items-center">
                <UIcon name="i-heroicons-map-pin" class="w-4 h-4 mr-1" />
                <span>1,2 km de vous</span>
              </div>
              <div class="flex items-center">
                <div class="flex">
                  <UIcon name="i-heroicons-star" class="w-4 h-4 text-yellow-400" />
                  <span class="ml-1">4,8</span>
                </div>
                <span class="text-sm ml-1">(12 évaluations)</span>
              </div>
            </div>
          </div>

          <!-- Statut de la demande -->
          <div class="flex items-center px-4 py-2 bg-green-50 dark:bg-green-900/30 rounded-full border border-green-200 dark:border-green-800">
            <div class="w-2 h-2 bg-green-500 rounded-full mr-2"></div>
            <span class="text-green-700 dark:text-green-400">Recherche d'aide</span>
          </div>
        </div>
      </div>

      <!-- Contenu principal -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
        <!-- Colonne principale -->
        <div class="md:col-span-2 space-y-6">
          <!-- Description -->
          <div class="bg-white dark:bg-gray-900 rounded-2xl p-6 shadow-lg shadow-gray-200/50 dark:shadow-gray-900/30 border border-gray-100 dark:border-gray-800">
            <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">Description</h2>
            <p class="text-gray-700 dark:text-gray-300">
              Je dois déplacer un canapé du 2ème étage au rez-de-chaussée. 
              C'est assez lourd, il faut être deux personnes minimum.
            </p>
          </div>

          <!-- Détails -->
          <div class="bg-white dark:bg-gray-900 rounded-2xl p-6 shadow-lg shadow-gray-200/50 dark:shadow-gray-900/30 border border-gray-100 dark:border-gray-800">
            <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">Détails</h2>
            <div class="space-y-4">
              <div class="flex items-center gap-2">
                <UIcon name="i-heroicons-calendar" class="w-5 h-5 text-gray-400" />
                <div>
                  <p class="font-medium text-gray-900 dark:text-white">Samedi 19 avril 2025</p>
                  <p class="text-sm text-gray-500">Après-midi</p>
                </div>
              </div>
              <div class="flex items-center gap-2">
                <UIcon name="i-heroicons-tag" class="w-5 h-5 text-gray-400" />
                <div>
                  <p class="font-medium text-gray-900 dark:text-white">Type d'aide</p>
                  <p class="text-sm text-gray-500">Coup de main ponctuel</p>
                </div>
              </div>
              <div class="flex items-center gap-2">
                <UIcon name="i-heroicons-gift" class="w-5 h-5 text-gray-400" />
                <div>
                  <p class="font-medium text-gray-900 dark:text-white">Proposition</p>
                  <p class="text-sm text-gray-500">Service rendu ou café offert!</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Sidebar -->
        <div class="space-y-6">
          <!-- Carte avec bouton d'action -->
          <div class="bg-white dark:bg-gray-900 rounded-2xl p-6 shadow-lg shadow-gray-200/50 dark:shadow-gray-900/30 border border-gray-100 dark:border-gray-800 sticky top-6">
            <button 
              class="w-full py-3 px-6 bg-primary-600 hover:bg-primary-700 text-white rounded-xl font-medium transition-colors flex items-center justify-center gap-2"
              @click="showProposalModal = true"
            >
              <UIcon name="i-heroicons-hand-raised" class="w-5 h-5" />
              Proposer mon aide
            </button>

            <!-- Profil du demandeur -->
            <div class="mt-6 pt-6 border-t border-gray-200 dark:border-gray-700">
              <div class="flex items-center gap-3">
               
                <div>
                  <p class="font-medium text-gray-900 dark:text-white">
                    <!-- {{ mission.client?.first_name }} -->
                  </p>
                  <p class="text-sm text-gray-500">
                    <!-- Membre depuis {{ formatDate(mission.client?.created_at) }} -->
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template> 
<script setup>
import { ref, computed, onMounted } from 'vue'
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
const deals = ref([])
const isLoading = ref(true)
const showProposalModal = ref(false)
const isSubmitting = ref(false)

// Formulaire de proposition
const proposalForm = ref({
  price: null,
  duration: 1,
  duration_unit: 'days',
  message: ''
})

// Computed
const canMakeProposal = computed(() => {
  if (!mission.value || !user.value) return false
  return (
    mission.value.status === 'open' && 
    mission.value.client_id !== user.value.id &&
    !deals.value.some(d => d.expert_id === user.value.id)
  )
})

const isValid = computed(() => {
  return proposalForm.value.price > 0 && 
         proposalForm.value.duration > 0 && 
         proposalForm.value.message.length > 0
})

// Méthodes
const loadMission = async () => {
  try {
    const { data: missionData, error: missionError } = await supabase
      .from('missions')
      .select(`
        *
      `)
      .eq('id', route.params.id)
      .single()

    if (missionError) throw missionError
    mission.value = missionData

    // Charger les propositions (deals)
    const { data: dealsData, error: dealsError } = await supabase
      .from('deals')
      .select(`
        *
      `)
      .eq('mission_id', route.params.id)
      .order('created_at', { ascending: false })

    if (dealsError) throw dealsError
    deals.value = dealsData

  } catch (error) {
    console.error('Error loading mission:', error)
  } finally {
    isLoading.value = false
  }
}

const submitProposal = async () => {
  if (!isValid.value) return

  try {
    isSubmitting.value = true

    const { error } = await supabase
      .from('deals')
      .insert({
        mission_id: mission.value.id,
        expert_id: user.value.id,
        client_id: mission.value.client_id,
        price: proposalForm.value.price,
        duration: proposalForm.value.duration,
        duration_unit: proposalForm.value.duration_unit,
        message: proposalForm.value.message,
        status: 'proposal'
      })

    if (error) throw error

    showProposalModal.value = false
    proposalForm.value = {
      price: null,
      duration: 1,
      duration_unit: 'days',
      message: ''
    }

    // Recharger les propositions
    await loadMission()

  } catch (error) {
    console.error('Error submitting proposal:', error)
    alert('Une erreur est survenue lors de l\'envoi de votre proposition')
  } finally {
    isSubmitting.value = false
  }
}

// Utilitaires
const formatDate = (date) => {
  if (!date) return ''
  return format(new Date(date), 'dd MMMM yyyy', { locale: fr })
}

const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(price || 0)
}

const getStatusColor = (status) => {
  const colors = {
    'open': 'green',
    'assigned': 'blue',
    'in_progress': 'yellow',
    'completed': 'gray',
    'cancelled': 'red'
  }
  return colors[status] || 'gray'
}

const getStatusLabel = (status) => {
  const labels = {
    'open': 'Ouvert',
    'assigned': 'Assigné',
    'in_progress': 'En cours',
    'completed': 'Terminé',
    'cancelled': 'Annulé'
  }
  return labels[status] || status
}

// Initialisation
onMounted(() => {
  loadMission()
})

definePageMeta({
  layout: 'default'
})
</script>