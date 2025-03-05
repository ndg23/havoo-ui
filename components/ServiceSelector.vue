<template>
  <div class="space-y-6">
    <div class="grid sm:grid-cols-2 gap-4">
      <button
        v-for="service in services"
        :key="service.id"
        @click="$emit('update:modelValue', service.id)"
        class="relative p-6 rounded-xl border-2 transition-all duration-300 group text-left"
        :class="modelValue === service.id 
          ? 'border-primary-600 bg-primary-50' 
          : 'border-gray-200 hover:border-gray-300'"
      >
        <!-- Icon -->
        <div class="w-12 h-12 rounded-full bg-white flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
          <span class="text-2xl">{{ service.icon }}</span>
        </div>
        
        <!-- Info -->
        <h3 class="font-medium text-gray-900">{{ service.name }}</h3>
        <p class="mt-1 text-sm text-gray-500">{{ service.description }}</p>
        
        <!-- Prix indicatif -->
        <div class="mt-4 inline-flex items-center px-3 py-1 rounded-full text-xs font-medium"
          :class="modelValue === service.id ? 'bg-primary-100 text-primary-700' : 'bg-gray-100 text-gray-600'"
        >
          {{ service.price }}
        </div>

        <!-- Check icon -->
        <div 
          v-if="modelValue === service.id"
          class="absolute top-4 right-4 w-6 h-6 rounded-full bg-primary-600 flex items-center justify-center"
        >
          <Check class="w-4 h-4 text-white" />
        </div>
      </button>
    </div>

    <!-- Message d'aide -->
    <p class="text-sm text-gray-500 text-center">
      Sélectionnez le type de service dont vous avez besoin
    </p>
  </div>
</template>

<script setup lang="ts">
import { Check } from 'lucide-vue-next'

defineProps<{
  modelValue: string
}>()

defineEmits<{
  'update:modelValue': [value: string]
}>()

const services = [
  { 
    id: 'menage', 
    name: 'Ménage', 
    icon: '🧹',
    description: 'Entretien régulier ou ponctuel',
    price: 'Dès 500 FCFA/h'
  },
  { 
    id: 'jardinage', 
    name: 'Jardinage', 
    icon: '🌱',
    description: 'Entretien et aménagement',
    price: 'Dès 1000 FCFA/h'
  },
  // ... autres services
]
</script> 