<template>
  <div>
    <!-- Profile Header -->
    <div class="bg-white rounded-2xl border border-gray-200 overflow-hidden">
      <div class="p-6">
        <div class="flex items-center gap-6">
          <div class="relative">
            <img 
              :src="user?.avatar || '/images/default-avatar.png'"
              class="w-24 h-24 rounded-xl object-cover"
            />
            <button 
              class="absolute -bottom-2 -right-2 p-2 bg-white rounded-full border border-gray-200 text-gray-500 hover:text-primary-500"
            >
              <PencilIcon class="w-4 h-4" />
            </button>
          </div>
          <div>
            <h1 class="text-2xl font-bold text-gray-900 mb-1">
              {{ user?.user_metadata?.full_name || 'Utilisateur' }}
            </h1>
            <p class="text-gray-500">{{ user?.email }}</p>
          </div>
        </div>
      </div>
      
      <div class="border-t border-gray-200 px-6 py-4">
        <div class="flex gap-6">
          <div>
            <div class="text-sm text-gray-500">Membre depuis</div>
            <div class="font-medium">{{ formatDate(user?.created_at) }}</div>
          </div>
          <div>
            <div class="text-sm text-gray-500">Demandes publiées</div>
            <div class="font-medium">{{ requestsCount }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Profile Sections -->
    <div class="mt-8 space-y-8">
      <!-- Informations personnelles -->
      <section class="bg-white rounded-2xl border border-gray-200 p-6">
        <div class="flex items-center justify-between mb-6">
          <h2 class="text-lg font-medium text-gray-900">
            Informations personnelles
          </h2>
          <button class="text-primary-600 hover:text-primary-700 text-sm font-medium">
            Modifier
          </button>
        </div>

        <div class="grid sm:grid-cols-2 gap-6">
          <div>
            <div class="text-sm text-gray-500 mb-1">Prénom</div>
            <div class="font-medium">{{ user?.user_metadata?.first_name || '-' }}</div>
          </div>
          <div>
            <div class="text-sm text-gray-500 mb-1">Nom</div>
            <div class="font-medium">{{ user?.user_metadata?.last_name || '-' }}</div>
          </div>
          <div>
            <div class="text-sm text-gray-500 mb-1">Téléphone</div>
            <div class="font-medium">{{ user?.user_metadata?.phone || '-' }}</div>
          </div>
          <div>
            <div class="text-sm text-gray-500 mb-1">Adresse</div>
            <div class="font-medium">{{ user?.user_metadata?.address || '-' }}</div>
          </div>
        </div>
      </section>

      <!-- Préférences -->
      <section class="bg-white rounded-2xl border border-gray-200 p-6">
        <h2 class="text-lg font-medium text-gray-900 mb-6">
          Préférences de notification
        </h2>
        <div class="space-y-4">
          <div class="flex items-center justify-between">
            <div>
              <div class="font-medium">Notifications par email</div>
              <div class="text-sm text-gray-500">Recevoir des mises à jour par email</div>
            </div>
            <Switch
              v-model="preferences.email"
              class="relative inline-flex h-6 w-11 items-center rounded-full"
              :class="preferences.email ? 'bg-primary-500' : 'bg-gray-200'"
            >
              <span class="sr-only">Notifications par email</span>
              <span
                class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                :class="preferences.email ? 'translate-x-6' : 'translate-x-1'"
              />
            </Switch>
          </div>
          <div class="flex items-center justify-between">
            <div>
              <div class="font-medium">Notifications push</div>
              <div class="text-sm text-gray-500">Recevoir des notifications sur le site</div>
            </div>
            <Switch
              v-model="preferences.push"
              class="relative inline-flex h-6 w-11 items-center rounded-full"
              :class="preferences.push ? 'bg-primary-500' : 'bg-gray-200'"
            >
              <span class="sr-only">Notifications push</span>
              <span
                class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                :class="preferences.push ? 'translate-x-6' : 'translate-x-1'"
              />
            </Switch>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { Switch } from '@headlessui/vue'
import { PencilIcon } from '@heroicons/vue/24/outline'

const user = useSupabaseUser()
const requestsCount = ref(0)

const preferences = ref({
  email: true,
  push: true
})

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

// Définir le layout
definePageMeta({
  layout: 'profile'
})
</script> 