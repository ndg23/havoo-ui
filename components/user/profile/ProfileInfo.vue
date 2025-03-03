<template>
  <div class="bg-white -shadow rounded-lg">
    <div class="p-6">
      <div class="flex items-center space-x-6">
        <div class="relative">
          <img
            :src="user.avatar || '/default-avatar.png'"
            alt="Photo de profil"
            class="w-24 h-24 rounded-full object-cover"
          />
          <button
            v-if="editable"
            @click="$emit('edit-avatar')"
            class="absolute bottom-0 right-0 bg-white rounded-full p-1 -shadow hover:bg-gray-50"
          >
            <PencilIcon class="w-4 h-4 text-gray-600" />
          </button>
        </div>

        <div class="flex-1">
          <h2 class="text-2xl font-bold text-gray-900">
            {{ user.name }}
          </h2>
          <p class="text-gray-600">{{ user.email }}</p>
          <p class="text-sm text-gray-500 mt-1">
            Membre depuis {{ formatDate(user.createdAt) }}
          </p>
        </div>

        <SharedUiButton
          v-if="editable"
          @click="$emit('edit')"
          variant="secondary"
        >
          Modifier le profil
        </SharedUiButton>
      </div>

      <div class="mt-6 border-t pt-6">
        <h3 class="text-lg font-semibold mb-4">Statistiques</h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div class="bg-gray-50 p-4 rounded-lg">
            <p class="text-sm text-gray-600">Objets partagés</p>
            <p class="text-2xl font-bold">{{ stats.sharedItems }}</p>
          </div>
          <div class="bg-gray-50 p-4 rounded-lg">
            <p class="text-sm text-gray-600">Locations effectuées</p>
            <p class="text-2xl font-bold">{{ stats.rentals }}</p>
          </div>
          <div class="bg-gray-50 p-4 rounded-lg">
            <p class="text-sm text-gray-600">Évaluations reçues</p>
            <p class="text-2xl font-bold">{{ stats.ratings }}/5</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  user: {
    name: string
    email: string
    avatar?: string
    createdAt: Date
  }
  stats: {
    sharedItems: number
    rentals: number
    ratings: number
  }
  editable?: boolean
}

defineProps<Props>()

defineEmits<{
  edit: []
  'edit-avatar': []
}>()

const formatDate = (date: Date) => {
  return new Intl.DateTimeFormat('fr-FR', {
    dateStyle: 'long'
  }).format(new Date(date))
}
</script> 