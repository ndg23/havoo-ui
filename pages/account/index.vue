<!-- pages/index.vue -->
<template>
  <div class="max-w-xl mx-auto px-4 py-8">
    <!-- Profile Header -->
    <div class="flex items-start gap-6 mb-8">
      <img 
        :src="profile?.avatar_url || '/default-avatar.png'" 
        class="h-24 w-24 rounded-full object-cover ring-2 ring-gray-100 dark:ring-gray-800"
        alt="Photo de profil"
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

    <!-- Stats -->
    <div class="grid grid-cols-3 gap-4 mb-8">
      <div class="text-center p-4 rounded-2xl bg-gray-50 dark:bg-gray-800">
        <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ profile?.completed_missions || 0 }}</p>
        <p class="text-sm text-gray-600 dark:text-gray-400">Missions</p>
      </div>
      <div class="text-center p-4 rounded-2xl bg-gray-50 dark:bg-gray-800">
        <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ profile?.hourly_rate || 0 }}€</p>
        <p class="text-sm text-gray-600 dark:text-gray-400">Tarif/h</p>
      </div>
      <div class="text-center p-4 rounded-2xl bg-gray-50 dark:bg-gray-800">
        <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ profile?.rating || '4.8' }}</p>
        <p class="text-sm text-gray-600 dark:text-gray-400">Note</p>
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

    <!-- Availability Status -->
    <div class="p-4 rounded-2xl bg-gray-50 dark:bg-gray-800 mb-8">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-2">
          <div class="w-3 h-3 rounded-full" 
            :class="profile?.availability_status === 'available' ? 'bg-[#FF5F40]' : 'bg-gray-400'"
          />
          <span class="text-sm font-medium text-gray-900 dark:text-white">
            {{ profile?.availability_status === 'available' ? 'Disponible' : 'Non disponible' }}
          </span>
        </div>
        <button 
          @click="toggleAvailability"
          class="text-sm text-[#FF5F40] hover:text-[#FF5F40]/80 dark:text-[#FF5F40] dark:hover:text-[#FF5F40]/80 hover:underline"
        >
          Modifier
        </button>
      </div>
    </div>

    <!-- Skills -->
    <div class="mb-8">
      <h2 class="text-lg font-semibold mb-4 text-gray-900 dark:text-white">Compétences</h2>
      <div class="flex flex-wrap gap-2">
        <span 
          v-for="skill in profile?.skills" 
          :key="skill.id"
          class="px-3 py-1 text-sm rounded-full bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300"
        >
          {{ skill.name }}
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
import { ref, onMounted } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const profile = ref(null)
const recentActivity = ref([])

onMounted(async () => {
  if (user.value) {
    await fetchProfile()
    await fetchRecentActivity()
  }
})

const fetchProfile = async () => {
  const { data } = await supabase
    .from('profiles')
    .select(`
      *,
      profession:profession_id (name),
      skills:user_skills (
        skill:skill_id (id, name)
      )
    `)
    .eq('id', user.value.id)
    .single()

  if (data) {
    profile.value = {
      ...data,
      skills: data.skills.map(s => s.skill)
    }
  }
}

const fetchRecentActivity = async () => {
  // Mock data for now
  recentActivity.value = []
}

const toggleAvailability = async () => {
  const newStatus = profile.value.availability_status === 'available' ? 'unavailable' : 'available'
  
  const { error } = await supabase
    .from('profiles')
    .update({ availability_status: newStatus })
    .eq('id', user.value.id)

  if (!error) {
    profile.value.availability_status = newStatus
  }
}
definePageMeta({
  layout: 'account'
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