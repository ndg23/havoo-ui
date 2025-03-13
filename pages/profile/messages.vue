<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête minimaliste style Twitter -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Messages</h1>
    </div>

    <!-- État de chargement -->
    <div v-if="isLoading" class="flex justify-center items-center py-20">
      <div class="h-10 w-10 border-4 border-gray-200 dark:border-gray-700 border-t-primary-500 dark:border-t-primary-400 rounded-full animate-spin"></div>
    </div>

    <!-- Aucun message -->
    <div v-else-if="conversations.length === 0" class="py-16 text-center">
      <div class="mb-4 flex justify-center">
        <div class="bg-primary-50 dark:bg-primary-900/20 p-4 rounded-full">
          <MessageSquare class="h-8 w-8 text-primary-500 dark:text-primary-400" />
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucun message</h3>
      <p class="text-gray-600 dark:text-gray-400 mb-6 max-w-sm mx-auto">
        Vous n'avez pas encore de conversations. Contactez des utilisateurs pour démarrer.
      </p>
      <NuxtLink 
        :to="isExpert ? '/requests' : '/experts'" 
        class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-full text-sm font-medium"
      >
        {{ isExpert ? 'Voir les demandes' : 'Trouver un expert' }}
      </NuxtLink>
    </div>

    <!-- Liste des conversations avec séparations horizontales -->
    <div v-else>
      <div 
        v-for="(conversation, index) in conversations" 
        :key="conversation.id"
        class="py-4 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-all cursor-pointer"
        :class="{ 'border-b border-gray-200 dark:border-gray-700': index !== conversations.length - 1 }"
        @click="openConversation(conversation)"
      >
        <div class="flex items-start">
          <!-- Avatar -->
          <img 
            :src="conversation.other_user.avatar || '/img/default-avatar.png'" 
            :alt="conversation.other_user.name"
            class="w-12 h-12 rounded-full object-cover border border-gray-100 dark:border-gray-700"
          />
          
          <!-- Contenu du message -->
          <div class="ml-3 flex-1">
            <div class="flex justify-between items-baseline">
              <h3 class="font-semibold text-gray-900 dark:text-white">
                {{ conversation.other_user.name }}
                <span v-if="conversation.related_to" class="text-sm font-normal text-gray-500 dark:text-gray-400 ml-1">
                  ({{ conversation.related_to }})
                </span>
              </h3>
              
              <span class="text-xs text-gray-500 dark:text-gray-400">{{ conversation.last_message.timestamp }}</span>
            </div>
            
            <!-- Aperçu du dernier message -->
            <div class="flex justify-between items-start mt-1">
              <p class="text-sm text-gray-700 dark:text-gray-300 line-clamp-1 pr-4">
                {{ conversation.last_message.content }}
              </p>
              
              <!-- Badge non lu -->
              <div 
                v-if="conversation.unread_count > 0" 
                class="bg-primary-600 text-white text-xs rounded-full h-5 min-w-[20px] flex items-center justify-center px-1"
              >
                {{ conversation.unread_count }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { MessageSquare } from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// État local
const isLoading = ref(true)

// Profil et conversations
const profile = ref({
  is_expert: true
})
const conversations = ref([
  {
    id: 'c1',
    other_user: {
      id: 'u1',
      name: 'Fatou Ndiaye',
      avatar: '/img/avatars/user2.jpg'
    },
    related_to: 'Développement site vitrine',
    last_message: {
      content: 'D\'accord pour le délai, je vous envoie les maquettes demain.',
      timestamp: 'Il y a 30 min',
      is_from_me: false
    },
    unread_count: 3
  },
  {
    id: 'c2',
    other_user: {
      id: 'u2',
      name: 'Ibrahim Sow',
      avatar: '/img/avatars/user3.jpg'
    },
    related_to: 'Maintenance mensuelle',
    last_message: {
      content: 'Pensez-vous pouvoir terminer les mises à jour avant la fin de la semaine?',
      timestamp: 'Hier',
      is_from_me: true
    },
    unread_count: 0
  },
  {
    id: 'c3',
    other_user: {
      id: 'u3',
      name: 'Marie Diop',
      avatar: '/img/avatars/user4.jpg'
    },
    related_to: 'Refonte logo',
    last_message: {
      content: 'Les modifications sont parfaites! Merci beaucoup.',
      timestamp: 'Il y a 3 jours',
      is_from_me: false
    },
    unread_count: 1
  }
])

// Computed
const isExpert = computed(() => profile.value.is_expert)

// Méthodes
const fetchConversations = async () => {
  try {
    // Simuler le chargement
    isLoading.value = true
    
    // Dans un environnement réel, nous chargerions les conversations depuis Supabase
    /*
    const { data, error } = await supabase.rpc('get_conversations_with_last_message', {
      p_user_id: user.value.id
    })
    
    if (error) throw error
    conversations.value = data
    */
    
    // Simuler un délai de chargement
    setTimeout(() => {
      isLoading.value = false
    }, 800)
  } catch (error) {
    console.error('Erreur lors du chargement des conversations:', error)
    isLoading.value = false
  }
}

const openConversation = (conversation) => {
  router.push(`/messages/${conversation.id}`)
}

// Initialisation
onMounted(() => {
  fetchConversations()
})

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
/* Animation pour l'apparition des composants */
.py-4 {
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