<template>
  <div class="request-container">
    <h1 class="text-2xl font-bold mb-6">Requests Management</h1>
    
    <div class="filters mb-6">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
          <select v-model="filters.status" class="w-full border rounded-md px-3 py-2">
            <option value="">All</option>
            <option value="open">Open</option>
            <option value="assigned">Assigned</option>
            <option value="completed">Completed</option>
            <option value="cancelled">Cancelled</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Sort By</label>
          <select v-model="filters.sortBy" class="w-full border rounded-md px-3 py-2">
            <option value="created_at">Date Created</option>
            <option value="deadline">Deadline</option>
            <option value="budget">Budget</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
          <input 
            type="text" 
            v-model="filters.search" 
            placeholder="Search by title or description"
            class="w-full border rounded-md px-3 py-2"
          />
        </div>
      </div>
    </div>
    
    <div v-if="loading" class="flex justify-center my-8">
      <div class="loader">Loading...</div>
    </div>
    
    <div v-else-if="requests.length === 0" class="text-center py-10">
      <p class="text-gray-500">No requests found. Try adjusting your filters or create a new request.</p>
      <button 
        @click="navigateToNewRequest" 
        class="mt-4 px-4 py-2 bg-primary text-white rounded-md hover:bg-primary-dark"
      >
        Create New Request
      </button>
    </div>
    
    <div v-else class="requests-list">
      <div v-for="request in filteredRequests" :key="request.id" class="request-card bg-white p-6 rounded-lg shadow-md mb-4 hover:shadow-lg transition-shadow">
        <div class="flex justify-between items-start">
          <div>
            <h2 class="text-xl font-semibold">{{ request.title }}</h2>
            <div class="mt-2 text-gray-600">
              <p class="line-clamp-2">{{ request.description }}</p>
            </div>
          </div>
          <div class="flex flex-col items-end">
            <span class="status-badge" :class="getStatusClass(request.status)">
              {{ request.status }}
            </span>
            <span class="mt-2 font-medium">{{ formatCurrency(request.budget) }}</span>
            <span class="text-sm text-gray-500">Deadline: {{ formatDate(request.deadline) }}</span>
          </div>
        </div>
        
        <div class="mt-4 flex flex-wrap gap-2">
          <span v-for="(skill, index) in request.skills_required" :key="index" class="skill-tag">
            {{ skill }}
          </span>
        </div>
        
        <div class="mt-4 pt-4 border-t flex justify-between">
          <span class="text-sm text-gray-500">Posted: {{ formatDate(request.created_at) }}</span>
          <button 
            @click="viewRequest(request.id)" 
            class="px-4 py-1 bg-primary text-white rounded-md text-sm hover:bg-primary-dark"
          >
            View Details
          </button>
        </div>
      </div>
    </div>
    
    <div v-if="requests.length > 0" class="pagination mt-8 flex justify-center">
      <!-- Pagination controls -->
      <button 
        @click="page > 1 && (page--)" 
        :disabled="page === 1"
        class="px-3 py-1 mx-1 border rounded-md" 
        :class="page === 1 ? 'text-gray-400 cursor-not-allowed' : 'text-gray-700 hover:bg-gray-100'"
      >
        Previous
      </button>
      <span class="px-3 py-1 mx-1">Page {{ page }} of {{ totalPages }}</span>
      <button 
        @click="page < totalPages && (page++)" 
        :disabled="page === totalPages"
        class="px-3 py-1 mx-1 border rounded-md"
        :class="page === totalPages ? 'text-gray-400 cursor-not-allowed' : 'text-gray-700 hover:bg-gray-100'"
      >
        Next
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const requests = ref([]);
const loading = ref(true);
const page = ref(1);
const perPage = ref(10);
const totalItems = ref(0);

const filters = ref({
  status: '',
  sortBy: 'created_at',
  search: ''
});

// Computed properties
const totalPages = computed(() => Math.ceil(totalItems.value / perPage.value));

const filteredRequests = computed(() => {
  // Filter requests based on filters
  let filtered = [...requests.value];
  
  // Filter by status
  if (filters.value.status) {
    filtered = filtered.filter(req => req.status === filters.value.status);
  }
  
  // Filter by search term
  if (filters.value.search) {
    const searchTerm = filters.value.search.toLowerCase();
    filtered = filtered.filter(req => 
      req.title.toLowerCase().includes(searchTerm) || 
      req.description.toLowerCase().includes(searchTerm)
    );
  }
  
  // Sort the results
  filtered.sort((a, b) => {
    const field = filters.value.sortBy;
    if (field === 'created_at' || field === 'deadline') {
      return new Date(b[field]) - new Date(a[field]); // Newest first
    } else if (field === 'budget') {
      return b[field] - a[field]; // Highest first
    }
    return 0;
  });
  
  return filtered;
});

// Methods
function fetchRequests() {
  loading.value = true;
  
  // Simulating API call
  setTimeout(() => {
    // This would be replaced with an actual API call
    // Example: const { data } = await useFetch('/api/requests')
    
    // Mock data array for development and testing
    requests.value = [
      {
        id: 1,
        client_id: 'c1b8a3d4-e5f6-7890-a1b2-c3d4e5f67890',
        title: 'Développement d\'une application mobile de livraison',
        description: 'Nous recherchons un expert pour développer une application mobile de livraison de repas pour notre restaurant. L\'application doit être disponible sur iOS et Android, avec des fonctionnalités de géolocalisation, paiement intégré et suivi de commande en temps réel.',
        budget: 1200000,
        deadline: '2023-10-15',
        status: 'open',
        skills_required: ['React Native', 'Firebase', 'API REST', 'Mobile Development'],
        created_at: '2023-08-01T10:30:00Z',
        updated_at: '2023-08-01T10:30:00Z'
      },
      {
        id: 2,
        client_id: 'd2c9b4e5-f6g7-8901-b2c3-d4e5f6g78901',
        title: 'Création d\'un site web e-commerce pour une boutique de mode',
        description: 'Nous avons besoin d\'un site e-commerce complet pour notre nouvelle collection de vêtements. Le site doit inclure un catalogue de produits, un panier d\'achat, l\'intégration de paiement et une gestion des stocks.',
        budget: 850000,
        deadline: '2023-09-30',
        status: 'assigned',
        skills_required: ['WordPress', 'WooCommerce', 'HTML/CSS', 'PHP', 'JavaScript'],
        created_at: '2023-07-25T14:45:00Z',
        updated_at: '2023-08-03T09:20:00Z'
      },
      {
        id: 3,
        client_id: 'e3d0c5f6-g7h8-9012-c3d4-e5f6g7h89012',
        title: 'Conception de logo et identité visuelle pour startup fintech',
        description: 'Notre startup fintech a besoin d\'une identité visuelle professionnelle incluant logo, charte graphique, cartes de visite et templates pour réseaux sociaux.',
        budget: 500000,
        deadline: '2023-09-10',
        status: 'completed',
        skills_required: ['Graphic Design', 'Branding', 'Adobe Illustrator', 'Adobe Photoshop'],
        created_at: '2023-06-15T08:30:00Z',
        updated_at: '2023-07-20T16:45:00Z'
      },
      {
        id: 4,
        client_id: 'f4e1d6g7-h8i9-0123-d4e5-f6g7h8i90123',
        title: 'Traduction de site web français vers wolof et anglais',
        description: 'Nous avons besoin de traduire l\'intégralité de notre site web (environ 50 pages) du français vers le wolof et l\'anglais. Le traducteur doit avoir une bonne connaissance du vocabulaire technique dans le domaine de la santé.',
        budget: 300000,
        deadline: '2023-08-25',
        status: 'open',
        skills_required: ['Translation', 'French', 'Wolof', 'English', 'Medical Terminology'],
        created_at: '2023-07-31T11:15:00Z',
        updated_at: '2023-07-31T11:15:00Z'
      },
      {
        id: 5,
        client_id: 'g5f2e7h8-i9j0-1234-e5f6-g7h8i9j01234',
        title: 'Consultant en référencement SEO pour site d\'actualités',
        description: 'Nous cherchons un expert SEO pour améliorer le référencement de notre site d\'actualités. Le consultant devra réaliser un audit complet, proposer une stratégie et accompagner sa mise en œuvre pendant 3 mois.',
        budget: 750000,
        deadline: '2023-11-30',
        status: 'open',
        skills_required: ['SEO', 'Google Analytics', 'Content Strategy', 'Keyword Research'],
        created_at: '2023-08-05T09:00:00Z',
        updated_at: '2023-08-05T09:00:00Z'
      },
      {
        id: 6,
        client_id: 'h6g3f8i9-j0k1-2345-f6g7-h8i9j0k12345',
        title: 'Montage vidéo pour série de publicités',
        description: 'Nous avons besoin d\'un monteur vidéo pour créer 5 publicités de 30 secondes à partir de rushs existants. Le style doit être dynamique et moderne, en accord avec notre marque de boissons énergisantes.',
        budget: 450000,
        deadline: '2023-09-05',
        status: 'cancelled',
        skills_required: ['Video Editing', 'Adobe Premiere Pro', 'After Effects', 'Sound Design'],
        created_at: '2023-07-10T13:20:00Z',
        updated_at: '2023-08-02T15:30:00Z'
      },
      {
        id: 7,
        client_id: 'i7h4g9j0-k1l2-3456-g7h8-i9j0k1l23456',
        title: 'Développement de chatbot pour service client',
        description: 'Nous souhaitons intégrer un chatbot à notre site web pour répondre aux questions fréquentes de nos clients. Le chatbot doit pouvoir être formé avec notre base de connaissances et s\'intégrer à notre système de tickets existant.',
        budget: 650000,
        deadline: '2023-10-10',
        status: 'open',
        skills_required: ['AI', 'Machine Learning', 'NLP', 'JavaScript', 'API Integration'],
        created_at: '2023-08-07T16:00:00Z',
        updated_at: '2023-08-07T16:00:00Z'
      },
      {
        id: 8,
        client_id: 'j8i5h0k1-l2m3-4567-h8i9-j0k1l2m34567',
        title: 'Formation Excel avancé pour équipe finance',
        description: 'Nous recherchons un formateur pour dispenser une formation Excel avancé (tableaux croisés dynamiques, macros, Power Query) à notre équipe financière de 10 personnes. La formation doit être pratique et adaptée à nos besoins spécifiques.',
        budget: 200000,
        deadline: '2023-09-20',
        status: 'assigned',
        skills_required: ['Excel', 'VBA', 'Power Query', 'Training', 'Finance'],
        created_at: '2023-07-28T10:45:00Z',
        updated_at: '2023-08-04T11:30:00Z'
      }
    ];
    
    totalItems.value = requests.value.length;
    loading.value = false;
  }, 1000);
}

function viewRequest(id) {
  router.push(`/requests/${id}`);
}

function navigateToNewRequest() {
  router.push('/requests/new');
}

function getStatusClass(status) {
  const classes = {
    'open': 'bg-blue-100 text-blue-800',
    'assigned': 'bg-yellow-100 text-yellow-800',
    'completed': 'bg-green-100 text-green-800',
    'cancelled': 'bg-red-100 text-red-800'
  };
  return classes[status] || 'bg-gray-100 text-gray-800';
}

function formatDate(dateString) {
  if (!dateString) return 'N/A';
  return new Date(dateString).toLocaleDateString();
}

function formatCurrency(amount) {
  if (!amount) return 'Budget: N/A';
  return new Intl.NumberFormat('fr-SN', { style: 'currency', currency: 'XOF' }).format(amount);
}

onMounted(() => {
  fetchRequests();
});
</script>

<style scoped>
.request-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1.5rem;
}

.status-badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 500;
  text-transform: capitalize;
}

.skill-tag {
  background-color: #f3f4f6;
  color: #4b5563;
  padding: 0.25rem 0.5rem;
  border-radius: 0.25rem;
  font-size: 0.75rem;
}

.loader {
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3498db;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 2s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style> 