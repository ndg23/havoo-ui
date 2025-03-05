<template>
  <div class="space-y-8">
    <!-- Titre et description -->
    <div class="text-center">
      <h2 class="text-xl font-medium text-gray-900">Quel service recherchez-vous ?</h2>
      <p class="mt-2 text-gray-500">Sélectionnez le type de service dont vous avez besoin</p>
    </div>
    
    <!-- Catégories principales -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <button
        v-for="category in mainCategories"
        :key="category.id"
        @click="selectCategory(category.id)"
        class="relative p-4 rounded-xl border-2 transition-all duration-300 group text-center aspect-square flex flex-col items-center justify-center"
        :class="selectedCategory === category.id 
          ? 'border-primary-600 bg-primary-50' 
          : 'border-gray-200 hover:border-gray-300'"
      >
        <!-- Icon -->
        <div 
          class="w-16 h-16 rounded-full flex items-center justify-center mb-4 transition-transform group-hover:scale-110"
          :class="selectedCategory === category.id ? 'bg-primary-100' : 'bg-gray-100'"
        >
          <component 
            :is="category.icon" 
            class="w-8 h-8"
            :class="selectedCategory === category.id ? 'text-primary-600' : 'text-gray-600'" 
          />
        </div>
        
        <!-- Nom -->
        <h3 
          class="font-medium transition-colors"
          :class="selectedCategory === category.id ? 'text-primary-700' : 'text-gray-900'"
        >
          {{ category.name }}
        </h3>
        
        <!-- Check icon -->
        <div 
          v-if="selectedCategory === category.id"
          class="absolute top-3 right-3 w-6 h-6 rounded-full bg-primary-600 flex items-center justify-center"
        >
          <Check class="w-4 h-4 text-white" />
        </div>
      </button>
    </div>
    
    <!-- Sous-catégories -->
    <div v-if="selectedCategory" class="mt-8">
      <h3 class="text-lg font-medium text-gray-900 mb-4">Précisez votre besoin</h3>
      
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
        <button
          v-for="service in filteredServices"
          :key="service.id"
          @click="selectService(service.id)"
          class="flex items-center gap-3 p-3 rounded-lg border transition-colors"
          :class="modelValue === service.id 
            ? 'border-primary-600 bg-primary-50' 
            : 'border-gray-200 hover:border-gray-300'"
        >
          <!-- Icon -->
          <div 
            class="w-10 h-10 rounded-full flex items-center justify-center shrink-0"
            :class="modelValue === service.id ? 'bg-primary-100' : 'bg-gray-100'"
          >
            <span class="text-xl">{{ service.icon }}</span>
          </div>
          
          <!-- Info -->
          <div class="flex-1 text-left">
            <div 
              class="font-medium"
              :class="modelValue === service.id ? 'text-primary-700' : 'text-gray-900'"
            >
              {{ service.name }}
            </div>
            <div class="text-xs text-gray-500">{{ service.description }}</div>
          </div>
          
          <!-- Prix -->
          <div 
            class="text-xs font-medium px-2 py-1 rounded-full"
            :class="modelValue === service.id ? 'bg-primary-100 text-primary-700' : 'bg-gray-100 text-gray-600'"
          >
            {{ service.price }}
          </div>
        </button>
      </div>
    </div>
    
    <!-- Recherche personnalisée -->
    <div class="mt-6 p-4 bg-gray-50 rounded-xl">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center">
          <Search class="w-5 h-5 text-gray-600" />
        </div>
        <div class="flex-1">
          <h4 class="font-medium text-gray-900">Vous ne trouvez pas ce que vous cherchez ?</h4>
          <p class="text-sm text-gray-500">Décrivez votre besoin et nous vous aiderons à trouver l'expert idéal.</p>
        </div>
        <button 
          class="px-3 py-1.5 text-sm font-medium text-primary-600 border border-primary-600 rounded-full hover:bg-primary-50"
          @click="showCustomServiceModal = true"
        >
          Préciser
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Check, Search, Home, Briefcase, Car, Heart } from 'lucide-vue-next'

defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

// État
const selectedCategory = ref('')
const showCustomServiceModal = ref(false)

// Catégories principales
const mainCategories = [
  { 
    id: 'maison', 
    name: 'Maison', 
    icon: Home
  },
  { 
    id: 'professionnel', 
    name: 'Professionnel', 
    icon: Briefcase
  },
  { 
    id: 'transport', 
    name: 'Transport', 
    icon: Car
  },
  { 
    id: 'bienetre', 
    name: 'Bien-être', 
    icon: Heart
  }
]

// Services détaillés
const allServices = [
  // Maison
  { 
    id: 'menage', 
    category: 'maison',
    name: 'Ménage', 
    icon: '🧹',
    description: 'Entretien régulier ou ponctuel',
    price: 'Dès 500 FCFA/h'
  },
  { 
    id: 'jardinage', 
    category: 'maison',
    name: 'Jardinage', 
    icon: '🌱',
    description: 'Entretien et aménagement',
    price: 'Dès 1000 FCFA/h'
  },
  { 
    id: 'bricolage', 
    category: 'maison',
    name: 'Bricolage', 
    icon: '🔨',
    description: 'Réparations et installations',
    price: 'Dès 1500 FCFA/h'
  },
  { 
    id: 'garde', 
    category: 'maison',
    name: "Garde d'enfants", 
    icon: '👶',
    description: 'Garde et accompagnement',
    price: 'Dès 800 FCFA/h'
  },
  
  // Professionnel
  { 
    id: 'comptabilite', 
    category: 'professionnel',
    name: 'Comptabilité', 
    icon: '📊',
    description: 'Gestion comptable et fiscale',
    price: 'Dès 5000 FCFA'
  },
  { 
    id: 'marketing', 
    category: 'professionnel',
    name: 'Marketing', 
    icon: '📱',
    description: 'Stratégie et communication',
    price: 'Dès 10000 FCFA'
  },
  
  // Transport
  { 
    id: 'chauffeur', 
    category: 'transport',
    name: 'Chauffeur', 
    icon: '🚗',
    description: 'Transport personnel ou professionnel',
    price: 'Dès 2000 FCFA'
  },
  { 
    id: 'demenagement', 
    category: 'transport',
    name: 'Déménagement', 
    icon: '📦',
    description: 'Transport de biens et meubles',
    price: 'Dès 15000 FCFA'
  },
  
  // Bien-être
  { 
    id: 'coiffure', 
    category: 'bienetre',
    name: 'Coiffure', 
    icon: '💇',
    description: 'Coupe, coloration, coiffage',
    price: 'Dès 3000 FCFA'
  },
  { 
    id: 'massage', 
    category: 'bienetre',
    name: 'Massage', 
    icon: '💆',
    description: 'Relaxation et bien-être',
    price: 'Dès 8000 FCFA'
  }
]

// Services filtrés par catégorie
const filteredServices = computed(() => {
  return allServices.filter(service => service.category === selectedCategory.value)
})

// Sélectionner une catégorie
const selectCategory = (categoryId: string) => {
  selectedCategory.value = categoryId
  // Réinitialiser le service sélectionné si on change de catégorie
  emit('update:modelValue', '')
}

// Sélectionner un service
const selectService = (serviceId: string) => {
  emit('update:modelValue', serviceId)
}
</script> 