<template>
  <Modal @close="$emit('close')">
    <template #title>
      Assigner un expert
    </template>
    
    <template #content>
      <div class="space-y-6">
        <!-- Service Info -->
        <div class="flex items-center gap-3 p-3 bg-gray-50 rounded-xl">
          <div class="w-10 h-10 rounded-lg bg-primary-50 flex items-center justify-center text-xl">
            {{ mission.service_icon }}
          </div>
          <div>
            <h3 class="font-medium text-gray-900">{{ mission.service }}</h3>
            <p class="text-sm text-gray-500">{{ formatDate(mission.date_needed) }} à {{ mission.time_needed }}</p>
          </div>
        </div>

        <!-- Recherche -->
        <div class="relative">
          <MagnifyingGlassIcon class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
          <input 
            v-model="searchQuery"
            type="text"
            placeholder="Rechercher un expert..."
            class="w-full pl-10 pr-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>

        <!-- Liste des experts -->
        <div class="space-y-3 max-h-96 overflow-y-auto">
          <div 
            v-for="expert in filteredExperts" 
            :key="expert.id"
            class="flex items-center justify-between p-3 border border-gray-200 rounded-xl hover:border-primary-500 cursor-pointer"
            :class="{ 'border-primary-500 bg-primary-50': selectedExpert?.id === expert.id }"
            @click="selectedExpert = expert"
          >
            <div class="flex items-center gap-3">
              <img 
                :src="expert.avatar_url || `https://ui-avatars.com/api/?name=${expert.first_name}+${expert.last_name}`"
                class="w-10 h-10 rounded-full"
              />
              <div>
                <div class="font-medium text-gray-900">
                  {{ expert.first_name }} {{ expert.last_name }}
                </div>
                <div class="flex items-center gap-2 text-sm text-gray-500">
                  <StarIcon class="w-4 h-4 text-yellow-400" />
                  {{ expert.rating }} ({{ expert.total_jobs }} missions)
                </div>
              </div>
            </div>
            <div class="flex items-center gap-2">
              <span 
                v-for="service in expert.services" 
                :key="service.id"
                class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
              >
                {{ service.name }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </template>

    <template #footer>
      <button 
        @click="$emit('close')"
        class="px-4 py-2 text-gray-700 bg-gray-100 rounded-xl hover:bg-gray-200"
      >
        Annuler
      </button>
      <button 
        @click="handleAssign"
        class="px-4 py-2 text-white bg-primary-500 rounded-xl hover:bg-primary-600 disabled:opacity-50"
        :disabled="!selectedExpert"
      >
        Assigner
      </button>
    </template>
  </Modal>
</template>

<script setup>
import { ref, computed } from 'vue'
import { MagnifyingGlassIcon, StarIcon } from '@heroicons/vue/24/outline'
import Modal from '~/components/shared/Modal.vue'

const props = defineProps({
  mission: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['close', 'assign'])

// État
const searchQuery = ref('')
const selectedExpert = ref(null)

// Données simulées
const experts = ref([
  {
    id: 1,
    first_name: 'Jean',
    last_name: 'Dupont',
    avatar_url: null,
    rating: 4.8,
    total_jobs: 45,
    services: [
      { id: 'menage', name: 'Ménage' },
      { id: 'jardinage', name: 'Jardinage' }
    ]
  }
  // ... autres experts
])

// Filtrage
const filteredExperts = computed(() => {
  let filtered = experts.value

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(expert => 
      expert.first_name.toLowerCase().includes(query) ||
      expert.last_name.toLowerCase().includes(query)
    )
  }

  return filtered
})

// Actions
const handleAssign = () => {
  if (selectedExpert.value) {
    emit('assign', {
      mission: props.mission,
      expert: selectedExpert.value
    })
  }
}

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}
</script> 