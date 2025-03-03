<template>
  <BaseModal :is-open="isOpen" :title="user ? 'Modifier l\'utilisateur' : 'Nouvel utilisateur'" @close="close">
    <form @submit.prevent="handleSubmit" class="space-y-6">
      <!-- Informations personnelles -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Informations personnelles</h4>
        <div class="space-y-4">
          <div class="flex items-center gap-4">
            <div class="flex-shrink-0">
              <img 
                :src="form.avatar || '/default-avatar.png'" 
                class="w-16 h-16 rounded-full object-cover border-2 border-gray-200"
              >
            </div>
            <div class="flex-1">
              <label class="block text-sm font-medium text-gray-700 mb-1">Photo de profil</label>
              <input 
                type="file" 
                accept="image/*"
                class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-medium file:bg-orange-50 file:text-orange-700 hover:file:bg-orange-100"
              >
            </div>
          </div>
          
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Nom complet</label>
              <input 
                type="text" 
                v-model="form.name"
                class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
                placeholder="Jean Dupont"
              >
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
              <input 
                type="email" 
                v-model="form.email"
                class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
                placeholder="jean@example.com"
              >
            </div>
          </div>
        </div>
      </div>

      <!-- Rôle et Statut -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Rôle et Statut</h4>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Rôle</label>
            <select 
              v-model="form.role"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
              <option value="user">Utilisateur</option>
              <option value="admin">Administrateur</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Statut</label>
            <select 
              v-model="form.status"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
            >
              <option value="active">Actif</option>
              <option value="inactive">Inactif</option>
              <option value="banned">Banni</option>
            </select>
          </div>
        </div>
      </div>

      <!-- Sécurité -->
      <div>
        <h4 class="text-sm font-medium text-gray-700 mb-4">Sécurité</h4>
        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Mot de passe</label>
            <input 
              type="password" 
              v-model="form.password"
              class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500"
              :placeholder="user ? 'Laisser vide pour ne pas modifier' : 'Nouveau mot de passe'"
            >
          </div>
          <div class="flex items-center gap-2">
            <input 
              type="checkbox" 
              v-model="form.requirePasswordChange"
              id="requirePasswordChange"
              class="rounded border-gray-300 text-orange-500 focus:ring-orange-500"
            >
            <label for="requirePasswordChange" class="text-sm text-gray-700">
              Exiger un changement de mot de passe à la prochaine connexion
            </label>
          </div>
        </div>
      </div>

      <!-- Actions -->
      <div class="flex justify-end gap-3 pt-4">
        <button 
          type="button"
          @click="close"
          class="px-4 py-2 text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200"
        >
          Annuler
        </button>
        <button 
          type="submit"
          class="px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600"
        >
          {{ user ? 'Modifier' : 'Créer' }}
        </button>
      </div>
    </form>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseModal from '../BaseModal.vue'

const props = defineProps<{
  isOpen: boolean
  user?: any
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'submit', data: any): void
}>()

const form = ref({
  name: '',
  email: '',
  avatar: '',
  role: 'user',
  status: 'active',
  password: '',
  requirePasswordChange: false
})

watch(() => props.user, (newUser) => {
  if (newUser) {
    form.value = {
      ...form.value,
      ...newUser,
      password: '' // Ne pas inclure le mot de passe dans l'édition
    }
  } else {
    form.value = {
      name: '',
      email: '',
      avatar: '',
      role: 'user',
      status: 'active',
      password: '',
      requirePasswordChange: false
    }
  }
}, { immediate: true })

const handleSubmit = () => {
  emit('submit', form.value)
  close()
}

const close = () => {
  emit('close')
}
</script> 