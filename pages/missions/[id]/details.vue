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
        *,
        client:profiles!client_id(*),
        profession:professions(*)
      `)
      .eq('id', route.params.id)
      .single()

    if (missionError) throw missionError
    mission.value = missionData

    // Charger les propositions (deals)
    const { data: dealsData, error: dealsError } = await supabase
      .from('deals')
      .select(`
        *,
        expert:profiles!expert_id(*)
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