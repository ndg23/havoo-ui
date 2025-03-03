<template>
  <div>
    <h1 class="text-2xl font-bold text-gray-900 mb-8">Paramètres</h1>

    <!-- Sections -->
    <div class="space-y-8">
      <!-- Sécurité -->
      <section class="bg-white rounded-2xl border border-gray-200 p-6">
        <h2 class="text-lg font-medium text-gray-900 mb-6">Sécurité</h2>
        
        <!-- Changer mot de passe -->
        <div class="space-y-4">
          <div class="relative">
            <input
              v-model="form.currentPassword"
              type="password"
              required
              class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-primary-500 focus:ring-0 focus:outline-none transition-colors"
              placeholder=" "
            />
            <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
              -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
              peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
              peer-focus:scale-85"
            >
              Mot de passe actuel
            </label>
          </div>

          <div class="relative">
            <input
              v-model="form.newPassword"
              type="password"
              required
              class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-primary-500 focus:ring-0 focus:outline-none transition-colors"
              placeholder=" "
            />
            <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
              -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
              peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
              peer-focus:scale-85"
            >
              Nouveau mot de passe
            </label>
          </div>

          <button 
            @click="updatePassword"
            class="w-full px-4 py-3 bg-primary-500 text-white font-medium rounded-xl hover:bg-primary-600 transition-colors"
          >
            Mettre à jour le mot de passe
          </button>
        </div>
      </section>

      <!-- Notifications -->
      <section class="bg-white rounded-2xl border border-gray-200 p-6">
        <h2 class="text-lg font-medium text-gray-900 mb-6">Notifications</h2>
        <div class="space-y-4">
          <div class="flex items-center justify-between">
            <div>
              <div class="font-medium">Notifications par email</div>
              <div class="text-sm text-gray-500">Recevoir des mises à jour par email</div>
            </div>
            <Switch
              v-model="notifications.email"
              class="relative inline-flex h-6 w-11 items-center rounded-full"
              :class="notifications.email ? 'bg-primary-500' : 'bg-gray-200'"
            >
              <span class="sr-only">Notifications par email</span>
              <span
                class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                :class="notifications.email ? 'translate-x-6' : 'translate-x-1'"
              />
            </Switch>
          </div>

          <div class="flex items-center justify-between">
            <div>
              <div class="font-medium">Notifications marketing</div>
              <div class="text-sm text-gray-500">Recevoir des offres et promotions</div>
            </div>
            <Switch
              v-model="notifications.marketing"
              class="relative inline-flex h-6 w-11 items-center rounded-full"
              :class="notifications.marketing ? 'bg-primary-500' : 'bg-gray-200'"
            >
              <span class="sr-only">Notifications marketing</span>
              <span
                class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                :class="notifications.marketing ? 'translate-x-6' : 'translate-x-1'"
              />
            </Switch>
          </div>
        </div>
      </section>

      <!-- Supprimer le compte -->
      <section class="bg-white rounded-2xl border border-gray-200 p-6">
        <h2 class="text-lg font-medium text-gray-900 mb-2">Supprimer le compte</h2>
        <p class="text-gray-500 text-sm mb-4">
          Cette action est irréversible et supprimera toutes vos données.
        </p>
        <button 
          @click="confirmDelete"
          class="px-4 py-2 text-sm font-medium text-red-600 hover:bg-red-50 rounded-xl transition-colors"
        >
          Supprimer mon compte
        </button>
      </section>
    </div>
  </div>
</template>

<script setup>
import { Switch } from '@headlessui/vue'

definePageMeta({
  layout: 'profile'
})

const form = ref({
  currentPassword: '',
  newPassword: ''
})

const notifications = ref({
  email: true,
  marketing: false
})

const updatePassword = async () => {
  // Logique de mise à jour du mot de passe
}

const confirmDelete = () => {
  // Logique de confirmation de suppression
}
</script> 