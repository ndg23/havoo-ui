<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête minimaliste style Twitter -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Explorer les demandes</h1>
    </div>

    <!-- Filtres et recherche en style pills avec plus de couleur -->
    <div class="sticky top-0 z-10 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm py-3 -mx-4 px-4 mb-4">
      <div class="flex items-center justify-between gap-4 overflow-x-auto pb-2 no-scrollbar">
        <div class="flex gap-2">
          <button 
            v-for="filter in filters" 
            :key="filter"
            class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors"
            :class="activeFilter === filter ? 
              'bg-primary-600 text-white dark:bg-primary-500' : 
              'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200 hover:bg-gray-200 dark:hover:bg-gray-700'"
            @click="setActiveFilter(filter)"
          >
            {{ filter }}
          </button>
        </div>

        <div class="relative">
          <Search class="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
          <input 
            type="text" 
            placeholder="Rechercher..."
            v-model="searchQuery"
            class="pl-10 pr-4 py-2 w-44 rounded-full border border-gray-200 dark:border-gray-700 bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          />
        </div>
      </div>
    </div>

    <!-- État de chargement -->
    <div v-if="isLoading" class="flex justify-center items-center py-20">
      <div class="h-10 w-10 border-4 border-gray-200 dark:border-gray-700 border-t-primary-500 dark:border-t-primary-400 rounded-full animate-spin"></div>
    </div>

    <!-- Aucune demande trouvée -->
    <div v-else-if="filteredRequests.length === 0" class="py-16 text-center">
      <div class="mb-4 flex justify-center">
        <div class="bg-primary-50 dark:bg-primary-900/20 p-4 rounded-full">
          <SearchX class="h-8 w-8 text-primary-500 dark:text-primary-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune demande trouvée</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-sm mx-auto">
        Aucune demande ne correspond à votre recherche
      </p>
    </div>

    <!-- Liste des demandes style Twitter avec séparation horizontale -->
    <div v-else>
      <div v-for="(request, index) in filteredRequests" :key="request.id" 
        class="py-5 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-all"
        :class="{ 'border-b border-gray-200 dark:border-gray-700': index !== filteredRequests.length - 1 }">
        <!-- En-tête avec avatar et nom -->
        <div class="flex items-center mb-3">
          <img 
            :src="request.avatar || '/img/default-avatar.png'" 
            :alt="request.clientName"
            class="w-10 h-10 rounded-full object-cover border border-gray-100 dark:border-gray-700"
          />
          <div class="ml-3">
            <span class="font-semibold text-gray-900 dark:text-white">{{ request.clientName }}</span>
            <div class="flex items-center text-xs text-gray-500 dark:text-gray-400">
              <span>{{ request.postedTime }}</span>
              <span class="mx-1">•</span>
              <span class="text-primary-600 dark:text-primary-400 font-medium">{{ request.category }}</span>
            </div>
          </div>
        </div>

        <!-- Contenu de la demande -->
        <div class="mb-3 cursor-pointer" @click="viewRequestDetails(request.id)">
          <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-2">{{ request.title }}</h3>
          <p class="text-gray-700 dark:text-gray-300 mb-3 line-clamp-2">{{ request.description }}</p>

          <!-- Tags avec couleurs -->
          <div class="flex flex-wrap gap-1.5 mb-3">
            <span 
              v-for="(tag, tagIndex) in request.tags" 
              :key="tagIndex" 
              class="rounded-full px-3 py-1 text-xs font-medium"
              :class="getTagColor(tagIndex)"
            >
              {{ tag }}
            </span>
          </div>
          
          <!-- Indicateurs -->
          <div class="flex items-center justify-between mt-4">
            <!-- Budget avec couleur -->
            <div class="font-bold text-xl text-primary-600 dark:text-primary-400">{{ request.budget }}</div>
            
            <!-- Deadline -->
            <div :class="['flex items-center text-xs px-2 py-1 rounded-full', request.isUrgent ? 'bg-red-100 text-red-600 dark:bg-red-900/20 dark:text-red-400' : 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300']">
              <Clock class="h-3.5 w-3.5 mr-1" />
              <span>{{ request.deadline }}</span>
            </div>
          </div>
        </div>

        <!-- Pied avec engagement et action -->
        <div class="flex items-center justify-between mt-4">
          <div class="text-sm text-gray-500 dark:text-gray-400 flex items-center">
            <MessageSquare class="h-4 w-4 mr-1.5" />
            <span>{{ request.proposalCount }} proposition{{ request.proposalCount !== 1 ? 's' : '' }}</span>
          </div>

          <button class="px-4 py-2 bg-primary-600 hover:bg-primary-700 dark:bg-primary-500 dark:hover:bg-primary-600 text-white rounded-full text-sm font-medium transition-transform hover:scale-105">
            Proposer mes services
          </button>
        </div>
      </div>
    </div>

    <!-- Bouton flottant pour créer une nouvelle demande avec couleur -->
    <button @click="navigateToNewRequest" class="fixed bottom-6 right-6 w-14 h-14 bg-primary-600 hover:bg-primary-700 text-white rounded-full shadow-lg flex items-center justify-center hover:scale-105 transition-transform">
      <Plus class="h-6 w-6" />
    </button>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import {
  Search,
  SearchX,
  Plus,
  MessageSquare,
  Clock
} from 'lucide-vue-next';

const router = useRouter();
const isLoading = ref(false);
const searchQuery = ref('');

// Catégories/Filtres
const filters = ['Tous', 'Bricolage', 'Informatique', 'Transport', 'Ménage', 'Cours', 'Beauté', 'Événementiel'];
const activeFilter = ref('Tous');

// Données simulées des demandes
const requests = ref([
  {
    id: 1,
    avatar: '/img/avatars/user1.jpg',
    clientName: 'Amadou D.',
    isVerified: true,
    postedTime: 'Il y a 2h',
    title: 'Réparation fuite robinet cuisine',
    description: 'Je recherche un plombier pour réparer une fuite au niveau du robinet de ma cuisine. Disponibilité souhaitée ce weekend.',
    tags: ['Plomberie', 'Réparation'],
    proposalCount: 3,
    budget: '25 000 FCFA',
    deadline: '3 jours',
    isUrgent: true,
    category: 'Bricolage'
  },
  {
    id: 2,
    avatar: '/img/avatars/user2.jpg',
    clientName: 'Sophie M.',
    isVerified: true,
    postedTime: 'Il y a 1j',
    title: 'Développement site web vitrine',
    description: 'Je souhaite créer un site vitrine pour mon entreprise de produits locaux. Design simple et moderne.',
    tags: ['WordPress', 'Développement web'],
    proposalCount: 1,
    budget: '350 000 FCFA',
    deadline: '30 jours',
    isUrgent: false,
    category: 'Informatique'
  },
  {
    id: 3,
    avatar: '/img/avatars/user3.jpg',
    clientName: 'Rama S.',
    isVerified: true,
    postedTime: 'Il y a 2j',
    title: "Cours d'anglais niveau intermédiaire",
    description: "Je cherche un professeur pour améliorer mon niveau d'anglais. 2 heures par semaine pendant 3 mois.",
    tags: ['Anglais', 'Cours'],
    proposalCount: 3,
    budget: '120 000 FCFA',
    deadline: 'Long terme',
    isUrgent: false,
    category: 'Cours'
  },
  {
    id: 4,
    avatar: '/img/avatars/user4.jpg',
    clientName: 'Fatou D.',
    isVerified: true,
    postedTime: 'Il y a 3j',
    title: 'Ménage complet appartement',
    description: 'Appartement 3 pièces à nettoyer entièrement, y compris vitres et balcon.',
    tags: ['Ménage', 'Nettoyage vitres'],
    proposalCount: 2,
    budget: '35 000 FCFA',
    deadline: '2 jours',
    isUrgent: true,
    category: 'Ménage'
  },
  {
    id: 5,
    avatar: '/img/avatars/user5.jpg',
    clientName: 'Abdoulaye T.',
    isVerified: true,
    postedTime: 'Il y a 4j',
    title: 'Réparation ordinateur portable',
    description: 'Mon ordinateur portable est très lent et crash régulièrement. Besoin d\'un diagnostic et réparation.',
    tags: ['Informatique', 'Réparation PC'],
    proposalCount: 1,
    budget: '30 000 FCFA',
    deadline: '1 jour',
    isUrgent: true,
    category: 'Informatique'
  }
]);

// Computed property pour filtrer les demandes
const filteredRequests = computed(() => {
  let filtered = requests.value;
  
  // Filtrer par catégorie
  if (activeFilter.value !== 'Tous') {
    filtered = filtered.filter(request => request.category === activeFilter.value);
  }
  
  // Filtrer par recherche
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(request => 
      request.title.toLowerCase().includes(query) || 
      request.description.toLowerCase().includes(query) ||
      request.tags.some(tag => tag.toLowerCase().includes(query))
    );
  }
  
  return filtered;
});

// Méthodes
const setActiveFilter = (filter) => {
  activeFilter.value = filter;
};

const navigateToNewRequest = () => {
  router.push('/requests/new');
};

const viewRequestDetails = (id) => {
  router.push(`/requests/${id}`);
};

// Fonction pour obtenir une couleur aléatoire mais cohérente pour les tags
const getTagColor = (index) => {
  const colors = [
    'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400',
    'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400',
    'bg-purple-100 text-purple-700 dark:bg-purple-900/30 dark:text-purple-400',
    'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400',
    'bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400',
    'bg-teal-100 text-teal-700 dark:bg-teal-900/30 dark:text-teal-400'
  ];
  
  return colors[index % colors.length];
};

// Simuler un chargement initial
onMounted(() => {
  isLoading.value = true;
  setTimeout(() => {
    isLoading.value = false;
  }, 800);
});

definePageMeta({
  layout: 'default'
});
</script>

<style scoped>
/* Masquer la barre de défilement tout en gardant la fonctionnalité */
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.no-scrollbar::-webkit-scrollbar {
  display: none;
}

/* Animation pour l'apparition des composants */
.py-5 {
  animation: fadeIn 0.3s ease-out;
  animation-fill-mode: both;
}

/* Animation séquentielle pour les items */
div > div:nth-child(1) { animation-delay: 0.05s; }
div > div:nth-child(2) { animation-delay: 0.1s; }
div > div:nth-child(3) { animation-delay: 0.15s; }
div > div:nth-child(4) { animation-delay: 0.2s; }
div > div:nth-child(5) { animation-delay: 0.25s; }

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>