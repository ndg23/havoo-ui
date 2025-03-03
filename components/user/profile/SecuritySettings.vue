<template>
  <div class="space-y-8">
    <div>
      <h2 class="text-2xl font-semibold text-gray-900">Sécurité</h2>
      <p class="mt-1 text-sm text-gray-500">Gérez la sécurité de votre compte.</p>
    </div>

    <!-- Changement de mot de passe -->
    <div class="bg-gray-50 rounded-xl p-6">
      <h3 class="text-lg font-medium text-gray-900">Changer le mot de passe</h3>
      <form @submit.prevent="handlePasswordChange" class="mt-4 space-y-4">
        <div>
          <label class="block text-sm font-medium text-gray-700">Mot de passe actuel</label>
          <input
            v-model="passwordForm.current"
            type="password"
            class="mt-1 block w-full rounded-xl border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Nouveau mot de passe</label>
          <input
            v-model="passwordForm.new"
            type="password"
            class="mt-1 block w-full rounded-xl border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Confirmer le nouveau mot de passe</label>
          <input
            v-model="passwordForm.confirm"
            type="password"
            class="mt-1 block w-full rounded-xl border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <button
          type="submit"
          class="inline-flex justify-center px-4 py-2 border border-transparent rounded-xl text-sm font-medium 
                 text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 
                 focus:ring-offset-2 focus:ring-blue-500"
        >
          Mettre à jour le mot de passe
        </button>
      </form>
    </div>

    <!-- Double authentification -->
    <div class="bg-gray-50 rounded-xl p-6">
      <div class="flex items-center justify-between">
        <div>
          <h3 class="text-lg font-medium text-gray-900">Double authentification</h3>
          <p class="mt-1 text-sm text-gray-500">
            Ajoutez une couche de sécurité supplémentaire à votre compte.
          </p>
        </div>
        <button
          @click="toggleTwoFactor"
          class="relative inline-flex flex-shrink-0 h-6 w-11 border-2 border-transparent rounded-full 
                 cursor-pointer transition-colors ease-in-out duration-200 focus:outline-none focus:ring-2 
                 focus:ring-offset-2 focus:ring-blue-500"
          :class="[twoFactorEnabled ? 'bg-blue-600' : 'bg-gray-200']"
        >
          <span
            class="pointer-events-none inline-block h-5 w-5 rounded-full bg-white shadow transform ring-0 
                   transition ease-in-out duration-200"
            :class="[twoFactorEnabled ? 'translate-x-5' : 'translate-x-0']"
          />
        </button>
      </div>
    </div>

    <!-- Sessions actives -->
    <div class="bg-gray-50 rounded-xl p-6">
      <h3 class="text-lg font-medium text-gray-900">Sessions actives</h3>
      <div class="mt-4 space-y-4">
        <div v-for="session in activeSessions" :key="session.id" 
             class="flex items-center justify-between py-4 border-t border-gray-200 first:border-0">
          <div class="flex items-center">
            <component :is="session.device === 'mobile' ? DevicePhoneMobileIcon : ComputerDesktopIcon" 
                      class="w-5 h-5 text-gray-400" />
            <div class="ml-3">
              <p class="text-sm font-medium text-gray-900">{{ session.location }}</p>
              <p class="text-xs text-gray-500">{{ session.lastActive }}</p>
            </div>
          </div>
          <button
            @click="terminateSession(session.id)"
            class="text-sm text-red-600 hover:text-red-700"
          >
            Déconnecter
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { DevicePhoneMobileIcon, ComputerDesktopIcon } from '@heroicons/vue/24/outline'

const passwordForm = ref({
  current: '',
  new: '',
  confirm: ''
})

const twoFactorEnabled = ref(false)
const activeSessions = ref([
  {
    id: 1,
    device: 'desktop',
    location: 'Paris, France',
    lastActive: 'Dernière activité il y a 2 minutes'
  },
  {
    id: 2,
    device: 'mobile',
    location: 'Lyon, France',
    lastActive: 'Dernière activité il y a 1 heure'
  }
])

const handlePasswordChange = () => {
  // Logique de changement de mot de passe
}

const toggleTwoFactor = () => {
  twoFactorEnabled.value = !twoFactorEnabled.value
}

const terminateSession = (sessionId) => {
  // Logique de déconnexion de session
}
</script> 