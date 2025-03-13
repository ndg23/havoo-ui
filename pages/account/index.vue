<template>
  <div class="max-w-5xl mx-auto px-4 pt-5 pb-16">

    <!-- Actions principales -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
      <NuxtLink :to="isExpert ? '/requests' : '/requests/new'"
        class="bg-black dark:bg-gray-800 text-white dark:text-white font-bold rounded-xl p-4 flex items-center justify-between shadow-sm hover:shadow-md hover:bg-gray-800 dark:hover:bg-gray-700 transition-all duration-200">
        <div class="flex items-center">
          <div class="bg-white/20 p-2 rounded-full mr-3">
            <component :is="isExpert ? Search : Plus" class="h-5 w-5" />
          </div>
          <span>{{ isExpert ? 'Découvrir les missions' : 'Publier une demande' }}</span>
        </div>
        <ArrowRight class="h-5 w-5 transition-transform group-hover:translate-x-1" />
      </NuxtLink>
      
      <NuxtLink :to="isExpert ? '/account/proposals' : '/experts'"
        class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-900 dark:text-white font-bold rounded-xl p-4 flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors">
        <div class="flex items-center">
          <div class="bg-primary-50 dark:bg-primary-900/20 p-2 rounded-full mr-3">
            <component :is="isExpert ? ChartBar : Badge" class="h-5 w-5 text-primary-600 dark:text-primary-400" />
          </div>
          <span>{{ isExpert ? 'Voir mes statistiques' : 'Trouver un expert' }}</span>
        </div>
        <ArrowRight class="h-5 w-5 text-gray-400" />
      </NuxtLink>
    </div>

    <!-- Active Projects -->
    <div class="mb-6">
      <h2 class="text-base font-bold mb-3 px-1">Activités en cours</h2>

      <div v-if="activeProjects.length === 0"
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-5 text-center text-base text-gray-500 dark:text-gray-400">
        <p>Aucune activité en cours</p>
        <NuxtLink to="/requests"
          class="mt-3 text-blue-500 dark:text-blue-400 text-sm font-medium inline-flex items-center">
          Trouver une mission
          <ArrowRight class="h-4 w-4 ml-1" />
        </NuxtLink>
      </div>

      <div v-else class="space-y-3">
        <div v-for="project in activeProjects" :key="project.id"
          class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-4 flex justify-between items-center">
          <div>
            <h3 class="font-medium text-base">{{ project.title }}</h3>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ project.with }}</p>
          </div>
          <div class="flex items-center">
            <span class="px-3 py-1 rounded-full text-sm"
              :class="project.status === 'En cours' ? 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400' : 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400'">
              {{ project.status }}
            </span>
            <NuxtLink :to="project.link" class="ml-2 p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700">
              <ChevronRight class="h-5 w-5 text-gray-400" />
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useSupabaseUser } from '#imports'
import {
  Plus,
  Search,
  ChevronRight,
  ArrowRight,
  Badge,
  ChartBar
} from 'lucide-vue-next'

// Projets actifs
const activeProjects = ref([
  {
    id: 1,
    title: 'Développement site web',
    with: 'Marine Dupont',
    status: 'En cours',
    link: '/account/contracts/1'
  },
  {
    id: 2,
    title: 'Consultation SEO',
    with: 'Thomas Martin',
    status: 'En attente',
    link: '/account/proposals/2'
  }
])

// Calculer si l'utilisateur est un expert (récupéré depuis le store ou le parent)
const isExpert = computed(() => {
  // Dans un environnement réel, vous utiliseriez un store pour partager cet état
  return true // À adapter selon votre logique
})

definePageMeta({
  layout: 'account'
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
