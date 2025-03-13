<template>
  <div class="space-y-6 max-w-7xl mx-auto">
    <!-- En-tête avec style Twitter -->
    <div class="px-4 py-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Services</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les services disponibles sur la plateforme</p>
    </div>
    
    <!-- Notifications -->
    <div 
      v-if="notification.show" 
      class="mx-4 p-4 rounded-xl flex items-start gap-3"
      :class="[
        notification.type === 'success' ? 'bg-green-50 text-green-800 dark:bg-green-900/20 dark:text-green-400' : 
        notification.type === 'error' ? 'bg-red-50 text-red-800 dark:bg-red-900/20 dark:text-red-400' : 
        'bg-blue-50 text-blue-800 dark:bg-blue-900/20 dark:text-blue-400'
      ]"
    >
      <component 
        :is="notification.type === 'success' ? 'CheckCircle' : notification.type === 'error' ? 'AlertTriangle' : 'Info'" 
        class="h-5 w-5 mt-0.5 flex-shrink-0" 
      />
      <div>
        <h3 class="font-medium">{{ notification.title }}</h3>
        <p class="text-sm opacity-80 mt-0.5">{{ notification.message }}</p>
      </div>
      <button 
        @click="notification.show = false" 
        class="ml-auto p-1.5 rounded-full hover:bg-black/5 dark:hover:bg-white/5"
      >
        <X class="h-4 w-4" />
      </button>
    </div>
    
    <!-- Statistiques rapides -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      <div 
        v-for="stat in stats" 
        :key="stat.label"
        class="bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-100 dark:border-gray-700"
      >
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ stat.label }}</p>
            <p class="text-2xl font-bold text-gray-900 dark:text-white mt-1">{{ stat.value }}</p>
          </div>
          <div 
            class="h-12 w-12 rounded-full flex items-center justify-center"
            :class="stat.colorClass"
          >
            <component :is="stat.icon" class="h-6 w-6 text-white" />
          </div>
        </div>
      </div>
    </div>
    
    <!-- Filtres et actions -->
    <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-5">
      <div class="flex flex-wrap gap-4 items-center justify-between">
        <div class="flex flex-wrap gap-3">
          <!-- Recherche -->
          <div class="relative">
            <Search class="absolute left-3 top-2.5 h-5 w-5 text-gray-400" />
            <input 
              v-model="search"
              type="text"
              placeholder="Rechercher un service..."
              class="pl-10 pr-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white w-60"
            />
          </div>
          
          <!-- Filtre de catégorie -->
          <select 
            v-model="categoryFilter"
            class="px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-full focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
          >
            <option value="all">Toutes les catégories</option>
            <option v-for="category in categories" :key="category.id" :value="category.id">
              {{ category.name }}
            </option>
          </select>
        </div>
        
        <!-- Actions -->
        <div class="flex items-center gap-2">
          <button 
            @click="refreshData"
            class="flex items-center p-2.5 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-600 rounded-full hover:bg-gray-50 dark:hover:bg-gray-700"
            title="Rafraîchir"
          >
            <RefreshCw class="h-5 w-5" />
          </button>
          <button 
            @click="openCreateModal"
            class="flex items-center gap-2 px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-full font-medium shadow-sm transition-colors"
          >
            <PlusCircle class="h-5 w-5" />
            <span>Nouveau service</span>
          </button>
        </div>
      </div>
    </div>
    
    <!-- Liste des services -->
    <div v-if="isLoading" class="flex justify-center p-12">
      <div class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-primary-500 border-r-transparent"></div>
    </div>
    
    <div v-else-if="filteredServices.length === 0" class="bg-white dark:bg-gray-800 rounded-xl p-8 text-center border border-gray-100 dark:border-gray-700">
      <div class="inline-flex items-center justify-center h-16 w-16 rounded-full bg-gray-100 dark:bg-gray-700 mb-4">
        <ShoppingBag class="h-8 w-8 text-gray-500 dark:text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun service trouvé</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-4">
        Essayez de modifier vos filtres ou d'ajouter un nouveau service.
      </p>
      <button 
        @click="openCreateModal"
        class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-full shadow-sm flex items-center gap-2 mx-auto"
      >
        <PlusCircle class="h-4 w-4" />
        <span>Nouveau service</span>
      </button>
    </div>
    
    <div v-else class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
      <div 
        v-for="service in paginatedServices" 
        :key="service.id"
        class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 overflow-hidden hover:shadow-md transition-all duration-200"
      >
        <!-- Image du service -->
        <div class="h-48 w-full bg-gray-200 dark:bg-gray-700 overflow-hidden relative">
          <img 
            v-if="service.image_url" 
            :src="service.image_url" 
            alt="Image du service"
            class="w-full h-full object-cover"
          />
          <div 
            v-else
            class="w-full h-full flex items-center justify-center"
          >
            <ShoppingBag class="h-12 w-12 text-gray-400 dark:text-gray-500" />
          </div>
          
          <!-- Badge de catégorie -->
          <div 
            class="absolute top-3 right-3 px-3 py-1.5 rounded-full text-xs font-medium shadow-sm" 
            :style="{ 
              backgroundColor: getCategoryColor(service.category_id), 
              color: 'white'
            }"
          >
            {{ getCategoryName(service.category_id) }}
          </div>
        </div>
        
        <div class="p-5">
          <div class="flex items-start justify-between mb-2">
            <h3 class="text-xl font-bold text-gray-900 dark:text-white truncate">
              {{ service.name }}
            </h3>
            
            <!-- Statut -->
            <span 
              class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
              :class="service.is_active ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'"
            >
              {{ service.is_active ? 'Actif' : 'Inactif' }}
            </span>
          </div>
          
          <!-- Prix -->
          <div class="flex items-center text-primary-600 dark:text-primary-400 font-bold text-lg mb-3">
            {{ formatPrice(service.price) }}
            <span class="text-sm text-gray-500 dark:text-gray-400 font-normal ml-1">/ {{ service.price_unit }}</span>
          </div>
          
          <!-- Description -->
          <p class="text-gray-600 dark:text-gray-400 line-clamp-3 mb-4 min-h-[80px]">
            {{ service.description || 'Aucune description fournie.' }}
          </p>
          
          <!-- Actions -->
          <div class="flex items-center justify-between mt-4 pt-4 border-t border-gray-100 dark:border-gray-700">
            <button 
              @click="openEditModal(service)"
              class="inline-flex items-center text-sm text-primary-600 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-300"
            >
              <Edit class="h-4 w-4 mr-1" />
              Modifier
            </button>
            
            <div class="flex gap-1">
              <button 
                @click="toggleServiceStatus(service)"
                class="p-1.5 text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full"
                :title="service.is_active ? 'Désactiver' : 'Activer'"
              >
                <component :is="service.is_active ? 'EyeOff' : 'Eye'" class="h-5 w-5" />
              </button>
              <button 
                @click="viewServiceDetails(service)"
                class="p-1.5 text-blue-500 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 hover:bg-blue-50 dark:hover:bg-blue-900/20 rounded-full"
                title="Voir les détails"
              >
                <Eye class="h-5 w-5" />
              </button>
              <button 
                @click="confirmDeleteService(service)"
                class="p-1.5 text-red-500 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-full"
                title="Supprimer"
              >
                <Trash2 class="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Pagination -->
    <div v-if="totalPages > 1" class="flex justify-center mt-6">
      <div class="inline-flex rounded-md shadow-sm">
        <button
          @click="currentPage > 1 ? currentPage-- : null"
          :disabled="currentPage === 1"
          class="px-4 py-2 text-sm font-medium border border-gray-300 dark:border-gray-600 rounded-l-lg bg-white dark:bg-gray-800 disabled:opacity-50"
          :class="currentPage === 1 ? 'text-gray-400 dark:text-gray-600' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'"
        >
          <ChevronLeft class="h-5 w-5" />
        </button>
        <button
          v-for="page in visiblePages"
          :key="page"
          @click="page !== '...' ? currentPage = page : null"
          :disabled="page === '...'"
          class="px-4 py-2 text-sm font-medium border border-gray-300 dark:border-gray-600 border-l-0 bg-white dark:bg-gray-800"
          :class="[
            page === '...' ? 'text-gray-400 dark:text-gray-600' : 
            page === currentPage ? 'text-primary-600 dark:text-primary-400 bg-primary-50 dark:bg-primary-900/20 border-primary-200 dark:border-primary-900' : 
            'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'
          ]"
        >
          {{ page }}
        </button>
        <button
          @click="currentPage < totalPages ? currentPage++ : null"
          :disabled="currentPage === totalPages || totalPages === 0"
          class="px-4 py-2 text-sm font-medium border border-gray-300 dark:border-gray-600 border-l-0 rounded-r-lg bg-white dark:bg-gray-800 disabled:opacity-50"
          :class="currentPage === totalPages || totalPages === 0 ? 'text-gray-400 dark:text-gray-600' : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'"
        >
          <ChevronRight class="h-5 w-5" />
        </button>
      </div>
    </div>
  
  <!-- Modal pour ajouter/éditer un service (via Teleport) -->
  <Teleport to="body">
    <div v-if="showFormModal" class="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div 
        class="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-2xl max-h-[90vh] overflow-hidden"
        @click.stop
      >
        <div class="flex items-start justify-between p-5 border-b border-gray-200 dark:border-gray-700">
          <h3 class="text-xl font-bold text-gray-900 dark:text-white">
            {{ isEditing ? 'Modifier un service' : 'Ajouter un service' }}
          </h3>
          <button 
            @click="showFormModal = false"
            class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300"
          >
            <X class="h-5 w-5" />
          </button>
        </div>
        
        <div class="p-5 overflow-y-auto max-h-[calc(90vh-130px)]">
          <!-- Formulaire -->
          <form @submit.prevent="saveService" class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <!-- Nom -->
              <div class="col-span-2">
                <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Nom <span class="text-red-500">*</span>
                </label>
                <input 
                  id="name"
                  v-model="form.name"
                  type="text"
                  required
                  placeholder="Nom du service"
                  class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                />
              </div>
              
              <!-- Catégorie -->
              <div>
                <label for="category" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Catégorie <span class="text-red-500">*</span>
                </label>
                <select 
                  id="category"
                  v-model="form.category_id"
                  required
                  class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
                >
                  <option value="" disabled>Sélectionner une catégorie</option>
                  <option v-for="category in categories" :key="category.id" :value="category.id">
                    {{ category.name }}
                  </option>
                </select>
              </div>
              
              <!-- Prix -->
              <div class="flex gap-3">
                <div class="flex-1">
                  <label for="price" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                    Prix <span class="text-red-500">*</span>
                  </label>
                  <input 
                    id="price"
                    v-model="form.price"
                    type="number"
                    min="0"
                    step="0.01"
                    required
                    placeholder="0.00"
                    class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                  />
                </div>
                
                <div class="w-40">
                  <label for="price_unit" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                    Unité <span class="text-red-500">*</span>
                  </label>
                  <select 
                    id="price_unit"
                    v-model="form.price_unit"
                    required
                    class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white appearance-none"
                  >
                    <option value="heure">Heure</option>
                    <option value="jour">Jour</option>
                    <option value="projet">Projet</option>
                    <option value="m²">m²</option>
                  </select>
                </div>
              </div>
              
              <!-- Description -->
              <div class="col-span-2">
                <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Description
                </label>
                <textarea 
                  id="description"
                  v-model="form.description"
                  rows="4"
                  placeholder="Description détaillée du service"
                  class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                ></textarea>
              </div>
              
              <!-- Image URL -->
              <div class="col-span-2">
                <label for="image_url" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  URL de l'image
                </label>
                <input 
                  id="image_url"
                  v-model="form.image_url"
                  type="url"
                  placeholder="https://exemple.com/image.jpg"
                  class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                />
              </div>
              
              <!-- Durée estimée -->
              <div>
                <label for="estimated_time" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Durée estimée
                </label>
                <input 
                  id="estimated_time"
                  v-model="form.estimated_time"
                  type="text"
                  placeholder="Ex: 2-3 heures"
                  class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:text-white"
                />
              </div>
              
              <!-- Statut -->
              <div class="flex items-center h-full">
                <label class="inline-flex items-center cursor-pointer">
                  <input 
                    type="checkbox" 
                    v-model="form.is_active" 
                    class="sr-only peer"
                  >
                  <div class="relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary-300 dark:peer-focus:ring-primary-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-primary-600"></div>
                  <span class="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300">Actif</span>
                </label>
              </div>
            </div>
          </form>
        </div>
        
        <div class="flex justify-end gap-3 p-5 border-t border-gray-200 dark:border-gray-700">
          <button 
            @click="showFormModal = false"
            class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            Annuler
          </button>
          <button 
            @click="saveService"
            :disabled="isSaving || !form.name || !form.category_id || form.price === ''"
            class="px-4 py-2 text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 rounded-lg shadow-sm disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <div v-if="isSaving" class="flex items-center">
              <div class="h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
              Enregistrement...
            </div>
            <span v-else>{{ isEditing ? 'Mettre à jour' : 'Ajouter' }}</span>
          </button>
        </div>
      </div>
    </div>
  </Teleport>
  
  <!-- Modal de détails -->
  <Teleport to="body">
    <div v-if="showDetailsModal" class="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div 
        class="bg-white dark:bg-gray-800 rounded-xl shadow-xl w-full max-w-2xl max-h-[90vh] overflow-hidden"
        @click.stop
      >
        <div class="flex items-start justify-between p-5 border-b border-gray-200 dark:border-gray-700">
          <h3 class="text-xl font-bold text-gray-900 dark:text-white">
            Détails du service
          </h3>
          <button 
            @click="showDetailsModal = false"
            class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300"
          >
            <X class="h-5 w-5" />
          </button>
        </div>
        
        <div v-if="selectedService" class="p-5 overflow-y-auto max-h-[calc(90vh-130px)]">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Image -->
            <div class="col-span-2 h-48 bg-gray-200 dark:bg-gray-700 rounded-lg overflow-hidden">
              <img 
                v-if="selectedService.image_url" 
                :src="selectedService.image_url" 
                alt="Image du service"
                class="w-full h-full object-cover"
              />
              <div 
                v-else
                class="w-full h-full flex items-center justify-center"
              >
                <ShoppingBag class="h-12 w-12 text-gray-400 dark:text-gray-500" />
              </div>
            </div>
            
            <!-- Informations principales -->
            <div>
              <h4 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Informations</h4>
              <dl class="space-y-3">
                <div>
                  <dt class="text-sm text-gray-500 dark:text-gray-400">Nom</dt>
                  <dd class="text-base font-medium text-gray-900 dark:text-white">{{ selectedService.name }}</dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500 dark:text-gray-400">Catégorie</dt>
                  <dd class="text-base font-medium text-gray-900 dark:text-white">
                    {{ getCategoryName(selectedService.category_id) }}
                  </dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500 dark:text-gray-400">Prix</dt>
                  <dd class="text-base font-medium text-primary-600 dark:text-primary-400">
                    {{ formatPrice(selectedService.price) }} / {{ selectedService.price_unit }}
                  </dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500 dark:text-gray-400">Statut</dt>
                  <dd class="text-base">
                    <span 
                      class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
                      :class="selectedService.is_active ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400' : 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-400'"
                    >
                      {{ selectedService.is_active ? 'Actif' : 'Inactif' }}
                    </span>
                  </dd>
                </div>
              </dl>
            </div>
            
            <!-- Informations complémentaires -->
            <div>
              <h4 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Détails</h4>
              <dl class="space-y-3">
                <div>
                  <dt class="text-sm text-gray-500 dark:text-gray-400">Durée estimée</dt>
                  <dd class="text-base font-medium text-gray-900 dark:text-white">
                    {{ selectedService.estimated_time || 'Non spécifiée' }}
                  </dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500 dark:text-gray-400">Créé le</dt>
                  <dd class="text-base font-medium text-gray-900 dark:text-white">
                    {{ formatDate(selectedService.created_at) }}
                  </dd>
                </div>
                <div>
                  <dt class="text-sm text-gray-500 dark:text-gray-400">Dernière mise à jour</dt>
                  <dd class="text-base font-medium text-gray-900 dark:text-white">
                    {{ formatDate(selectedService.updated_at) }}
                  </dd>
                </div>
              </dl>
            </div>
            
            <!-- Description -->
            <div class="col-span-2 mt-2">
              <h4 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Description</h4>
              <p class="text-gray-600 dark:text-gray-400">
                {{ selectedService.description || 'Aucune description fournie.' }}
              </p>
            </div>
          </div>
        </div>
        
        <div class="flex justify-end gap-3 p-5 border-t border-gray-200 dark:border-gray-700">
          <button 
            @click="showDetailsModal = false"
            class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700"
          >
            Fermer
          </button>
          <button 
            v-if="selectedService"
            @click="openEditModal(selectedService); showDetailsModal = false"
            class="px-4 py-2 text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 rounded-lg shadow-sm flex items-center"
          >
            <Edit class="h-4 w-4 mr-1.5" />
            Modifier
          </button>
        </div>
      </div>
    </div>
  </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { 
  ShoppingBag, PlusCircle, Search, X, RefreshCw, Edit, Trash2, Eye, EyeOff, 
  CheckCircle, AlertTriangle, Info, ChevronLeft, ChevronRight, Download
} from 'lucide-vue-next'

// État
const supabase = useSupabaseClient()
const services = ref([])
const categories = ref([])
const isLoading = ref(true)
const error = ref(null)
const search = ref('')
const categoryFilter = ref('all')
const currentPage = ref(1)
const itemsPerPage = ref(9)
const showFormModal = ref(false)
const showDetailsModal = ref(false)
const selectedService = ref(null)
const isEditing = ref(false)
const isSaving = ref(false)
const editingId = ref(null)
const notification = ref({ show: false, type: '', title: '', message: '' })

// Formulaire
const form = ref({
  name: '',
  description: '',
  price: '',
  price_unit: 'heure',
  category_id: '',
  image_url: '',
  estimated_time: '',
  is_active: true
})

// Statistiques
const stats = ref([
  { 
    label: 'Services', 
    value: '0', 
    icon: ShoppingBag, 
    colorClass: 'bg-primary-500 dark:bg-primary-600' 
  },
  { 
    label: 'Services actifs', 
    value: '0', 
    icon: CheckCircle, 
    colorClass: 'bg-green-500 dark:bg-green-600' 
  },
  { 
    label: 'Catégories', 
    value: '0', 
    icon: Info, 
    colorClass: 'bg-blue-500 dark:bg-blue-600' 
  },
  { 
    label: 'Prix moyen', 
    value: '0€', 
    icon: AlertTriangle, 
    colorClass: 'bg-amber-500 dark:bg-amber-600' 
  }
])

// Filtrage
const filteredServices = computed(() => {
  let filtered = [...services.value]
  
  // Filtre de recherche
  if (search.value) {
    const searchLower = search.value.toLowerCase()
    filtered = filtered.filter(service => 
      service.name.toLowerCase().includes(searchLower) || 
      (service.description && service.description.toLowerCase().includes(searchLower))
    )
  }
  
  // Filtre de catégorie
  if (categoryFilter.value !== 'all') {
    filtered = filtered.filter(service => service.category_id === categoryFilter.value)
  }
  
  return filtered
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredServices.value.length / itemsPerPage.value))

const paginatedServices = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredServices.value.slice(start, end)
})

// Pages visibles
const visiblePages = computed(() => {
  const totalPageCount = totalPages.value
  if (totalPageCount <= 7) {
    return Array.from({ length: totalPageCount }, (_, i) => i + 1)
  }
  
  if (currentPage.value <= 3) {
    return [1, 2, 3, 4, 5, '...', totalPageCount]
  } else if (currentPage.value >= totalPageCount - 2) {
    return [1, '...', totalPageCount - 4, totalPageCount - 3, totalPageCount - 2, totalPageCount - 1, totalPageCount]
  } else {
    return [1, '...', currentPage.value - 1, currentPage.value, currentPage.value + 1, '...', totalPageCount]
  }
})

// Méthodes
const fetchData = async () => {
  isLoading.value = true
  
  try {
    // Récupérer les catégories
    const { data: categoriesData, error: categoriesError } = await supabase
      .from('categories')
      .select('*')
      .order('name')
    
    if (categoriesError) throw categoriesError
    
    categories.value = categoriesData || []
    
    // Récupérer les services
    const { data: servicesData, error: servicesError } = await supabase
      .from('services')
      .select('*')
      .order('name')
    
    if (servicesError) throw servicesError
    
    services.value = servicesData || []
    
    // Mettre à jour les statistiques
    updateStats()
  } catch (err) {
    console.error('Erreur lors du chargement des données:', err)
    error.value = err.message
    showNotification('error', 'Erreur', 'Impossible de charger les données')
  } finally {
    isLoading.value = false
  }
}

// Mettre à jour les statistiques
const updateStats = () => {
  stats.value[0].value = services.value.length.toString()
  stats.value[1].value = services.value.filter(s => s.is_active).length.toString()
  stats.value[2].value = categories.value.length.toString()
  
  // Calculer le prix moyen
  if (services.value.length > 0) {
    const totalPrice = services.value.reduce((sum, service) => sum + parseFloat(service.price || 0), 0)
    const avgPrice = totalPrice / services.value.length
    stats.value[3].value = formatPrice(avgPrice)
  } else {
    stats.value[3].value = '0€'
  }
}

// État
const loading = ref(true)
const sortOption = ref('recent')
const serviceToDelete = ref(null)
const showDeleteModal = ref(false)
const serviceToEdit = ref(null)
const showServiceModal = ref(false)
const statusMessage = ref({
  show: false,
  type: 'info',
  message: ''
})

// const filteredServices = computed(() => {
//   if (!search.value && !categoryFilter.value) return services.value
  
//   const searchLower = search.value?.toLowerCase() || ''
//   const categoryId = categoryFilter.value
  
//   return services.value.filter(service => 
//     service.name?.toLowerCase().includes(searchLower) ||
//     service.description?.toLowerCase().includes(searchLower) ||
//     (categoryId && service.category_id === categoryId)
//   )
// })

// const totalPages = computed(() => Math.ceil(filteredServices.value.length / itemsPerPage))
// const paginatedServices = computed(() => {
//   const start = (currentPage.value - 1) * itemsPerPage
//   const end = start + itemsPerPage
//   return filteredServices.value.slice(start, end)
// })

const paginationStart = computed(() => {
  if (filteredServices.value.length === 0) return 0
  return (currentPage.value - 1) * itemsPerPage + 1
})

const paginationEnd = computed(() => {
  const end = currentPage.value * itemsPerPage
  return end > filteredServices.value.length ? filteredServices.value.length : end
})

const displayedPages = computed(() => {
  if (totalPages.value <= 7) {
    return Array.from({ length: totalPages.value }, (_, i) => i + 1)
  }
  
  if (currentPage.value <= 4) {
    return [1, 2, 3, 4, 5, '...', totalPages.value]
  }
  
  if (currentPage.value >= totalPages.value - 3) {
    return [1, '...', totalPages.value - 4, totalPages.value - 3, totalPages.value - 2, totalPages.value - 1, totalPages.value]
  }
  
  return [1, '...', currentPage.value - 1, currentPage.value, currentPage.value + 1, '...', totalPages.value]
})

function formatDate(dateString) {
  if (!dateString) return '—'
  const date = new Date(dateString)
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

function formatPrice(price) {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR',
    minimumFractionDigits: 0
  }).format(price)
}

function getCategoryName(categoryId) {
  const category = categories.value.find(c => c.id === categoryId)
  return category ? category.name : 'Non catégorisé'
}

function openServiceModal() {
  serviceToEdit.value = {
    name: '',
    description: '',
    category_id: '',
    price: 0,
    duration: 60,
    active: true,
    icon: '🔧'
  }
  showServiceModal.value = true
}

function editService(service) {
  serviceToEdit.value = { ...service }
  showServiceModal.value = true
}

function openDeleteModal(service) {
  serviceToDelete.value = service
  showDeleteModal.value = true
}

function exportServices() {
  // Logique d'exportation
  console.log('Exporter les services')
}

async function fetchServices() {
  isLoading.value = true
  error.value = null
  
  try {
    // Récupérer les catégories
    const { data: categoriesData, error: categoriesError } = await supabase
      .from('categories')
      .select('*')
      .order('name')
    
    if (categoriesError) throw categoriesError
    
    categories.value = categoriesData || []
    
    // Récupérer les services
    const { data: servicesData, error: servicesError } = await supabase
      .from('services')
      .select('*')
      .order('created_at', { ascending: false })
    
    if (servicesError) throw servicesError
    
    services.value = servicesData || []
    
    // Mettre à jour les statistiques
    updateStats()
  } catch (err) {
    console.error('Erreur lors du chargement des données:', err)
    error.value = err.message
    showNotification('error', 'Erreur', 'Impossible de charger les données')
  } finally {
    isLoading.value = false
  }
}

async function saveService(serviceData) {
  try {
    // Logique pour enregistrer le service
    await fetchServices()
    showServiceModal.value = false
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement du service:', error)
    alert('Erreur lors de l\'enregistrement du service: ' + error.message)
  }
}

async function deleteService() {
  if (!serviceToDelete.value) return
  
  try {
    // Logique pour supprimer le service
    await fetchServices()
    showDeleteModal.value = false
    serviceToDelete.value = null
  } catch (error) {
    console.error('Erreur lors de la suppression du service:', error)
    alert('Erreur lors de la suppression du service: ' + error.message)
  }
}

// Réinitialiser les filtres
const resetFilters = () => {
  search.value = ''
  categoryFilter.value = ''
  sortOption.value = 'recent'
  currentPage.value = 1
}

// Afficher un message de statut
const showStatusMessage = (type, message, duration = 5000) => {
  statusMessage.value = {
    show: true,
    type,
    message
  }
  
  setTimeout(() => {
    statusMessage.value.show = false
  }, duration)
}

watch([search, categoryFilter, sortOption], () => {
  currentPage.value = 1
})

onMounted(() => {
  fetchServices()
})

definePageMeta({
  layout: 'admin'
})
</script>

<style scoped>
/* Style pour les sélecteurs avec flèche dropdown */
select {
  background-position: right 1rem center;
  background-repeat: no-repeat;
  background-size: 1em;
  background-image: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>');
}

/* Animation pour le modal */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.25s ease, transform 0.25s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>