<template>
  <div class="min-h-screen">
    <!-- Hero Section -->
    <section class="relative bg-gradient-to-br from-primary-500 to-primary-600 overflow-hidden">
      <div class="absolute inset-0 bg-grid-white/10"></div>
      
      <div class="relative max-w-7xl mx-auto px-4 py-24 sm:py-32">
        <div class="grid lg:grid-cols-2 gap-12 items-center">
          <!-- Texte -->
          <div class="text-center lg:text-left space-y-6">
            <h1 class="text-4xl sm:text-5xl font-bold text-white">
              Trouvez l'expert idéal pour vos besoins
            </h1>
            <p class="text-xl text-white/90">
              Des professionnels qualifiés pour tous vos services à domicile
            </p>
            <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
              <NuxtLink 
                to="/demande"
                class="px-6 py-3 bg-white text-primary-600 rounded-xl font-medium hover:bg-gray-100 transition-colors"
              >
                Faire une demande
              </NuxtLink>
              <NuxtLink 
                to="/experts"
                class="px-6 py-3 bg-white/10 text-white rounded-xl font-medium hover:bg-white/20 transition-colors"
              >
                Voir les experts
              </NuxtLink>
            </div>
          </div>

          <!-- Image/Illustration -->
          <div class="relative lg:h-[500px] hidden lg:block">
            <img 
              src="https://images.pexels.com/photos/3768914/pexels-photo-3768914.jpeg"
              alt="Services à domicile"
              class="absolute inset-0 w-full h-full object-cover rounded-2xl -shadow-2xl"
              onerror="this.onerror=null; this.src='https://images.pexels.com/photos/4239091/pexels-photo-4239091.jpeg'"
            />
            <!-- Overlay pour améliorer la lisibilité -->
            <div class="absolute inset-0 bg-gradient-to-br from-primary-500/20 to-transparent rounded-2xl"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- Services Section -->
    <section class="py-24 bg-gray-50">
      <div class="max-w-7xl mx-auto px-4">
      
        
        <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-8">
          <NuxtLink
            v-for="service in services"
            :key="service.id"
            :to="`/demande?service=${service.id}`"
            class="relative group overflow-hidden"
          >
            <!-- Card -->
            <div class="bg-white rounded-2xl p-8 text-center border-2 border-transparent hover:border-primary-500 transition-all duration-300">
              <!-- Icon avec cercle -->
              <div class="relative inline-flex mb-6">
                <div class="absolute inset-0 bg-primary-100 rounded-full transform transition-transform duration-300 group-hover:scale-110"></div>
                <div class="relative w-16 h-16 flex items-center justify-center text-4xl">
                  {{ service.icon }}
                </div>
              </div>

              <!-- Texte -->
              <h3 class="text-xl font-medium text-gray-900 mb-2">
                {{ service.name }}
              </h3>
              <p class="text-gray-600 text-sm mb-4">
                {{ service.description }}
              </p>

              <!-- Prix avec badge -->
              <div class="inline-flex items-center px-3 py-1 rounded-full bg-primary-50 text-primary-600 text-sm font-medium">
                {{ service.price }}
              </div>

              <!-- Flèche -->
              <div class="mt-4 text-primary-500 transform translate-y-2 opacity-0 transition-all duration-300 group-hover:translate-y-0 group-hover:opacity-100">
                <ArrowRightIcon class="w-5 h-5 mx-auto" />
              </div>
            </div>
          </NuxtLink>
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
              <UserGroupIcon class="w-8 h-8 text-primary-600" />
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
import { ClipboardIcon, UserGroupIcon, CheckCircleIcon, ArrowRightIcon, ShieldCheckIcon, ClockIcon, CurrencyDollarIcon } from '@heroicons/vue/24/solid'

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