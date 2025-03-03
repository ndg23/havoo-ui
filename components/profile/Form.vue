<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Informations de base -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label class="block text-sm font-medium text-gray-700">Nom</label>
        <input
          v-model="formData.name"
          type="text"
          class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
        />
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700">Email</label>
        <input
          v-model="formData.email"
          type="email"
          class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
        />
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700">Téléphone</label>
        <input
          v-model="formData.phone"
          type="tel"
          class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
        />
      </div>
    </div>

    <!-- Adresse -->
    <div class="space-y-4">
      <h3 class="text-lg font-medium text-gray-900">Adresse</h3>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700">Rue</label>
          <input
            v-model="formData.address.street"
            type="text"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Ville</label>
          <input
            v-model="formData.address.city"
            type="text"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Code postal</label>
          <input
            v-model="formData.address.postalCode"
            type="text"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>
      </div>
    </div>

    <div class="pt-6 border-t border-gray-200">
      <button
        type="submit"
        class="inline-flex justify-center px-6 py-3 border border-transparent rounded-xl -shadow-sm 
               text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 
               focus:ring-offset-2 focus:ring-blue-500"
      >
        Enregistrer les modifications
      </button>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { User } from '~/types'

const props = defineProps<{
  user: User
}>()

const emit = defineEmits<{
  (e: 'update', user: Partial<User>): void
}>()

const formData = ref<Partial<User>>({
  ...props.user
})

const handleSubmit = () => {
  emit('update', formData.value)
}
</script> 