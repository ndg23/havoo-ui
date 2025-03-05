<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Navbar -->
    <Navbar />

    <!-- Contenu principal -->
    <main class="pt-16"> <!-- pt-16 pour compenser la hauteur de la navbar -->
      <slot />
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200">
      <div class="max-w-7xl mx-auto px-4 py-12">
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
                to="/privacy"
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
  </div>
</template>

<script setup>
import Logo from '~/components/Logo.vue';
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