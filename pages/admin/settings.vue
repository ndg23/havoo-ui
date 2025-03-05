<template>
  <div class="space-y-8">
    <!-- Sections de paramètres -->
    <div class="grid grid-cols-12 gap-6">
      <!-- Menu latéral -->
      <div class="col-span-3">
        <nav class="space-y-1">
          <button
            v-for="section in sections"
            :key="section.id"
            @click="currentSection = section.id"
            class="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors"
            :class="currentSection === section.id 
              ? 'bg-primary-50 text-primary-600' 
              : 'text-gray-600 hover:bg-gray-50'"
          >
            <component :is="section.icon" class="w-5 h-5" />
            {{ section.name }}
          </button>
        </nav>
      </div>

      <!-- Contenu des paramètres -->
      <div class="col-span-9 space-y-6">
        <!-- Paramètres généraux -->
        <div v-if="currentSection === 'general'" class="space-y-6">
          <div class="bg-white rounded-xl border border-gray-200 overflow-hidden">
            <div class="p-6">
              <h3 class="text-lg font-medium text-gray-900 mb-6">Paramètres généraux</h3>
              <form @submit.prevent="saveGeneralSettings" class="space-y-6">
                <div class="grid grid-cols-2 gap-6">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                      Nom de la plateforme
                    </label>
                    <input 
                      v-model="settings.platform_name"
                      type="text"
                      class="w-full px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                      Email de contact
                    </label>
                    <input 
                      v-model="settings.contact_email"
                      type="email"
                      class="w-full px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                      Devise
                    </label>
                    <select 
                      v-model="settings.currency"
                      class="w-full px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
                    >
                      <option value="XOF">FCFA (XOF)</option>
                      <option value="EUR">Euro (EUR)</option>
                      <option value="USD">Dollar (USD)</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                      Langue par défaut
                    </label>
                    <select 
                      v-model="settings.default_language"
                      class="w-full px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
                    >
                      <option value="fr">Français</option>
                      <option value="en">English</option>
                    </select>
                  </div>
                </div>
                <button 
                  type="submit"
                  class="px-4 py-2 bg-primary-500 text-white rounded-xl hover:bg-primary-600"
                >
                  Enregistrer les modifications
                </button>
              </form>
            </div>
          </div>
        </div>

        <!-- Paramètres de paiement -->
        <div v-if="currentSection === 'payment'" class="space-y-6">
          <div class="bg-white rounded-xl border border-gray-200 overflow-hidden">
            <div class="p-6">
              <h3 class="text-lg font-medium text-gray-900 mb-6">Configuration des paiements</h3>
              <form @submit.prevent="savePaymentSettings" class="space-y-6">
                <div class="grid grid-cols-2 gap-6">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                      Commission plateforme (%)
                    </label>
                    <input 
                      v-model.number="settings.platform_fee"
                      type="number"
                      min="0"
                      max="100"
                      class="w-full px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                      Délai de paiement (jours)
                    </label>
                    <input 
                      v-model.number="settings.payment_delay"
                      type="number"
                      min="1"
                      class="w-full px-4 py-2 rounded-xl border border-gray-200 focus:ring-primary-500 focus:border-primary-500"
                    />
                  </div>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">
                    Méthodes de paiement actives
                  </label>
                  <div class="space-y-2">
                    <label class="flex items-center gap-2">
                      <input 
                        type="checkbox"
                        v-model="settings.payment_methods"
                        value="mobile_money"
                        class="rounded text-primary-500 focus:ring-primary-500"
                      />
                      Mobile Money
                    </label>
                    <label class="flex items-center gap-2">
                      <input 
                        type="checkbox"
                        v-model="settings.payment_methods"
                        value="card"
                        class="rounded text-primary-500 focus:ring-primary-500"
                      />
                      Carte bancaire
                    </label>
                    <label class="flex items-center gap-2">
                      <input 
                        type="checkbox"
                        v-model="settings.payment_methods"
                        value="cash"
                        class="rounded text-primary-500 focus:ring-primary-500"
                      />
                      Espèces
                    </label>
                  </div>
                </div>
                <button 
                  type="submit"
                  class="px-4 py-2 bg-primary-500 text-white rounded-xl hover:bg-primary-600"
                >
                  Enregistrer les modifications
                </button>
              </form>
            </div>
          </div>
        </div>

        <!-- Paramètres de notification -->
        <div v-if="currentSection === 'notifications'" class="space-y-6">
          <div class="bg-white rounded-xl border border-gray-200 overflow-hidden">
            <div class="p-6">
              <h3 class="text-lg font-medium text-gray-900 mb-6">Configuration des notifications</h3>
              <form @submit.prevent="saveNotificationSettings" class="space-y-6">
                <div class="space-y-4">
                  <div>
                    <label class="flex items-center gap-2">
                      <input 
                        type="checkbox"
                        v-model="settings.notifications.email"
                        class="rounded text-primary-500 focus:ring-primary-500"
                      />
                      Notifications par email
                    </label>
                  </div>
                  <div>
                    <label class="flex items-center gap-2">
                      <input 
                        type="checkbox"
                        v-model="settings.notifications.sms"
                        class="rounded text-primary-500 focus:ring-primary-500"
                      />
                      Notifications par SMS
                    </label>
                  </div>
                  <div>
                    <label class="flex items-center gap-2">
                      <input 
                        type="checkbox"
                        v-model="settings.notifications.push"
                        class="rounded text-primary-500 focus:ring-primary-500"
                      />
                      Notifications push
                    </label>
                  </div>
                </div>
                <button 
                  type="submit"
                  class="px-4 py-2 bg-primary-500 text-white rounded-xl hover:bg-primary-600"
                >
                  Enregistrer les modifications
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import {
  Cog6ToothIcon,
  CurrencyDollarIcon,
  BellIcon,
  ShieldCheckIcon
} from '@heroicons/vue/24/outline'

// Sections de paramètres
const sections = [
  { id: 'general', name: 'Général', icon: Cog6ToothIcon },
  { id: 'payment', name: 'Paiements', icon: CurrencyDollarIcon },
  { id: 'notifications', name: 'Notifications', icon: BellIcon },
  { id: 'security', name: 'Sécurité', icon: ShieldCheckIcon }
]

const currentSection = ref('general')

// Paramètres par défaut
const settings = ref({
  platform_name: 'Havoo Services',
  contact_email: 'contact@havoo.com',
  currency: 'XOF',
  default_language: 'fr',
  platform_fee: 15,
  payment_delay: 7,
  payment_methods: ['mobile_money', 'card'],
  notifications: {
    email: true,
    sms: true,
    push: false
  }
})

// Actions
const saveGeneralSettings = async () => {
  try {
    // Implémenter la sauvegarde
    console.log('Save general settings:', settings.value)
  } catch (error) {
    console.error('Error:', error)
  }
}

const savePaymentSettings = async () => {
  try {
    // Implémenter la sauvegarde
    console.log('Save payment settings:', settings.value)
  } catch (error) {
    console.error('Error:', error)
  }
}

const saveNotificationSettings = async () => {
  try {
    // Implémenter la sauvegarde
    console.log('Save notification settings:', settings.value)
  } catch (error) {
    console.error('Error:', error)
  }
}

definePageMeta({
  layout: 'admin'
})
</script> 