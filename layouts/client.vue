<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <div class="flex max-w-7xl mx-auto">
      <!-- Sidebar -->
      <aside class="fixed w-[75px] sm:w-[240px] h-screen py-2 z-40">
        <div class="h-full bg-white dark:bg-gray-900 rounded-xl">
          <!-- Logo -->
          <div class="p-4">
            <NuxtLink to="/client" class="inline-flex">
              <span class="hidden sm:block text-2xl font-bold text-primary-600">HAVOO</span>
              <span class="sm:hidden text-2xl font-bold text-primary-600">H</span>
            </NuxtLink>
          </div>

          <!-- Navigation principale -->
          <nav class="px-2">
            <div class="space-y-1">
              <NuxtLink 
                to="/client" 
                class="flex items-center justify-center sm:justify-start gap-4 p-3 text-xl text-gray-900 dark:text-white rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
              >
                <UIcon name="i-heroicons-home" class="w-7 h-7" />
                <span class="hidden sm:block">Accueil</span>
              </NuxtLink>
              
              <NuxtLink 
                to="/client/missions" 
                class="flex items-center justify-center sm:justify-start gap-4 p-3 text-xl text-gray-900 dark:text-white rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
              >
                <UIcon name="i-heroicons-briefcase" class="w-7 h-7" />
                <span class="hidden sm:block">Missions</span>
              </NuxtLink>

              <NuxtLink 
                to="/client/experts" 
                class="flex items-center justify-center sm:justify-start gap-4 p-3 text-xl text-gray-900 dark:text-white rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
              >
                <UIcon name="i-heroicons-users" class="w-7 h-7" />
                <span class="hidden sm:block">Experts</span>
              </NuxtLink>

              <NuxtLink 
                to="/client/messages" 
                class="flex items-center justify-center sm:justify-start gap-4 p-3 text-xl text-gray-900 dark:text-white rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
              >
                <UIcon name="i-heroicons-chat-bubble-left-right" class="w-7 h-7" />
                <span class="hidden sm:block">Messages</span>
              </NuxtLink>
            </div>

            <!-- Bouton publier -->
            <div class="px-3 mt-4">
              <UButton
                to="/client/missions/new"
                color="primary"
                size="xl"
                class="w-full justify-center rounded-full"
              >
                <UIcon name="i-heroicons-plus" class="w-6 h-6 sm:hidden" />
                <span class="hidden sm:block">Publier une mission</span>
              </UButton>
            </div>
          </nav>

          <!-- Profil et paiements -->
          <div class="absolute bottom-4 left-0 right-0 px-4">
            <!-- Solde Wave -->
            <div class="hidden sm:block mb-4 p-3 bg-gray-50 dark:bg-gray-800 rounded-2xl">
              <div class="flex items-center gap-3 mb-2">
                <img src="/icons/wave.svg" alt="Wave" class="w-6 h-6" />
                <span class="text-sm font-medium">Solde Wave</span>
              </div>
              <p class="text-2xl font-bold text-gray-900 dark:text-white">45 000 FCFA</p>
            </div>

            <!-- Menu utilisateur -->
            <UDropdown :items="userMenuItems" :ui="{ item: { base: 'p-2' }, trigger: 'w-full' }">
              <div class="flex items-center justify-center sm:justify-start gap-3 p-2 rounded-full hover:bg-gray-50 dark:hover:bg-gray-800 cursor-pointer transition-colors">
                <UAvatar
                  src=""
                  alt="Photo de profil"
                  size="lg"
                />
                <div class="hidden sm:block min-w-0">
                  <p class="font-medium text-gray-900 dark:text-white truncate">{{ user?.first_name }} {{ user?.last_name }}</p>
                  <p class="text-sm text-gray-500 dark:text-gray-400 truncate">{{ user?.phone }}</p>
                </div>
              </div>
            </UDropdown>
          </div>
        </div>
      </aside>

      <!-- Main content -->
      <main class="flex-1 ml-[75px] sm:ml-[240px]">
        <!-- Header -->
        <header class="sticky top-0 z-30 bg-white/80 dark:bg-gray-900/80 backdrop-blur-sm border-b border-gray-100 dark:border-gray-800">
          <div class="flex items-center justify-between h-16 px-4 max-w-[800px] mx-auto">
            <h1 class="text-xl font-semibold text-gray-900 dark:text-white truncate">{{ $route.name }}</h1>
            
            <div class="flex items-center gap-4">
              <UButton
                color="gray"
                variant="ghost"
                icon="i-heroicons-bell"
              />
              <UInput
                icon="i-heroicons-magnifying-glass"
                placeholder="Rechercher..."
                class="hidden sm:flex w-64"
              />
            </div>
          </div>
        </header>

        <!-- Page content -->
        <div class="max-w-[800px] mx-auto px-4 py-6">
          <slot />
        </div>
      </main>

      <!-- Right sidebar -->
      <div class="hidden xl:block w-[240px]">
        <!-- Contenu futur -->
      </div>
    </div>

    <!-- Mobile navigation (xs screens only) -->
    <nav class="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-900 border-t border-gray-100 dark:border-gray-800 sm:hidden z-40">
      <div class="grid grid-cols-5 gap-1">
        <NuxtLink 
          to="/client" 
          class="flex flex-col items-center py-3 text-gray-600 dark:text-gray-400"
        >
          <UIcon name="i-heroicons-home" class="w-6 h-6" />
          <span class="text-xs mt-1">Accueil</span>
        </NuxtLink>
        
        <NuxtLink 
          to="/client/missions" 
          class="flex flex-col items-center py-3 text-gray-600 dark:text-gray-400"
        >
          <UIcon name="i-heroicons-briefcase" class="w-6 h-6" />
          <span class="text-xs mt-1">Missions</span>
        </NuxtLink>
        
        <NuxtLink 
          to="/client/missions/new" 
          class="flex flex-col items-center py-3 text-primary-600"
        >
          <div class="w-12 h-12 -mt-6 rounded-full bg-primary-600 flex items-center justify-center shadow-lg">
            <UIcon name="i-heroicons-plus" class="w-6 h-6 text-white" />
          </div>
          <span class="text-xs mt-1">Publier</span>
        </NuxtLink>
        
        <NuxtLink 
          to="/client/messages" 
          class="flex flex-col items-center py-3 text-gray-600 dark:text-gray-400"
        >
          <UIcon name="i-heroicons-chat-bubble-left-right" class="w-6 h-6" />
          <span class="text-xs mt-1">Messages</span>
        </NuxtLink>
        
        <NuxtLink 
          to="/client/profile" 
          class="flex flex-col items-center py-3 text-gray-600 dark:text-gray-400"
        >
          <UIcon name="i-heroicons-user-circle" class="w-6 h-6" />
          <span class="text-xs mt-1">Profil</span>
        </NuxtLink>
      </div>
    </nav>
  </div>
</template>

<script setup lang="ts">
const notifications = [
  [
    {
      label: 'Nouvelle proposition',
      icon: 'i-heroicons-document-text',
      description: 'Pour votre mission "Réparation climatiseur"',
      avatar: { src: '', alt: 'Expert' }
    },
    {
      label: 'Nouveau message',
      icon: 'i-heroicons-chat-bubble-left',
      description: 'De Mohamed concernant votre mission',
      avatar: { src: '', alt: 'Mohamed' }
    }
  ]
]

const userMenuItems = [
  [
    {
      label: 'Mon profil',
      icon: 'i-heroicons-user-circle',
      to: '/client/profile'
    },
    {
      label: 'Paramètres',
      icon: 'i-heroicons-cog-6-tooth',
      to: '/client/settings'
    }
  ],
  [
    {
      label: 'Déconnexion',
      icon: 'i-heroicons-arrow-right-on-rectangle',
      click: () => {/* Implémenter la déconnexion */}
    }
  ]
]

// Simuler les données utilisateur
const user = ref({
  first_name: 'Amadou',
  last_name: 'Diallo',
  email: 'amadou.diallo@example.com',
  phone: '+221 77 123 45 67'
})

definePageMeta({
  middleware: ['auth']
})
</script> 