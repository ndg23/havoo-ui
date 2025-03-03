<template>
  <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-[480px] mx-auto">
      <!-- Header -->
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-gray-900">
          Devenir Expert
        </h1>
        <p class="mt-2 text-gray-600">
          Rejoignez notre communauté de professionnels
        </p>
      </div>

      <!-- Form Card -->
      <div class="bg-white rounded-2xl -shadow-sm border border-gray-200 p-8">
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <!-- Name Inputs -->
          <div class="grid grid-cols-2 gap-4">
            <div class="relative">
              <input
                v-model="form.firstName"
                type="text"
                required
                class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-indigo-500 focus:ring-0 focus:outline-none transition-colors"
                placeholder=" "
                :class="{ 'border-red-300': errors.firstName }"
              />
              <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85"
              >
                Prénom
              </label>
            </div>

            <div class="relative">
              <input
                v-model="form.lastName"
                type="text"
                required
                class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-indigo-500 focus:ring-0 focus:outline-none transition-colors"
                placeholder=" "
                :class="{ 'border-red-300': errors.lastName }"
              />
              <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
                -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
                peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
                peer-focus:scale-85"
              >
                Nom
              </label>
            </div>
          </div>

          <!-- Email Input -->
          <div class="relative">
            <input
              v-model="form.email"
              type="email"
              required
              class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-indigo-500 focus:ring-0 focus:outline-none transition-colors"
              placeholder=" "
              :class="{ 'border-red-300': errors.email }"
            />
            <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
              -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
              peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
              peer-focus:scale-85"
            >
              Email professionnel
            </label>
          </div>

          <!-- Phone Input -->
          <div class="relative">
            <input
              v-model="form.phone"
              type="tel"
              required
              class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-indigo-500 focus:ring-0 focus:outline-none transition-colors"
              placeholder=" "
              :class="{ 'border-red-300': errors.phone }"
            />
            <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
              -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
              peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
              peer-focus:scale-85"
            >
              Téléphone
            </label>
          </div>

          <!-- Service Selection -->
          <div class="relative">
            <Listbox v-model="form.service" as="div">
              <ListboxLabel class="block text-sm font-medium text-gray-500 mb-1">
                Votre domaine d'expertise
              </ListboxLabel>
              <div class="relative">
                <ListboxButton class="w-full h-14 px-4 text-left rounded-xl border-2 border-gray-200 focus:border-indigo-500 focus:outline-none">
                  <span class="block truncate">{{ form.service?.name || 'Sélectionnez votre domaine' }}</span>
                  <span class="absolute inset-y-0 right-0 flex items-center pr-4">
                    <ChevronUpDownIcon class="h-5 w-5 text-gray-400" aria-hidden="true" />
                  </span>
                </ListboxButton>

                <Transition
                  leave-active-class="transition duration-100 ease-in"
                  leave-from-class="opacity-100"
                  leave-to-class="opacity-0"
                >
                  <ListboxOptions class="absolute z-10 mt-1 w-full bg-white rounded-xl -shadow-lg border border-gray-200 py-1">
                    <ListboxOption
                      v-for="service in services"
                      :key="service.id"
                      :value="service"
                      v-slot="{ active, selected }"
                      as="template"
                    >
                      <li :class="[
                        active ? 'bg-indigo-50 text-indigo-900' : 'text-gray-900',
                        'relative cursor-pointer select-none py-3 px-4'
                      ]">
                        <span class="flex items-center">
                          <span class="text-xl mr-3">{{ service.icon }}</span>
                          <span :class="[selected ? 'font-semibold' : 'font-normal', 'block truncate']">
                            {{ service.name }}
                          </span>
                        </span>
                      </li>
                    </ListboxOption>
                  </ListboxOptions>
                </Transition>
              </div>
            </Listbox>
          </div>

          <!-- Password Input -->
          <div class="relative">
            <input
              v-model="form.password"
              :type="showPassword ? 'text' : 'password'"
              required
              class="peer w-full h-14 px-4 pt-2 rounded-xl border-2 border-gray-200 placeholder-transparent focus:border-indigo-500 focus:ring-0 focus:outline-none transition-colors"
              placeholder=" "
              :class="{ 'border-red-300': errors.password }"
            />
            <label class="absolute left-4 top-4 text-gray-500 text-sm transition-all duration-200 
              -translate-y-3 scale-85 peer-placeholder-shown:translate-y-0 
              peer-placeholder-shown:scale-100 peer-focus:-translate-y-3 
              peer-focus:scale-85"
            >
              Mot de passe
            </label>
            <button 
              type="button"
              @click="showPassword = !showPassword"
              class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
            >
              <EyeIcon v-if="showPassword" class="w-5 h-5" />
              <EyeSlashIcon v-else class="w-5 h-5" />
            </button>
          </div>

          <!-- Terms Checkbox -->
          <label class="flex items-start gap-3">
            <input
              v-model="form.terms"
              type="checkbox"
              required
              class="mt-1 w-4 h-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
            />
            <span class="text-sm text-gray-600">
              J'accepte les <NuxtLink to="/legal/terms" class="text-indigo-600 hover:text-indigo-700">conditions d'utilisation</NuxtLink>
              et la <NuxtLink to="/legal/privacy" class="text-indigo-600 hover:text-indigo-700">politique de confidentialité</NuxtLink>
            </span>
          </label>

          <!-- Submit Button -->
          <button
            type="submit"
            class="w-full bg-indigo-600 text-white h-12 rounded-xl font-medium hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors"
            :class="{ 'opacity-50 cursor-not-allowed': loading }"
            :disabled="loading"
          >
            <span v-if="loading">Création du compte...</span>
            <span v-else>Créer mon compte professionnel</span>
          </button>
        </form>
      </div>

      <!-- Login Link -->
      <p class="mt-8 text-center text-sm text-gray-600">
        Déjà inscrit ?
        <NuxtLink 
          to="/auth/login" 
          class="font-medium text-indigo-600 hover:text-indigo-700"
        >
          Se connecter
        </NuxtLink>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { Listbox, ListboxButton, ListboxLabel, ListboxOption, ListboxOptions } from '@headlessui/vue'
import { EyeIcon, EyeSlashIcon, ChevronUpDownIcon } from '@heroicons/vue/24/outline'

definePageMeta({
  layout: 'auth'
})

const client = useSupabaseClient()
const loading = ref(false)
const showPassword = ref(false)

const services = [
  { id: 'menage', name: 'Ménage', icon: '🧹' },
  { id: 'jardinage', name: 'Jardinage', icon: '🌱' },
  { id: 'bricolage', name: 'Bricolage', icon: '🔨' },
  { id: 'garde', name: 'Garde d\'enfants', icon: '👶' }
]

const form = reactive({
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  service: null,
  password: '',
  terms: false
})

const errors = reactive({
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  password: ''
})

const handleSubmit = async () => {
  // Reset errors
  Object.keys(errors).forEach(key => errors[key] = '')

  try {
    loading.value = true
    const { error } = await client.auth.signUp({
      email: form.email,
      password: form.password,
      options: {
        data: {
          firstName: form.firstName,
          lastName: form.lastName,
          phone: form.phone,
          serviceId: form.service?.id,
          role: 'expert'
        }
      }
    })

    if (error) throw error

    // Redirect to expert dashboard or confirmation page
    navigateTo('/auth/confirmation')
  } catch (error) {
    console.error('Error:', error.message)
    if (error.message.includes('email')) {
      errors.email = 'Email déjà utilisé ou invalide'
    }
  } finally {
    loading.value = false
  }
}
</script> 