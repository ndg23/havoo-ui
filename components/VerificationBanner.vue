<template>
  <div class="relative overflow-hidden mb-6">
    <!-- Bannière de vérification -->
    <div 
      class="bg-gradient-to-r from-amber-50 to-amber-100 dark:from-amber-900/20 dark:to-amber-800/20 
      border border-amber-200 dark:border-amber-800 rounded-lg shadow-sm p-4 flex items-start"
    >
      <!-- Icône -->
      <div class="flex-shrink-0 mt-0.5">
        <ShieldAlert class="h-6 w-6 text-amber-500 dark:text-amber-400" />
      </div>
      
      <!-- Contenu -->
      <div class="ml-3 flex-1">
        <div class="flex items-center justify-between flex-wrap gap-2">
          <h3 class="text-sm font-medium text-amber-800 dark:text-amber-300">
            Votre compte n'est pas encore vérifié
          </h3>
          <div>
            <button 
              @click="startVerification"
              class="inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded-full 
              bg-amber-100 dark:bg-amber-800 text-amber-700 dark:text-amber-200 
              hover:bg-amber-200 dark:hover:bg-amber-700 focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-amber-500"
            >
              Vérifier maintenant
              <ArrowRight class="ml-1 h-3.5 w-3.5" />
            </button>
          </div>
        </div>
        <div class="mt-2 text-sm text-amber-700 dark:text-amber-300">
          <p>
            La vérification de votre identité augmente votre crédibilité auprès des autres utilisateurs et débloque des fonctionnalités supplémentaires.
            <strong class="font-medium">Seule votre Carte Nationale d'Identité est nécessaire.</strong>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ShieldAlert, ArrowRight } from 'lucide-vue-next'
import { useRouter } from 'vue-router'

const router = useRouter()
const emit = defineEmits(['verification-started'])

const startVerification = () => {
  emit('verification-started')
  router.push('/profile/verification')
}
</script> 