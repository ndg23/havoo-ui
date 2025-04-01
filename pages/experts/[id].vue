// pages/experts/_id.vue
<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- Header avec style Apple -->
    <header class="sticky top-0 z-10 bg-white/80 dark:bg-gray-800/80 backdrop-blur-md border-b border-gray-100/50 dark:border-gray-700/50">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center gap-3">
        <button 
          @click="$router.back()" 
          class="p-2 -ml-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
        >
          <UIcon name="i-heroicons-arrow-left" class="h-5 w-5 text-gray-900 dark:text-white" />
        </button>
        <h1 class="text-lg font-medium text-gray-900 dark:text-white">
          Profil Expert
        </h1>
      </div>
    </header>

    <!-- Loading state -->
    <div v-if="isLoading" class="animate-pulse">
      <div class="h-48 bg-white dark:bg-gray-800"></div>
    </div>

    <template v-else-if="expert">
      <!-- Section profil principale -->
      <div class="bg-white dark:bg-gray-800 px-4 pt-8 pb-6">
        <div class="max-w-2xl mx-auto">
          <!-- Avatar et infos principales -->
          <div class="flex flex-col items-center">
            <div class="relative mb-4">
              <div 
                v-if="expert.avatar_url"
                class="w-28 h-28 rounded-full bg-cover bg-center ring-4 ring-white dark:ring-gray-800 shadow-lg"
                :style="{ backgroundImage: `url(${expert.avatar_url})` }"
              ></div>
              <div 
                v-else
                class="w-28 h-28 rounded-full bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center text-primary-600 dark:text-primary-400 text-4xl font-bold ring-4 ring-white dark:ring-gray-800"
              >
                {{ getInitials(expert.first_name, expert.last_name) }}
              </div>
              
              <!-- Badge vérifié -->
              <div 
                v-if="expert.is_verified"
                class="absolute bottom-0 right-0 bg-primary-500 text-white p-2 rounded-full shadow-lg"
              >
                <UIcon name="i-heroicons-check-badge" class="h-5 w-5" />
              </div>
            </div>

            <!-- Nom et statut -->
            <div class="text-center">
              <h2 class="text-2xl font-bold text-gray-900 dark:text-white">
                {{ expert.first_name }} {{ expert.last_name }}
              </h2>
              <div class="mt-1 text-lg text-gray-600 dark:text-gray-400">
                {{ expert.profession?.name }}
              </div>
              
              <!-- Statut de disponibilité -->
              <div 
                class="mt-3 inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-sm font-medium"
                :class="{
                  'bg-green-50 dark:bg-green-900/20 text-green-600': expert.availability_status === 'available',
                  'bg-red-50 dark:bg-red-900/20 text-red-600': expert.availability_status !== 'available'
                }"
              >
                <span class="relative flex h-2 w-2">
                  <span 
                    class="animate-ping absolute inline-flex h-full w-full rounded-full opacity-75"
                    :class="{
                      'bg-green-500': expert.availability_status === 'available',
                      'bg-red-500': expert.availability_status !== 'available'
                    }"
                  ></span>
                  <span 
                    class="relative inline-flex rounded-full h-2 w-2"
                    :class="{
                      'bg-green-500': expert.availability_status === 'available',
                      'bg-red-500': expert.availability_status !== 'available'
                    }"
                  ></span>
                </span>
                {{ expert.availability_status === 'available' ? 'Disponible' : 'Occupé' }}
              </div>
            </div>
          </div>

          <!-- Stats avec style Apple -->
          <div class="grid grid-cols-3 gap-4 mt-8">
            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-2xl p-4 text-center">
              <div class="flex items-center justify-center gap-1 text-2xl font-bold text-gray-900 dark:text-white">
                <UIcon name="i-heroicons-star" class="h-6 w-6 text-yellow-400" />
                {{ averageRating.toFixed(1) }}
              </div>
              <div class="text-sm text-gray-600 dark:text-gray-400 mt-1">
                Note moyenne
              </div>
            </div>
            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-2xl p-4 text-center">
              <div class="text-2xl font-bold text-gray-900 dark:text-white">
                {{ completedDeals.length }}
              </div>
              <div class="text-sm text-gray-600 dark:text-gray-400 mt-1">
                Missions
              </div>
            </div>
            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-2xl p-4 text-center">
              <div class="text-2xl font-bold text-gray-900 dark:text-white">
                {{ formatMemberDuration(expert.created_at) }}
              </div>
              <div class="text-sm text-gray-600 dark:text-gray-400 mt-1">
                d'expérience
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Sections d'informations -->
      <div class="max-w-2xl mx-auto px-4 py-6 space-y-4">
        <!-- À propos -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            À propos
          </h2>
          <p class="text-gray-600 dark:text-gray-300 leading-relaxed">
            {{ expert.bio || 'Aucune biographie disponible' }}
          </p>
        </div>

        <!-- Compétences -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Compétences
          </h2>
          <div class="flex flex-wrap gap-2">
            <span 
              v-for="skill in expert.skills" 
              :key="skill.id"
              class="px-4 py-2 rounded-full bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 text-sm font-medium"
            >
              {{ skill.name }}
            </span>
          </div>
        </div>

        <!-- Avis -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white">
              Avis
            </h2>
            <span class="text-sm text-gray-500 dark:text-gray-400">
              {{ completedDeals.length }} avis
            </span>
          </div>

          <div class="space-y-6">
            <div 
              v-for="deal in completedDeals" 
              :key="deal.id"
              class="pb-6 border-b border-gray-100 dark:border-gray-700 last:border-0 last:pb-0"
            >
              <div class="flex items-start justify-between mb-4">
                <div class="flex items-center gap-3">
                  <div 
                    v-if="deal.client?.avatar_url"
                    class="w-10 h-10 rounded-full bg-cover bg-center"
                    :style="{ backgroundImage: `url(${deal.client.avatar_url})` }"
                  ></div>
                  <div 
                    v-else
                    class="w-10 h-10 rounded-full bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center text-primary-600 dark:text-primary-400 text-sm font-bold"
                  >
                    {{ getInitials(deal.client?.first_name, deal.client?.last_name) }}
                  </div>
                  <div>
                    <div class="font-medium text-gray-900 dark:text-white">
                      {{ deal.client?.first_name }} {{ deal.client?.last_name }}
                    </div>
                    <div class="text-sm text-gray-500 dark:text-gray-400">
                      {{ formatDate(deal.created_at) }}
                    </div>
                  </div>
                </div>
                <div class="flex items-center gap-1">
                  <UIcon name="i-heroicons-star" class="h-4 w-4 text-yellow-400" />
                  <span class="font-medium">{{ deal.expert_rating }}</span>
                </div>
              </div>
              <p class="text-gray-600 dark:text-gray-300">
                {{ deal.expert_review || 'Aucun commentaire' }}
              </p>
            </div>
          </div>
        </div>

        <!-- Contact -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Contact
          </h2>
          <div class="space-y-4">
            <!-- Email -->
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center text-primary-600">
                <v-icon name="bi-envelope" />
              </div>
              <div>
                <div class="text-sm text-gray-500 dark:text-gray-400">Email</div>
                <div class="text-gray-900 dark:text-white">{{ expert.email }}</div>
              </div>
            </div>
            
            <!-- Téléphone -->
            <div v-if="expert.phone" class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center text-primary-600">
                <v-icon name="bi-phone" />
              </div>
              <div>
                <div class="text-sm text-gray-500 dark:text-gray-400">Téléphone</div>
                <div class="text-gray-900 dark:text-white">{{ expert.phone }}</div>
              </div>
            </div>

            <!-- Localisation -->
            <div v-if="getLocation(expert)" class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center text-primary-600">
                <v-icon name="bi-geo-alt" />
              </div>
              <div>
                <div class="text-sm text-gray-500 dark:text-gray-400">Localisation</div>
                <div class="text-gray-900 dark:text-white">{{ getLocation(expert) }}</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Bouton d'action -->
        <button
          class="w-full inline-flex items-center justify-center px-6 py-4 rounded-2xl bg-primary-600 hover:bg-primary-700 text-white font-medium transition-all shadow-sm"
          @click="handleContact"
        >
          <UIcon name="i-heroicons-chat-bubble-left-right" class="h-5 w-5 mr-2" />
          Contacter l'expert
        </button>
      </div>
    </template>

    <!-- Error state -->
    <div 
      v-else 
      class="max-w-2xl mx-auto px-4 py-8 text-center"
    >
      <div class="bg-white dark:bg-gray-800 rounded-xl p-8">
        <v-icon 
          name="bi-exclamation-circle"
          class="text-4xl text-red-500 mb-4"
        />
        <h2 class="text-xl font-semibold text-gray-900 dark:text-white mb-2">
          Expert introuvable
        </h2>
        <p class="text-gray-500 dark:text-gray-400 mb-6">
          L'expert que vous recherchez n'existe pas ou n'est plus disponible.
        </p>
        <NuxtLink
          to="/experts"
          class="inline-flex items-center px-4 py-2 rounded-xl bg-primary-600 hover:bg-primary-700 text-white font-medium transition-all"
        >
          <v-icon name="bi-arrow-left" class="mr-2" />
          Retour aux experts
        </NuxtLink>
      </div>
    </div>

    <!-- Ajouter avant la fermeture de la dernière div du template -->
    <div class="max-w-2xl mx-auto px-4 pb-6">
      <!-- Bouton Signaler -->
      <button
        @click="showReportModal = true"
        class="w-full mt-2 inline-flex items-center justify-center px-6 py-4 rounded-2xl 
               bg-gray-50 hover:bg-gray-100 dark:bg-gray-800 dark:hover:bg-gray-700
               text-red-600 dark:text-red-400 font-medium transition-all"
      >
        <UIcon name="i-heroicons-flag" class="h-5 w-5 mr-2" />
        Signaler cet expert
      </button>
    </div>

    <!-- Modal de signalement -->
    <UModal v-model="showReportModal">
      <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 max-w-lg w-full">
        <div class="text-center mb-6">
          <div class="mx-auto w-12 h-12 rounded-full bg-red-50 dark:bg-red-900/20 
                      flex items-center justify-center mb-4">
            <UIcon name="i-heroicons-flag" class="h-6 w-6 text-red-600" />
          </div>
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
            Signaler cet expert
          </h3>
          <p class="mt-2 text-gray-600 dark:text-gray-400">
            Veuillez sélectionner la raison du signalement
          </p>
        </div>

        <form @submit.prevent="handleReport" class="space-y-4">
          <!-- Raisons du signalement -->
          <div class="space-y-2">
            <label 
              v-for="reason in reportReasons" 
              :key="reason.value"
              class="flex items-center p-3 rounded-xl border border-gray-200 dark:border-gray-700
                     cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors"
            >
              <input
                type="radio"
                name="reportReason"
                :value="reason.value"
                v-model="selectedReason"
                class="w-4 h-4 text-primary-600 border-gray-300 focus:ring-primary-500"
              />
              <span class="ml-3 text-gray-900 dark:text-white">{{ reason.label }}</span>
            </label>
          </div>

          <!-- Description -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Description détaillée (optionnelle)
            </label>
            <textarea
              v-model="reportDescription"
              rows="3"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 dark:border-gray-700
                     bg-white dark:bg-gray-800 text-gray-900 dark:text-white
                     focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              placeholder="Décrivez le problème..."
            ></textarea>
          </div>

          <!-- Boutons d'action -->
          <div class="flex gap-3 mt-6">
            <button
              type="button"
              @click="showReportModal = false"
              class="flex-1 px-4 py-3 rounded-xl border border-gray-200 dark:border-gray-700
                     text-gray-700 dark:text-gray-300 font-medium
                     hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
            >
              Annuler
            </button>
            <button
              type="submit"
              :disabled="!selectedReason || isSubmitting"
              class="flex-1 px-4 py-3 rounded-xl bg-red-600 hover:bg-red-700
                     text-white font-medium transition-colors disabled:opacity-50"
            >
              {{ isSubmitting ? 'Envoi...' : 'Signaler' }}
            </button>
          </div>
        </form>
      </div>
    </UModal>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
// import { useToast } from 'vue-toastification'
// import { useSupabaseClient } from '#supabase/client'

const route = useRoute()
const router = useRouter()
const supabase = useSupabaseClient()
const expert = ref(null)
const isLoading = ref(true)

// Nouvelles propriétés pour les deals
const completedDeals = ref([])
const averageRating = computed(() => {
  if (!completedDeals.value.length) return 0
  const total = completedDeals.value.reduce((sum, deal) => 
    sum + (deal.expert_rating || 0), 0
  )
  return total / completedDeals.value.length
})

// États pour le signalement
const showReportModal = ref(false)
const selectedReason = ref('')
const reportDescription = ref('')
const isSubmitting = ref(false)

// Raisons de signalement
const reportReasons = [
  { value: 'fake_profile', label: 'Faux profil' },
  { value: 'inappropriate_behavior', label: 'Comportement inapproprié' },
  { value: 'scam', label: 'Tentative d\'arnaque' },
  { value: 'other', label: 'Autre raison' }
]

// Charger les données de l'expert
onMounted(async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select(`
        *,
        profession:professions(*),
        skills:user_skills(skill:skills(*)),
        deals!deals_expert_id_fkey (
          id,
          expert_rating,
          expert_review,
          status,
          created_at,
          client:client_id (
            id,
            first_name,
            last_name,
            avatar_url
          )
        )
      `)
      .eq('id', route.params.id)
      .single()

    if (error) throw error
    expert.value = data
    completedDeals.value = data.deals?.filter(deal => 
      deal.status === 'completed' && deal.expert_rating !== null
    ) || []
  } catch (error) {
    console.error('Erreur lors du chargement du profil:', error)
    expert.value = null
  } finally {
    isLoading.value = false
  }
})

// Helpers
const getInitials = (firstName, lastName) => {
  return `${firstName?.charAt(0) || ''}${lastName?.charAt(0) || ''}`.toUpperCase()
}

const getLocation = (expert) => {
  const parts = []
  if (expert.city?.trim()) parts.push(expert.city)
  if (expert.country?.trim()) parts.push(expert.country)
  return parts.length > 0 ? parts.join(', ') : null
}

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    month: 'long',
    year: 'numeric'
  })
}

const formatUrl = (url) => {
  if (!url) return ''
  return url.startsWith('http') ? url : `https://${url}`
}

const formatWebsiteDisplay = (url) => {
  if (!url) return ''
  return url.replace(/^https?:\/\//, '').replace(/\/$/, '')
}

const formatMemberDuration = (date) => {
  const months = Math.floor(
    (new Date() - new Date(date)) / (1000 * 60 * 60 * 24 * 30)
  )
  if (months < 1) return '< 1 mois'
  if (months < 12) return `${months} mois`
  const years = Math.floor(months / 12)
  return `${years} ${years === 1 ? 'an' : 'ans'}`
}

const handleContact = () => {
  // TODO: Implémenter la logique de contact
  console.log('Contact expert:', expert.value.id)
}

// Gestion du signalement
const handleReport = async () => {
  if (!selectedReason.value) return

  try {
    isSubmitting.value = true
    
    // Envoi du signalement
    const { error } = await supabase
      .from('reports')
      .insert({
        reported_user_id: expert.value.id,
        reason: selectedReason.value,
        description: reportDescription.value,
        status: 'pending'
      })

    if (error) throw error

    // Réinitialisation et fermeture
    showReportModal.value = false
    selectedReason.value = ''
    reportDescription.value = ''

    // Notification de succès
    const toast = useToast()
    toast.add({
      title: 'Signalement envoyé',
      description: 'Nous examinerons votre signalement dans les plus brefs délais.',
      color: 'green'
    })

  } catch (error) {
    console.error('Erreur lors du signalement:', error)
    const toast = useToast()
    toast.add({
      title: 'Erreur',
      description: 'Impossible d\'envoyer le signalement. Veuillez réessayer.',
      color: 'red'
    })
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
/* Animations douces style Apple */
.transition-all {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Ombre subtile style Apple */
.shadow-sm {
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
}

/* Animation du statut */
@keyframes ping {
  75%, 100% {
    transform: scale(2);
    opacity: 0;
  }
}
.animate-ping {
  animation: ping 1.5s cubic-bezier(0, 0, 0.2, 1) infinite;
}
</style>