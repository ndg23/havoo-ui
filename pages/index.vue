<template>
  <div class="min-h-screen">
    <!-- Hero Section -->
    <section class="relative bg-gradient-to-br from-primary-500 to-primary-600 overflow-hidden">
      <div class="absolute inset-0 bg-grid-white/10"></div>
      
      <div class="relative max-w-7xl mx-auto px-4 py-24 sm:py-32">
        <div class="text-center max-w-4xl mx-auto">
          <!-- Titre principal -->
          <h1 class="text-5xl sm:text-6xl font-bold text-white tracking-tight">
            Services à domicile
            <span class="block mt-2 bg-clip-text text-transparent bg-gradient-to-r from-white to-white/80">
              Simple. Rapide. Fiable.
            </span>
          </h1>

          <!-- Sous-titre -->
          <p class="mt-8 text-xl text-white/90 leading-relaxed">
            Choisissez votre approche préférée pour trouver le service dont vous avez besoin
          </p>

          <!-- Options principales -->
          <div class="mt-12 grid sm:grid-cols-2 gap-6 max-w-3xl mx-auto">
            <!-- Chercher un expert -->
            <div class="group">
              <NuxtLink 
                to="/experts"
                class="relative flex flex-col items-center p-8 bg-white/10 backdrop-blur-sm rounded-2xl hover:bg-white/15 transition-all duration-300"
              >
                <div class="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300">
                  <Search class="w-8 h-8 text-white" />
                </div>
                <h2 class="text-xl font-semibold text-white mb-2">Chercher un expert</h2>
                <p class="text-white/80 text-sm">
                  Parcourez notre sélection de professionnels qualifiés
                </p>
                <ArrowRight class="w-5 h-5 text-white mt-4 group-hover:translate-x-1 transition-transform" />
              </NuxtLink>
            </div>

            <!-- Publier une demande -->
            <div class="group">
              <NuxtLink 
                to="/requests"
                class="relative flex flex-col items-center p-8 bg-white/10 backdrop-blur-sm rounded-2xl hover:bg-white/15 transition-all duration-300"
              >
                <div class="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300">
                  <FileText class="w-8 h-8 text-white" />
                </div>
                <h2 class="text-xl font-semibold text-white mb-2">Publier une demande</h2>
                <p class="text-white/80 text-sm">
                  Décrivez votre besoin et recevez des propositions
                </p>
                <ArrowRight class="w-5 h-5 text-white mt-4 group-hover:translate-x-1 transition-transform" />
              </NuxtLink>
            </div>
          </div>

          <!-- Scroll indicator -->
          <div class="absolute bottom-8 left-1/2 -translate-x-1/2 animate-bounce">
            <ChevronDown class="w-6 h-6 text-white/60" />
          </div>
        </div>
      </div>
    </section>

  

    <!-- Comment ça marche -->
    <section class="py-24">
      <div class="max-w-7xl mx-auto px-4">
        <h2 class="text-3xl font-bold text-gray-900 text-center mb-12">
          Comment ça marche ?
        </h2>

        <div class="grid md:grid-cols-3 gap-8">
          <div class="text-center">
            <div class="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <ClipboardIcon class="w-8 h-8 text-primary-600" />
            </div>
            <h3 class="text-xl font-medium text-gray-900 mb-2">1. Faites votre demande</h3>
            <p class="text-gray-600">Décrivez votre besoin en quelques clics</p>
          </div>

          <div class="text-center">
            <div class="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <User class="w-8 h-8 text-primary-600" />
            </div>
            <h3 class="text-xl font-medium text-gray-900 mb-2">2. Choisissez votre expert</h3>
            <p class="text-gray-600">Sélectionnez le professionnel qui vous convient</p>
          </div>

          <div class="text-center">
            <div class="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <CheckCircleIcon class="w-8 h-8 text-primary-600" />
            </div>
            <h3 class="text-xl font-medium text-gray-900 mb-2">3. Service réalisé</h3>
            <p class="text-gray-600">Profitez d'un service de qualité</p>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="py-24 bg-primary-500">
      <div class="max-w-3xl mx-auto px-4 text-center">
        <h2 class="text-3xl font-bold text-white mb-6">
          Prêt à commencer ?
        </h2>
        <p class="text-xl text-white/90 mb-8">
          Rejoignez des milliers de clients satisfaits
        </p>
        <NuxtLink 
          to="/demande"
          class="inline-block px-8 py-4 bg-white text-primary-600 rounded-xl font-medium hover:bg-gray-100 transition-colors"
        >
          Faire une demande
        </NuxtLink>
      </div>
    </section>
  </div>
</template>

<script setup>
import { 
  ClipboardIcon, 
  User, 
  CheckCircleIcon, 
  Search, 
  FileText, 
  ArrowRight, 
  ChevronDown,
  Shield,
  BadgeCheck,
  Clock,
  Star
} from 'lucide-vue-next'

const services = [
  {
    id: 'menage',
    name: 'Ménage',
    icon: '🧹',
    price: 'Dès 500 FCFA',
    description: 'Entretien de votre domicile'
  },
  {
    id: 'jardinage',
    name: 'Jardinage',
    icon: '🌱',
    price: 'Dès 1000 FCFA',
    description: 'Entretien de vos espaces verts'
  },
  {
    id: 'bricolage',
    name: 'Bricolage',
    icon: '🔨',
    price: 'Dès 1500 FCFA',
    description: 'Réparations et installations'
  },
  {
    id: 'garde',
    name: "Garde d'enfants",
    icon: '👶',
    price: 'Dès 800 FCFA',
    description: 'Garde et accompagnement'
  }
]
</script>

<style scoped>
.bg-grid-white {
  background-image: url("data:image/svg+xml,%3Csvg width='40' height='40' viewBox='0 0 40 40' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23fff' fill-opacity='0.1' fill-rule='evenodd'%3E%3Ccircle cx='2' cy='2' r='1'/%3E%3C/g%3E%3C/svg%3E");
}
</style>