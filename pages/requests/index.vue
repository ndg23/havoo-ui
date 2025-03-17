<template>
  <div class="max-w-4xl mx-auto px-4 py-6 bg-white">
    <div class="flex justify-between items-center mb-5">
      <h1 class="text-xl font-bold text-gray-900">Demandes de services</h1>
      
      <!-- Create request button for clients -->
      <button 
        v-if="!isExpert"
        @click="showCreateRequestModal = true" 
        class="px-4 py-2 bg-primary-600 text-white rounded-full text-sm font-medium shadow-sm hover:bg-primary-700"
      >
        Publier une demande
      </button>
    </div>

    <!-- Active filters display -->
    <div v-if="activeFilters.length > 0" class="mb-4">
      <div class="flex items-center flex-wrap gap-2">
        <div class="text-sm text-gray-500 mr-1">Filtres actifs:</div>
        <span 
          v-for="filter in activeFilters" 
          :key="filter.id"
          class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-primary-100 text-primary-800"
        >
          {{ filter.name }}
          <button 
            @click="removeFilter(filter)"
            class="ml-1.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-600 hover:bg-primary-200"
          >
            <svg class="h-3 w-3" fill="currentColor" viewBox="0 0 20 20">
              <path d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
            </svg>
          </button>
        </span>
        <button 
          @click="clearFilters"
          class="text-xs text-gray-500 hover:text-gray-700 ml-1"
        >
          Effacer tous
        </button>
      </div>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-xl border border-gray-200 mb-5 shadow-sm">
      <div class="p-4">
        <div class="flex flex-wrap gap-3 mb-3">
          <!-- Budget filter -->
          <div class="relative">
            <select 
              v-model="filters.budget" 
              class="pl-3 pr-8 py-2 rounded-full border border-gray-300 bg-white text-sm"
            >
              <option value="">Budget</option>
              <option value="0-100">Moins de 100€</option>
              <option value="100-500">100€ - 500€</option>
              <option value="500-1000">500€ - 1000€</option>
              <option value="1000+">Plus de 1000€</option>
            </select>
          </div>
          
          <!-- Delivery time filter -->
          <div class="relative">
            <select 
              v-model="filters.deliveryTime" 
              class="pl-3 pr-8 py-2 rounded-full border border-gray-300 bg-white text-sm"
            >
              <option value="">Délai</option>
              <option value="1-3">1-3 jours</option>
              <option value="3-7">3-7 jours</option>
              <option value="7-14">1-2 semaines</option>
              <option value="14+">Plus de 2 semaines</option>
            </select>
          </div>
          
          <!-- Category filter -->
          <div class="relative">
            <select 
              v-model="filters.categoryId" 
              class="pl-3 pr-8 py-2 rounded-full border border-gray-300 bg-white text-sm"
            >
              <option value="">Catégorie</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>
        </div>
        
        <!-- Search and skills -->
        <div class="flex flex-col sm:flex-row gap-3">
          <div class="relative flex-grow">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg class="h-4 w-4 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
              </svg>
            </div>
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Rechercher une demande..." 
              class="w-full pl-10 pr-3 py-2 rounded-full border border-gray-300 bg-white text-sm"
            />
          </div>
          
          <!-- Skills filter -->
          <div class="relative" data-skills-dropdown>
            <button 
              @click="showSkillsDropdown = !showSkillsDropdown"
              class="px-4 py-2 rounded-full border border-gray-300 bg-white text-sm flex items-center"
            >
              Compétences
              <svg 
                class="ml-1 h-4 w-4 text-gray-400" 
                :class="{ 'transform rotate-180': showSkillsDropdown }"
                xmlns="http://www.w3.org/2000/svg" 
                viewBox="0 0 20 20" 
                fill="currentColor"
              >
                <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </button>
            
            <!-- Skills dropdown -->
            <div 
              v-show="showSkillsDropdown" 
              class="absolute z-10 mt-1 w-64 bg-white shadow-lg rounded-lg border border-gray-200"
            >
              <div class="mb-2">
                <input 
                  v-model="skillSearchQuery" 
                  type="text" 
                  placeholder="Rechercher des compétences" 
                  class="w-full px-3 py-1.5 rounded-lg border border-gray-300 bg-white text-sm"
                />
              </div>
              
              <div class="max-h-40 overflow-y-auto">
                <div 
                  v-for="skill in filteredSkills" 
                  :key="skill.id"
                  @click="toggleSkillFilter(skill)"
                  class="flex items-center py-1.5 px-2 hover:bg-gray-100 cursor-pointer"
                >
                  <input 
                    type="checkbox"
                    :checked="isSkillSelected(skill)"
                    class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
                  />
                  <span class="ml-2 text-sm">{{ skill.name }}</span>
                </div>
                
                <div v-if="filteredSkills.length === 0" class="py-2 px-2 text-sm text-gray-500">
                  Aucun résultat
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading state -->
    <div v-if="isLoading" class="py-10 flex justify-center">
      <svg class="animate-spin h-6 w-6 text-primary-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>

    <!-- Empty state -->
    <div v-else-if="filteredRequests.length === 0" class="bg-white rounded-xl border border-gray-200 p-8 text-center shadow-sm">
      <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-gray-100 mb-4">
        <svg class="h-6 w-6 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </div>
      <h3 class="text-lg font-medium text-gray-900 mb-1">Aucune demande trouvée</h3>
      <p class="text-gray-500">
        Essayez d'ajuster vos filtres ou votre recherche
      </p>
    </div>
    
    <!-- Requests grid -->
    <div v-else class="space-y-4">
      <div 
        v-for="request in filteredRequests" 
        :key="request.id"
        class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow"
      >
        <div class="p-4">
          <div class="flex justify-between mb-2">
            <h3 class="font-medium text-lg">{{ request.title }}</h3>
            <div class="text-primary-600 font-semibold">{{ request.budget }}€</div>
          </div>
          
          <p class="text-gray-600 text-sm line-clamp-2 mb-4">
            {{ request.description }}
          </p>
          
          <div class="flex flex-wrap gap-2 mb-3">
            <span 
              v-for="skill in request.skills" 
              :key="skill.id"
              class="inline-block px-2.5 py-0.5 text-xs rounded-full bg-gray-100 text-gray-800"
            >
              {{ skill.name }}
            </span>
            <span class="inline-block px-2.5 py-0.5 text-xs rounded-full bg-blue-100 text-blue-800">
              {{ request.category_name }}
            </span>
          </div>
          
          <div class="flex items-center justify-between border-t border-gray-200 pt-3 mt-1">
            <div class="flex items-center">
              <div class="h-6 w-6 rounded-full bg-gray-200 overflow-hidden mr-2">
                <img 
                  v-if="request.client_avatar" 
                  :src="request.client_avatar" 
                  alt="Client" 
                  class="h-full w-full object-cover"
                />
                <svg v-else class="h-3 w-3 m-1.5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                </svg>
              </div>
              <span class="text-sm text-gray-600">{{ request.client_name }}</span>
            </div>
            
            <div class="flex items-center gap-2 text-sm text-gray-500">
              <span>{{ formatTimeframe(request.delivery_time) }}</span>
              <span>•</span>
              <span>{{ formatDate(request.created_at) }}</span>
            </div>
          </div>
        </div>
        
        <!-- Action buttons -->
        <div class="bg-gray-50 px-4 py-3 flex justify-between items-center border-t border-gray-200">
          <div class="text-sm text-gray-500">
            {{ request.proposal_count }} proposition{{ request.proposal_count !== 1 ? 's' : '' }}
          </div>
          
          <div>
            <button 
              v-if="isExpert && !hasUserSubmittedProposal(request.id)"
              @click="showProposalModal(request)"
              class="px-4 py-1.5 bg-primary-600 text-white rounded-full text-sm font-medium inline-flex items-center"
            >
              <svg class="h-4 w-4 mr-1.5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path d="M11 3a1 1 0 100 2h2.586l-6.293 6.293a1 1 0 101.414 1.414L15 6.414V9a1 1 0 102 0V4a1 1 0 00-1-1h-5z" />
                <path d="M5 5a2 2 0 00-2 2v8a2 2 0 002 2h8a2 2 0 002-2v-3a1 1 0 10-2 0v3H5V7h3a1 1 0 000-2H5z" />
              </svg>
              Proposer
            </button>
            
            <NuxtLink
              v-else-if="isExpert && hasUserSubmittedProposal(request.id)"
              to="/account/proposals"
              class="px-4 py-1.5 text-sm rounded-full border border-gray-300 hover:bg-gray-100"
            >
              Déjà proposé
            </NuxtLink>
            
            <NuxtLink 
              :to="`/requests/${request.id}`"
              class="px-4 py-1.5 rounded-full text-sm border border-gray-300 hover:bg-gray-100"
            >
              Détails
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Load more -->
    <div v-if="hasMoreRequests && !isLoading" class="mt-6 flex justify-center">
      <button 
        @click="loadMoreRequests" 
        class="px-4 py-2 text-sm text-primary-600 hover:text-primary-700 flex items-center"
      >
        Voir plus de demandes
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-1" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
        </svg>
      </button>
    </div>

    <!-- Submit Proposal Modal -->
    <Teleport to="body">
      <div 
        v-if="showingProposalModal" 
        class="fixed inset-0 z-50 overflow-y-auto bg-black bg-opacity-50 flex items-center justify-center"
        @click.self="closeProposalModal"
      >
        <div class="bg-white dark:bg-gray-800 rounded-xl max-w-lg w-full mx-4 p-5">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-medium">Soumettre une proposition</h3>
            <button @click="closeProposalModal" class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </button>
          </div>
          
          <div class="mb-5">
            <div class="mb-4 text-sm">
              <div class="font-medium">Demande: {{ selectedRequest?.title }}</div>
              <div class="text-gray-500">Budget: {{ selectedRequest?.budget }}€</div>
            </div>
            
            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Votre tarif</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span class="text-gray-500">€</span>
                  </div>
                  <input
                    v-model.number="proposalForm.price"
                    type="number"
                    min="0"
                    required
                    class="w-full pl-8 pr-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
                  />
                </div>
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Délai estimé (jours)</label>
                <input
                  v-model.number="proposalForm.estimatedDays"
                  type="number"
                  min="1"
                  required
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
                />
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Message</label>
                <textarea
                  v-model="proposalForm.message"
                  rows="4"
                  required
                  placeholder="Expliquez pourquoi vous êtes la personne idéale pour ce projet..."
                  class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-700 dark:text-white focus:border-primary-500 focus:ring-1 focus:ring-primary-500"
                ></textarea>
              </div>
            </div>
          </div>
          
          <div class="flex justify-end">
            <button 
              @click="closeProposalModal" 
              class="px-4 py-2 text-gray-700 dark:text-gray-300 border border-gray-300 dark:border-gray-600 rounded-lg mr-3 hover:bg-gray-50 dark:hover:bg-gray-700"
            >
              Annuler
            </button>
            <button 
              @click="submitProposal" 
              :disabled="isSubmitting"
              class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg flex items-center"
              :class="{ 'opacity-75 cursor-not-allowed': isSubmitting }"
            >
              <svg v-if="isSubmitting" class="animate-spin -ml-1 mr-2 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ isSubmitting ? 'Envoi...' : 'Envoyer proposition' }}
            </button>
          </div>
        </div>
      </div>
    </Teleport>

    <!-- Create Request Modal for clients -->
    <Teleport to="body">
      <div 
        v-if="showCreateRequestModal" 
        class="fixed inset-0 z-50 overflow-y-auto bg-black bg-opacity-50 flex items-center justify-center"
        @click.self="closeCreateRequestModal"
      >
        <div class="bg-white dark:bg-gray-800 rounded-xl max-w-lg w-full mx-4 p-5">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-medium">Publier une demande de service</h3>
            <button @click="closeCreateRequestModal" class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300">
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
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Budget (€)</label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <span class="text-gray-500">€</span>
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
                  class="absolute z-10 mt-1 w-full bg-white shadow-lg rounded-lg border border-gray-200"
                >
                  <div 
                    v-for="skill in filteredRequestSkills" 
                    :key="skill.id"
                    @click="addRequestSkill(skill)"
                    class="px-3 py-2 hover:bg-gray-100 cursor-pointer"
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
          
          <div class="flex justify-end">
            <button 
              @click="closeCreateRequestModal" 
              class="px-4 py-2 text-gray-700 dark:text-gray-300 border border-gray-300 dark:border-gray-600 rounded-lg mr-3 hover:bg-gray-50 dark:hover:bg-gray-700"
            >
              Annuler
            </button>
            <button 
              @click="submitRequest" 
              :disabled="isSubmitting"
              class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg flex items-center"
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
import { ref, computed, reactive, onMounted, onBeforeUnmount } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
// import { useToast } from 'vue-toastification'
import { Search, CheckCircleIcon, UserIcon, BoxIcon, ClipboardIcon } from 'lucide-vue-next'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const toast = useToast()

// States
const isLoading = ref(true)
const isSubmitting = ref(false)
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
  deliveryTime: 7,
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
    if (filters.budget === '0-100') label = 'Moins de 100€'
    else if (filters.budget === '100-500') label = '100€ - 500€'
    else if (filters.budget === '500-1000') label = '500€ - 1000€'
    else if (filters.budget === '1000+') label = 'Plus de 1000€'
    
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
  
  try {
    let query = supabase
      .from('requests')
      .select(`
        id, 
        title, 
        description, 
        budget, 
        delivery_time,
        status,
        created_at,
        category_id,
        categories(name),
        request_skills(skills(id, name))
      `)
      .eq('status', 'open')
      .order('created_at', { ascending: false })
      .range((currentPage.value - 1) * pageSize, currentPage.value * pageSize)
    
    const { data, error } = await query
    
    if (error) throw error
    
    // Format requests
    requests.value = data.map(request => ({
      id: request.id,
      title: request.title,
      description: request.description,
      budget: request.budget,
      delivery_time: request.delivery_time,
      status: request.status,
      created_at: request.created_at,
      category_id: request.category_id,
      category_name: request.categories?.name || 'Non catégorisé',
      skills: request.request_skills.map(rs => rs.skills),
      formatted_budget: new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(request.budget),
      formatted_date: formatDate(request.created_at)
    }))
    
    // Check for more requests
    const { count } = await supabase
      .from('requests')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'open')
    
    hasMoreRequests.value = count > currentPage.value * pageSize
    
    // If expert, fetch proposals to check which requests user has already proposed on
    if (isExpert.value && user.value) {
      await fetchUserProposals()
    }
    
  } catch (error) {
    console.error('Error fetching requests:', error)
    toast.error('Erreur lors du chargement des demandes')
  } finally {
    isLoading.value = false
  }
}

const fetchCategories = async () => {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('id, name')
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
      .select('id, name')
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
      .from('proposals')
      .select('request_id')
      .eq('expert_id', user.value.id)
    
    if (error) throw error
    
    userProposals.value = data.map(p => p.request_id)
  } catch (error) {
    console.error('Error fetching user proposals:', error)
  }
}

const loadMoreRequests = async () => {
  if (!hasMoreRequests.value) return
  
  currentPage.value++
  await fetchRequests()
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
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

const hasProposed = (requestId) => {
  return userProposals.value.includes(requestId)
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
      .from('proposals')
      .insert({
        request_id: selectedRequest.value.id,
        expert_id: user.value.id,
        price: proposalForm.price,
        estimated_days: proposalForm.estimatedDays,
        message: proposalForm.message,
        status: 'pending'
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
  requestForm.deliveryTime = 7
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
    
    // Insert skills
    if (requestForm.skills.length > 0) {
      const skillMappings = requestForm.skills.map(skill => ({
        request_id: request.id,
        skill_id: skill.id
      }))
      
      const { error: skillError } = await supabase
        .from('request_skills')
        .insert(skillMappings)
      
      if (skillError) throw skillError
    }
    
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
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>