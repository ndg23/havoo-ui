<template>
  <footer class="bg-gray-50 border-t">
    <div class="max-w-7xl mx-auto px-4 py-12">
      <div class="grid grid-cols-4 gap-8">
        <!-- À propos -->
        <div>
          <h3 class="text-sm font-semibold text-gray-900 mb-4">À propos</h3>
          <ul class="space-y-3">
            <li>
              <NuxtLink to="/about" class="text-sm text-gray-600 hover:text-gray-900">
                Qui sommes-nous
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/contact" class="text-sm text-gray-600 hover:text-gray-900">
                Nous contacter
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/blog" class="text-sm text-gray-600 hover:text-gray-900">
                Blog
              </NuxtLink>
            </li>
          </ul>
        </div>

        <!-- Aide -->
        <div>
          <h3 class="text-sm font-semibold text-gray-900 mb-4">Aide</h3>
          <ul class="space-y-3">
            <li>
              <NuxtLink to="/help" class="text-sm text-gray-600 hover:text-gray-900">
                Centre d'aide
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/faq" class="text-sm text-gray-600 hover:text-gray-900">
                FAQ
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/safety" class="text-sm text-gray-600 hover:text-gray-900">
                Sécurité
              </NuxtLink>
            </li>
          </ul>
        </div>

        <!-- Légal -->
        <div>
          <h3 class="text-sm font-semibold text-gray-900 mb-4">Légal</h3>
          <ul class="space-y-3">
            <li>
              <NuxtLink to="/terms" class="text-sm text-gray-600 hover:text-gray-900">
                Conditions d'utilisation
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/legal/privacy" class="text-sm text-gray-600 hover:text-gray-900">
                Politique de confidentialité
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/legal" class="text-sm text-gray-600 hover:text-gray-900">
                Mentions légales
              </NuxtLink>
            </li>
          </ul>
        </div>

        <!-- Réseaux sociaux -->
        <div>
          <h3 class="text-sm font-semibold text-gray-900 mb-4">Suivez-nous</h3>
          <div class="flex items-center gap-4">
            <a 
              href="https://twitter.com/kilou" 
              target="_blank"
              rel="noopener noreferrer"
              class="text-gray-400 hover:text-gray-500"
            >
              <span class="sr-only">Twitter</span>
              <TwitterIcon class="w-6 h-6" />
            </a>
            <a 
              href="https://facebook.com/kilou"
              target="_blank"
              rel="noopener noreferrer"
              class="text-gray-400 hover:text-gray-500"
            >
              <span class="sr-only">Facebook</span>
              <FacebookIcon class="w-6 h-6" />
            </a>
            <a 
              href="https://instagram.com/kilou"
              target="_blank"
              rel="noopener noreferrer"
              class="text-gray-400 hover:text-gray-500"
            >
              <span class="sr-only">Instagram</span>
              <InstagramIcon class="w-6 h-6" />
            </a>
          </div>
        </div>
      </div>

      <div class="border-t mt-8 pt-8 flex items-center justify-between">
        <p class="text-sm text-gray-500">
          © {{ new Date().getFullYear() }} Kilou. Tous droits réservés.
        </p>
        <div class="flex items-center gap-4">
          <select 
            v-model="language"
            class="text-sm text-gray-600 bg-transparent border-none focus:ring-0"
          >
            <option value="fr">Français</option>
            <option value="en">English</option>
          </select>
          <select 
            v-model="currency"
            class="text-sm text-gray-600 bg-transparent border-none focus:ring-0"
          >
            <option value="eur">EUR FCFA</option>
            <option value="usd">USD $</option>
          </select>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { TwitterIcon, FacebookIcon, InstagramIcon } from 'lucide-vue-next'

const language = ref('fr')
const currency = ref('eur')
</script> 