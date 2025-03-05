<template>
  <div class="max-w-5xl mx-auto px-4 py-12">
    <!-- En-tête du profil -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden mb-8">
      <!-- Bannière -->
      <div class="h-32 bg-gradient-to-r from-primary-500 to-primary-600 relative">
        <button class="absolute bottom-2 right-2 bg-white/80 backdrop-blur-sm p-1.5 rounded-full text-gray-700 hover:bg-white transition-colors">
          <Camera class="w-5 h-5" />
        </button>
      </div>
      
      <!-- Informations principales -->
      <div class="px-8 pb-6 flex flex-col md:flex-row gap-6 items-start md:items-end -mt-12">
        <!-- Photo de profil -->
        <div class="relative">
          <div class="w-24 h-24 rounded-full border-4 border-white bg-white shadow-sm overflow-hidden">
            <img 
              src="https://randomuser.me/api/portraits/men/32.jpg" 
              alt="Photo de profil"
              class="w-full h-full object-cover"
            />
          </div>
          <button class="absolute bottom-0 right-0 bg-primary-600 p-1.5 rounded-full text-white hover:bg-primary-700 transition-colors">
            <Camera class="w-4 h-4" />
          </button>
        </div>
        
        <!-- Nom et statut -->
        <div class="flex-1">
          <h1 class="text-2xl font-bold text-gray-900">Thomas Kouadio</h1>
          <p class="text-gray-600 mt-1">Membre depuis janvier 2024</p>
        </div>
        
        <!-- Actions -->
        <div class="flex gap-3 mt-4 md:mt-0">
          <NuxtLink 
            to="/account/edit-profile" 
            class="flex items-center gap-2 px-4 py-2 bg-primary-600 text-white rounded-xl hover:bg-primary-700 transition-colors"
          >
            <Edit class="w-4 h-4" />
            <span class="text-sm font-medium">Modifier le profil</span>
          </NuxtLink>
        </div>
      </div>
    </div>
    
    <!-- Cartes d'accès rapide -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
      <!-- Carte Demandes -->
      <NuxtLink to="/requests" class="bg-white rounded-xl border border-gray-200 p-5 hover:shadow-md transition-shadow">
        <div class="flex items-center gap-4">
          <div class="w-12 h-12 rounded-full bg-primary-50 flex items-center justify-center">
            <ClipboardList class="w-6 h-6 text-primary-600" />
          </div>
          <div>
            <h2 class="font-medium text-gray-900">Mes demandes</h2>
            <p class="text-sm text-gray-500">Gérer vos demandes de services</p>
          </div>
        </div>
      </NuxtLink>
      
      <!-- Carte Favoris -->
      <NuxtLink to="/favorites" class="bg-white rounded-xl border border-gray-200 p-5 hover:shadow-md transition-shadow">
        <div class="flex items-center gap-4">
          <div class="w-12 h-12 rounded-full bg-red-50 flex items-center justify-center">
            <Heart class="w-6 h-6 text-red-500" />
          </div>
          <div>
            <h2 class="font-medium text-gray-900">Favoris</h2>
            <p class="text-sm text-gray-500">Vos experts préférés</p>
          </div>
        </div>
      </NuxtLink>
      
      <!-- Carte Sécurité -->
      <NuxtLink to="/account/security" class="bg-white rounded-xl border border-gray-200 p-5 hover:shadow-md transition-shadow">
        <div class="flex items-center gap-4">
          <div class="w-12 h-12 rounded-full bg-green-50 flex items-center justify-center">
            <ShieldCheck class="w-6 h-6 text-green-600" />
          </div>
          <div>
            <h2 class="font-medium text-gray-900">Sécurité</h2>
            <p class="text-sm text-gray-500">Protégez votre compte</p>
          </div>
        </div>
      </NuxtLink>
    </div>
    
    <!-- Biographie -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-8">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-lg font-medium text-gray-900">À propos de moi</h2>
        <NuxtLink 
          to="/account/edit-profile" 
          class="text-sm text-primary-600 hover:text-primary-700 flex items-center gap-1"
        >
          <Edit class="w-4 h-4" />
          <span>Modifier</span>
        </NuxtLink>
      </div>
      
      <div v-if="userProfile.bio" class="text-gray-700">
        {{ userProfile.bio }}
      </div>
      <div v-else class="text-gray-500 italic">
        Ajoutez une biographie pour vous présenter aux autres utilisateurs.
      </div>
    </div>
    
    <!-- Compétences -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-8">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-lg font-medium text-gray-900">Compétences</h2>
        <NuxtLink 
          to="/account/edit-profile" 
          class="text-sm text-primary-600 hover:text-primary-700 flex items-center gap-1"
        >
          <Edit class="w-4 h-4" />
          <span>Modifier</span>
        </NuxtLink>
      </div>
      
      <div v-if="userProfile.skills.length > 0" class="flex flex-wrap gap-2">
        <div 
          v-for="skill in userProfile.skills" 
          :key="skill.id"
          class="px-3 py-1.5 bg-gray-100 rounded-full text-gray-800 text-sm flex items-center gap-1"
        >
          <span v-if="skill.icon" class="text-lg">{{ skill.icon }}</span>
          <span>{{ skill.name }}</span>
          <span v-if="skill.level" class="ml-1 text-xs text-gray-500">({{ skill.level }})</span>
        </div>
      </div>
      <div v-else class="text-gray-500 italic">
        Ajoutez des compétences pour mettre en valeur votre expertise.
      </div>
    </div>
    
        <!-- Informations personnelles -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 mb-8">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-lg font-medium text-gray-900">Informations personnelles</h2>
        <NuxtLink 
          to="/account/edit-profile" 
          class="text-sm text-primary-600 hover:text-primary-700 flex items-center gap-1"
        >
          <Edit class="w-4 h-4" />
          <span>Modifier</span>
        </NuxtLink>
      </div>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="space-y-4">
            <div class="flex items-center gap-3">
              <Mail class="w-5 h-5 text-gray-400" />
              <div>
                <p class="text-sm text-gray-500">Email</p>
                <p class="text-gray-900">thomas.kouadio@example.com</p>
              </div>
            </div>
            
            <div class="flex items-center gap-3">
              <Phone class="w-5 h-5 text-gray-400" />
              <div>
                <p class="text-sm text-gray-500">Téléphone</p>
                <p class="text-gray-900">+229 97 12 34 56</p>
            </div>
              </div>
            </div>
            
        <div class="space-y-4">
            <div class="flex items-center gap-3">
              <MapPin class="w-5 h-5 text-gray-400" />
              <div>
                <p class="text-sm text-gray-500">Adresse</p>
                <p class="text-gray-900">Cotonou, Bénin</p>
              </div>
            </div>
          
              <div class="flex items-center gap-3">
            <Calendar class="w-5 h-5 text-gray-400" />
            <div>
              <p class="text-sm text-gray-500">Date de naissance</p>
              <p class="text-gray-900">15 mai 1990</p>
            </div>
          </div>
        </div>
          </div>
        </div>
    
    <!-- Activité récente -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-lg font-medium text-gray-900">Activité récente</h2>
        <NuxtLink 
          to="/account/activity" 
          class="text-sm text-primary-600 hover:text-primary-700"
        >
          Voir tout
        </NuxtLink>
      </div>
      
      <div class="space-y-4">
        <div v-if="recentActivities.length > 0">
          <div 
            v-for="activity in recentActivities" 
            :key="activity.id"
            class="flex items-start gap-4 py-3 border-b border-gray-100 last:border-0"
          >
            <div class="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center">
              <component :is="getActivityIcon(activity.type)" class="w-5 h-5 text-gray-500" />
            </div>
                    <div class="flex-1">
              <p class="text-gray-900">{{ activity.description }}</p>
              <p class="text-sm text-gray-500 mt-0.5">{{ activity.date }}</p>
                  </div>
                </div>
              </div>
              
        <div v-else class="py-8 text-center">
          <div class="w-16 h-16 mx-auto rounded-full bg-gray-100 flex items-center justify-center">
            <History class="w-8 h-8 text-gray-400" />
          </div>
          <p class="mt-4 text-gray-600">Aucune activité récente</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { 
  Camera, Edit, Mail, Phone, MapPin, Calendar, 
  ClipboardList, Heart, ShieldCheck, History,
  Search, Star, MessageSquare, CreditCard, Award
} from 'lucide-vue-next'

// Profil utilisateur
const userProfile = ref({
  bio: "Passionné par les nouvelles technologies et le développement personnel. J'aime découvrir de nouveaux services et rencontrer des experts dans différents domaines.",
  skills: [
    { id: 1, name: 'Informatique', icon: '💻', level: 'Avancé' },
    { id: 2, name: 'Photographie', icon: '📷', level: 'Intermédiaire' },
    { id: 3, name: 'Cuisine', icon: '🍳', level: 'Débutant' },
    { id: 4, name: 'Jardinage', icon: '🌱' },
    { id: 5, name: 'Bricolage', icon: '🔨' }
  ]
})

// Activités récentes
const recentActivities = ref([
  {
    id: 1,
    type: 'request',
    description: 'Vous avez publié une demande de ménage',
    date: 'Il y a 2 jours'
  },
  {
    id: 2,
    type: 'favorite',
    description: 'Vous avez ajouté Aminata Diallo à vos favoris',
    date: 'Il y a 5 jours'
  },
  {
    id: 3,
    type: 'message',
    description: 'Vous avez reçu un message de Kofi Mensah',
    date: 'Il y a 1 semaine'
  }
])

// Helpers
const getActivityIcon = (type: string) => {
  const icons = {
    'request': ClipboardList,
    'favorite': Heart,
    'message': MessageSquare,
    'payment': CreditCard,
    'review': Star,
    'search': Search
  }
  return icons[type as keyof typeof icons] || History
}
</script> 