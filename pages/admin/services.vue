<template>
  <div class="space-y-6">
    <!-- Header avec bouton d'ajout -->
    <div class="flex items-center justify-between">
      <div class="flex items-center gap-4">
        <div class="relative w-64">
          <MagnifyingGlassIcon class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
          <input 
            v-model="searchQuery"
            type="text"
            placeholder="Rechercher un service..."
            class="w-full pl-10 pr-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
        <select 
          v-model="categoryFilter"
          class="px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
        >
          <option value="">Toutes les catégories</option>
          <option v-for="cat in categories" :key="cat.id" :value="cat.id">
            {{ cat.name }}
          </option>
        </select>
      </div>
      <button 
        @click="openAddModal"
        class="flex items-center gap-2 px-4 py-2 bg-primary-500 text-white rounded-xl hover:bg-primary-600"
      >
        <PlusIcon class="w-5 h-5" />
        <span>Ajouter un service</span>
      </button>
    </div>

    <!-- Grid des services -->
    <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
      <div 
        v-for="service in filteredServices" 
        :key="service.id"
        class="bg-white rounded-xl border border-gray-200 overflow-hidden hover:shadow-lg transition-shadow"
      >
        <!-- Service Header -->
        <div class="p-6 flex items-start justify-between border-b border-gray-100">
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-primary-50 flex items-center justify-center text-2xl">
              {{ service.icon }}
            </div>
            <div>
              <h3 class="font-medium text-gray-900">{{ service.name }}</h3>
              <p class="text-sm text-gray-500">{{ service.category }}</p>
            </div>
          </div>
          <Menu as="div" class="relative">
            <MenuButton class="p-2 rounded-lg hover:bg-gray-50">
              <EllipsisVerticalIcon class="w-5 h-5 text-gray-400" />
            </MenuButton>
            <MenuItems class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-1 border border-gray-200">
              <MenuItem v-slot="{ active }">
                <button
                  class="flex w-full items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                  @click="editService(service)"
                >
                  <PencilIcon class="w-4 h-4 mr-3" />
                  Modifier
                </button>
              </MenuItem>
              <MenuItem v-slot="{ active }">
                <button
                  class="flex w-full items-center px-4 py-2 text-sm text-red-600 hover:bg-red-50"
                  @click="confirmDelete(service)"
                >
                  <TrashIcon class="w-4 h-4 mr-3" />
                  Supprimer
                </button>
              </MenuItem>
            </MenuItems>
          </Menu>
        </div>

        <!-- Service Stats -->
        <div class="p-6 grid grid-cols-2 gap-4">
          <div>
            <p class="text-sm font-medium text-gray-500">Prix de base</p>
            <p class="text-lg font-bold text-gray-900">{{ service.base_price }} FCFA</p>
          </div>
          <div>
            <p class="text-sm font-medium text-gray-500">Experts</p>
            <p class="text-lg font-bold text-gray-900">{{ service.expert_count }}</p>
          </div>
          <div>
            <p class="text-sm font-medium text-gray-500">Demandes</p>
            <p class="text-lg font-bold text-gray-900">{{ service.request_count }}</p>
          </div>
          <div>
            <p class="text-sm font-medium text-gray-500">Note moyenne</p>
            <div class="flex items-center gap-1">
              <StarIcon class="w-5 h-5 text-yellow-400" />
              <span class="font-bold text-gray-900">{{ service.rating }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal d'ajout/modification -->
    <Modal v-if="showModal" @close="showModal = false">
      <template #title>
        {{ editingService ? 'Modifier le service' : 'Ajouter un service' }}
      </template>
      
      <template #content>
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Nom du service
            </label>
            <input 
              v-model="form.name"
              type="text"
              required
              class="w-full px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Catégorie
            </label>
            <select 
              v-model="form.category_id"
              required
              class="w-full px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
            >
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">
                {{ cat.name }}
              </option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Prix de base (FCFA)
            </label>
            <input 
              v-model.number="form.base_price"
              type="number"
              required
              min="0"
              class="w-full px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Description
            </label>
            <textarea 
              v-model="form.description"
              rows="3"
              class="w-full px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
            ></textarea>
          </div>

          <div class="flex justify-end gap-3">
            <button
              type="button"
              class="px-4 py-2 text-gray-700 bg-gray-100 rounded-xl hover:bg-gray-200"
              @click="showModal = false"
            >
              Annuler
            </button>
            <button
              type="submit"
              class="px-4 py-2 text-white bg-primary-500 rounded-xl hover:bg-primary-600"
            >
              {{ editingService ? 'Modifier' : 'Ajouter' }}
            </button>
          </div>
        </form>
      </template>
    </Modal>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Menu, MenuButton, MenuItems, MenuItem } from '@headlessui/vue'
import Modal from '~/components/shared/Modal.vue'
import { 
  MagnifyingGlassIcon,
  PlusIcon,
  EllipsisVerticalIcon,
  PencilIcon,
  TrashIcon,
  StarIcon
} from '@heroicons/vue/24/outline'

// État
const searchQuery = ref('')
const categoryFilter = ref('')
const showModal = ref(false)
const editingService = ref(null)

const form = ref({
  name: '',
  category_id: '',
  base_price: 0,
  description: ''
})

// Données simulées
const categories = [
  { id: 1, name: 'Maison' },
  { id: 2, name: 'Extérieur' },
  { id: 3, name: 'Bricolage' }
]

const services = ref([
  {
    id: 1,
    name: 'Ménage',
    category: 'Maison',
    icon: '🧹',
    base_price: 500,
    expert_count: 25,
    request_count: 156,
    rating: 4.8
  },
  {
    id: 2,
    name: 'Jardinage',
    category: 'Extérieur',
    icon: '🌱',
    base_price: 1000,
    expert_count: 15,
    request_count: 80,
    rating: 4.5
  },
  {
    id: 3,
    name: 'Bricolage',
    category: 'Bricolage',
    icon: '🔨',
    base_price: 1500,
    expert_count: 10,
    request_count: 50,
    rating: 4.7
  }
  // ... autres services
])

// Filtrage
const filteredServices = computed(() => {
  let filtered = services.value

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(service => 
      service.name.toLowerCase().includes(query)
    )
  }

  if (categoryFilter.value) {
    filtered = filtered.filter(service => 
      service.category_id === categoryFilter.value
    )
  }

  return filtered
})

// Actions
const openAddModal = () => {
  editingService.value = null
  form.value = {
    name: '',
    category_id: '',
    base_price: 0,
    description: ''
  }
  showModal.value = true
}

const editService = (service) => {
  editingService.value = service
  form.value = { ...service }
  showModal.value = true
}

const handleSubmit = async () => {
  try {
    if (editingService.value) {
      // Mettre à jour le service
      console.log('Update service:', form.value)
    } else {
      // Créer un nouveau service
      console.log('Create service:', form.value)
    }
    showModal.value = false
  } catch (error) {
    console.error('Error:', error)
  }
}

const confirmDelete = (service) => {
  // Implémenter la suppression avec confirmation
  console.log('Delete service:', service)
}

definePageMeta({
  layout: 'admin'
})
</script> 