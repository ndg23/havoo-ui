<template>
  <div class="min-h-screen bg-white">
    <!-- Hero Section with more impactful Twitter-inspired design -->
    <section class="relative bg-white overflow-hidden">
      <!-- Enhanced background effects -->
      <!-- <div class="absolute inset-0 bg-gradient-to-br from-primary-50 to-white opacity-70"></div>
      <div class="absolute top-20 right-20 w-64 h-64 rounded-full bg-primary-100 blur-3xl opacity-30"></div>
      <div class="absolute bottom-20 left-20 w-64 h-64 rounded-full bg-blue-100 blur-3xl opacity-30"></div> -->

      <div class="relative max-w-4xl mx-auto px-4 py-24 sm:py-32">
        <div class="text-center">
          <!-- More impactful headline with gradient text -->
          <h1 class="text-5xl sm:text-6xl font-bold tracking-tight">
            Services à domicile
            <span class="block mt-3 bg-clip-text text-transparent bg-gradient-to-r from-primary-600 to-blue-600">
              Simple. Rapide. Fiable.
            </span>
          </h1>

          <!-- Enhanced subtitle with stronger metrics -->
          <p class="mt-6 text-xl text-gray-600">
            Rejoignez plus de <span class="font-bold px-1.5 py-0.5 rounded-md bg-primary-50 text-primary-700">10
              000</span> clients satisfaits et <span
              class="font-bold px-1.5 py-0.5 rounded-md bg-primary-50 text-primary-700">2 500</span> experts qualifiés
          </p>

          <!-- Replacing search with two clean, impactful buttons -->
          <div class="mt-14 flex flex-col sm:flex-row justify-center gap-5 relative z-10">
            <NuxtLink to="/requests/new"
              class="bg-primary-600 hover:bg-primary-700 text-white px-8 py-4 rounded-full font-medium text-lg transition-all flex items-center justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="mr-3" width="24" height="24" viewBox="0 0 24 24">
                <g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                  color="currentColor">
                  <path
                    d="M16 17H9m7-4h-3m7.5 1c0 3.771 0 5.657-1.245 6.828S16.007 22 12 22h-.773c-3.26 0-4.892 0-6.024-.798a4.1 4.1 0 0 1-.855-.805c-.848-1.066-.848-2.6-.848-5.67v-2.545c0-2.963 0-4.445.469-5.628c.754-1.903 2.348-3.403 4.37-4.113C9.595 2 11.168 2 14.318 2c1.798 0 2.698 0 3.416.252c1.155.406 2.066 1.263 2.497 2.35c.268.676.268 1.523.268 3.216z" />
                  <path
                    d="M3.5 12a3.333 3.333 0 0 1 3.333-3.333c.666 0 1.451.116 2.098-.057a1.67 1.67 0 0 0 1.179-1.18c.173-.647.057-1.432.057-2.098A3.333 3.333 0 0 1 13.5 2" />
                </g>
              </svg> Publier une demande
            </NuxtLink>
            <NuxtLink to="/experts"
              class="bg-white text-gray-800 border border-gray-200 hover:bg-gray-50 px-8 py-4 rounded-full font-medium text-lg transition-all flex items-center justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="mr-3" width="25" height="24" viewBox="0 0 25 24">
                <path fill="currentColor" fill-rule="evenodd"
                  d="M16.434 6.35c0 2.39-1.94 4.34-4.34 4.34l-.01-.01c-2.39 0-4.34-1.95-4.34-4.34S9.704 2 12.094 2s4.34 1.96 4.34 4.35m-1.5-.01c0-1.56-1.27-2.84-2.84-2.84c-1.56 0-2.84 1.28-2.84 2.84s1.28 2.84 2.84 2.84a2.85 2.85 0 0 0 2.84-2.84"
                  clip-rule="evenodd" />
                <path fill="currentColor"
                  d="M12.024 12.19c2.67 0 4.76.75 6.21 2.23v-.01c2.046 2.086 2.04 4.846 2.04 5.024v.005c-.01.41-.34.74-.75.74h-.01a.755.755 0 0 1-.74-.76c0-.05 0-2.33-1.62-3.97c-1.16-1.17-2.89-1.77-5.13-1.77s-3.97.6-5.13 1.77c-1.62 1.65-1.62 3.95-1.62 3.97c0 .41-.33.76-.74.76c-.36.02-.76-.32-.76-.73v-.004c-.001-.168-.008-2.939 2.04-5.026c1.45-1.48 3.54-2.23 6.21-2.23" />
              </svg>

              Chercher des experts
            </NuxtLink>
          </div>

          <!-- Services with more impactful Twitter pill design -->
          <div class="mt-20 text-center">
            <span
              class="inline-block px-4 py-1.5 bg-primary-50 text-primary-700 rounded-full text-sm font-medium mb-4">Services
              populaires</span>
            <h3 class="text-2xl font-bold text-gray-900 mb-8">Explorer nos catégories de services</h3>
            <div class="flex flex-wrap justify-center gap-4">
              <NuxtLink v-for="service in services" :key="service.id" :to="`/experts?service=${service.id}`"
                class="bg-white hover:bg-gray-50 transition-all px-6 py-3 rounded-full flex items-center border border-gray-100 min-w-[170px]">
                <span class="mr-3 text-2xl">{{ service.icon }}</span>
                <span class="text-gray-800 font-medium">{{ service.name }}</span>
              </NuxtLink>
            </div>
          </div>

          <!-- Minimal scroll indicator -->
          <div class="absolute bottom-10 left-1/2 -translate-x-1/2 animate-bounce bg-transparent p-2">
            <ChevronDown class="w-6 h-6 text-primary-500" />
          </div>
        </div>
      </div>
    </section>

    <!-- How it works - Enhanced Twitter-inspired steps -->
    <section class="py-28 bg-white relative overflow-hidden">
      <div class="max-w-6xl mx-auto px-4">
        <!-- Section header with enhanced Twitter typography -->
        <div class="text-center mb-20">
          <span
            class="inline-block px-4 py-1.5 bg-primary-50 text-primary-700 rounded-full text-sm font-medium mb-4">Comment
            ça marche</span>
          <h2 class="text-4xl font-bold text-gray-900">
            L'efficacité en trois étapes
          </h2>
        </div>

        <!-- Steps with enhanced Twitter card style -->
        <div class="space-y-24">
          <!-- Step 1 -->
          <div class="grid grid-cols-1 lg:grid-cols-5 gap-10 items-center">
            <div class="lg:col-span-2">
              <div
                class="inline-flex items-center justify-center w-20 h-20 rounded-full bg-gray-100 text-primary-600 font-bold text-7xl mb-6">
                1</div>
              <h3 class="text-2xl font-bold text-gray-900 mb-4">
                Décrivez votre besoin
              </h3>
              <p class="text-lg text-gray-600 leading-relaxed">
                Précisez simplement ce dont vous avez besoin. Notre interface intuitive vous guide à chaque étape.
              </p>
            </div>
            <div class="lg:col-span-3">
              <div
                class="rounded-2xl overflow-hidden border border-gray-100 transform hover:scale-[1.02] transition-all duration-300">
                <img src="https://images.pexels.com/photos/6615722/pexels-photo-6615722.jpeg" alt="Étape 1"
                  class="w-full" />
              </div>
            </div>
          </div>
          
          <!-- Step 2 -->
          <div class="grid grid-cols-1 lg:grid-cols-5 gap-10 items-center">
            <div class="lg:col-span-3 order-2 lg:order-1">
              <div
                class="rounded-2xl overflow-hidden border border-gray-100 transform hover:scale-[1.02] transition-all duration-300">
                <img src="https://images.pexels.com/photos/3184405/pexels-photo-3184405.jpeg" alt="Étape 2"
                  class="w-full" />
              </div>
            </div>
            <div class="lg:col-span-2 order-1 lg:order-2">
              <div
                class="inline-flex items-center justify-center w-20 h-20 rounded-full bg-gray-100 text-primary-600 font-bold text-7xl mb-6">
                2</div>
              <h3 class="text-2xl font-bold text-gray-900 mb-4">
                Connectez avec des experts
              </h3>
              <p class="text-lg text-gray-600 leading-relaxed">
                Notre algorithme intelligent trouve les meilleurs experts pour votre besoin spécifique.
              </p>
            </div>
          </div>
          
          <!-- Step 3 -->
          <div class="grid grid-cols-1 lg:grid-cols-5 gap-10 items-center">
            <div class="lg:col-span-2">
              <div
                class="inline-flex items-center justify-center w-20 h-20 rounded-full  text-primary-600 font-bold text-7xl mb-6">
                3</div>
              <h3 class="text-2xl font-bold text-gray-900 mb-4">
                Problème résolu
              </h3>
              <p class="text-lg text-gray-600 leading-relaxed">
                Profitez d'un service de qualité et d'une résolution efficace de votre problème.
              </p>
            </div>
            <div class="lg:col-span-3">
              <div
                class="rounded-2xl overflow-hidden border border-gray-100 transform hover:scale-[1.02] transition-all duration-300">
                <img src="https://images.pexels.com/photos/7415061/pexels-photo-7415061.jpeg" alt="Étape 3"
                  class="w-full" />
              </div>
            </div>
          </div>
        </div>

        <!-- Enhanced CTA with Twitter-style button -->
        <div class="mt-20 text-center">
          <NuxtLink to="/requests/new"
            class="inline-flex items-center px-8 py-4 bg-primary-600 text-white font-medium rounded-full hover:bg-primary-700 transition-all">
            Créer une demande
            <ArrowRight class="ml-2 h-5 w-5" />
          </NuxtLink>
        </div>
      </div>
    </section>

    <!-- Features section with enhanced Twitter card design -->
    <section class="py-24 bg-white">
      <div class="max-w-6xl mx-auto px-4">
        <div class="grid lg:grid-cols-2 gap-16 items-center">
          <!-- Enhanced text content -->
          <div class="space-y-8">
            <h2 class="text-4xl font-bold text-gray-900">
              La qualité au service 
              <span class="text-primary-600">de votre quotidien</span>
            </h2>
            <div class="space-y-6 text-lg">
              <div class="flex items-start gap-4 p-4 bg-white rounded-2xl transition-all border border-gray-100">
                <span
                  class="flex-shrink-0 w-12 h-12 rounded-full bg-primary-50 flex items-center justify-center text-primary-600">
                  <Shield class="w-5 h-5" />
                </span>
                <div>
                  <h3 class="font-semibold text-gray-900 mb-1">Experts vérifiés</h3>
                  <p class="text-gray-600">Tous nos experts sont vérifiés et évalués par notre communauté</p>
                </div>
              </div>
              <div class="flex items-start gap-4 p-4 bg-white rounded-2xl transition-all border border-gray-100">
                <span
                  class="flex-shrink-0 w-12 h-12 rounded-full bg-primary-50 flex items-center justify-center text-primary-600">
                  <BadgeCheck class="w-5 h-5" />
                </span>
                <div>
                  <h3 class="font-semibold text-gray-900 mb-1">Satisfaction garantie</h3>
                  <p class="text-gray-600">Satisfaction garantie ou remboursé sous 24h</p>
                </div>
              </div>
              <div class="flex items-start gap-4 p-4 bg-white rounded-2xl transition-all border border-gray-100">
                <span
                  class="flex-shrink-0 w-12 h-12 rounded-full bg-primary-50 flex items-center justify-center text-primary-600">
                  <Clock class="w-5 h-5" />
                </span>
                <div>
                  <h3 class="font-semibold text-gray-900 mb-1">Intervention rapide</h3>
                  <p class="text-gray-600">Réponse rapide et intervention dans les 24-48h</p>
          </div>
              </div>
            </div>
            
            <!-- Enhanced avatar group with Twitter style -->
            <div class="pt-3 bg-white p-5 rounded-2xl border border-gray-100">
              <div class="flex items-center gap-4">
                <div class="flex -space-x-3">
                  <img v-for="i in 4" :key="i"
                    :src="`https://randomuser.me/api/portraits/${i % 2 ? 'women' : 'men'}/${i}.jpg`"
                    class="w-10 h-10 rounded-full border-2 border-white" alt="User avatar" />
                  <div
                    class="w-10 h-10 rounded-full bg-primary-50 flex items-center justify-center text-xs font-medium text-primary-600 border-2 border-white">
                    +5k
                  </div>
                </div>
                <div>
                  <div class="font-bold text-gray-900">Plus de 10 000 clients satisfaits</div>
                  <div class="text-gray-500">Rejoignez une communauté de confiance</div>
                </div>
              </div>
            </div>
            
            <!-- Enhanced action buttons with Twitter style -->
            <div class="pt-4 flex flex-col sm:flex-row gap-4">
              <NuxtLink to="/requests/new"
                class="bg-primary-600 hover:bg-primary-700 text-white px-6 py-3.5 rounded-full font-medium transition-all flex items-center justify-center">
                <FileText class="w-4 h-4 mr-2" />
                Publier une demande
              </NuxtLink>
              <NuxtLink to="/experts"
                class="bg-white text-gray-800 border border-gray-200 hover:bg-gray-50 px-6 py-3.5 rounded-full font-medium transition-all flex items-center justify-center">
                <Search class="w-4 h-4 mr-2" />
                Chercher un expert
              </NuxtLink>
            </div>
          </div>

          <!-- Enhanced image with Twitter-style cards -->
          <div class="relative">
            <div
              class="rounded-2xl overflow-hidden transform hover:scale-[1.02] transition-all duration-300 border border-gray-100">
              <div class="absolute inset-0 bg-gradient-to-tr from-primary-600/10 to-transparent z-10"></div>
              <img src="https://images.pexels.com/photos/3760263/pexels-photo-3760263.jpeg" alt="Service professionnel"
                class="w-full h-full object-cover" />
            </div>

            <!-- Enhanced rating card -->
            <div
              class="absolute -top-5 -right-5 bg-white rounded-xl border border-gray-100 p-4 flex items-center gap-3 transform hover:scale-105 transition-transform">
              <Star class="w-9 h-9 text-amber-400 fill-current" />
              <div>
                <div class="text-xs text-gray-500 font-medium">Note moyenne</div>
                <div class="text-2xl font-bold text-primary-600">4.9<span class="text-gray-400 text-lg">/5</span></div>
              </div>
            </div>
            
            <!-- Enhanced experts card -->
            <div
              class="absolute bottom-6 -left-6 bg-white rounded-xl border border-gray-100 p-4 transform hover:scale-105 transition-transform">
              <div class="text-xs text-gray-500 font-medium">Experts disponibles</div>
              <div class="text-2xl font-bold text-primary-600">2,500<span class="text-primary-400 text-lg">+</span>
              </div>
            </div>
            
            <!-- Enhanced availability card -->
            <div
              class="absolute -bottom-5 right-10 bg-white rounded-xl border border-gray-100 p-4 transform hover:scale-105 transition-transform">
              <div class="text-xs text-gray-500 font-medium">Interventions</div>
              <div class="text-2xl font-bold text-primary-600">24/7</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Enhanced CTA section -->
    <section class="py-20 bg-gradient-to-r from-primary-600 to-primary-700 relative overflow-hidden">
      <!-- Background elements -->
      <div class="absolute top-0 right-0 w-40 h-40 rounded-full bg-white/10 -translate-y-1/2 translate-x-1/2"></div>
      <div class="absolute bottom-0 left-0 w-40 h-40 rounded-full bg-white/10 translate-y-1/2 -translate-x-1/2"></div>

      <div class="max-w-4xl mx-auto px-4 text-center relative z-10">
        <h2 class="text-3xl font-bold text-white mb-5">Vous êtes un professionnel ?</h2>
        <p class="text-white/90 text-xl max-w-3xl mx-auto mb-8">
          Rejoignez notre communauté d'experts et développez votre activité. Accédez à des clients qualifiés sans
          démarche commerciale.
        </p>
        <NuxtLink to="/register-expert"
          class="bg-white text-primary-600 px-8 py-4 rounded-full font-medium hover:bg-white/90 transition-all inline-flex items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="mr-3 text-primary-600" width="24" height="24"
            viewBox="0 0 24 24">
            <path fill="currentColor" fill-rule="evenodd"
              d="M2.901 22.006h10.18c.41 0 .75-.34.75-.75s-.34-.75-.75-.75H2.892c-.09 0-.16-.05-.16-.06a3.33 3.33 0 0 1 2.25-2.36l3.72-1.12c.31-.1.53-.39.53-.72v-1.94c0-.23-.11-.45-.29-.59c-1.67-1.31-2.71-2.78-2.71-6.05c0-3.01 1.5-4.67 4.24-4.67c1.742 0 2.464.723 2.49.75c.14.16.35.25.56.25c1.36 0 2.21.61 2.21 3.67c0 3.28-1.04 4.74-2.71 6.05c-.18.14-.29.36-.29.59v1.94c0 .41.34.75.75.75s.75-.34.75-.75v-1.58c1.59-1.31 3-3.13 3-7c0-1.37 0-4.96-3.41-5.16c-.46-.37-1.51-1.01-3.34-1.01c-3.59 0-5.74 2.3-5.74 6.17s1.41 5.69 3 7v1.02l-3.18.96c-1.6.49-2.86 1.8-3.27 3.43c-.11.46-.02.92.27 1.29c.31.4.81.64 1.34.64m14.849.25c0 .41.34.75.75.75s.75-.34.75-.75v-2.75H22c.41 0 .75-.34.75-.75s-.34-.75-.75-.75h-2.75v-2.75c0-.41-.34-.75-.75-.75s-.75.34-.75.75v2.75H15c-.41 0-.75.34-.75.75s.34.75.75.75h2.75z"
              color="currentColor" />
          </svg> Devenir expert
        </NuxtLink>

        <!-- Social proof -->
        <div class="mt-10 flex flex-wrap justify-center gap-8">
          <div class="text-white">
            <div class="text-3xl font-bold">10k+</div>
            <div class="text-white/80">Clients</div>
          </div>
          <div class="text-white">
            <div class="text-3xl font-bold">2.5k+</div>
            <div class="text-white/80">Experts</div>
          </div>
          <div class="text-white">
            <div class="text-3xl font-bold">50k+</div>
            <div class="text-white/80">Services</div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { 
  User, 
  Search, 
  FileText, 
  ArrowRight, 
  ChevronDown,
  Shield,
  BadgeCheck,
  Clock,
  Star
} from 'lucide-vue-next'
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

// Données de service améliorées
const services = [
  {
    id: 'menage',
    name: 'Ménage',
    icon: '🧹',
    description: 'Entretien de votre domicile'
  },
  {
    id: 'jardinage',
    name: 'Jardinage',
    icon: '🌱',
    description: 'Entretien de vos espaces verts'
  },
  {
    id: 'bricolage',
    name: 'Bricolage',
    icon: '🔨',
    description: 'Réparations et installations'
  },
  {
    id: 'garde',
    name: "Garde d'enfants",
    icon: '👶',
    description: 'Garde et accompagnement'
  },
  {
    id: 'cours',
    name: "Cours particuliers",
    icon: '📚',
    description: 'Soutien scolaire'
  },
  {
    id: 'demenagement',
    name: "Déménagement",
    icon: '📦',
    description: 'Assistance au déménagement'
  }
]
</script>

<style scoped>
.bg-grid-pattern {}

/* Animation de brillance GAFAM */
@keyframes shine {
  100% {
    left: 125%;
  }
}

.animate-shine {
  animation: shine 1.5s;
}
</style>