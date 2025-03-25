<template>
  <div class="min-h-screen bg-white dark:bg-gray-900">
    <!-- Twitter-style sticky header with blur effect -->
    <div class="sticky top-0 z-30 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm border-b border-gray-200 dark:border-gray-800">
      <div class="max-w-3xl mx-auto px-4 py-3 flex justify-between items-center">
        <h1 class="text-xl font-bold text-gray-900 dark:text-white">Demandes</h1>
        
        <!-- Create request button for clients with Twitter style -->
        <button 
          v-if="!isExpert"
          @click="showCreateRequestModal = true" 
          class="rounded-full bg-primary-600 hover:bg-primary-700 px-5 py-2 text-white font-medium text-sm transition-colors shadow-sm"
          aria-label="Créer une nouvelle demande"
        >
          Nouvelle demande
        </button>
      </div>
      
      <!-- Twitter-style search bar -->
      <div class="max-w-3xl mx-auto px-4 pb-3">
        <div class="relative">
          <div class="absolute inset-y-0 left-3 flex items-center pointer-events-none">
            <Search class="h-5 w-5 text-gray-400 dark:text-gray-500" />
          </div>
          <input 
            v-model="searchQuery" 
            type="text" 
            placeholder="Rechercher une demande..." 
            class="block w-full bg-gray-100 dark:bg-gray-800 border-none rounded-full pl-10 pr-4 py-2.5 text-gray-900 dark:text-gray-100 focus:ring-2 focus:ring-primary-500 transition-all"
          />
        </div>
      </div>
      
      <!-- Twitter-style filters row -->
      <div class="max-w-3xl mx-auto px-4 pb-3 flex gap-2 overflow-x-auto scrollbar-hide">
        <button 
          @click="showAdvancedFilters = !showAdvancedFilters"
          class="flex items-center gap-1.5 px-3.5 py-1.5 text-sm rounded-full border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z" />
          </svg>
          Filtres
          <span v-if="activeFilters.length > 0" class="ml-0.5 flex items-center justify-center h-5 w-5 text-xs bg-primary-500 text-white rounded-full">{{ activeFilters.length }}</span>
        </button>
        
        <!-- Active filters pills with Twitter style -->
        <div v-for="filter in activeFilters" :key="filter.id" class="inline-flex">
          <span class="inline-flex items-center px-3 py-1.5 rounded-full text-xs font-medium bg-primary-50 dark:bg-primary-900/30 text-primary-800 dark:text-primary-200 border border-primary-100 dark:border-primary-800/30 transition-colors">
            {{ filter.name }}
            <button 
              @click="removeFilter(filter)"
              class="ml-1.5 h-4 w-4 rounded-full inline-flex items-center justify-center hover:bg-primary-200/70 dark:hover:bg-primary-800/70"
              aria-label="Supprimer le filtre"
            >
              <svg class="h-3 w-3" fill="currentColor" viewBox="0 0 20 20">
                <path d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
              </svg>
            </button>
          </span>
        </div>
        
        <!-- Clear filters button with Twitter style -->
        <button 
          v-if="activeFilters.length > 0"
          @click="clearFilters"
          class="text-xs text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white px-3.5 py-1.5 rounded-full border border-gray-200 dark:border-gray-700 transition-colors"
        >
          Effacer tous
        </button>
      </div>
    </div>
    
    <!-- Advanced filters panel with Twitter style -->
    <div 
      v-if="showAdvancedFilters" 
      class="border-b border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-800 shadow-sm animate-slide-down"
    >
      <div class="max-w-3xl mx-auto px-4 py-4">
        <div class="grid grid-cols-2 md:grid-cols-3 gap-3">
          <!-- Budget filter with Twitter style -->
          <div>
            <select 
              v-model="filters.budget" 
              class="w-full pl-3 pr-8 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            >
              <option value="">Budget</option>
              <option value="0-100">Moins de 100FCFA</option>
              <option value="100-500">100FCFA - 500FCFA</option>
              <option value="500-1000">500FCFA - 1000FCFA</option>
              <option value="1000+">Plus de 1000FCFA</option>
            </select>
          </div>
          
          <!-- Delivery time filter with Twitter style -->
          <div>
            <select 
              v-model="filters.deliveryTime" 
              class="w-full pl-3 pr-8 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            >
              <option value="">Délai</option>
              <option value="1-3">1-3 jours</option>
              <option value="3-7">3-7 jours</option>
              <option value="7-14">1-2 semaines</option>
              <option value="14+">Plus de 2 semaines</option>
            </select>
          </div>
          
          <!-- Category filter with Twitter style -->
          <div>
            <select 
              v-model="filters.categoryId" 
              class="w-full pl-3 pr-8 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 text-sm focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
            >
              <option value="">Catégorie</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>
          
          <!-- Skills selector with Twitter style -->
          <div class="md:col-span-3">
            <div class="relative" data-skills-dropdown>
              <button 
                @click="showSkillsDropdown = !showSkillsDropdown"
                class="w-full px-4 py-2 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 text-sm flex items-center justify-between focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
              >
                <span class="text-gray-700 dark:text-gray-300">{{ selectedSkillFilters.length > 0 ? `${selectedSkillFilters.length} compétence(s) sélectionnée(s)` : 'Compétences' }}</span>
                <svg 
                  class="h-4 w-4 text-gray-400 dark:text-gray-500 transition-transform duration-200 ease-in-out" 
                  :class="{ 'rotate-180': showSkillsDropdown }"
                  xmlns="http://www.w3.org/2000/svg" 
                  viewBox="0 0 20 20" 
                  fill="currentColor"
                >
                  <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                </svg>
              </button>
              
              <!-- Skills dropdown with Twitter style -->
              <div 
                v-show="showSkillsDropdown" 
                class="absolute z-10 mt-1 w-full bg-white dark:bg-gray-800 shadow-lg rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden animate-fade-in"
              >
                <div class="p-2.5 border-b border-gray-100 dark:border-gray-700">
                  <div class="relative">
                    <div class="absolute inset-y-0 left-3 flex items-center pointer-events-none">
                      <Search class="h-4 w-4 text-gray-400" />
                    </div>
                    <input 
                      v-model="skillSearchQuery" 
                      type="text" 
                      placeholder="Rechercher des compétences" 
                      class="w-full pl-9 pr-3 py-1.5 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 text-sm focus:ring-1 focus:ring-primary-500 focus:border-primary-500"
                    />
                  </div>
                </div>
                
                <div class="max-h-48 overflow-y-auto p-2">
                  <div 
                    v-for="skill in filteredSkills" 
                    :key="skill.id"
                    @click="toggleSkillFilter(skill)"
                    class="flex items-center py-2 px-3 hover:bg-gray-50 dark:hover:bg-gray-700 rounded-lg cursor-pointer transition-colors"
                  >
                    <div class="flex items-center justify-center rounded-md w-5 h-5 border border-gray-300 dark:border-gray-600 mr-3"
                         :class="{ 'bg-primary-500 border-primary-500': isSkillSelected(skill.id) }">
                      <svg v-if="isSkillSelected(skill.id)" class="h-3 w-3 text-white" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8.586 10l7.293-7.293a1 1 0 011.414 0z" />
                      </svg>
                    </div>
                    <span class="text-sm text-gray-700 dark:text-gray-300">{{ skill.name }}</span>
                  </div>
                  
                  <div v-if="filteredSkills.length === 0" class="py-3 px-3 text-sm text-gray-500 dark:text-gray-400 text-center">
                    Aucun résultat
                  </div>
                </div>
                
                <!-- Selected skills badges -->
                <div v-if="selectedSkillFilters.length > 0" class="p-2.5 border-t border-gray-100 dark:border-gray-700 bg-gray-50 dark:bg-gray-800/50 flex flex-wrap gap-1.5">
                  <span 
                    v-for="skill in selectedSkillFilters" 
                    :key="skill.id"
                    class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-primary-50 dark:bg-primary-900/30 text-primary-800 dark:text-primary-200"
                  >
                    {{ skill.name }}
                    <button 
                      @click.stop="removeSkillFilter(skill)"
                      class="ml-1 h-3.5 w-3.5 rounded-full inline-flex items-center justify-center hover:bg-primary-200 dark:hover:bg-primary-800"
                    >
                      <svg class="h-2.5 w-2.5" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                      </svg>
                    </button>
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading state -->
    <div v-if="isLoading" class="max-w-3xl mx-auto flex justify-center items-center py-16">
      <div class="animate-spin h-10 w-10 text-primary-500">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
      </div>
    </div>

    <!-- Error state -->
    <div v-else-if="error" class="max-w-3xl mx-auto bg-red-50 dark:bg-red-900/20 p-5 rounded-xl border border-red-100 dark:border-red-800/40 text-red-700 dark:text-red-400 mx-4 my-6">
      <div class="flex">
        <svg class="h-5 w-5 text-red-500 dark:text-red-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p>{{ error }}</p>
      </div>
      <button 
        @click="fetchRequests" 
        class="mt-3 text-sm font-medium text-red-600 dark:text-red-400 hover:text-red-500"
      >
        Réessayer
      </button>
    </div>

    <!-- Empty state -->
    <div v-else-if="filteredRequests.length === 0" class="text-center py-16 max-w-3xl mx-auto px-4">
      <div class="mx-auto h-16 w-16 text-gray-300 dark:text-gray-600 bg-gray-50 dark:bg-gray-800 rounded-full flex items-center justify-center">
        <Search class="h-8 w-8" />
      </div>
      <h3 class="mt-4 text-base font-medium text-gray-900 dark:text-white">Aucune demande trouvée</h3>
      <p class="mt-1 text-sm text-gray-500 dark:text-gray-400 max-w-md mx-auto">
        Essayez de modifier vos filtres ou revenez plus tard pour découvrir de nouveaux projets.
      </p>
      <button 
        @click="clearFilters" 
        v-if="activeFilters.length > 0"
        class="mt-4 px-4 py-2 text-sm font-medium text-primary-600 dark:text-primary-400 bg-primary-50 dark:bg-primary-900/20 hover:bg-primary-100 dark:hover:bg-primary-900/30 rounded-full transition-colors"
      >
        Effacer les filtres
      </button>
    </div>
    
    <!-- Requests list -->
    <div v-else class="max-w-3xl mx-auto">
      <div 
        v-for="request in filteredRequests" 
        :key="request.id"
        class="border-b border-gray-200 dark:border-gray-800 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors animate-fade-in"
      >
        <div class="p-5">
          <!-- Request header with category and date -->
          <div class="flex items-center justify-between mb-2.5">
            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 border border-blue-100 dark:border-blue-800/30">
              {{ request.categories?.name || 'Catégorie inconnue' }}
            </span>
            <span class="text-xs text-gray-500 dark:text-gray-400">{{ formatDate(request.created_at) }}</span>
          </div>
          
          <!-- Title and description -->
          <NuxtLink :to="`/requests/${request.id}`" class="block group">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors mb-1.5">
              {{ request.title }}
            </h3>
            <p class="text-sm text-gray-600 dark:text-gray-300 mb-4 line-clamp-2">{{ request.description }}</p>
          </NuxtLink>
          
          <!-- Price and deadline info -->
          <div class="flex flex-wrap gap-4 mb-4">
            <div class="inline-flex items-center px-3 py-1 bg-gray-50 dark:bg-gray-800/80 rounded-full">
              <svg class="h-4 w-4 text-gray-500 dark:text-gray-400 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <span class="font-medium text-gray-900 dark:text-white">{{ formatPrice(request.budget) }}</span>
            </div>
            <div class="inline-flex items-center px-3 py-1 bg-gray-50 dark:bg-gray-800/80 rounded-full">
              <svg class="h-4 w-4 text-gray-500 dark:text-gray-400 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              <span class="text-sm text-gray-700 dark:text-gray-300">Échéance: {{ formatDate(request.deadline) }}</span>
            </div>
          </div>
          
          <!-- User info and action buttons -->
          <div class="flex items-center justify-between">
            <div class="flex items-center">
              <div class="h-10 w-10 rounded-full overflow-hidden bg-gray-200 dark:bg-gray-700 flex-shrink-0 border border-gray-100 dark:border-gray-600">
                <img v-if="request.profiles?.avatar_url" :src="request.profiles.avatar_url" alt="Avatar" class="h-full w-full object-cover" />
                <div v-else class="h-full w-full flex items-center justify-center text-gray-600 dark:text-gray-400 text-sm font-medium">
                  {{ getInitials(request.profiles?.first_name, request.profiles?.last_name) }}
                </div>
              </div>
              <span class="ml-2.5 text-sm font-medium text-gray-900 dark:text-white">
                {{ request.profiles?.first_name }} {{ request.profiles?.last_name }}
              </span>
            </div>
            
            <div>
              <button 
                v-if="isExpert && !hasUserSubmittedProposal(request.id)"
                @click="openProposalModal(request)"
                class="inline-flex items-center px-4 py-1.5 border border-transparent text-sm font-medium rounded-full shadow-sm text-white bg-primary-600 hover:bg-primary-700 transition-colors"
              >
                Proposition rapide
              </button>
              <span 
                v-else-if="isExpert && hasUserSubmittedProposal(request.id)"
                class="inline-flex items-center px-3 py-1.5 text-sm font-medium rounded-full text-green-700 dark:text-green-400 bg-green-50 dark:bg-green-900/30 border border-green-100 dark:border-green-800/30"
              >
                <svg class="h-3.5 w-3.5 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Proposition envoyée
              </span>
              <NuxtLink 
                v-else
                :to="`/requests/${request.id}`"
                class="inline-flex items-center text-sm font-medium text-primary-600 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-300"
              >
                Voir les détails
                <svg class="ml-1 w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Load more button -->
      <div v-if="hasMoreRequests" class="p-5 text-center">
        <button 
          @click="loadMoreRequests" 
          class="px-6 py-2.5 border border-gray-200 dark:border-gray-700 rounded-full text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors shadow-sm"
          :disabled="isLoadingMore"
        >
          <span v-if="isLoadingMore" class="flex items-center justify-center">
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-gray-600 dark:text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            Chargement...
          </span>
          <span v-else>Charger plus de demandes</span>
        </button>
      </div>
    </div>

    <!-- Quick Proposal Modal -->
    <Teleport to="body">
      <div 
        v-if="showingProposalModal" 
        class="fixed inset-0 z-50 overflow-y-auto bg-black/50 dark:bg-black/70 backdrop-blur-sm flex items-center justify-center"
        @click.self="closeProposalModal"
      >
        <div class="bg-white dark:bg-gray-800 rounded-2xl max-w-lg w-full mx-4 p-5 shadow-xl animate-slide-up">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Proposition rapide</h3>
            <button 
              @click="closeProposalModal" 
              class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 p-1 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
              aria-label="Fermer"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </button>
          </div>
          
          <div class="mb-5">
            <div class="mb-4 p-4 bg-gray-50 dark:bg-gray-800/50 rounded-xl border border-gray-100 dark:border-gray-700">
              <div class="font-medium text-gray-900 dark:text-white">{{ selectedRequest?.title }}</div>
              <div class="mt-2 flex flex-wrap gap-2">
                <div class="inline-flex items-center px-2.5 py-0.5 bg-gray-100 dark:bg-gray-700 rounded-full text-xs text-gray-800 dark:text-gray-300">
                  <svg class="h-3.5 w-3.5 mr-1.5 text-gray-500 dark:text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  {{ formatPrice(selectedRequest?.budget) }}
                </div>
                <div class="inline-flex items-center px-2.5 py-0.5 bg-gray-100 dark:bg-gray-700 rounded-full text-xs text-gray-800 dark:text-gray-300">
                  <svg class="h-3.5 w-3.5 mr-1.5 text-gray-500 dark:text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  {{ formatDate(selectedRequest?.deadline) }}
                </div>
                <div class="inline-flex items-center px-2.5 py-0.5 bg-blue-50 dark:bg-blue-900/20 rounded-full text-xs text-blue-700 dark:text-blue-300 border border-blue-100 dark:border-blue-800/30">
                  {{ selectedRequest?.categories?.name }}
                </div>
              </div>
              <div class="mt-2 text-sm text-gray-500 dark:text-gray-400 line-clamp-2">{{ selectedRequest?.description }}</div>
            </div>
            
            <form @submit.prevent="submitProposal" class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Votre tarif</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span class="text-gray-500 dark:text-gray-400">FCFA</span>
                  </div>
                  <input
                    v-model.number="proposalForm.price"
                    type="number"
                    min="0"
                    required
                    class="w-full pl-12 pr-3 py-2.5 border border-gray-200 dark:border-gray-700 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                  />
                </div>
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Délai de livraison (jours)</label>
                <input
                  v-model.number="proposalForm.estimatedDays"
                  type="number"
                  min="1"
                  required
                  class="w-full px-3 py-2.5 border border-gray-200 dark:border-gray-700 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                />
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1.5">Message</label>
                <textarea
                  v-model="proposalForm.message"
                  rows="4"
                  required
                  placeholder="Décrivez votre approche et pourquoi vous êtes la personne idéale pour ce projet..."
                  class="w-full px-3 py-2.5 border border-gray-200 dark:border-gray-700 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-colors"
                ></textarea>
              </div>
              
              <div class="flex justify-end space-x-3 pt-4">
                <button 
                  type="button"
                  @click="closeProposalModal" 
                  class="px-4 py-2 border border-gray-200 dark:border-gray-700 rounded-full text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
                >
                  Annuler
                </button>
                <button 
                  type="submit"
                  class="px-4 py-2 bg-primary-600 text-white rounded-full hover:bg-primary-700 dark:hover:bg-primary-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
                  :disabled="isSubmitting"
                >
                  <span v-if="isSubmitting" class="flex items-center">
                    <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Envoi en cours...
                  </span>
                  <span v-else>Envoyer la proposition</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </Teleport>

    <!-- Create request modal for clients -->
    <Teleport to="body">
      <div 
        v-if="showCreateRequestModal" 
        class="fixed inset-0 z-50 overflow-y-auto bg-black/50 dark:bg-black/70 backdrop-blur-sm flex items-center justify-center"
        @click.self="closeCreateRequestModal"
      >
        <div class="bg-white dark:bg-gray-800 rounded-2xl max-w-lg w-full mx-4 p-5 shadow-xl animate-slide-up">
          <div class="flex justify-between items-center mb-5">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Publier une demande de service</h3>
            <button 
              @click="closeCreateRequestModal" 
              class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 p-1 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
              aria-label="Fermer"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </button>
          </div>
          
          <div class="space-y-4 mb-5">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Titre</label>
              <input
                v-model="requestForm.title"
                type="text"
                required
                placeholder="Décrivez brièvement votre demande"
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Description détaillée</label>
              <textarea
                v-model="requestForm.description"
                rows="4"
                required
                placeholder="Expliquez en détail ce dont vous avez besoin..."
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
              ></textarea>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Budget (FCFA)</label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <span class="text-gray-500">FCFA</span>
                </div>
                <input
                  v-model.number="requestForm.budget"
                  type="number"
                  min="0"
                  required
                  class="w-full pl-8 pr-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
                />
              </div>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Délai souhaité (jours)</label>
              <input
                v-model.number="requestForm.deliveryTime"
                type="number"
                min="1"
                required
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
              />
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Catégorie</label>
              <select
                v-model="requestForm.categoryId"
                required
                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
              >
                <option value="" disabled>Sélectionnez une catégorie</option>
                <option v-for="category in categories" :key="category.id" :value="category.id">
                  {{ category.name }}
                </option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Compétences requises</label>
              <div class="relative">
                <input
                  v-model="requestSkillSearch"
                  type="text"
                  placeholder="Rechercher des compétences..."
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
                  @focus="showRequestSkillResults = true"
                />
                
                <!-- Skills dropdown -->
                <div 
                  v-if="showRequestSkillResults && filteredRequestSkills.length > 0" 
                  class="absolute z-10 mt-1 w-full bg-white dark:bg-gray-800 shadow-lg rounded-lg border border-gray-200 dark:border-gray-700"
                >
                  <div 
                    v-for="skill in filteredRequestSkills" 
                    :key="skill.id"
                    @click="addRequestSkill(skill)"
                    class="px-3 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-md cursor-pointer"
                  >
                    {{ skill.name }}
                  </div>
                </div>
              </div>
              
              <!-- Selected skills -->
              <div v-if="requestForm.skills.length > 0" class="mt-2 flex flex-wrap gap-2">
                <span 
                  v-for="skill in requestForm.skills" 
                  :key="skill.id"
                  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-sm font-medium bg-primary-100 text-primary-800"
                >
                  {{ skill.name }}
                  <button 
                    type="button" 
                    @click="removeRequestSkill(skill)"
                    class="ml-1 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-600 hover:bg-primary-200"
                  >
                    <svg class="h-3 w-3" fill="currentColor" viewBox="0 0 20 20">
                      <path d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                    </svg>
                  </button>
                </span>
              </div>
            </div>
          </div>
          
          <div class="flex justify-end space-x-3">
            <button 
              @click="closeCreateRequestModal" 
              class="px-4 py-2 text-gray-700 dark:text-gray-300 border border-gray-200 dark:border-gray-700 rounded-full hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
            >
              Annuler
            </button>
            <button 
              @click="submitRequest" 
              :disabled="isSubmitting"
              class="px-5 py-2 bg-primary-600 hover:bg-primary-700 dark:hover:bg-primary-500 text-white rounded-full transition-colors shadow-sm flex items-center"
              :class="{ 'opacity-75 cursor-not-allowed': isSubmitting }"
            >
              <svg v-if="isSubmitting" class="animate-spin -ml-1 mr-2 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ isSubmitting ? 'Création...' : 'Publier la demande' }}
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted, onBeforeUnmount, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { Search, CheckCircleIcon, UserIcon, BoxIcon, ClipboardIcon } from 'lucide-vue-next'

const supabase = useSupabaseClient()
const user = useSupabaseUser()

// Create a toast utility
const toast = {
  success: (message) => {
    console.log('Success:', message);
    // In a real implementation, you would use a proper toast notification system
  },
  error: (message) => {
    console.error('Error:', message);
    // In a real implementation, you would use a proper toast notification system
  }
}

// States
const isLoading = ref(true)
const isLoadingMore = ref(false)
const isSubmitting = ref(false)
const error = ref(null)
const requests = ref([])
const categories = ref([])
const skills = ref([])
const searchQuery = ref('')
const hasMoreRequests = ref(false)
const currentPage = ref(1)
const pageSize = 10

// User state
const isExpert = computed(() => user.value?.user_metadata?.is_expert || false)
const userProposals = ref([])

// Filters
const filters = reactive({
  budget: '',
  deliveryTime: '',
  categoryId: ''
})
const skillSearchQuery = ref('')
const selectedSkillFilters = ref([])
const showSkillsDropdown = ref(false)
const showAdvancedFilters = ref(false)

// Modals
const showingProposalModal = ref(false)
const selectedRequest = ref(null)
const proposalForm = reactive({
  price: 0,
  estimatedDays: 1,
  message: ''
})

// Create request
const showCreateRequestModal = ref(false)
const requestForm = reactive({
  title: '',
  description: '',
  budget: 0,
  deliveryTime: 1,
  categoryId: '',
  skills: []
})
const requestSkillSearch = ref('')
const showRequestSkillResults = ref(false)

// Computed
const filteredRequests = computed(() => {
  let result = [...requests.value]
  
  // Search
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(request => 
      request.title.toLowerCase().includes(query) || 
      request.description.toLowerCase().includes(query)
    )
  }
  
  // Budget filter
  if (filters.budget) {
    const [min, max] = filters.budget.split('-')
    if (max === '+') {
      result = result.filter(request => request.budget >= parseInt(min))
    } else {
      result = result.filter(request => 
        request.budget >= parseInt(min) && 
        (max ? request.budget <= parseInt(max) : true)
      )
    }
  }
  
  // Delivery time filter
  if (filters.deliveryTime) {
    const [min, max] = filters.deliveryTime.split('-')
    if (max === '+') {
      result = result.filter(request => request.delivery_time >= parseInt(min))
    } else {
      result = result.filter(request => 
        request.delivery_time >= parseInt(min) && 
        (max ? request.delivery_time <= parseInt(max) : true)
      )
    }
  }
  
  // Category filter
  if (filters.categoryId) {
    result = result.filter(request => request.category_id === filters.categoryId)
  }
  
  // Skills filter
  if (selectedSkillFilters.value.length > 0) {
    result = result.filter(request => {
      // Check if any of the selected skills exist in this request's skills
      return selectedSkillFilters.value.some(selectedSkill => 
        request.skills.some(requestSkill => requestSkill.id === selectedSkill.id)
      )
    })
  }
  
  return result
})

const filteredSkills = computed(() => {
  if (!skillSearchQuery.value) return skills.value
  
  const query = skillSearchQuery.value.toLowerCase()
  return skills.value.filter(skill => 
    skill.name.toLowerCase().includes(query)
  )
})

const filteredRequestSkills = computed(() => {
  if (!requestSkillSearch.value) return skills.value
  
  const query = requestSkillSearch.value.toLowerCase()
  return skills.value.filter(skill => 
    skill.name.toLowerCase().includes(query) && 
    !requestForm.skills.some(s => s.id === skill.id)
  )
})

const activeFilters = computed(() => {
  const result = []
  
  // Budget filter
  if (filters.budget) {
    let label
    if (filters.budget === '0-100') label = 'Moins de 100FCFA'
    else if (filters.budget === '100-500') label = '100FCFA - 500FCFA'
    else if (filters.budget === '500-1000') label = '500FCFA - 1000FCFA'
    else if (filters.budget === '1000+') label = 'Plus de 1000FCFA'
    
    result.push({ id: 'budget', name: label })
  }
  
  // Delivery time filter
  if (filters.deliveryTime) {
    let label
    if (filters.deliveryTime === '1-3') label = '1-3 jours'
    else if (filters.deliveryTime === '3-7') label = '3-7 jours'
    else if (filters.deliveryTime === '7-14') label = '1-2 semaines'
    else if (filters.deliveryTime === '14+') label = 'Plus de 2 semaines'
    
    result.push({ id: 'delivery', name: label })
  }
  
  // Category filter
  if (filters.categoryId) {
    const category = categories.value.find(c => c.id === filters.categoryId)
    if (category) {
      result.push({ id: 'category', name: category.name })
    }
  }
  
  // Skills filters
  selectedSkillFilters.value.forEach(skill => {
    result.push({ id: `skill-${skill.id}`, name: skill.name, skillId: skill.id })
  })
  
  return result
})

// Methods
const fetchRequests = async () => {
  isLoading.value = true
  error.value = null
  
  try {
    // Récupérer les demandes avec les informations du client et de la catégorie
    const { data, error: requestsError } = await supabase
      .from('requests')
      .select(`
        *,
        profiles:client_id (
          first_name,
          last_name,
          avatar_url
        ),
        categories:category_id (
          name
        )
      `)
      .eq('status', 'open')
      .order('created_at', { ascending: false })
      .range((currentPage.value - 1) * pageSize, currentPage.value * pageSize)
    
    if (requestsError) throw requestsError
    
    requests.value = data
    
    // Check for more requests
    const { count, error: countError } = await supabase
      .from('requests')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'open')
    
    if (countError) throw countError
    
    hasMoreRequests.value = count > currentPage.value * pageSize
    
    // Get user proposals if logged in
    if (user.value) {
      await fetchUserProposals()
    }
  } catch (err) {
    console.error('Error fetching requests:', err)
    error.value = "Une erreur est survenue lors du chargement des demandes. Veuillez réessayer."
  } finally {
    isLoading.value = false
  }
}

const fetchCategories = async () => {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .order('name')
    
    if (error) throw error
    
    categories.value = data
  } catch (error) {
    console.error('Error fetching categories:', error)
  }
}

const fetchSkills = async () => {
  try {
    const { data, error } = await supabase
      .from('skills')
      .select('*')
      .order('name')
    
    if (error) throw error
    
    skills.value = data
  } catch (error) {
    console.error('Error fetching skills:', error)
  }
}

const fetchUserProposals = async () => {
  try {
    const { data, error } = await supabase
      .from('deals')
      .select('request_id')
      .eq('expert_id', user.value.id)
    
    if (error) throw error
    
    userProposals.value = data.map(p => p.request_id)
  } catch (error) {
    console.error('Error fetching user proposals:', error)
  }
}

const loadMoreRequests = async () => {
  if (!hasMoreRequests.value || isLoadingMore.value) return;
  
  isLoadingMore.value = true;
  currentPage.value++;
  
  try {
    // Récupérer les demandes avec les informations du client et de la catégorie
    const { data, error: requestsError } = await supabase
      .from('requests')
      .select(`
        *,
        profiles:client_id (
          first_name,
          last_name,
          avatar_url
        ),
        categories:category_id (
          name
        )
      `)
      .eq('status', 'open')
      .order('created_at', { ascending: false })
      .range((currentPage.value - 1) * pageSize, currentPage.value * pageSize);
    
    if (requestsError) throw requestsError;
    
    requests.value = [...requests.value, ...data];
    
    // Check for more requests
    const { count, error: countError } = await supabase
      .from('requests')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'open');
    
    if (countError) throw countError;
    
    hasMoreRequests.value = count > currentPage.value * pageSize;
  } catch (err) {
    console.error('Error fetching more requests:', err);
    toast.error("Une erreur est survenue lors du chargement des demandes supplémentaires.");
  } finally {
    isLoadingMore.value = false;
  }
}

const formatDate = (dateString) => {
  if (!dateString) return '';
  
  const date = new Date(dateString);
  const now = new Date();
  const diffTime = Math.abs(now - date);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  
  if (diffDays <= 1) {
    return "Aujourd'hui";
  } else if (diffDays <= 2) {
    return "Hier";
  } else if (diffDays <= 7) {
    return `Il y a ${diffDays} jours`;
  } else {
    return date.toLocaleDateString('fr-FR', { day: 'numeric', month: 'long' });
  }
}

const formatTimeframe = (days) => {
  if (!days) return 'Non spécifié';
  
  if (days === 1) {
    return '1 jour';
  } else if (days < 7) {
    return `${days} jours`;
  } else if (days === 7) {
    return '1 semaine';
  } else if (days < 30) {
    const weeks = Math.floor(days / 7);
    return `${weeks} semaine${weeks > 1 ? 's' : ''}`;
  } else {
    const months = Math.floor(days / 30);
    return `${months} mois`;
  }
}

const formatPrice = (price) => {
  if (price === null || price === undefined) return 'Prix non défini';
  
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(price);
}

const getInitials = (firstName, lastName) => {
  if (!firstName && !lastName) return '';
  if (!firstName) return lastName.charAt(0).toUpperCase();
  if (!lastName) return firstName.charAt(0).toUpperCase();
  
  return `${firstName.charAt(0)}${lastName.charAt(0)}`.toUpperCase();
}

const removeFilter = (filter) => {
  if (filter.id === 'budget') {
    filters.budget = ''
  } else if (filter.id === 'delivery') {
    filters.deliveryTime = ''
  } else if (filter.id === 'category') {
    filters.categoryId = ''
  } else if (filter.skillId) {
    selectedSkillFilters.value = selectedSkillFilters.value.filter(
      skill => skill.id !== filter.skillId
    )
  }
}

const clearFilters = () => {
  filters.budget = ''
  filters.deliveryTime = ''
  filters.categoryId = ''
  selectedSkillFilters.value = []
  searchQuery.value = ''
}

const addSkillFilter = (skill) => {
  if (!selectedSkillFilters.value.some(s => s.id === skill.id)) {
    selectedSkillFilters.value.push(skill)
  }
  showSkillsDropdown.value = false
  skillSearchQuery.value = ''
}

const removeSkillFilter = (skill) => {
  selectedSkillFilters.value = selectedSkillFilters.value.filter(
    s => s.id !== skill.id
  )
}

const hasUserSubmittedProposal = (requestId) => {
  return userProposals.value.includes(requestId);
}

// Proposal modal
const openProposalModal = (request) => {
  selectedRequest.value = request
  showingProposalModal.value = true
  
  // Reset form
  proposalForm.price = request.budget
  proposalForm.estimatedDays = request.delivery_time
  proposalForm.message = ''
}

const closeProposalModal = () => {
  showingProposalModal.value = false
  selectedRequest.value = null
}

const submitProposal = async () => {
  if (!selectedRequest.value || !user.value) return
  
  isSubmitting.value = true
  
  try {
    const { error } = await supabase
      .from('deals')
      .insert({
        request_id: selectedRequest.value.id,
        expert_id: user.value.id,
        price: proposalForm.price,
        duration: proposalForm.estimatedDays,
        message: proposalForm.message,
        status: 'proposal'
      })
    
    if (error) throw error
    
    // Update local user proposals
    userProposals.value.push(selectedRequest.value.id)
    
    toast.success('Proposition envoyée avec succès')
    closeProposalModal()
  } catch (error) {
    console.error('Error submitting proposal:', error)
    toast.error('Erreur lors de l\'envoi de la proposition')
  } finally {
    isSubmitting.value = false
  }
}

// Create request functions
const openCreateRequestModal = () => {
  showCreateRequestModal.value = true
  
  // Reset form
  requestForm.title = ''
  requestForm.description = ''
  requestForm.budget = 0
  requestForm.deliveryTime = 1
  requestForm.categoryId = ''
  requestForm.skills = []
}

const closeCreateRequestModal = () => {
  showCreateRequestModal.value = false
}

const addSkillToRequest = (skill) => {
  if (!requestForm.skills.some(s => s.id === skill.id)) {
    requestForm.skills.push(skill)
  }
  requestSkillSearch.value = ''
  showRequestSkillResults.value = false
}

const removeSkillFromRequest = (skill) => {
  requestForm.skills = requestForm.skills.filter(s => s.id !== skill.id)
}

const submitRequest = async () => {
  if (!user.value) return
  
  isSubmitting.value = true
  
  try {
    // Insert request
    const { data: request, error } = await supabase
      .from('requests')
      .insert({
        title: requestForm.title,
        description: requestForm.description,
        budget: requestForm.budget,
        delivery_time: requestForm.deliveryTime,
        category_id: requestForm.categoryId || null,
        client_id: user.value.id,
        status: 'open'
      })
      .select('id')
      .single()
    
    if (error) throw error
    
    toast.success('Demande publiée avec succès')
    closeCreateRequestModal()
    
    // Refresh requests
    fetchRequests()
    
  } catch (error) {
    console.error('Error creating request:', error)
    toast.error('Erreur lors de la création de la demande')
  } finally {
    isSubmitting.value = false
  }
}

// Click outside for dropdowns
const handleClickOutside = (event) => {
  if (showSkillsDropdown.value && !event.target.closest('[data-skills-dropdown]')) {
    showSkillsDropdown.value = false
  }
}

// Lifecycle hooks
onMounted(async () => {
  document.addEventListener('click', handleClickOutside)
  
  await Promise.all([
    fetchRequests(),
    fetchCategories(),
    fetchSkills()
  ])
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})

// Watch for changes in skillSearchQuery
watch(skillSearchQuery, (newQuery) => {
  if (!newQuery.trim()) {
    filteredSkills.value = skills.value
    return
  }
  
  const query = newQuery.toLowerCase()
  filteredSkills.value = skills.value.filter(skill => 
    skill.name.toLowerCase().includes(query)
  )
})

// Watch for changes in requestSkillSearch
watch(requestSkillSearch, (newQuery) => {
  if (!newQuery.trim()) {
    filteredRequestSkills.value = []
    showRequestSkillResults.value = false
    return
  }
  
  const query = newQuery.toLowerCase()
  filteredRequestSkills.value = skills.value.filter(skill => 
    skill.name.toLowerCase().includes(query) && 
    !requestForm.skills.some(s => s.id === skill.id)
  )
  
  showRequestSkillResults.value = filteredRequestSkills.value.length > 0
})

// Apply filters
const applyFilters = () => {
  // Implement filter logic here
  console.log('Applying filters:', filters)
  console.log('Selected skills:', selectedSkillFilters.value)
  console.log('Search query:', searchQuery.value)
}

// Fix the isSkillSelected function and add the toggleSkillFilter function 
const isSkillSelected = (skillId) => {
  return selectedSkillFilters.value.some(skill => skill.id === skillId);
}

const toggleSkillFilter = (skill) => {
  if (isSkillSelected(skill.id)) {
    removeSkillFilter(skill);
  } else {
    addSkillFilter(skill);
  }
}

// Rename to match function calls in the template
const addRequestSkill = (skill) => {
  addSkillToRequest(skill);
}

const removeRequestSkill = (skill) => {
  removeSkillFromRequest(skill);
}
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Hide scrollbars but keep functionality */
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}

.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

/* Animation for dropdown */
@keyframes slideDown {
  from { 
    opacity: 0;
    transform: translateY(-10px);
  }
  to { 
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-slide-down {
  animation: slideDown 0.2s ease-out forwards;
}

/* Animation for modal */
@keyframes slideUp {
  from { 
    opacity: 0;
    transform: translateY(10px);
  }
  to { 
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-slide-up {
  animation: slideUp 0.2s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.animate-fade-in {
  animation: fadeIn 0.15s ease-out forwards;
}

/* Smooth transition effects */
button, a, .transition-colors {
  transition: all 0.2s ease;
}

/* Hover effects */
.hover\:bg-gray-50:hover {
  transition: background-color 0.15s ease;
}

/* Card animation on hover */
.border-b {
  transition: background-color 0.2s ease, transform 0.1s ease;
}

.border-b:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

/* Floating action button animation */
@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(79, 70, 229, 0.4);
  }
  70% {
    box-shadow: 0 0 0 10px rgba(79, 70, 229, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(79, 70, 229, 0);
  }
}

.bg-primary-600 {
  position: relative;
  overflow: hidden;
}

.bg-primary-600:after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 5px;
  height: 5px;
  background: rgba(255, 255, 255, 0.5);
  opacity: 0;
  border-radius: 100%;
  transform: scale(1, 1) translate(-50%);
  transform-origin: 50% 50%;
}

.bg-primary-600:hover:after {
  animation: ripple 0.6s ease-out;
}

@keyframes ripple {
  0% {
    transform: scale(0, 0);
    opacity: 0.5;
  }
  100% {
    transform: scale(25, 25);
    opacity: 0;
  }
}
</style>