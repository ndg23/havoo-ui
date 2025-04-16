<template>
  <div class="min-h-screen bg-white dark:bg-black">
    <!-- Hero Section with Apple-inspired design and Twitter impact -->
    <section class="relative bg-white dark:bg-black overflow-hidden">
      <!-- Subtle gradient background effect -->
      <div class="absolute inset-0 bg-gradient-to-br from-gray-50 to-white dark:from-gray-950 dark:to-black opacity-80"></div>
      
      <!-- Apple-style floating blur elements -->
      <div class="absolute top-40 right-20 w-80 h-80 rounded-full bg-primary-100 blur-3xl opacity-20 dark:opacity-10"></div>
      <div class="absolute bottom-20 left-40 w-64 h-64 rounded-full bg-blue-100 blur-3xl opacity-20 dark:opacity-10"></div>

      <div class="relative max-w-4xl mx-auto px-4 py-32 sm:py-40">
        <div class="text-center">
          <!-- Apple-style headline with refined spacing -->
          <h1 class="text-5xl sm:text-6xl font-bold tracking-tight text-gray-900 dark:text-white">
            Services à domicile
            <span class="block mt-4 bg-clip-text text-transparent bg-gradient-to-r from-primary-500 to-blue-500 dark:from-primary-400 dark:to-blue-400">
              Simple. Rapide. Fiable.
            </span>
          </h1>

          <!-- Twitter-style metrics highlight with Apple refinement -->
          <p class="mt-8 text-xl text-gray-600 dark:text-gray-300">
            Rejoignez plus de <span class="font-bold px-1.5 py-0.5 rounded-md bg-primary-50 dark:bg-primary-900/30 text-primary-700 dark:text-primary-400">10 000</span> clients satisfaits et <span class="font-bold px-1.5 py-0.5 rounded-md bg-primary-50 dark:bg-primary-900/30 text-primary-700 dark:text-primary-400">2 500</span> experts qualifiés
          </p>

          <!-- Apple-style clean buttons with Twitter impact -->
          <div class="mt-16 flex flex-col sm:flex-row justify-center gap-6 relative z-10">
            <NuxtLink to="/requests/new"
              class="bg-primary-600 hover:bg-primary-700 dark:bg-primary-500 dark:hover:bg-primary-600 text-white px-8 py-4 rounded-full font-medium text-lg transition-all flex items-center justify-center s">
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
              class="bg-white dark:bg-gray-900 text-gray-800 dark:text-gray-200 border border-gray-200 dark:border-gray-800 hover:bg-gray-50 dark:hover:bg-gray-800 px-8 py-4 rounded-full font-medium text-lg transition-all flex items-center justify-center s">
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
        </div>
      </div>

      <!-- Apple-style elegant stats display -->
      <!-- <div class="mt-24 grid grid-cols-3 gap-8 max-w-3xl mx-auto pb-32">
        <div class="text-center flex flex-col items-center">
          <div class="text-5xl font-bold mb-3 text-gray-900 dark:text-white bg-clip-text text-transparent bg-gradient-to-r from-primary-500 to-primary-600 dark:from-primary-400 dark:to-primary-500">10k+</div>
          <div class="text-gray-600 dark:text-gray-400">Clients satisfaits</div>
        </div>
        <div class="text-center flex flex-col items-center">
          <div class="text-5xl font-bold mb-3 text-gray-900 dark:text-white bg-clip-text text-transparent bg-gradient-to-r from-primary-500 to-primary-600 dark:from-primary-400 dark:to-primary-500">2.5k+</div>
          <div class="text-gray-600 dark:text-gray-400">Experts qualifiés</div>
        </div>
        <div class="text-center flex flex-col items-center">
          <div class="text-5xl font-bold mb-3 text-gray-900 dark:text-white bg-clip-text text-transparent bg-gradient-to-r from-primary-500 to-primary-600 dark:from-primary-400 dark:to-primary-500">4.9</div>
          <div class="text-gray-600 dark:text-gray-400">Note moyenne</div>
        </div>
      </div> -->

      <!-- Refined scroll indicator -->
      <div class="absolute bottom-10 left-1/2 -translate-x-1/2 animate-bounce">
        <ChevronDown class="w-6 h-6 text-gray-400 dark:text-gray-500" />
      </div>
    </section>

    <!-- Services Section with Apple-style cards -->
    <section class="py-32 bg-gray-50 dark:bg-gray-950">
      <div class="max-w-6xl mx-auto px-4">
        <h2 class="text-4xl font-bold text-center mb-24 text-gray-900 dark:text-white">
          Des services pour chaque besoin
        </h2>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-10">
          <div 
            v-for="service in services" 
            :key="service.id"
            class="group relative bg-white dark:bg-black rounded-3xl p-10 overflow-hidden hover:scale-[1.03] transition-transform shadow-lg shadow-gray-200/50 dark:shadow-gray-900/20 border border-gray-100 dark:border-gray-800"
          >
            <div class="text-5xl mb-6">{{ service.icon }}</div>
            <h3 class="text-2xl font-semibold mb-3 text-gray-900 dark:text-white">{{ service.name }}</h3>
            <p class="text-gray-600 dark:text-gray-400">{{ service.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- How it works with Apple-style clean visual steps -->
    <section class="py-32 bg-white dark:bg-black">
      <div class="max-w-6xl mx-auto px-4">
        <h2 class="text-4xl font-bold text-center mb-24 text-gray-900 dark:text-white">
          Simplicité. À chaque étape.
        </h2>

        <div class="space-y-40">
          <div 
            v-for="(step, index) in steps" 
            :key="index"
            class="flex flex-col lg:flex-row items-center gap-20"
          >
            <div class="lg:w-1/2 space-y-8">
              <div class="text-9xl font-bold text-gray-100 dark:text-gray-900">{{ index + 1 }}</div>
              <h3 class="text-3xl font-bold text-gray-900 dark:text-white">{{ step.title }}</h3>
              <p class="text-xl text-gray-600 dark:text-gray-400">{{ step.description }}</p>
            </div>
            <div class="lg:w-1/2">
              <img 
                :src="step.image" 
                :alt="step.title"
                class="rounded-3xl shadow-2xl dark:shadow-gray-900/50 hover:scale-[1.02] transition-transform"
              />
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Twitter-style impactful CTA with Apple refinement -->
    <section class="py-32 bg-gradient-to-b from-gray-50 to-white dark:from-gray-950 dark:to-black text-center">
      <div class="max-w-4xl mx-auto px-4">
        <h2 class="text-4xl font-bold mb-8 text-gray-900 dark:text-white">Prêt à commencer ?</h2>
        <p class="text-xl text-gray-600 dark:text-gray-400 mb-16">
          Rejoignez la révolution des services à domicile.
        </p>
        <NuxtLink 
          to="/requests/new"
          class="inline-flex items-center px-10 py-5 bg-primary-600 hover:bg-primary-700 dark:bg-primary-500 dark:hover:bg-primary-600 text-white rounded-full text-lg font-medium transition-colors gap-3 shadow-xl shadow-primary-500/20 dark:shadow-primary-500/10"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24">
            <path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v14m-7-7h14"/>
          </svg>
          Publier une demande
          <ArrowRight class="ml-2 w-6 h-6" />
        </NuxtLink>
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

// Services with refined descriptions
const services = [
  {
    id: 'menage',
    name: 'Ménage',
    icon: '🧹',
    description: 'Entretien impeccable de votre domicile par des experts qualifiés'
  },
  {
    id: 'jardinage',
    name: 'Jardinage',
    icon: '🌱',
    description: 'Transformation et entretien de vos espaces verts'
  },
  {
    id: 'bricolage',
    name: 'Bricolage',
    icon: '🔨',
    description: 'Solutions professionnelles pour vos projets et réparations'
  },
  {
    id: 'garde',
    name: "Garde d'enfants",
    icon: '👶',
    description: 'Accompagnement bienveillant et éducatif pour vos enfants'
  },
  {
    id: 'cours',
    name: "Cours particuliers",
    icon: '📚',
    description: 'Soutien scolaire personnalisé pour tous les niveaux'
  },
  {
    id: 'demenagement',
    name: "Déménagement",
    icon: '📦',
    description: 'Organisation et assistance complète pour votre déménagement'
  }
]

// Enhanced steps with better descriptions
const steps = [
  {
    title: "Décrivez votre besoin",
    description: "Une interface épurée pour préciser vos besoins en quelques clics. Simple, rapide et intuitive.",
    image: "https://images.pexels.com/photos/6615722/pexels-photo-6615722.jpeg"
  },
  {
    title: "Connectez avec des experts",
    description: "Notre algorithme avancé vous propose les meilleurs experts disponibles selon vos critères spécifiques.",
    image: "https://images.pexels.com/photos/3184405/pexels-photo-3184405.jpeg"
  },
  {
    title: "Profitez du service",
    description: "Recevez un service d'excellence avec une satisfaction garantie et un suivi attentif.",
    image: "https://images.pexels.com/photos/7415061/pexels-photo-7415061.jpeg"
  }
]
</script>

<style scoped>
/* Apple-style smooth animations */
.transition-all {
  transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
}

/* Enhanced parallax effect */
.parallax {
  transform: translateZ(0);
  will-change: transform;
}

/* Apple-style blur effect */
.blur-backdrop {
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
}

/* Twitter-style dynamic dark mode glass effect */
.dark .glass-effect {
  background: rgba(10, 10, 15, 0.75);
  backdrop-filter: blur(24px);
}

/* Apple elastic hover animation */
@keyframes elastic-hover {
  0% { transform: scale(1); }
  50% { transform: scale(1.04); }
  100% { transform: scale(1.03); }
}

.hover-elastic:hover {
  animation: elastic-hover 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
</style>