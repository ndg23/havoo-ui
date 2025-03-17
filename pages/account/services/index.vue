<template>
  <div class="min-h-screen bg-white">
    <!-- Header -->
    <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div class="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
        <h1 class="text-xl font-bold">Mes services</h1>
        <NuxtLink 
          to="/account/services/new" 
          class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
        >
          <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
          Nouveau service
        </NuxtLink>
      </div>
    </header>

    <!-- Main content -->
    <main class="max-w-2xl mx-auto px-4 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center py-12">
        <svg class="animate-spin h-8 w-8 text-gray-400 mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <p class="text-gray-500">Chargement de vos services...</p>
      </div>

      <!-- Error state -->
      <div v-else-if="error" class="bg-red-50 p-4 rounded-lg text-red-700 my-6">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <p>{{ error }}</p>
        </div>
        <button 
          @click="fetchServices" 
          class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
        >
          Réessayer
        </button>
      </div>

      <!-- Not an expert -->
      <div v-else-if="!isExpert" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
        <h3 class="mt-2 text-lg font-medium text-gray-900">Devenez expert</h3>
        <p class="mt-1 text-gray-500">Vous devez être un expert pour proposer des services.</p>
        <div class="mt-6">
          <NuxtLink 
            to="/account/" 
            class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
          >
            Devenir expert
          </NuxtLink>
        </div>
      </div>

      <!-- Empty state -->
      <div v-else-if="services.length === 0" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
        </svg>
        <h3 class="mt-2 text-lg font-medium text-gray-900">Aucun service</h3>
        <p class="mt-1 text-gray-500">Vous n'avez pas encore créé de service à proposer.</p>
        <div class="mt-6">
          <NuxtLink 
            to="/account/services/new" 
            class="inline-flex items-center px-4 py-2 rounded-full text-sm font-medium text-white bg-black hover:bg-gray-800 transition-colors"
          >
            <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            Créer un service
          </NuxtLink>
        </div>
      </div>

      <!-- Service list -->
      <div v-else class="space-y-4">
        <!-- Tabs -->
        <div class="border-b border-gray-200">
          <nav class="-mb-px flex space-x-6">
            <button 
              v-for="tab in tabs" 
              :key="tab.value"
              @click="activeTab = tab.value"
              class="py-2 px-1 text-sm font-medium border-b-2 transition-colors"
              :class="activeTab === tab.value 
                ? 'border-black text-black' 
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'"
            >
              {{ tab.label }}
              <span 
                v-if="getFilteredServices(tab.value).length > 0"
                class="ml-1 text-xs rounded-full bg-gray-100 px-2 py-0.5"
              >
                {{ getFilteredServices(tab.value).length }}
              </span>
            </button>
          </nav>
        </div>

        <!-- Service cards -->
        <div v-if="getFilteredServices(activeTab).length === 0" class="text-center py-8">
          <p class="text-gray-500">Aucun service {{ getTabLabel(activeTab).toLowerCase() }}</p>
        </div>
        
        <div v-else class="space-y-4">
          <div
            v-for="service in getFilteredServices(activeTab)"
            :key="service.id"
            class="bg-white border border-gray-200 rounded-lg overflow-hidden hover:shadow-sm transition-shadow"
          >
            <div class="p-4">
              <div class="flex justify-between items-start">
                <div>
                  <div class="flex items-center space-x-2 mb-1">
                    <span 
                      class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                      :class="service.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'"
                    >
                      {{ service.is_active ? 'Actif' : 'Inactif' }}
                    </span>
                    <span 
                      v-if="service.category" 
                      class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
                    >
                      {{ service.category.name }}
                    </span>
                  </div>
                  <h3 class="text-lg font-medium text-gray-900 line-clamp-1">{{ service.title }}</h3>
                  <p class="mt-1 text-sm text-gray-500 line-clamp-2">{{ service.description }}</p>
                </div>
                
                <div class="text-right flex-shrink-0">
                  <div class="text-base font-bold text-gray-900">
                    {{ formatPrice(service.price) }}
                  </div>
                  <div v-if="service.delivery_time" class="text-xs text-gray-500 mt-1">
                    {{ service.delivery_time }} jour{{ service.delivery_time > 1 ? 's' : '' }}
                  </div>
                </div>
              </div>
              
              <div class="mt-4 flex items-center justify-between">
                <div class="flex space-x-2">
                  <NuxtLink 
                    :to="`/account/services/${service.id}`"
                    class="inline-flex items-center px-3 py-1.5 border border-gray-300 rounded-md text-xs font-medium text-gray-700 bg-white hover:bg-gray-50 transition-colors"
                  >
                    <svg class="w-3.5 h-3.5 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                    Voir
                  </NuxtLink>
                  <NuxtLink 
                    :to="`/account/services/edit/${service.id}`"
                    class="inline-flex items-center px-3 py-1.5 border border-gray-300 rounded-md text-xs font-medium text-gray-700 bg-white hover:bg-gray-50 transition-colors"
                  >
                    <svg class="w-3.5 h-3.5 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                    Modifier
                  </NuxtLink>
                </div>
                <button 
                  @click="toggleServiceStatus(service)"
                  class="inline-flex items-center px-3 py-1.5 border border-gray-300 rounded-md text-xs font-medium text-gray-700 bg-white hover:bg-gray-50 transition-colors"
                >
                  {{ service.is_active ? 'Désactiver' : 'Activer' }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useSupabaseClient, useSupabaseUser } from '#imports';

const supabase = useSupabaseClient();
const user = useSupabaseUser();

// État
const services = ref([]);
const profile = ref(null);
const isLoading = ref(true);
const error = ref(null);
const activeTab = ref('all');

// Computed
const isExpert = computed(() => {
  return profile.value?.is_expert || false;
});

// Tabs
const tabs = [
  { label: 'Tous', value: 'all' },
  { label: 'Actifs', value: 'active' },
  { label: 'Inactifs', value: 'inactive' }
];

// Récupérer le profil de l'utilisateur
const fetchProfile = async () => {
  if (!user.value) return;
  
  try {
    const { data, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single();
    
    if (profileError) throw profileError;
    
    profile.value = data;
  } catch (err) {
    console.error('Error fetching profile:', err);
  }
};

// Récupérer les services de l'expert
const fetchServices = async () => {
  if (!user.value) return;
  
  isLoading.value = true;
  error.value = null;
  
  try {
    const { data, error: serviceError } = await supabase
      .from('services')
      .select(`
        *,
        category:category_id (*)
      `)
      .eq('expert_id', user.value.id)
      .order('created_at', { ascending: false });
    
    if (serviceError) throw serviceError;
    
    services.value = data || [];
  } catch (err) {
    console.error('Error fetching services:', err);
    error.value = "Une erreur est survenue lors du chargement de vos services";
  } finally {
    isLoading.value = false;
  }
};

// Filtrer les services selon l'onglet actif
const getFilteredServices = (tab) => {
  if (tab === 'all') return services.value;
  if (tab === 'active') return services.value.filter(service => service.is_active);
  if (tab === 'inactive') return services.value.filter(service => !service.is_active);
  return services.value;
};

// Obtenir le libellé de l'onglet
const getTabLabel = (tabValue) => {
  const tab = tabs.find(t => t.value === tabValue);
  return tab ? tab.label : '';
};

// Activer/désactiver un service
const toggleServiceStatus = async (service) => {
  try {
    const { error: updateError } = await supabase
      .from('services')
      .update({ is_active: !service.is_active })
      .eq('id', service.id);
    
    if (updateError) throw updateError;
    
    // Mettre à jour localement
    service.is_active = !service.is_active;
  } catch (err) {
    console.error('Error updating service status:', err);
    alert("Une erreur est survenue lors de la mise à jour du service");
  }
};

// Formater le prix
const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(price);
};

// Cycle de vie
onMounted(async () => {
  await fetchProfile();
  await fetchServices();
});
</script>

<style scoped>
.line-clamp-1 {
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style> 