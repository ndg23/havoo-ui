<!-- pages/index.vue -->
<template>
  <div class="max-w-xl mx-auto px-4 py-8">
    <!-- Profile Header -->
    <div class="flex items-start gap-6 mb-8">
      <img 
        :src="profile?.avatar_url || defaultAvatar" 
        :alt="`Photo de profil de ${profile?.first_name || 'utilisateur'}`"
        class="h-24 w-24 rounded-full object-cover ring-2 ring-gray-100 dark:ring-gray-800"
      />
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
          {{ profile?.first_name }} {{ profile?.last_name }}
          </h1>
        <p class="text-gray-600 dark:text-gray-400 mt-1">
          {{ profile?.profession?.name }}
        </p>
        <div class="flex items-center gap-2 mt-3">
          <NuxtLink 
            to="/account/settings"
            class="text-sm font-medium px-4 py-1.5 rounded-full border border-[#FF5F40] text-[#FF5F40] hover:bg-[#FF5F40]/10 dark:border-[#FF5F40] dark:text-[#FF5F40] dark:hover:bg-[#FF5F40]/10 transition-colors"
          >
            Modifier le profil
          </NuxtLink>
          <button 
            class="text-sm font-medium px-4 py-1.5 rounded-full border border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
          >
            Partager
          </button>
        </div>
      </div>
                </div>
  <!-- Availability Status -->
  <div class="p-4 rounded-2xl bg-gray-50 dark:bg-gray-800 mb-8">
    <div class="flex items-center justify-between">
      <div>
        <h3 class="text-lg font-medium text-gray-900 dark:text-white">Statut de disponibilité</h3>
        <p class="text-sm text-gray-600 dark:text-gray-400 mt-1">
          Indiquez aux clients si vous êtes actuellement disponible pour des missions
        </p>
            </div>

      <div class="flex items-center gap-3">
        <span class="text-sm font-medium" :class="[
          profile?.availability_status === 'available' 
            ? 'text-green-600 dark:text-green-400'
            : 'text-gray-500 dark:text-gray-400'
        ]">
          {{ profile?.availability_status === 'available' ? 'Disponible' : 'Indisponible' }}
        </span>
        
        <button 
          type="button"
          role="switch"
          :aria-checked="profile?.availability_status === 'available'"
          @click="toggleAvailability"
          class="relative inline-flex h-8 w-14 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-primary-600 focus:ring-offset-2"
          :class="[
            profile?.availability_status === 'available' 
              ? 'bg-green-500 dark:bg-green-600' 
              : 'bg-gray-200 dark:bg-gray-600'
          ]"
        >
          <span 
            aria-hidden="true"
            class="pointer-events-none relative inline-block h-7 w-7 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
            :class="[
              profile?.availability_status === 'available' 
                ? 'translate-x-6' 
                : 'translate-x-0'
            ]"
          >
            <span
              class="absolute inset-0 flex h-full w-full items-center justify-center transition-opacity"
              :class="[
                profile?.availability_status === 'available' 
                  ? 'opacity-0 duration-100 ease-out' 
                  : 'opacity-100 duration-200 ease-in'
              ]"
            >
              <svg class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4" />
              </svg>
                </span>
            <span
              class="absolute inset-0 flex h-full w-full items-center justify-center transition-opacity"
              :class="[
                profile?.availability_status === 'available' 
                  ? 'opacity-100 duration-200 ease-in' 
                  : 'opacity-0 duration-100 ease-out'
              ]"
            >
              <svg class="h-4 w-4 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
                </span>
                </span>
        </button>
                  </div>
                </div>
              </div>
    <!-- Stats -->
    <div class="mb-8">
      <h2 class="text-lg font-semibold mb-4 text-gray-900 dark:text-white">Statistiques</h2>
      <div class="grid grid-cols-2 gap-4">
        <!-- Missions -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700">
          <div class="flex items-center justify-between mb-4">
            <div class="w-12 h-12 rounded-xl bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center">
              <UIcon name="i-heroicons-briefcase" class="w-6 h-6 text-blue-600 dark:text-blue-400" />
            </div>
          </div>
          <div>
            <h3 class="text-3xl font-bold text-gray-900 dark:text-white">
              {{ completedDeals.length }}
            </h3>
            <p class="text-sm font-medium text-gray-600 dark:text-gray-400 mt-1">
              Missions complétées
            </p>
        </div>
      </div>

        <!-- Note moyenne -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700">
          <div class="flex items-center justify-between mb-4">
            <div class="w-12 h-12 rounded-xl bg-amber-50 dark:bg-amber-900/20 flex items-center justify-center">
              <UIcon name="i-heroicons-star" class="w-6 h-6 text-amber-600 dark:text-amber-400" />
            </div>
              </div>
          <div>
            <div class="flex items-baseline gap-2">
              <h3 class="text-3xl font-bold text-gray-900 dark:text-white">
                {{ averageRating.toFixed(1) }}
              </h3>
              <span class="text-sm font-medium text-gray-500 dark:text-gray-400">/{{ MAX_RATING }}</span>
            </div>
            <p class="text-sm font-medium text-gray-600 dark:text-gray-400 mt-1">
              Note moyenne
            </p>
          </div>
        </div>

        <!-- Expérience -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700">
          <div class="flex items-center justify-between mb-4">
            <div class="w-12 h-12 rounded-xl bg-green-50 dark:bg-green-900/20 flex items-center justify-center">
              <UIcon name="i-heroicons-clock" class="w-6 h-6 text-green-600 dark:text-green-400" />
            </div>
          </div>
              <div>
            <h3 class="text-3xl font-bold text-gray-900 dark:text-white">
              {{ formatMemberDuration(profile?.created_at) }}
                </h3>
            <p class="text-sm font-medium text-gray-600 dark:text-gray-400 mt-1">
              d'expérience
                </p>
              </div>
        </div>

        <!-- Taux de satisfaction -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl p-6 border border-gray-100 dark:border-gray-700">
          <div class="flex items-center justify-between mb-4">
            <div class="w-12 h-12 rounded-xl bg-purple-50 dark:bg-purple-900/20 flex items-center justify-center">
              <UIcon name="i-heroicons-heart" class="w-6 h-6 text-purple-600 dark:text-purple-400" />
            </div>
          </div>
          <div>
            <h3 class="text-3xl font-bold text-gray-900 dark:text-white">
              {{ Math.round((completedDeals.filter(d => d.expert_rating >= 4).length / completedDeals.length) * 100) || 0 }}%
            </h3>
            <p class="text-sm font-medium text-gray-600 dark:text-gray-400 mt-1">
              Taux de satisfaction
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- Bio -->
    <div class="mb-8">
      <p class="text-gray-700 dark:text-gray-300 whitespace-pre-line">
        {{ profile?.bio || 'Aucune bio renseignée' }}
      </p>
      <div class="flex items-center gap-3 mt-4 text-sm text-gray-600 dark:text-gray-400">
        <span v-if="profile?.city" class="flex items-center gap-1">
          <IconMapPin class="w-4 h-4" />
          {{ profile.city }}
        </span>
        <span v-if="profile?.website" class="flex items-center gap-1">
          <IconLink class="w-4 h-4" />
          <a :href="profile.website" target="_blank" class="hover:underline">{{ profile.website }}</a>
        </span>
      </div>
    </div>

  

    <!-- Recent Activity -->
    <div>
      <h2 class="text-lg font-semibold mb-4 text-gray-900 dark:text-white">Activité récente</h2>
      <div class="space-y-4">
        <div v-if="!recentActivity?.length" class="text-center py-8 text-gray-500">
          Aucune activité récente
        </div>
        <div 
          v-for="activity in recentActivity" 
          :key="activity.id"
          class="p-4 rounded-2xl bg-gray-50 dark:bg-gray-800"
        >
          <div class="flex items-start justify-between">
            <div>
              <p class="font-medium text-gray-900 dark:text-white">{{ activity.title }}</p>
              <p class="text-sm text-gray-600 dark:text-gray-400">{{ activity.description }}</p>
            </div>
            <span class="text-sm text-gray-500">{{ activity.date }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { useCustomToast } from '~/composables/useCustomToast'
import { useDefaultAvatar } from '~/composables/useDefaultAvatar'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const profile = ref(null)
const completedDeals = ref([])
const MAX_RATING = 5

const averageRating = computed(() => {
  if (!completedDeals.value.length) return 0
  const total = completedDeals.value.reduce((sum, deal) => 
    sum + Math.min(deal.expert_rating || 0, MAX_RATING), 0
  )
  return total / completedDeals.value.length
})
const recentActivity = ref([])

// Initialiser useCustomToast
const { showToast } = useCustomToast()

// Avatar par défaut en base64
const { defaultAvatar } = useDefaultAvatar()

const toggleAvailability = async () => {
  try {
    const newStatus = profile.value.availability_status === 'available' ? 'unavailable' : 'available'
    
    const { error } = await supabase
      .from('profiles')
      .update({ 
        availability_status: newStatus,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value.id)

    if (error) throw error
    
    profile.value.availability_status = newStatus
    showToast.success(`Statut mis à jour : ${newStatus === 'available' ? 'Disponible' : 'Indisponible'}`)
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors de la mise à jour du statut')
  }
}

const fetchProfile = async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select(`
        *,
        profession:profession_id (name),
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
      .eq('id', user.value.id)
      .single()

    if (error) throw error

    if (data) {
      profile.value = data
      completedDeals.value = data.deals?.filter(deal => 
        deal.status === 'completed' && deal.expert_rating !== null
      ) || []
    }
  } catch (error) {
    console.error('Erreur:', error)
    showToast.error('Erreur lors du chargement du profil')
  }
}

// Ajouter la fonction formatMemberDuration
const formatMemberDuration = (date) => {
  if (!date) return '0 mois'
  const months = Math.floor(
    (new Date() - new Date(date)) / (1000 * 60 * 60 * 24 * 30)
  )
  if (months < 1) return '< 1 mois'
  if (months < 12) return `${months} mois`
  const years = Math.floor(months / 12)
  return `${years} ${years === 1 ? 'an' : 'ans'}`
}

onMounted(async () => {
  if (user.value) {
    await fetchProfile()
  } else {
    showToast.error('Veuillez vous connecter pour accéder à votre profil')
    router.push('/auth/login')
  }
})

definePageMeta({
  layout: 'account',
  middleware: 'auth'
})
</script>

<style scoped>
/* Transitions douces style Twitter 2021 */
.transition-all {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Ombre subtile style Twitter 2021 */
.shadow-sm {
  box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05), 0 1px 3px 0 rgb(0 0 0 / 0.1);
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

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: .5;
  }
}

/* Nouvelles animations style Twitter 2021 */
@keyframes slideUp {
  from {
    transform: translateY(10px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.animate-slide-up {
  animation: slideUp 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Effet de survol style Twitter 2021 */
.hover-lift {
  transition: transform 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.hover-lift:hover {
  transform: translateY(-2px);
}

/* Effet de focus style Twitter 2021 */
.focus-ring {
  @apply focus:outline-none focus:ring-2 focus:ring-[#FF5F40] focus:ring-offset-2 dark:focus:ring-offset-gray-900;
}

/* Effet de glassmorphism style Twitter 2021 */
.glass-effect {
  @apply bg-white/80 dark:bg-gray-900/80 backdrop-blur-xl;
}

/* Effet de gradient style Twitter 2021 */
.gradient-border {
  position: relative;
}

.gradient-border::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 1px;
  background: linear-gradient(to right, #FF5F40, #FF8A70);
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
}

/* Add new color utility classes */
.text-primary {
  @apply text-[#FF5F40] dark:text-[#FF5F40];
}

.bg-primary {
  @apply bg-[#FF5F40] dark:bg-[#FF5F40];
}

.hover-primary {
  @apply hover:text-[#FF5F40] dark:hover:text-[#FF5F40];
}

.border-primary {
  @apply border-[#FF5F40] dark:border-[#FF5F40];
}
</style>