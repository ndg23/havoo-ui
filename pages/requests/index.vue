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
              <option value="0-100">Moins de 100FCFA</option>
              <option value="100-500">100FCFA - 500FCFA</option>
              <option value="500-1000">500FCFA - 1000FCFA</option>
              <option value="1000+">Plus de 1000FCFA</option>
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
    <div v-if="isLoading" class="flex justify-center items-center py-12">
      <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary-600"></div>
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
        @click="fetchRequests" 
        class="mt-3 text-sm font-medium text-red-600 hover:text-red-500"
      >
        Réessayer
      </button>
    </div>

    <!-- Empty state -->
    <div v-else-if="filteredRequests.length === 0" class="text-center py-12">
      <div class="mx-auto h-12 w-12 text-gray-400">
        <Search class="h-12 w-12" />
      </div>
      <h3 class="mt-2 text-sm font-medium text-gray-900">Aucune demande trouvée</h3>
      <p class="mt-1 text-sm text-gray-500">
        Essayez de modifier vos filtres ou revenez plus tard.
      </p>
    </div>

    <!-- Requests list -->
    <div v-else class="grid grid-cols-1 gap-4">
      <div 
        v-for="request in filteredRequests" 
        :key="request.id"
        class="bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow duration-200"
      >
        <div class="flex justify-between items-start">
          <div>
            <div class="flex items-center space-x-2 mb-2">
              <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                {{ request.categories?.name || 'Catégorie inconnue' }}
              </span>
              <span class="text-xs text-gray-500">{{ formatDate(request.created_at) }}</span>
            </div>
            <NuxtLink :to="`/requests/${request.id}`" class="block">
              <h3 class="text-lg font-medium text-gray-900 hover:text-primary-600 transition-colors mb-2">
                {{ request.title }}
              </h3>
            </NuxtLink>
            <p class="text-sm text-gray-500 mb-4 line-clamp-2">{{ request.description }}</p>
          </div>
          <div class="text-right">
            <p class="text-lg font-medium text-gray-900">{{ formatPrice(request.budget) }}</p>
            <p class="text-xs text-gray-500">Date limite: {{ formatDate(request.deadline) }}</p>
          </div>
        </div>
        
        <div class="flex items-center justify-between mt-4 pt-4 border-t border-gray-100">
          <div class="flex items-center">
            <div v-if="request.profiles?.avatar_url" class="h-8 w-8 rounded-full overflow-hidden">
              <img :src="request.profiles.avatar_url" alt="Avatar" class="h-full w-full object-cover" />
            </div>
            <div v-else class="h-8 w-8 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 text-xs font-medium">
              {{ getInitials(request.profiles?.first_name, request.profiles?.last_name) }}
            </div>
            <span class="ml-2 text-sm text-gray-700">
              {{ request.profiles?.first_name }} {{ request.profiles?.last_name }}
            </span>
          </div>
          
          <div>
            <NuxtLink 
              v-if="isExpert && !hasUserSubmittedProposal(request.id)" 
              :to="`/requests/${request.id}`"
              class="inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded-full shadow-sm text-white bg-primary-600 hover:bg-primary-700"
            >
              Faire une proposition
            </NuxtLink>
            <span 
              v-else-if="isExpert && hasUserSubmittedProposal(request.id)"
              class="inline-flex items-center px-3 py-1.5 text-xs font-medium rounded-full text-primary-700 bg-primary-100"
            >
              <CheckCircleIcon class="h-3.5 w-3.5 mr-1" />
              Proposition envoyée
            </span>
            <NuxtLink 
              v-else
              :to="`/requests/${request.id}`"
              class="inline-flex items-center text-sm font-medium text-primary-600 hover:text-primary-500"
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
    <div v-if="hasMoreRequests && !isLoading" class="mt-6 text-center">
      <button 
        @click="loadMoreRequests" 
        class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50"
      >
        Charger plus de demandes
      </button>
    </div>

    <!-- Proposal modal -->
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
              <div class="text-gray-500">Budget: {{ selectedRequest?.budget }}FCFA</div>
            </div>
            
            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Votre tarif</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span class="text-gray-500">FCFA</span>
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

    <!-- Create request modal for clients -->
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
import { ref, computed, reactive, onMounted, onBeforeUnmount, watch } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
// import { useToast } from 'vue-toastification'
import { Search, CheckCircleIcon, UserIcon, BoxIcon, ClipboardIcon } from 'lucide-vue-next'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const toast = useToast()

// States
const isLoading = ref(true)
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
// const filteredRequestSkills = ref([])

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
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>