<template>
  <div class="min-h-screen">
    <!-- Hero Section Version Fond Blanc -->
    <section class="relative bg-white overflow-hidden">
      <!-- Motif de fond subtil -->
      <div class="absolute inset-0 bg-grid-pattern opacity-5"></div>
      <!-- Formes décoratives -->
      <div class="absolute top-20 right-20 w-64 h-64 rounded-full bg-primary-100 blur-3xl opacity-50"></div>
      <div class="absolute bottom-20 left-20 w-64 h-64 rounded-full bg-blue-100 blur-3xl opacity-50"></div>
      
      <div class="relative max-w-7xl mx-auto px-4 py-24 sm:py-32">
        <div class="text-center max-w-4xl mx-auto">
          <!-- Titre principal en noir -->
          <h1 class="text-5xl sm:text-6xl font-bold text-gray-900 tracking-tight">
            Services à domicile
            <span class="block mt-2 bg-clip-text text-transparent bg-gradient-to-r from-primary-600 to-blue-600">
              Simple. Rapide. Fiable.
            </span>
          </h1>

          <!-- Sous-titre avec chiffres d'impact -->
          <p class="mt-8 text-xl text-gray-600 leading-relaxed">
            Rejoignez plus de <span class="font-bold text-primary-600">10 000</span> clients satisfaits et <span class="font-bold text-blue-600">2 500</span> experts qualifiés 
          </p>

          <!-- Options principales - version GAFAM pure -->
          <div class="mt-10 grid sm:grid-cols-2 gap-6 max-w-3xl mx-auto">
            <!-- Chercher un expert - simplifié -->
            <div class="relative group overflow-hidden rounded-2xl border border-gray-100 transform transition-transform duration-300">
              <NuxtLink 
                to="/experts"
                class="w-full h-full flex flex-col items-center p-8 bg-blue-50 transition-colors duration-300 relative z-10 overflow-hidden group-hover:bg-blue-100"
              >
                <!-- Icône pure -->
                <div class="w-20 h-20 bg-blue-100 rounded-2xl flex items-center justify-center mb-6 group-hover:bg-blue-200 transition-colors">
                  <Search class="w-10 h-10 text-blue-600" />
                </div>
                <h2 class="text-2xl font-bold text-gray-900 mb-3">Chercher un expert</h2>
                <p class="text-gray-600 text-base mb-6 max-w-xs">
                  Trouvez le professionnel idéal en quelques clics
                </p>
                
                <!-- Bouton plus impactant -->
                <div class="mt-auto w-full">
                  <span class="w-full py-3 bg-blue-600 text-white font-medium rounded-xl inline-flex items-center justify-center group-hover:bg-blue-700 transition-colors text-base">
                    Commencer
                    <ArrowRight class="w-4 h-4 ml-2" />
                  </span>
                </div>
              </NuxtLink>
            </div>

            <!-- Publier une demande - simplifié -->
            <div class="relative group overflow-hidden rounded-2xl border border-gray-100 transform transition-transform duration-300">
              <NuxtLink 
                to="/requests/new"
                class="w-full h-full flex flex-col items-center p-8 bg-primary-50 transition-colors duration-300 relative z-10 overflow-hidden group-hover:bg-primary-100"
              >
                <!-- Icône pure -->
                <div class="w-20 h-20 bg-primary-100 rounded-2xl flex items-center justify-center mb-6 group-hover:bg-primary-200 transition-colors">
                  <FileText class="w-10 h-10 text-primary-600" />
                </div>
                <h2 class="text-2xl font-bold text-gray-900 mb-3">Publier une demande</h2>
                <p class="text-gray-600 text-base mb-6 max-w-xs">
                  Décrivez votre besoin et recevez des propositions
                </p>
                
                <!-- Bouton plus impactant -->
                <div class="mt-auto w-full">
                  <span class="w-full py-3 bg-primary-600 text-white font-medium rounded-xl inline-flex items-center justify-center group-hover:bg-primary-700 transition-colors text-base">
                    Commencer
                    <ArrowRight class="w-4 h-4 ml-2" />
                  </span>
                </div>
              </NuxtLink>
            </div>
          </div>

          <!-- Services populaires - version claire -->
          <div class="mt-16 text-center">
            <h3 class="text-gray-700 font-medium mb-6">Services populaires</h3>
            <div class="flex flex-wrap justify-center gap-3">
              <NuxtLink 
                v-for="service in services" 
                :key="service.id"
                :to="`/experts?service=${service.id}`"
                class="bg-gray-100 hover:bg-gray-200 transition-colors px-4 py-2 rounded-full flex items-center shadow-sm"
              >
                <span class="mr-2">{{ service.icon }}</span>
                <span class="text-gray-800">{{ service.name }}</span>
              </NuxtLink>
            </div>
          </div>

          <!-- Scroll indicator -->
          <div class="absolute bottom-8 left-1/2 -translate-x-1/2 animate-bounce">
            <ChevronDown class="w-6 h-6 text-gray-400" />
          </div>
        </div>
      </div>
    </section>

    <!-- Comment ça marche - Style GAFAM -->
    <section class="py-20 bg-white dark:bg-black relative overflow-hidden">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- En-tête de section -->
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white">
            Comment ça fonctionne
          </h2>
          <p class="mt-4 text-xl text-gray-600 dark:text-gray-300 max-w-3xl mx-auto">
            Un processus simple en trois étapes pour obtenir l'aide dont vous avez besoin
          </p>
        </div>

        <!-- Étapes avec illustrations de style GAFAM -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 lg:gap-12">
          <!-- Étape 1 -->
          <div class="bg-gray-50 dark:bg-gray-900 rounded-3xl p-8 text-center card-gafam relative">
            <div class="absolute top-0 right-0 -mt-4 -mr-4 bg-primary-500 text-white h-12 w-12 rounded-full flex items-center justify-center font-bold text-xl shadow-lg">1</div>
            <div class="h-32 flex items-center justify-center mb-6">
              <SearchIcon class="h-20 w-20 text-primary-500" />
            </div>
            <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3">
              Décrivez votre besoin
            </h3>
            <p class="text-gray-600 dark:text-gray-300">
              Publiez votre demande en détaillant votre problème et vos attentes. Notre système intelligent vous guide.
            </p>
          </div>

          <!-- Étape 2 -->
          <div class="bg-gray-50 dark:bg-gray-900 rounded-3xl p-8 text-center card-gafam relative">
            <div class="absolute top-0 right-0 -mt-4 -mr-4 bg-primary-500 text-white h-12 w-12 rounded-full flex items-center justify-center font-bold text-xl shadow-lg">2</div>
            <div class="h-32 flex items-center justify-center mb-6">
              <UsersIcon class="h-20 w-20 text-primary-500" />
            </div>
            <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3">
              Connectez avec des experts
            </h3>
            <p class="text-gray-600 dark:text-gray-300">
              Recevez des propositions d'experts qualifiés et vérifiés. Consultez leurs profils et évaluations.
            </p>
          </div>

          <!-- Étape 3 -->
          <div class="bg-gray-50 dark:bg-gray-900 rounded-3xl p-8 text-center card-gafam relative">
            <div class="absolute top-0 right-0 -mt-4 -mr-4 bg-primary-500 text-white h-12 w-12 rounded-full flex items-center justify-center font-bold text-xl shadow-lg">3</div>
            <div class="h-32 flex items-center justify-center mb-6">
              <CheckCircleIcon class="h-20 w-20 text-primary-500" />
            </div>
            <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-3">
              Problème résolu
            </h3>
            <p class="text-gray-600 dark:text-gray-300">
              Collaborez efficacement via notre plateforme sécurisée et obtenez des résultats garantis.
            </p>
          </div>
        </div>

        <!-- CTA dans la section -->
        <div class="mt-16 text-center">
          <NuxtLink 
            to="/requests/new" 
            class="btn-gafam inline-flex items-center px-8 py-4 bg-primary-600 text-white font-medium rounded-full hover:bg-primary-700 shadow-md hover:shadow-lg transition-all duration-300"
          >
            Créer une demande
            <ArrowRight class="ml-2 h-5 w-5" />
          </NuxtLink>
        </div>
      </div>

      <!-- Formes décoratives de style GAFAM -->
      <div class="absolute top-1/4 left-0 w-64 h-64 rounded-full bg-primary-100 dark:bg-primary-900/20 -translate-x-1/2 blur-3xl opacity-50"></div>
      <div class="absolute bottom-1/3 right-0 w-96 h-96 rounded-full bg-blue-100 dark:bg-blue-900/20 translate-x-1/2 blur-3xl opacity-40"></div>
    </section>

    <!-- CTA Section - version améliorée -->
    <section class="py-20 bg-white">
      <div class="max-w-7xl mx-auto px-4">
        <div class="grid lg:grid-cols-2 gap-12 items-center">
          <!-- Texte -->
          <div class="space-y-6">
            <h2 class="text-4xl font-bold text-gray-900 tracking-tight">
              La qualité au service 
              <span class="block text-primary-600">de votre quotidien</span>
            </h2>
            <div class="space-y-4 text-lg text-gray-600">
              <p class="flex items-start gap-3">
                <Shield class="w-6 h-6 text-primary-600 shrink-0 mt-1" />
                <span>Tous nos experts sont vérifiés et évalués par notre communauté</span>
              </p>
              <p class="flex items-start gap-3">
                <BadgeCheck class="w-6 h-6 text-primary-600 shrink-0 mt-1" />
                <span>Satisfaction garantie ou remboursé sous 24h</span>
              </p>
              <p class="flex items-start gap-3">
                <Clock class="w-6 h-6 text-primary-600 shrink-0 mt-1" />
                <span>Réponse rapide et intervention dans les 24-48h</span>
              </p>
            </div>
            <div class="pt-2">
              <div class="flex items-center gap-4">
                <div class="flex -space-x-2">
                  <img 
                    v-for="i in 4" 
                    :key="i"
                    :src="`https://randomuser.me/api/portraits/${i % 2 ? 'women' : 'men'}/${i}.jpg`"
                    class="w-10 h-10 rounded-full border-2 border-white"
                    alt="User avatar"
                  />
                </div>
                <div class="text-sm">
                  <div class="font-medium text-gray-900">Plus de 10 000 clients satisfaits</div>
                  <div class="text-gray-500">Rejoignez une communauté de confiance</div>
                </div>
              </div>
            </div>
            
            <!-- Boutons d'action - NOUVEAU -->
            <div class="pt-4 flex flex-col sm:flex-row gap-4">
              <button @click="openRequestModal" class="bg-primary-500 hover:bg-primary-600 text-white px-6 py-3 rounded-lg font-medium transition-colors flex items-center justify-center">
                <FileText class="w-5 h-5 mr-2" />
                Publier une demande
              </button>
              <button @click="openSearchModal" class="border border-primary-500 text-primary-600 hover:bg-primary-50 px-6 py-3 rounded-lg font-medium transition-colors flex items-center justify-center">
                <Search class="w-5 h-5 mr-2" />
                Chercher un expert
              </button>
            </div>
          </div>

          <!-- Image avec badges flottants -->
          <div class="relative lg:h-[500px]">
            <img 
              src="https://images.pexels.com/photos/3760263/pexels-photo-3760263.jpeg"
              alt="Service professionnel"
              class="w-full h-full object-cover rounded-2xl shadow-2xl"
            />
            <!-- Overlay gradient -->
            <div class="absolute inset-0 rounded-2xl bg-gradient-to-tr from-primary-600/20 to-transparent"></div>
            
            <!-- Badge flottant - note -->
            <div class="absolute -top-6 -right-6 bg-white rounded-2xl shadow-xl p-4 flex items-center gap-3">
              <Star class="w-8 h-8 text-yellow-400 fill-current" />
              <div>
                <div class="font-medium text-gray-900">Note moyenne</div>
                <div class="text-2xl font-bold text-primary-600">4.9/5</div>
              </div>
            </div>
            
            <!-- Badge flottant - experts -->
            <div class="absolute bottom-6 -left-6 bg-white rounded-2xl shadow-xl p-4">
              <div class="font-medium text-gray-900">Experts disponibles</div>
              <div class="text-2xl font-bold text-primary-600">2,500+</div>
            </div>
            
            <!-- Badge flottant - interventions -->
            <div class="absolute -bottom-6 right-12 bg-white rounded-2xl shadow-xl p-4">
              <div class="font-medium text-gray-900">Interventions</div>
              <div class="text-2xl font-bold text-primary-600">24/7</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Devenir expert - NOUVEAU -->
    <section class="py-16 bg-primary-500">
      <div class="max-w-5xl mx-auto px-4 text-center">
        <h2 class="text-3xl font-bold text-white mb-6">Vous êtes un professionnel ?</h2>
        <p class="text-white/90 text-lg max-w-3xl mx-auto mb-8">
          Rejoignez notre communauté d'experts et développez votre activité. Accédez à des clients qualifiés sans démarche commerciale.
        </p>
        <NuxtLink 
          to="/register-expert" 
          class="bg-white text-primary-600 px-8 py-3 rounded-lg font-medium hover:bg-white/90 transition-colors inline-flex items-center"
        >
          <User class="w-5 h-5 mr-2" />
          Devenir expert
        </NuxtLink>
      </div>
    </section>
    
    <!-- Modales pour inscription - seraient implémentées séparément -->
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
  Star,
  ArrowLeft,
  Search as SearchIcon,
  Users as UsersIcon
} from 'lucide-vue-next'
import { ref } from 'vue'

// Données de service améliorées
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
  },
  {
    id: 'cours',
    name: "Cours particuliers",
    icon: '📚',
    price: 'Dès 1200 FCFA',
    description: 'Soutien scolaire'
  },
  {
    id: 'demenagement',
    name: "Déménagement",
    icon: '📦',
    price: 'Dès 2000 FCFA',
    description: 'Assistance au déménagement'
  }
]

// Les fonctions pour les modales ne sont plus nécessaires car nous utilisons des liens directs
</script>

<style scoped>
.bg-grid-pattern {
  background-image: url("data:image/svg+xml,%3Csvg width='40' height='40' viewBox='0 0 40 40' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23000' fill-opacity='0.1' fill-rule='evenodd'%3E%3Ccircle cx='2' cy='2' r='1'/%3E%3C/g%3E%3C/svg%3E");
}

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