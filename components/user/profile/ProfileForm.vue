<template>
  <div class="space-y-8">
    <div>
      <h2 class="text-2xl font-semibold text-gray-900">Informations personnelles</h2>
      <p class="mt-1 text-sm text-gray-500">Mettez à jour vos informations personnelles.</p>
    </div>

    <form @submit.prevent="handleSubmit" class="space-y-6">
      <!-- Informations de base -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="block text-sm font-medium text-gray-700">Prénom</label>
          <input
            v-model="formData.firstName"
            type="text"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Nom</label>
          <input
            v-model="formData.lastName"
            type="text"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700">Email</label>
          <input
            v-model="formData.email"
            type="email"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700">Téléphone</label>
          <input
            v-model="formData.phone"
            type="tel"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700">Adresse</label>
          <input
            v-model="formData.location"
            type="text"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Ville</label>
          <input
            v-model="formData.city"
            type="text"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700">Code postal</label>
          <input
            v-model="formData.postalCode"
            type="text"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
          />
        </div>

        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700">À propos</label>
          <textarea
            v-model="formData.bio"
            rows="4"
            class="mt-1 block w-full rounded-xl border-gray-300 -shadow-sm focus:border-blue-500 focus:ring-blue-500"
            placeholder="Parlez-nous un peu de vous..."
          />
          <p class="mt-2 text-sm text-gray-500">
            Une brève description qui apparaîtra sur votre profil public.
          </p>
        </div>
      </div>

      <!-- Préférences de communication -->
      <div class="space-y-4">
        <h3 class="text-lg font-medium text-gray-900">Préférences de communication</h3>
        <div class="space-y-3">
          <label class="flex items-center">
            <input
              v-model="formData.communicationPrefs.email"
              type="checkbox"
              class="h-4 w-4 rounded text-blue-600 focus:ring-blue-500"
            />
            <span class="ml-3 text-sm text-gray-700">
              J'accepte de recevoir des communications par email
            </span>
          </label>

          <label class="flex items-center">
            <input
              v-model="formData.communicationPrefs.sms"
              type="checkbox"
              class="h-4 w-4 rounded text-blue-600 focus:ring-blue-500"
            />
            <span class="ml-3 text-sm text-gray-700">
              J'accepte de recevoir des communications par SMS
            </span>
          </label>
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
  </div>
</template>

<script setup>
const formData = ref({
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  location: '',
  city: '',
  postalCode: '',
  bio: '',
  communicationPrefs: {
    email: true,
    sms: false
  }
})

const handleSubmit = () => {
  // Logique de soumission du formulaire
  console.log('Form submitted:', formData.value)
}
</script> 