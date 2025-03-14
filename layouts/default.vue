<template>
  <div class="min-h-screen bg-gradient-to-b from-gray-50 to-white dark:from-gray-900 dark:to-gray-800">
    <!-- Navbar -->
    <Navbar />

    <!-- Contenu principal -->
    <main class="mx-auto min-h-screen ">
      <slot />
    </main>

    <!-- Footer -->
    <footer class="bg-white/90 backdrop-blur-md border-t border-gray-200/50 dark:bg-gray-800/90 dark:border-gray-700/50">
      <div class="max-w-7xl mx-auto px-6 py-16">
        <div class="grid md:grid-cols-3 gap-8">
          <!-- Logo et description -->
          <div>
          <Logo />
          </div>

          <!-- Liens rapides -->
          <div>
            <h4 class="font-medium text-gray-900 mb-3">Liens utiles</h4>
            <div class="space-y-2">
              <NuxtLink 
                to="/experts"
                class="block text-sm text-gray-600 hover:text-gray-900"
              >
                Trouver un expert
              </NuxtLink>
              <NuxtLink 
                to="/requests"
                class="block text-sm text-gray-600 hover:text-gray-900"
              >
                Publier une demande
              </NuxtLink>
            </div>
          </div>

          <!-- Légal -->
          <div>
            <h4 class="font-medium text-gray-900 mb-3">Légal</h4>
            <div class="space-y-2">
              <NuxtLink 
                to="/legal/privacy"
                class="block text-sm text-gray-600 hover:text-gray-900"
              >
                Confidentialité
              </NuxtLink>
              <NuxtLink 
                to="/terms"
                class="block text-sm text-gray-600 hover:text-gray-900"
              >
                Conditions d'utilisation
              </NuxtLink>
            </div>
          </div>
        </div>

        <!-- Copyright -->
        <div class="mt-8 pt-8 border-t border-gray-100">
          <p class="text-sm text-gray-500 text-center">
            © {{ new Date().getFullYear() }} ServicePro. Tous droits réservés.
          </p>
        </div>
      </div>
    </footer>

    <!-- Bouton principal d'action -->
    <NuxtLink 
      to="/account/new-request" 
      class="fixed right-6 bottom-6 bg-blue-500 hover:bg-blue-600 text-white px-6 py-3 rounded-full font-medium flex items-center justify-center shadow-lg transform hover:scale-105 transition-all duration-300 z-50"
    >
      <PlusIcon class="h-4 w-4 mr-2" />
      <span>Créer une demande</span>
    </NuxtLink>
  </div>
</template>

<script setup>
import Logo from '~/components/Logo.vue';
// import { Footer } from 'lucide-vue-next'
import Navbar from '~/components/Navbar.vue'
import AppHeader from '~/components/layout/AppHeader.vue'
import AppFooter from '~/components/layout/AppFooter.vue'
// Pas besoin de logique particulière ici
</script> 
<style scoped>
html {
  font-size: 17px;
  line-height: 1.47059;
  font-weight: 400;
  letter-spacing: -0.022em;
  font-family: "SF Pro Text", "SF Pro Icons", "Helvetica Neue", Helvetica, Arial, sans-serif;
  background-color: rgb(255, 255, 255);
  color: rgb(29, 29, 31);
  font-style: normal;
}
p {
  display: block;
    margin-block-start: 1em;
    margin-block-end: 1em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
    unicode-bidi: isolate;
}

</style>