<template>
  <footer class="bg-white border-t border-gray-100">
    <div class="container mx-auto px-6 py-20">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-12">
        <!-- Logo et description -->
        <div class="space-y-6">
          <h3 class="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            KILOU
          </h3>
          <p class="text-gray-500 leading-relaxed">
            Partagez et empruntez des objets facilement avec vos amis. 
            Une solution économique et écologique.
          </p>
          <div class="flex space-x-4">
            <a 
              v-for="social in socials" 
              :key="social.name"
              :href="social.url"
              class="p-2 text-gray-400 hover:text-gray-900 transition-colors"
              target="_blank"
              rel="noopener"
            >
              <component :is="social.icon" class="w-6 h-6" />
            </a>
          </div>
        </div>

        <!-- Navigation -->
        <div v-for="section in footerSections" :key="section.title">
          <h4 class="text-lg font-semibold text-gray-900 mb-6">
            {{ section.title }}
          </h4>
          <ul class="space-y-4">
            <li v-for="link in section.links" :key="link.name">
              <NuxtLink 
                :to="link.path"
                class="text-gray-500 hover:text-gray-900 transition-colors"
              >
                {{ link.name }}
              </NuxtLink>
            </li>
          </ul>
        </div>
      </div>

      <!-- Barre inférieure -->
      <div class="mt-20 pt-8 border-t border-gray-100 flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
        <p class="text-gray-500 text-sm">
          © {{ new Date().getFullYear() }} KILOU. Tous droits réservés.
        </p>
        <div class="flex space-x-6">
          <NuxtLink 
            v-for="link in legalLinks" 
            :key="link.name"
            :to="link.path"
            class="text-sm text-gray-500 hover:text-gray-900 transition-colors"
          >
            {{ link.name }}
          </NuxtLink>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import {
  GlobeAltIcon,
  ChatBubbleLeftIcon,
  UserGroupIcon
} from '@heroicons/vue/24/outline'

const socials = [
  { name: 'Twitter', icon: 'TwitterIcon', url: '#' },
  { name: 'Facebook', icon: 'FacebookIcon', url: '#' },
  { name: 'Instagram', icon: 'InstagramIcon', url: '#' }
]

const footerSections = [
  {
    title: 'Découvrir',
    links: [
      { name: 'Comment ça marche', path: '/how-it-works' },
      { name: 'Témoignages', path: '/testimonials' },
      { name: 'Guide d\'utilisation', path: '/guide' }
    ]
  },
  {
    title: 'Communauté',
    links: [
      { name: 'Blog', path: '/blog' },
      { name: 'Partenaires', path: '/partners' },
      { name: 'Devenir hôte', path: '/become-host' }
    ]
  },
  {
    title: 'Support',
    links: [
      { name: 'Centre d\'aide', path: '/help' },
      { name: 'Nous contacter', path: '/contact' },
      { name: 'FAQ', path: '/faq' }
    ]
  }
]

const legalLinks = [
  { name: 'Confidentialité', path: '/privacy' },
  { name: 'Conditions d\'utilisation', path: '/terms' },
  { name: 'Mentions légales', path: '/legal' }
]
</script> 