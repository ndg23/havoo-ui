<template>
  <div class="max-w-5xl mx-auto px-4 pt-5 pb-16">
    <!-- Profile Header -->
    <div class="mb-6 bg-white dark:bg-gray-800 rounded-xl overflow-hidden border border-gray-200 dark:border-gray-700">
      <div class="h-32 bg-gray-100 dark:bg-gray-700 relative">
        <div v-if="!isProfileConfirmed"
          class="absolute top-0 left-0 right-0 bg-red-500 dark:bg-red-600 py-2 px-4 text-white text-sm font-medium flex items-center justify-center gap-2">
          <AlertTriangle class="w-4 h-4" />
          <span>Profil non vérifié</span>
          <NuxtLink to="/account/verification"
            class="ml-2 bg-white text-red-600 px-3 py-1 rounded-full text-xs font-bold hover:bg-red-50">
            Vérifier maintenant
          </NuxtLink>
        </div>
      </div>
      <div class="p-5">
        <div class="flex justify-between items-start">
          <div class="relative -mt-16">
            <img :src="profile?.avatar_url || '/img/default-avatar.png'"
              class="w-24 h-24 rounded-full border-4 border-white dark:border-gray-800 object-cover"
              alt="Photo de profil" />
            <div class="absolute bottom-0 right-0 w-6 h-6 rounded-full border-2 border-white dark:border-gray-800"
              :class="availability ? 'bg-green-500' : 'bg-gray-400'"></div>
          </div>
          <button @click="toggleExpertMode" class="px-4 py-2 rounded-full text-sm font-bold border"
            :class="isExpert ? 'bg-primary-50 text-primary-600 border-primary-200 dark:bg-primary-900/20 dark:border-primary-800 dark:text-primary-400' : 'border-gray-200 dark:border-gray-700'">
            {{ isExpert ? 'Mode Expert' : 'Mode Client' }}
          </button>
        </div>

        <div class="mt-3">
          <h1 class="text-xl font-bold">{{ profile?.first_name }} {{ profile?.last_name }}</h1>
          <div class="flex items-center gap-2 mt-2 text-sm text-gray-500 dark:text-gray-400">
            <span>{{ availability ? 'En ligne' : 'Hors ligne' }}</span>
            <Switch v-model="availability" @change="updateAvailability" class="ml-1" />
          </div>
        </div>
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-3 gap-3 mb-6">
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 text-center">
        <div class="text-xl font-bold">{{ stats.completed || 0 }}</div>
        <div class="text-sm text-gray-500 dark:text-gray-400">Missions</div>
      </div>
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 text-center">
        <div class="flex items-center justify-center">
          <span class="text-xl font-bold">{{ stats.rating || '-' }}</span>
          <Star v-if="stats.rating" class="h-5 w-5 ml-1 text-amber-400 fill-amber-400" />
        </div>
        <div class="text-sm text-gray-500 dark:text-gray-400">Note</div>
      </div>
      <div class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-200 dark:border-gray-700 text-center">
        <div class="text-xl font-bold">{{ isExpert ? stats.earnings || 0 : stats.spent || 0 }}€</div>
        <div class="text-sm text-gray-500 dark:text-gray-400">{{ isExpert ? 'Revenus' : 'Budget' }}</div>
      </div>
    </div>

    <!-- Menu horizontal style Twitter 2023 -->
    <div class="mb-8">
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden">
        <div class="overflow-x-auto py-1 px-2">
          <div class="flex whitespace-nowrap min-w-full">
            <NuxtLink to="/account/requests" 
              class="flex flex-col items-center p-3 hover:bg-gray-50 dark:hover:bg-gray-750 rounded-xl mx-1 transition-colors">
              <div class="bg-blue-50 dark:bg-blue-900/20 p-3 rounded-full mb-2">
                <Briefcase class="h-6 w-6 text-blue-600 dark:text-blue-400" />
              </div>
              <span class="font-medium text-sm">Demandes</span>
            </NuxtLink>
            
            <NuxtLink to="/account/contracts" 
              class="flex flex-col items-center p-3 hover:bg-gray-50 dark:hover:bg-gray-750 rounded-xl mx-1 transition-colors">
              <div class="bg-green-50 dark:bg-green-900/20 p-3 rounded-full mb-2 relative">
                <FileCheck class="h-6 w-6 text-green-600 dark:text-green-400" />
                <span v-if="stats.activeContracts > 0" 
                  class="absolute -top-1 -right-1 bg-primary-600 text-white text-xs font-bold w-5 h-5 rounded-full flex items-center justify-center">
                  {{ stats.activeContracts }}
                </span>
              </div>
              <span class="font-medium text-sm">Contrats</span>
            </NuxtLink>
            
            <NuxtLink v-if="isExpert" to="/account/proposals" 
              class="flex flex-col items-center p-3 hover:bg-gray-50 dark:hover:bg-gray-750 rounded-xl mx-1 transition-colors">
              <div class="bg-amber-50 dark:bg-amber-900/20 p-3 rounded-full mb-2">
                <SendHorizonal class="h-6 w-6 text-amber-600 dark:text-amber-400" />
              </div>
              <span class="font-medium text-sm">Propositions</span>
            </NuxtLink>
            
            <NuxtLink v-if="isExpert" to="/account/services" 
              class="flex flex-col items-center p-3 hover:bg-gray-50 dark:hover:bg-gray-750 rounded-xl mx-1 transition-colors">
              <div class="bg-purple-50 dark:bg-purple-900/20 p-3 rounded-full mb-2">
                <Package class="h-6 w-6 text-purple-600 dark:text-purple-400" />
              </div>
              <span class="font-medium text-sm">Services</span>
            </NuxtLink>
            
            <NuxtLink to="/messages" 
              class="flex flex-col items-center p-3 hover:bg-gray-50 dark:hover:bg-gray-750 rounded-xl mx-1 transition-colors">
              <div class="bg-pink-50 dark:bg-pink-900/20 p-3 rounded-full mb-2 relative">
                <MessageCircle class="h-6 w-6 text-pink-600 dark:text-pink-400" />
                <span v-if="unreadMessages > 0" 
                  class="absolute -top-1 -right-1 bg-red-500 text-white text-xs font-bold w-5 h-5 rounded-full flex items-center justify-center">
                  {{ unreadMessages }}
                </span>
              </div>
              <span class="font-medium text-sm">Messages</span>
            </NuxtLink>
            
            <NuxtLink to="/account/settings" 
              class="flex flex-col items-center p-3 hover:bg-gray-50 dark:hover:bg-gray-750 rounded-xl mx-1 transition-colors">
              <div class="bg-gray-100 dark:bg-gray-700 p-3 rounded-full mb-2">
                <Settings class="h-6 w-6 text-gray-600 dark:text-gray-400" />
              </div>
              <span class="font-medium text-sm">Paramètres</span>
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>

    <!-- Slot pour le contenu spécifique à chaque page -->
    <slot />

  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import {
  Star,
  AlertTriangle,
  Briefcase,
  FileCheck,
  MessageCircle,
  Settings,
  SendHorizonal,
  Package
} from 'lucide-vue-next'
import Switch from '~/components/ui/Switch.vue'

// États essentiels
const profile = ref(null)
const user = useSupabaseUser()
const supabase = useSupabaseClient()
const availability = ref(true)
const unreadMessages = ref(2)
const isProfileConfirmed = ref(false)

// Stats simplifiées
const stats = ref({
  completed: 14,
  rating: 4.8,
  earnings: 380,
  spent: 250,
  openRequests: 8,
  activeContracts: 2
})

// Calculer si l'utilisateur est un expert
const isExpert = computed(() => {
  return profile.value?.is_expert || false
})

// Méthodes
const fetchProfile = async () => {
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()

    if (error) throw error
    profile.value = data
    availability.value = data.is_available !== false
  } catch (error) {
    console.error('Erreur lors du chargement du profil:', error)
  }
}

const updateAvailability = async () => {
  try {
    const { error } = await supabase
      .from('profiles')
      .update({ is_available: availability.value })
      .eq('id', user.value.id)

    if (error) throw error
  } catch (error) {
    console.error('Erreur lors de la mise à jour de la disponibilité:', error)
  }
}

const toggleExpertMode = () => {
  // Basculer entre les modes
  profile.value.is_expert = !profile.value.is_expert
}

// Initialisation
onMounted(() => {
  fetchProfile()
})
</script>

<style scoped>
.rounded-xl {
  border-radius: 1rem;
}

/* Effet de survol pour les menus */
a:hover svg {
  transform: scale(1.05);
  transition: transform 0.2s ease;
}

/* Permettre le défilement sur mobile */
.overflow-x-auto {
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none; /* Firefox */
}

.overflow-x-auto::-webkit-scrollbar {
  display: none; /* Chrome, Safari */
}
</style>