<template>
  <div class="space-y-8">
    <div>
      <h2 class="text-2xl font-semibold text-gray-900">Préférences</h2>
      <p class="mt-1 text-sm text-gray-500">Personnalisez votre expérience.</p>
    </div>

    <form @submit.prevent="handleSubmit" class="space-y-6">
      <!-- Langue et Fuseau horaire -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="block text-sm font-medium text-gray-700">Langue</label>
          <select
            v-model="preferences.language"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          >
            <option value="fr">Français</option>
            <option value="en">English</option>
            <option value="es">Español</option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Fuseau horaire</label>
          <select
            v-model="preferences.timezone"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          >
            <option value="Europe/Paris">Paris (UTC+1)</option>
            <option value="Europe/London">London (UTC)</option>
            <option value="America/New_York">New York (UTC-5)</option>
          </select>
        </div>
      </div>

      <!-- Préférences de communication -->
      <div class="space-y-4">
        <h3 class="text-lg font-medium text-gray-900">Préférences de communication</h3>
        <div class="space-y-3">
          <label class="flex items-center">
            <input
              v-model="preferences.emailNotifications"
              type="checkbox"
              class="h-4 w-4 rounded text-blue-600 focus:ring-blue-500"
            />
            <span class="ml-3 text-sm text-gray-700">Recevoir des notifications par email</span>
          </label>

          <label class="flex items-center">
            <input
              v-model="preferences.smsNotifications"
              type="checkbox"
              class="h-4 w-4 rounded text-blue-600 focus:ring-blue-500"
            />
            <span class="ml-3 text-sm text-gray-700">Recevoir des notifications par SMS</span>
          </label>

          <label class="flex items-center">
            <input
              v-model="preferences.newsletter"
              type="checkbox"
              class="h-4 w-4 rounded text-blue-600 focus:ring-blue-500"
            />
            <span class="ml-3 text-sm text-gray-700">S'abonner à la newsletter</span>
          </label>
        </div>
      </div>

      <!-- Devise et Format -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="block text-sm font-medium text-gray-700">Devise préférée</label>
          <select
            v-model="preferences.currency"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          >
            <option value="EUR">EUR (€)</option>
            <option value="USD">USD ($)</option>
            <option value="GBP">GBP (£)</option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Format de date</label>
          <select
            v-model="preferences.dateFormat"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          >
            <option value="DD/MM/YYYY">DD/MM/YYYY</option>
            <option value="MM/DD/YYYY">MM/DD/YYYY</option>
            <option value="YYYY-MM-DD">YYYY-MM-DD</option>
          </select>
        </div>
      </div>

      <div class="pt-6 border-t border-gray-200">
        <button
          type="submit"
          class="inline-flex justify-center px-6 py-3 border border-transparent rounded-xl -shadow-sm 
                 text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 
                 focus:ring-offset-2 focus:ring-blue-500"
        >
          Enregistrer les préférences
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
const preferences = ref({
  language: 'fr',
  timezone: 'Europe/Paris',
  emailNotifications: true,
  smsNotifications: false,
  newsletter: true,
  currency: 'EUR',
  dateFormat: 'DD/MM/YYYY'
})

const handleSubmit = () => {
  // Logique de soumission
}
</script> 