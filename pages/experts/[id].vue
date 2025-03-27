// pages/experts/_id.vue
<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- Loading state -->
    <div v-if="isLoading" class="animate-pulse">
      <div class="h-48 bg-white dark:bg-gray-800"></div>
    </div>

    <template v-else-if="expert">
      <!-- Header avec photo de profil -->
      <div class="bg-white dark:bg-gray-800">
        <div class="max-w-2xl mx-auto px-4 pt-8 pb-6">
          <!-- Avatar et badges -->
          <div class="flex flex-col items-center mb-6">
            <div class="relative mb-4">
              <div 
                v-if="expert.avatar_url"
                class="w-24 h-24 rounded-full bg-cover bg-center ring-4 ring-white dark:ring-gray-800 shadow-lg"
                :style="{ backgroundImage: `url(${expert.avatar_url})` }"
              ></div>
              <div 
                v-else
                class="w-24 h-24 rounded-full bg-primary-50 dark:bg-primary-900/20 flex items-center justify-center text-primary-600 dark:text-primary-400 text-3xl font-bold ring-4 ring-white dark:ring-gray-800"
              >
                {{ getInitials(expert.first_name, expert.last_name) }}
              </div>
              <!-- Badge vérifié -->
              <div 
                v-if="expert.is_verified"
                class="absolute bottom-0 right-0 bg-primary-500 text-white p-1.5 rounded-full shadow-lg"
              >
                <v-icon name="bi-patch-check-fill" scale="1.2" />
              </div>
            </div>

            <!-- Nom et profession -->
            <h1 class="text-xl font-bold text-gray-900 dark:text-white text-center">
              {{ expert.first_name }} {{ expert.last_name }}
            </h1>
            <div 
              v-if="expert.profession?.name" 
              class="mt-1 text-gray-600 dark:text-gray-400"
            >
              {{ expert.profession.name }}
            </div>

            <!-- Statut de disponibilité -->
            <div 
              class="mt-3 inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-sm font-medium"
              :class="{
                'bg-green-50 dark:bg-green-900/20 text-green-600': expert.availability_status === 'available',
                'bg-red-50 dark:bg-red-900/20 text-red-600': expert.availability_status !== 'available'
              }"
            >
              <v-icon 
                :name="expert.availability_status === 'available' ? 'bi-circle-fill' : 'bi-dash-circle-fill'" 
                scale="0.9"
              />
              {{ expert.availability_status === 'available' ? 'Disponible' : 'Occupé' }}
            </div>
          </div>

          <!-- Stats rapides -->
          <div class="grid grid-cols-2 gap-4 mt-6">
            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-4 text-center">
              <div class="text-2xl font-bold text-primary-600 dark:text-primary-400">
                {{ expert.profile_completion_percentage }}%
              </div>
              <div class="text-sm text-gray-600 dark:text-gray-400 mt-1">
                Profil complété
              </div>
            </div>
            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-4 text-center">
              <div class="text-2xl font-bold text-primary-600 dark:text-primary-400">
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
      <div class="max-w-2xl mx-auto px-4 py-6 space-y-6">
        <!-- À propos -->
        <div class="bg-white dark:bg-gray-800 rounded-xl p-6">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
            <v-icon name="bi-person" />
            À propos
          </h2>
          <p 
            v-if="expert.bio?.trim()"
            class="text-gray-600 dark:text-gray-300 whitespace-pre-line"
          >
            {{ expert.bio }}
          </p>
          <p v-else class="text-gray-400 dark:text-gray-500 italic">
            Aucune biographie disponible
          </p>
        </div>

        <!-- Compétences -->
        <div class="bg-white dark:bg-gray-800 rounded-xl p-6">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
            <v-icon name="bi-lightning" />
            Compétences
          </h2>
          <div 
            v-if="expert.skills?.length"
            class="flex flex-wrap gap-2"
          >
            <span 
              v-for="skill in expert.skills" 
              :key="skill.id"
              class="px-3 py-1.5 rounded-full bg-primary-50 dark:bg-primary-900/20 text-primary-600 dark:text-primary-400 text-sm font-medium"
            >
              {{ skill.name }}
            </span>
          </div>
          <p v-else class="text-gray-400 dark:text-gray-500 italic">
            Aucune compétence renseignée
          </p>
        </div>

        <!-- Informations de contact -->
        <div class="bg-white dark:bg-gray-800 rounded-xl p-6">
          <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
            <v-icon name="bi-envelope" />
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
          class="w-full inline-flex items-center justify-center px-4 py-3 rounded-xl bg-primary-600 hover:bg-primary-700 text-white font-medium transition-all shadow-sm"
          @click="handleContact"
        >
          <v-icon name="bi-chat-dots" class="mr-2" />
          Contacter
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
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
// import { useSupabaseClient } from '#supabase/client'

const route = useRoute()
const router = useRouter()
const supabase = useSupabaseClient()
const expert = ref(null)
const isLoading = ref(true)

// Charger les données de l'expert
onMounted(async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select(`
        *,
        profession:professions(*),
        skills:user_skills(skill:skills(*))
      `)
      .eq('id', route.params.id)
      .single()

    if (error) throw error
    expert.value = data
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
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Twitter-style subtle shadows */
.shadow-xs {
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

/* Enhanced Twitter-style animations */
.transition-colors {
  transition-property: background-color, border-color, color, fill, stroke;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}

.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}
</style>