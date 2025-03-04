<template>
  <div>
    <div class="flex items-center justify-between mb-8">
      <h1 class="text-2xl font-bold text-gray-900">Mes demandes</h1>
      <NuxtLink 
        to="/demande"
        class="inline-flex items-center px-4 py-2 rounded-xl bg-primary-500 text-white hover:bg-primary-600 transition-colors"
      >
        <PlusIcon class="w-5 h-5 mr-2" />
        Nouvelle demande
      </NuxtLink>
    </div>

    <!-- Liste des demandes -->
    <div class="space-y-4">
      <div v-for="demande in demandes" :key="demande.id" 
        class="bg-white rounded-2xl border border-gray-200 overflow-hidden"
      >
        <div class="p-6">
          <div class="flex items-start justify-between">
            <div>
              <div class="flex items-center gap-3 mb-2">
                <span class="text-2xl">{{ serviceIcons[demande.service_type] }}</span>
                <h3 class="font-medium text-gray-900">{{ serviceNames[demande.service_type] }}</h3>
                <span 
                  :class="[
                    'px-2 py-1 text-xs font-medium rounded-full',
                    statusStyles[demande.status]
                  ]"
                >
                  {{ statusLabels[demande.status] }}
                </span>
              </div>
              <p class="text-gray-600 mb-4">{{ demande.description }}</p>
              <div class="flex items-center gap-4 text-sm text-gray-500">
                <div class="flex items-center gap-1">
                  <CalendarIcon class="w-4 h-4" />
                  {{ formatDate(demande.desired_date) }}
                </div>
                <div class="flex items-center gap-1">
                  <MapPinIcon class="w-4 h-4" />
                  {{ demande.city }}
                </div>
              </div>
            </div>
            <Menu as="div" class="relative">
              <MenuButton class="p-2 hover:bg-gray-50 rounded-xl">
                <EllipsisVerticalIcon class="w-5 h-5 text-gray-400" />
              </MenuButton>
              <MenuItems class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg border focus:outline-none">
                <MenuItem v-slot="{ active }">
                  <button
                    class="block w-full text-left px-4 py-2 text-sm"
                    :class="active ? 'bg-gray-50 text-gray-900' : 'text-gray-700'"
                  >
                    Voir les détails
                  </button>
                </MenuItem>
                <MenuItem v-slot="{ active }">
                  <button
                    class="block w-full text-left px-4 py-2 text-sm"
                    :class="active ? 'bg-gray-50 text-gray-900' : 'text-gray-700'"
                  >
                    Modifier
                  </button>
                </MenuItem>
                <MenuItem v-slot="{ active }">
                  <button
                    class="block w-full text-left px-4 py-2 text-sm text-red-600"
                    :class="active ? 'bg-red-50' : ''"
                  >
                    Supprimer
                  </button>
                </MenuItem>
              </MenuItems>
            </Menu>
          </div>
        </div>
        
        <!-- Propositions reçues -->
        <div v-if="demande.proposals?.length" class="border-t border-gray-200 bg-gray-50 px-6 py-4">
          <div class="text-sm font-medium text-gray-900 mb-3">
            {{ demande.proposals.length }} proposition(s) reçue(s)
          </div>
          <div class="space-y-3">
            <div v-for="proposal in demande.proposals" :key="proposal.id"
              class="flex items-center justify-between bg-white p-3 rounded-xl border border-gray-200"
            >
              <div class="flex items-center gap-3">
                <img :src="proposal.expert.avatar" class="w-8 h-8 rounded-full" />
                <div>
                  <div class="font-medium">{{ proposal.expert.name }}</div>
                  <div class="text-sm text-gray-500">{{ proposal.price }}€/h</div>
                </div>
              </div>
              <button class="text-primary-600 hover:text-primary-700 font-medium text-sm">
                Voir détails
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import { 
  PlusIcon, 
  CalendarIcon, 
  MapPinIcon,
  EllipsisVerticalIcon 
} from '@heroicons/vue/24/outline'

definePageMeta({
  layout: 'profile'
})

// Données de test
const demandes = ref([
  {
    id: 1,
    service_type: 'menage',
    status: 'pending',
    description: 'Ménage complet d\'un appartement de 80m²',
    desired_date: '2024-03-15',
    city: 'Paris',
    proposals: [
      {
        id: 1,
        expert: {
          name: 'Marie D.',
          avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
        },
        price: 25
      }
    ]
  },
  {
    id: 2,
    service_type: 'jardinage',
    status: 'confirmed',
    description: 'Taille de haie et tonte de pelouse',
    desired_date: '2024-03-20',
    city: 'Lyon',
    proposals: []
  }
])

const serviceIcons = {
  menage: '🧹',
  jardinage: '🌱',
  bricolage: '🔨',
  garde: '👶'
}

const serviceNames = {
  menage: 'Ménage',
  jardinage: 'Jardinage',
  bricolage: 'Bricolage',
  garde: 'Garde d\'enfants'
}

const statusLabels = {
  pending: 'En attente',
  confirmed: 'Confirmé',
  completed: 'Terminé',
  cancelled: 'Annulé'
}

const statusStyles = {
  pending: 'bg-yellow-50 text-yellow-800',
  confirmed: 'bg-green-50 text-green-800',
  completed: 'bg-blue-50 text-blue-800',
  cancelled: 'bg-red-50 text-red-800'
}

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}
</script> 