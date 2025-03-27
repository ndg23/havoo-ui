<template>
  <div class="min-h-screen bg-white">
    <!-- Twitter-inspired sticky header with lighter design -->
    <header class="sticky top-0 z-10 bg-white border-b border-gray-100 px-4 py-3 mb-5">
      <div class="max-w-5xl mx-auto flex items-center justify-between">
        <div class="flex items-center">
          <button 
            @click="router.back()" 
            class="flex items-center text-gray-700 hover:text-primary-600 transition-colors font-medium"
          >
            <ChevronLeft class="h-5 w-5 mr-1" />
            <span>Retour</span>
          </button>
          
          <h1 class="text-xl font-bold text-gray-900 ml-6 hidden md:block">
            Détails de l'utilisateur
          </h1>
        </div>
        
        <div v-if="user && !error" class="flex gap-3">
          <button
            @click="editMode = !editMode"
            class="px-4 py-2 rounded-full flex items-center bg-gray-50 text-gray-800 hover:bg-gray-100 transition-colors text-sm font-medium border border-gray-100"
          >
            <component :is="editMode ? 'Eye' : 'Edit'" class="h-4 w-4 mr-2" />
            {{ editMode ? 'Voir profil' : 'Modifier' }}
          </button>
          
          <button
            @click="confirmDelete"
            class="p-2 rounded-full flex items-center text-red-500 hover:bg-red-50 transition-colors border border-transparent hover:border-red-100"
          >
            <Trash class="h-5 w-5" />
          </button>
        </div>
      </div>
    </header>

    <main class="max-w-5xl mx-auto px-4 py-4">
      <!-- Enhanced loading state with Twitter spinner -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-24">
        <div class="animate-spin h-10 w-10 mb-5 text-primary-500">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="#E1E8ED" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        </div>
        <p class="text-gray-500 font-medium">Chargement des informations...</p>
      </div>
      
      <!-- Twitter-style error state -->
      <div v-else-if="error" class="max-w-md mx-auto bg-red-50 p-5 rounded-2xl border border-red-50 text-red-700">
        <div class="flex">
          <AlertCircle class="h-5 w-5 text-red-500 mr-3 flex-shrink-0" />
          <div>
            <p class="font-medium">Utilisateur non trouvé</p>
            <p class="mt-1 text-sm">Impossible de trouver les détails de cet utilisateur. Il a peut-être été supprimé.</p>
            <button 
              @click="router.push('/admin/users')" 
              class="mt-4 text-sm font-semibold text-red-600 hover:text-red-700 bg-red-50 hover:bg-red-100 px-5 py-2 rounded-full transition-colors"
            >
              Retour à la liste
            </button>
          </div>
        </div>
      </div>
      
      <!-- Main content -->
      <div v-else-if="user" class="space-y-6">
        <!-- User profile header with Twitter-style design -->
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden hover:border-gray-200 transition-colors">
          <div class="h-36 bg-gradient-to-r from-primary-50 to-blue-50 relative">
            <!-- Subtle decorative elements -->
            <div class="absolute top-0 right-0 w-32 h-32 rounded-full bg-primary-100 opacity-20 -translate-y-1/2 translate-x-1/2"></div>
            <div class="absolute bottom-0 left-0 w-24 h-24 rounded-full bg-blue-100 opacity-20 translate-y-1/2 -translate-x-1/2"></div>
          </div>
          
          <div class="relative px-6 pt-16 pb-6">
            <!-- User avatar positioned at the edge of the header with improved border -->
            <div class="absolute -top-12 left-6">
              <div class="h-24 w-24 rounded-full border-4 border-white bg-white overflow-hidden ring-4 ring-primary-50 ring-opacity-50">
                <img 
                  v-if="user.avatar_url" 
                  :src="user.avatar_url" 
                  alt="Avatar" 
                  class="h-full w-full object-cover"
                />
                <div v-else class="h-full w-full bg-gray-100 flex items-center justify-center">
                  <User class="h-12 w-12 text-gray-400" />
                </div>
              </div>
            </div>
            
            <div class="flex flex-col md:flex-row md:items-start md:justify-between">
              <div>
                <h1 class="text-2xl font-bold text-gray-900">
                  {{ user.first_name }} {{ user.last_name }}
                </h1>
                <div class="text-gray-500 mt-1 flex items-center">
                  <Mail class="h-3.5 w-3.5 mr-1.5 text-gray-400" />
                  {{ user.email }}
                </div>
                
                <div class="flex mt-3 gap-2">
                  <!-- Role badge with enhanced hover effect -->
                  <span 
                    class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium transition-colors duration-200"
                    :class="{
                      'bg-blue-50 text-blue-700 hover:bg-blue-100': user.role === 'admin',
                      'bg-primary-50 text-primary-700 hover:bg-primary-100': user.role === 'expert',
                      'bg-gray-100 text-gray-800 hover:bg-gray-200': user.role === 'client'
                    }"
                  >
                    <component 
                      :is="user.role === 'admin' ? 'Shield' : user.role === 'expert' ? 'Briefcase' : 'User'" 
                      class="h-3 w-3 mr-1.5" 
                    />
                    {{ formatRole(user.role) }}
                  </span>
                  
                  <!-- Status badge with enhanced styling -->
                  <span 
                    class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium transition-colors duration-200"
                    :class="{
                      'bg-green-50 text-green-700 hover:bg-green-100': user.status === 'active',
                      'bg-amber-50 text-amber-700 hover:bg-amber-100': user.status === 'pending',
                      'bg-red-50 text-red-700 hover:bg-red-100': user.status === 'blocked'
                    }"
                  >
                    <component 
                      :is="user.status === 'active' ? 'CheckCircle' : user.status === 'pending' ? 'Clock' : 'XCircle'" 
                      class="h-3 w-3 mr-1.5" 
                    />
                    {{ formatStatus(user.status) }}
                  </span>
                </div>
              </div>
              
              <div class="mt-4 md:mt-0">
                <div class="text-sm text-gray-500 flex items-center px-3 py-1.5 bg-gray-50 rounded-lg">
                  <Calendar class="h-4 w-4 mr-2 text-gray-400" />
                  <span>Inscrit le {{ formatDate(user.created_at) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- View mode content -->
        <div v-if="!editMode" class="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <!-- Left column: Personal information -->
          <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
              <h3 class="font-semibold text-gray-900 flex items-center">
                <User class="h-5 w-5 mr-2 text-primary-600" />
                Informations personnelles
              </h3>
            </div>
            
            <div class="p-6 space-y-4">
              <div class="border-b border-gray-100 pb-4">
                <div class="text-sm font-medium text-gray-500 mb-1">Nom complet</div>
                <div class="text-gray-900 font-medium">{{ user.first_name }} {{ user.last_name }}</div>
              </div>
              
              <div class="border-b border-gray-100 pb-4">
                <div class="text-sm font-medium text-gray-500 mb-1">Email</div>
                <div class="text-gray-900">{{ user.email }}</div>
              </div>
              
              <div class="border-b border-gray-100 pb-4">
                <div class="text-sm font-medium text-gray-500 mb-1">Téléphone</div>
                <div class="text-gray-900">{{ user.phone || '—' }}</div>
              </div>
              
              <div>
                <div class="text-sm font-medium text-gray-500 mb-1">Adresse</div>
                <div class="text-gray-900">
                  <div>{{ user.location || '—' }}</div>
                  <div v-if="user.city || user.zip_code" class="mt-1">
                    {{ user.zip_code || '' }} {{ user.city || '' }}
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Middle column: Expert information -->
          <div v-if="user.role === 'expert'" class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
              <h3 class="font-semibold text-gray-900 flex items-center">
                <Briefcase class="h-5 w-5 mr-2 text-primary-600" />
                Informations expert
              </h3>
            </div>
            
            <div class="p-6 space-y-4">
              <div class="border-b border-gray-100 pb-4">
                <div class="text-sm font-medium text-gray-500 mb-1">Tarif horaire</div>
                <div class="text-gray-900 font-medium">
                  {{ user.hourly_rate ? `${user.hourly_rate} FCFA/h` : '—' }}
                </div>
              </div>
              
              <div class="border-b border-gray-100 pb-4">
                <div class="text-sm font-medium text-gray-500 mb-1">Disponibilité</div>
                <div class="text-gray-900 flex items-center">
                  <div class="h-2 w-2 rounded-full mr-2 bg-green-500"></div>
                  {{ user.availability_status || 'Disponible' }}
                </div>
              </div>
              
              <div class="border-b border-gray-100 pb-4">
                <div class="text-sm font-medium text-gray-500 mb-1">Vérification</div>
                <div class="mt-1">
                  <span 
                    class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium"
                    :class="{
                      'bg-green-50 text-green-700': user.verification_status === 'verified',
                      'bg-amber-50 text-amber-700': user.verification_status === 'pending',
                      'bg-red-50 text-red-700': user.verification_status === 'rejected'
                    }"
                  >
                    <component :is="getVerificationIcon(user.verification_status)" class="h-3.5 w-3.5 mr-1" />
                    {{ formatVerificationStatus(user.verification_status) }}
                  </span>
                </div>
              </div>
              
              <div>
                <div class="text-sm font-medium text-gray-500 mb-1">Note moyenne</div>
                <div class="flex items-center">
                  <div class="flex">
                    <Star class="h-5 w-5 text-amber-400" :fill="true" />
                    <Star class="h-5 w-5 text-amber-400" :fill="user.rating >= 2" />
                    <Star class="h-5 w-5 text-amber-400" :fill="user.rating >= 3" />
                    <Star class="h-5 w-5 text-amber-400" :fill="user.rating >= 4" />
                    <Star class="h-5 w-5 text-amber-400" :fill="user.rating >= 5" />
                  </div>
                  <span class="ml-2 font-medium">{{ user.rating || '—' }}</span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Right column: Statistics -->
          <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
              <h3 class="font-semibold text-gray-900 flex items-center">
                <BarChart2 class="h-5 w-5 mr-2 text-primary-600" />
                Statistiques
              </h3>
            </div>
            
            <div class="p-6">
              <div class="grid grid-cols-2 gap-4">
                <div class="bg-white p-4 rounded-lg border border-gray-100 hover:border-primary-100 hover:bg-blue-50/10 transition-all duration-200 group">
                  <div class="flex justify-between items-start">
                    <div>
                      <div class="text-sm text-gray-500 mb-1">Demandes</div>
                      <div class="text-2xl font-bold text-gray-900 group-hover:text-primary-600 transition-colors">{{ stats.missions || 0 }}</div>
                    </div>
                    <div class="h-9 w-9 rounded-full bg-primary-50 flex items-center justify-center group-hover:bg-primary-100 transition-colors">
                      <FileText class="h-4 w-4 text-primary-600" />
                    </div>
                  </div>
                </div>
                
                <div class="bg-white p-4 rounded-lg border border-gray-100 hover:border-primary-100 hover:bg-blue-50/10 transition-all duration-200 group">
                  <div class="flex justify-between items-start">
                    <div>
                      <div class="text-sm text-gray-500 mb-1">Propositions</div>
                      <div class="text-2xl font-bold text-gray-900 group-hover:text-primary-600 transition-colors">{{ stats.proposals || 0 }}</div>
                    </div>
                    <div class="h-9 w-9 rounded-full bg-primary-50 flex items-center justify-center group-hover:bg-primary-100 transition-colors">
                      <MessageCircle class="h-4 w-4 text-primary-600" />
                    </div>
                  </div>
                </div>
                
                <div class="bg-white p-4 rounded-lg border border-gray-100 hover:border-primary-100 hover:bg-blue-50/10 transition-all duration-200 group">
                  <div class="flex justify-between items-start">
                    <div>
                      <div class="text-sm text-gray-500 mb-1">Contrats</div>
                      <div class="text-2xl font-bold text-gray-900 group-hover:text-primary-600 transition-colors">{{ stats.contracts || 0 }}</div>
                    </div>
                    <div class="h-9 w-9 rounded-full bg-primary-50 flex items-center justify-center group-hover:bg-primary-100 transition-colors">
                      <FileText class="h-4 w-4 text-primary-600" />
                    </div>
                  </div>
                </div>
                
                <div class="bg-white p-4 rounded-lg border border-gray-100 hover:border-primary-100 hover:bg-blue-50/10 transition-all duration-200 group">
                  <div class="flex justify-between items-start">
                    <div>
                      <div class="text-sm text-gray-500 mb-1">Avis</div>
                      <div class="text-2xl font-bold text-gray-900 group-hover:text-primary-600 transition-colors">{{ stats.reviews || 0 }}</div>
                    </div>
                    <div class="h-9 w-9 rounded-full bg-primary-50 flex items-center justify-center group-hover:bg-primary-100 transition-colors">
                      <Star class="h-4 w-4 text-primary-600" />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Quick verification button for experts in view mode -->
        <div v-if="user.role === 'expert' && !editMode" class="mt-6 flex items-center gap-4">
          <button
            v-if="user.verification_status !== 'verified'"
            @click="verifyExpert"
            class="px-5 py-2.5 rounded-full bg-white text-green-600 hover:bg-green-50 transition-all flex items-center gap-2 border border-green-200"
          >
            <Badge class="h-4 w-4" />
            <span>Vérifier l'expert</span>
          </button>
          
          <button
            v-else
            @click="confirmUnverifyExpert"
            class="px-5 py-2.5 rounded-full bg-white text-gray-700 hover:bg-gray-50 transition-all flex items-center gap-2 border border-gray-200"
          >
            <ShieldOff class="h-4 w-4" />
            <span>Retirer la vérification</span>
          </button>

          <div v-if="verificationLoading" class="animate-pulse text-sm text-gray-600 ml-2 flex items-center">
            <div class="animate-spin h-4 w-4 mr-2 text-primary-500">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="#E1E8ED" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
            </div>
            Mise à jour...
          </div>
        </div>
        
        <!-- Edit mode content -->
        <div v-if="editMode" class="bg-white rounded-2xl border border-gray-100 overflow-hidden p-6">
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <Edit class="h-5 w-5 mr-2 text-primary-600" />
              Modifier l'utilisateur
            </h3>
            
            <div class="flex gap-3">
              <button
                @click="cancelEdit"
                class="px-4 py-2 rounded-full text-gray-700 hover:bg-gray-50 transition-all border border-gray-100"
              >
                <span class="flex items-center">
                  <X class="h-4 w-4 mr-2" />
                  Annuler
                </span>
              </button>
              
              <button
                @click="saveChanges"
                class="px-5 py-2 rounded-full bg-primary-600 text-white hover:bg-primary-700 transition-all"
              >
                <span class="flex items-center">
                  <Check class="h-4 w-4 mr-2" />
                  Enregistrer
                </span>
              </button>
            </div>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Personal Information Form -->
            <div class="bg-white rounded-xl border border-gray-100 p-5 hover:border-gray-200 transition-colors">
              <h4 class="font-medium text-gray-900 mb-4 flex items-center">
                <User class="h-4 w-4 mr-2 text-primary-600" />
                Informations personnelles
              </h4>
              
              <div class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1" for="first_name">Prénom</label>
                    <input
                      id="first_name"
                      v-model="editedUser.first_name"
                      type="text"
                      class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                      placeholder="Prénom"
                    />
                  </div>
                  
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1" for="last_name">Nom</label>
                    <input
                      id="last_name"
                      v-model="editedUser.last_name"
                      type="text"
                      class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                      placeholder="Nom"
                    />
                  </div>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1" for="email">Email</label>
                  <input
                    id="email"
                    v-model="editedUser.email"
                    type="email"
                    class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                    placeholder="exemple@email.com"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1" for="phone">Téléphone</label>
                  <input
                    id="phone"
                    v-model="editedUser.phone"
                    type="tel"
                    class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                    placeholder="+XX XXX XXX XXX"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1" for="location">Adresse</label>
                  <input
                    id="location"
                    v-model="editedUser.location"
                    type="text"
                    class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                    placeholder="Adresse"
                  />
                </div>
                
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1" for="city">Ville</label>
                    <input
                      id="city"
                      v-model="editedUser.city"
                      type="text"
                      class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                      placeholder="Ville"
                    />
                  </div>
                  
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1" for="zip_code">Code postal</label>
                    <input
                      id="zip_code"
                      v-model="editedUser.zip_code"
                      type="text"
                      class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                      placeholder="Code postal"
                    />
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Status and role form -->
            <div class="bg-white rounded-xl border border-gray-100 p-5 hover:border-gray-200 transition-colors">
              <h4 class="font-medium text-gray-900 mb-4 flex items-center">
                <Settings class="h-4 w-4 mr-2 text-primary-600" />
                Statut et rôle
              </h4>
              
              <div class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1" for="role">Rôle</label>
                  <select
                    id="role"
                    v-model="editedUser.role"
                    class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                  >
                    <option value="admin">Administrateur</option>
                    <option value="expert">Expert</option>
                    <option value="client">Client</option>
                  </select>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1" for="status">Statut</label>
                  <select
                    id="status"
                    v-model="editedUser.status"
                    class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                  >
                    <option value="active">Actif</option>
                    <option value="pending">En attente</option>
                    <option value="blocked">Bloqué</option>
                  </select>
                </div>
                
                <div v-if="editedUser.role === 'expert'">
                  <label class="block text-sm font-medium text-gray-700 mb-1" for="hourly_rate">Tarif horaire (FCFA)</label>
                  <input
                    id="hourly_rate"
                    v-model="editedUser.hourly_rate"
                    type="number"
                    class="w-full px-3 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition-all"
                    placeholder="Tarif horaire"
                  />
                </div>
                
                <div v-if="editedUser.role === 'expert'">
                  <label class="block text-sm font-medium text-gray-700 mb-1" for="verification_status">Statut de vérification</label>
                  <div class="flex gap-3 mt-1">
                    <button
                      @click="editedUser.verification_status = 'verified'"
                      class="flex-1 px-3 py-2.5 rounded-lg border flex items-center justify-center gap-2 transition-all"
                      :class="editedUser.verification_status === 'verified' ? 
                        'bg-green-50 border-green-200 text-green-700' : 
                        'border-gray-200 hover:bg-gray-50 text-gray-700'"
                    >
                      <CheckCircle class="h-4 w-4" :class="editedUser.verification_status === 'verified' ? 'text-green-500' : 'text-gray-400'" />
                      <span>Vérifié</span>
                    </button>
                    
                    <button
                      @click="editedUser.verification_status = 'pending'"
                      class="flex-1 px-3 py-2.5 rounded-lg border flex items-center justify-center gap-2 transition-all"
                      :class="editedUser.verification_status === 'pending' ? 
                        'bg-yellow-50 border-yellow-200 text-yellow-700' : 
                        'border-gray-200 hover:bg-gray-50 text-gray-700'"
                    >
                      <Clock class="h-4 w-4" :class="editedUser.verification_status === 'pending' ? 'text-yellow-500' : 'text-gray-400'" />
                      <span>En attente</span>
                    </button>
                    
                    <button
                      @click="editedUser.verification_status = 'rejected'"
                      class="flex-1 px-3 py-2.5 rounded-lg border flex items-center justify-center gap-2 transition-all"
                      :class="editedUser.verification_status === 'rejected' ? 
                        'bg-red-50 border-red-200 text-red-700' : 
                        'border-gray-200 hover:bg-gray-50 text-gray-700'"
                    >
                      <X class="h-4 w-4" :class="editedUser.verification_status === 'rejected' ? 'text-red-500' : 'text-gray-400'" />
                      <span>Rejeté</span>
                    </button>
                  </div>
                </div>
                
                <div class="pt-4">
                  <h4 class="font-medium text-gray-900 mb-4 flex items-center">
                    <Image class="h-4 w-4 mr-2 text-primary-600" />
                    Photo de profil
                  </h4>
                  
                  <div class="flex items-center space-x-4">
                    <div class="h-16 w-16 rounded-full bg-gray-100 overflow-hidden flex-shrink-0 border border-gray-200">
                      <img 
                        v-if="editedUser.avatar_url" 
                        :src="editedUser.avatar_url" 
                        alt="Avatar" 
                        class="h-full w-full object-cover"
                      />
                      <User v-else class="h-8 w-8 text-gray-400 m-4" />
                    </div>
                    
                    <div>
                      <button class="px-3 py-1.5 border border-gray-200 rounded-lg text-sm hover:bg-gray-50 transition-colors">
                        <span class="flex items-center">
                          <UploadCloud class="h-3.5 w-3.5 mr-1.5" />
                          Modifier la photo
                        </span>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Activity section (always visible) -->
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-5 flex items-center">
            <Activity class="h-5 w-5 mr-2 text-primary-600" />
            Activité récente
          </h3>
          
          <div v-if="activities.length > 0" class="space-y-4">
            <div 
              v-for="activity in activities" 
              :key="activity.id"
              class="flex p-4 rounded-lg hover:bg-gray-50 transition-colors border border-gray-100 group"
            >
              <div class="h-10 w-10 rounded-full bg-gray-50 flex items-center justify-center mr-4 flex-shrink-0 group-hover:bg-primary-50 transition-colors">
                <component :is="getActivityIcon(activity.type)" class="h-5 w-5 text-primary-500" />
              </div>
              
              <div class="flex-grow">
                <div class="text-gray-900 font-medium group-hover:text-primary-600 transition-colors">{{ activity.title }}</div>
                <div class="text-sm text-gray-500 mt-1">{{ formatDate(activity.created_at, true) }}</div>
              </div>
              
              <button class="text-gray-400 hover:text-primary-600 h-8 w-8 rounded-full flex items-center justify-center hover:bg-gray-50">
                <ChevronRight class="h-5 w-5" />
              </button>
            </div>
          </div>
          
          <div v-else class="flex flex-col items-center justify-center py-10 text-gray-500 bg-gray-50 rounded-lg">
            <Calendar class="h-12 w-12 text-gray-300 mb-3" />
            <p class="font-medium">Aucune activité récente</p>
            <p class="text-sm text-gray-400 mt-1">Les activités de l'utilisateur apparaîtront ici</p>
          </div>
        </div>
      </div>
    </main>

    <!-- Delete confirmation modal -->
    <ConfirmModal
      :show="showDeleteModal"
      title="Supprimer cet utilisateur ?"
      @close="showDeleteModal = false"
    >
      <div class="py-3">
        <div class="flex justify-center mb-4">
          <div class="h-16 w-16 rounded-full bg-red-50 flex items-center justify-center">
            <AlertCircle class="h-8 w-8 text-red-500" />
          </div>
        </div>
        
        <p class="text-gray-700 mb-4 text-center">
          Cette action est irréversible et supprimera définitivement toutes les données de cet utilisateur.
        </p>
        
        <div class="bg-gray-50 p-4 rounded-lg mb-4 border border-gray-100">
          <div class="flex items-center">
            <div class="h-10 w-10 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 mr-4">
              <img 
                v-if="user?.avatar_url" 
                :src="user.avatar_url" 
                alt="Avatar" 
                class="h-full w-full object-cover"
              />
              <User v-else class="h-6 w-6 text-gray-400 m-2" />
            </div>
            <div>
              <div class="font-medium">{{ user?.first_name }} {{ user?.last_name }}</div>
              <div class="text-sm text-gray-500">{{ user?.email }}</div>
            </div>
          </div>
        </div>
      </div>
      
      <template #footer>
        <div class="flex justify-end gap-3">
          <button
            @click="showDeleteModal = false"
            class="px-4 py-2 bg-white border border-gray-100 rounded-full text-gray-700 hover:bg-gray-50 transition-colors"
          >
            Annuler
          </button>
          
          <button
            @click="deleteUser"
            class="px-4 py-2 bg-white text-red-600 rounded-full hover:bg-red-50 transition-colors border border-red-100"
            :class="{ 'opacity-75 cursor-not-allowed': deleting }"
            :disabled="deleting"
          >
            <span v-if="deleting" class="flex items-center">
              <Loader2 class="animate-spin h-4 w-4 mr-2" />
              Suppression...
            </span>
            <span v-else>Supprimer</span>
          </button>
        </div>
      </template>
    </ConfirmModal>

    <!-- Verification success modal -->
    <ConfirmModal
      :show="showVerificationModal"
      :title="verificationModalTitle"
      @close="showVerificationModal = false"
    >
      <div class="py-3">
        <div class="flex justify-center mb-4">
          <div 
            class="h-16 w-16 rounded-full flex items-center justify-center"
            :class="verificationState === 'verified' ? 'bg-green-50' : 'bg-gray-50'"
          >
            <component :is="verificationState === 'verified' ? 'CheckCircle' : 'ShieldOff'" 
              class="h-8 w-8"
              :class="verificationState === 'verified' ? 'text-green-500' : 'text-gray-500'"
            />
          </div>
        </div>
        
        <p class="text-gray-700 mb-4 text-center">
          {{ verificationModalMessage }}
        </p>
        
        <div class="bg-gray-50 p-4 rounded-lg mb-4 border border-gray-100">
          <div class="flex items-center">
            <div class="h-10 w-10 rounded-full bg-gray-100 overflow-hidden flex-shrink-0 mr-4">
              <img 
                v-if="user?.avatar_url" 
                :src="user.avatar_url" 
                alt="Avatar" 
                class="h-full w-full object-cover"
              />
              <User v-else class="h-6 w-6 text-gray-400 m-2" />
            </div>
            <div>
              <div class="font-medium">{{ user?.first_name }} {{ user?.last_name }}</div>
              <div class="text-sm text-gray-500">{{ user?.email }}</div>
            </div>
          </div>
        </div>
      </div>
      
      <template #footer>
        <div class="flex justify-end gap-3">
          <button
            @click="showVerificationModal = false"
            class="px-4 py-2 bg-white border border-gray-100 rounded-full text-gray-700 hover:bg-gray-50 transition-colors"
          >
            Fermer
          </button>
        </div>
      </template>
    </ConfirmModal>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useSupabaseClient } from '#imports'
import { 
  ChevronLeft, ChevronRight, Edit, Trash, User, Star, AlertCircle, Loader2,
  MessageCircle, FileText, CreditCard, Check, X, ShoppingBag,
  Calendar, Clock, Briefcase, Heart, Activity, BarChart2, Eye, CheckCircle, Badge, ShieldOff, Mail, UploadCloud, Settings, Image
} from 'lucide-vue-next'
import ConfirmModal from '@/components/admin/ConfirmModal.vue'

const router = useRouter()
const route = useRoute()
const client = useSupabaseClient()

const userId = route.params.id
const user = ref(null)
const loading = ref(true)
const error = ref(null)
const showDeleteModal = ref(false)
const deleting = ref(false)
const activities = ref([])
const stats = ref({
  missions: 0,
  proposals: 0,
  contracts: 0,
  reviews: 0
})

// Edit mode management
const editMode = ref(false)
const editedUser = ref(null)

// Verification management
const showVerificationModal = ref(false)
const verificationModalTitle = ref('')
const verificationModalMessage = ref('')
const verificationState = ref(null)
const verificationLoading = ref(false)

// Load user data
onMounted(async () => {
  try {
    loading.value = true
    
    // Get user details
    const { data, error: fetchError } = await client
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .single()
    
    if (fetchError) throw fetchError
    
    if (!data) {
      error.value = 'Utilisateur non trouvé'
    } else {
      user.value = data
      // Create a copy for editing
      editedUser.value = JSON.parse(JSON.stringify(data))
      
      // Load activities (simulation)
      activities.value = generateMockActivities()
      
      // Load statistics (simulation)
      stats.value = await fetchUserStats()
    }
  } catch (err) {
    console.error('Erreur lors du chargement des données:', err)
    error.value = err.message
  } finally {
    loading.value = false
  }
})

// Cancel edit
const cancelEdit = () => {
  // Reset form data to original
  editedUser.value = JSON.parse(JSON.stringify(user.value))
  editMode.value = false
}

// Save changes
const saveChanges = async () => {
  try {
    loading.value = true
    
    // Update the profile in the database
    const { error: updateError } = await client
      .from('profiles')
      .update(editedUser.value)
      .eq('id', userId)
      
    if (updateError) throw updateError
    
    // Update local user data
    user.value = JSON.parse(JSON.stringify(editedUser.value))
    
    // Switch back to view mode
    editMode.value = false
    
    // Show a success notification
    alert('Utilisateur mis à jour avec succès')
  } catch (err) {
    console.error('Erreur lors de la mise à jour:', err)
    alert('Erreur: ' + err.message)
  } finally {
    loading.value = false
  }
}

// Generate mock activities
const generateMockActivities = () => {
  const types = ['message', 'contract', 'mission', 'proposal', 'review']
  const results = []
  
  const count = Math.floor(Math.random() * 5) + 1
  
  for (let i = 0; i < count; i++) {
    const type = types[Math.floor(Math.random() * types.length)]
    results.push({
      id: `activity-${i}`,
      type,
      title: getActivityTitle(type),
      created_at: new Date(Date.now() - Math.random() * 7 * 24 * 60 * 60 * 1000).toISOString()
    })
  }
  
  return results.sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
}

// Get user statistics
const fetchUserStats = async () => {
  // In a real app, you would query the database
  // For this example, we generate random data
  return {
    missions: Math.floor(Math.random() * 20),
    proposals: Math.floor(Math.random() * 15),
    contracts: Math.floor(Math.random() * 10),
    reviews: Math.floor(Math.random() * 8)
  }
}

// Get activity title
const getActivityTitle = (type) => {
  switch (type) {
    case 'message':
      return 'A envoyé un message'
    case 'contract':
      return 'A signé un contrat'
    case 'mission':
      return 'A créé une nouvelle demande'
    case 'proposal':
      return 'A envoyé une proposition'
    case 'review':
      return 'A laissé un avis'
    default:
      return 'Activité'
  }
}

// Get activity icon
const getActivityIcon = (type) => {
  switch (type) {
    case 'message':
      return MessageCircle
    case 'contract':
      return FileText
    case 'mission':
      return ShoppingBag
    case 'proposal':
      return Briefcase
    case 'review':
      return Star
    default:
      return Clock
  }
}

// Format role
const formatRole = (role) => {
  switch (role) {
    case 'admin':
      return 'Administrateur'
    case 'expert':
      return 'Expert'
    case 'client':
      return 'Client'
    default:
      return role
  }
}

// Format status
const formatStatus = (status) => {
  switch (status) {
    case 'active':
      return 'Actif'
    case 'pending':
      return 'En attente'
    case 'blocked':
      return 'Bloqué'
    default:
      return status
  }
}

// Format verification status
const formatVerificationStatus = (status) => {
  switch (status) {
    case 'verified':
      return 'Vérifié'
    case 'pending':
      return 'En attente'
    case 'rejected':
      return 'Rejeté'
    default:
      return status
  }
}

// Format date
const formatDate = (dateString, includeTime = false) => {
  if (!dateString) return '—'
  const date = new Date(dateString)
  
  if (includeTime) {
    return date.toLocaleDateString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }
  
  return date.toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// Edit user
const editUser = () => {
  // Redirect to edit page or open a modal
  alert('Fonctionnalité d\'édition à implémenter')
}

// Confirm delete
const confirmDelete = () => {
  showDeleteModal.value = true
}

// Delete user
const deleteUser = async () => {
  try {
    deleting.value = true
    
    // Delete user profile
    const { error: profileError } = await client
      .from('profiles')
      .delete()
      .eq('id', userId)
    
    if (profileError) throw profileError
    
    // Delete user in Auth
    const { error: authError } = await client.auth.admin.deleteUser(userId)
    
    if (authError) throw authError
    
    // Redirect to user list
    router.push({
      path: '/admin/users',
      query: { success: 'user_deleted' }
    })
  } catch (error) {
    console.error('Erreur lors de la suppression:', error)
    alert('Erreur lors de la suppression: ' + error.message)
  } finally {
    deleting.value = false
    showDeleteModal.value = false
  }
}

// Add helper function to get verification icons
const getVerificationIcon = (status) => {
  switch (status) {
    case 'verified':
      return CheckCircle
    case 'pending':
      return Clock
    case 'rejected':
      return X
    default:
      return AlertCircle
  }
}

// Verify expert function
const verifyExpert = async () => {
  try {
    verificationLoading.value = true
    
    // Update verification status in the database
    const { error: updateError } = await client
      .from('profiles')
      .update({ 
        verification_status: 'verified',
        is_verified: true // Additional field for compatibility
      })
      .eq('id', userId)
    
    if (updateError) throw updateError
    
    // Update local user data
    user.value.verification_status = 'verified'
    user.value.is_verified = true
    
    // Show success modal
    verificationState.value = 'verified'
    verificationModalTitle.value = 'Expert vérifié avec succès'
    verificationModalMessage.value = 'Cet expert a été vérifié et pourra maintenant apparaître comme certifié sur la plateforme.'
    showVerificationModal.value = true
    
    // Add to activity log
    logActivity('user_verified', `Expert ${user.value.first_name} ${user.value.last_name} vérifié`)
    
  } catch (err) {
    console.error('Erreur lors de la vérification:', err)
    alert('Erreur: ' + err.message)
  } finally {
    verificationLoading.value = false
  }
}

// Unverify expert function
const confirmUnverifyExpert = async () => {
  if (!confirm('Êtes-vous sûr de vouloir retirer la vérification de cet expert ?')) {
    return
  }
  
  try {
    verificationLoading.value = true
    
    // Update verification status in the database
    const { error: updateError } = await client
      .from('profiles')
      .update({ 
        verification_status: 'rejected',
        is_verified: false
      })
      .eq('id', userId)
    
    if (updateError) throw updateError
    
    // Update local user data
    user.value.verification_status = 'rejected'
    user.value.is_verified = false
    
    // Show success modal
    verificationState.value = 'unverified'
    verificationModalTitle.value = 'Vérification retirée'
    verificationModalMessage.value = 'La vérification a été retirée pour cet expert.'
    showVerificationModal.value = true
    
    // Add to activity log
    logActivity('user_unverified', `Vérification retirée pour ${user.value.first_name} ${user.value.last_name}`)
    
  } catch (err) {
    console.error('Erreur lors du retrait de vérification:', err)
    alert('Erreur: ' + err.message)
  } finally {
    verificationLoading.value = false
  }
}

// Log activity
const logActivity = async (type, title) => {
  try {
    await client
      .from('activities')
      .insert({
        type,
        title,
        user_id: userId
      })
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'activité:', error)
  }
}

// Page configuration
definePageMeta({
  layout: 'admin',
})
</script>