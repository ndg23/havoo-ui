<template>
    <div class="min-h-screen bg-gray-50 dark:bg-black text-black dark:text-white">
      <div class="max-w-5xl mx-auto h-[calc(100vh-64px)] bg-white dark:bg-black shadow-lg">
        <!-- Interface de messagerie X 2024 - Version Impactful -->
        <div class="flex h-full">
          <!-- Liste des conversations (colonne gauche) -->
          <div class="w-full md:w-[280px] border-r border-gray-100 dark:border-gray-800 flex flex-col">
            <!-- En-tête de la liste -->
            <div class="p-4 flex items-center justify-between sticky top-0 bg-white/95 dark:bg-black/95 backdrop-blur-md z-10 border-b border-gray-100 dark:border-gray-800">
              <h1 class="text-xl font-extrabold text-black dark:text-white tracking-tight">Messages</h1>
              <button 
                class="p-2.5 rounded-full hover:bg-gray-100 dark:hover:bg-gray-900 text-black dark:text-white transition-all active:scale-90"
                @click="showNewMessageModal = true"
              >
                <Edit class="h-5 w-5" />
              </button>
            </div>
            
            <!-- Barre de recherche -->
            <div class="px-3 py-3 sticky top-[60px] bg-white/95 dark:bg-black/95 backdrop-blur-md z-10 border-b border-gray-100 dark:border-gray-800">
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Search class="h-4 w-4 text-gray-500" />
                </div>
                <input 
                  type="text" 
                  v-model="searchQuery"
                  placeholder="Rechercher" 
                  class="block w-full pl-10 pr-3 py-2.5 bg-gray-100 dark:bg-gray-900 border-none rounded-full text-sm placeholder-gray-500 dark:placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-500 dark:text-white transition-all"
                />
              </div>
            </div>
            
            <!-- Liste des conversations -->
            <div class="flex-1 overflow-y-auto hide-scrollbar">
              <div v-if="isLoading" class="flex justify-center items-center h-32">
                <Loader2 class="h-5 w-5 text-blue-500 animate-spin" />
              </div>
              
              <div v-else-if="filteredConversations.length === 0" class="p-6 text-center text-gray-500 dark:text-gray-400">
                <MessageSquareOff class="h-12 w-12 mx-auto mb-4 text-gray-400 dark:text-gray-600" />
                <p v-if="searchQuery" class="text-sm">Aucun résultat pour "{{ searchQuery }}"</p>
                <p v-else class="text-sm font-medium">Commencez une nouvelle conversation</p>
                <button 
                  @click="showNewMessageModal = true"
                  class="mt-5 px-5 py-2.5 text-sm font-medium text-white bg-blue-500 hover:bg-blue-600 rounded-full transition-all hover:shadow-md active:scale-95"
                >
                  Nouveau message
                </button>
              </div>
              
              <div v-else>
                <button
                  v-for="conversation in filteredConversations"
                  :key="conversation.id"
                  @click="selectConversation(conversation)"
                  class="w-full px-3 py-3 flex items-start hover:bg-gray-50 dark:hover:bg-gray-900 transition-all duration-200 active:bg-gray-100 dark:active:bg-gray-800"
                  :class="[selectedConversation?.id === conversation.id ? 'bg-blue-50 dark:bg-blue-900/20' : '']"
                >
                    <!-- Avatar -->
                  <div class="flex-shrink-0 mr-3 relative">
                      <img 
                        v-if="getOtherParticipant(conversation)?.avatar_url" 
                        :src="getOtherParticipant(conversation).avatar_url" 
                        alt="Avatar" 
                      class="h-12 w-12 rounded-full object-cover border-2 border-transparent"
                      :class="[selectedConversation?.id === conversation.id ? 'border-blue-500' : '']"
                      />
                      <div 
                        v-else 
                      class="h-12 w-12 rounded-full bg-gradient-to-tr from-blue-500 to-blue-400 dark:from-blue-600 dark:to-blue-400 flex items-center justify-center text-white font-bold text-base shadow-sm"
                      >
                        {{ getInitials(getOtherParticipant(conversation)?.first_name, getOtherParticipant(conversation)?.last_name) }}
                      </div>
                    <!-- En ligne indicator -->
                    <div 
                      v-if="isUserOnline(getOtherParticipant(conversation)?.id)"
                      class="absolute bottom-0 right-0 h-3 w-3 bg-green-500 rounded-full border-2 border-white dark:border-black ring-2 ring-white dark:ring-black"
                    ></div>
                    </div>
                    
                    <!-- Infos de la conversation -->
                    <div class="flex-1 min-w-0">
                      <div class="flex justify-between items-baseline">
                      <h3 class="text-base font-bold text-black dark:text-white truncate">
                          {{ getOtherParticipant(conversation)?.first_name }} {{ getOtherParticipant(conversation)?.last_name }}
                        </h3>
                      <span class="text-xs text-gray-500 ml-1 font-medium">
                          {{ formatDate(conversation.last_message_at) }}
                        </span>
                      </div>
                    <p class="text-sm text-gray-600 dark:text-gray-400 truncate mt-0.5">
                        {{ conversation.last_message || 'Nouvelle conversation' }}
                      </p>
                      <div v-if="conversation.unread_count > 0" class="mt-1">
                      <span class="inline-flex items-center justify-center h-5 w-5 rounded-full bg-blue-500 text-white text-xs font-medium shadow-sm">
                          {{ conversation.unread_count }}
                        </span>
                      </div>
                    </div>
                </button>
              </div>
            </div>
          </div>
          
          <!-- Zone de conversation (colonne droite) -->
          <div class="hidden md:flex md:flex-1 flex-col bg-white dark:bg-black">
            <!-- État vide (aucune conversation sélectionnée) -->
            <div v-if="!selectedConversation" class="flex-1 flex flex-col items-center justify-center p-8 text-center">
              <div class="max-w-md">
                <div class="w-20 h-20 bg-gradient-to-tr from-blue-500 to-indigo-500 dark:from-blue-600 dark:to-indigo-500 rounded-full flex items-center justify-center mx-auto mb-6 shadow-lg">
                  <MessageSquare class="h-10 w-10 text-white" />
                </div>
                <h3 class="text-2xl font-extrabold text-black dark:text-white mb-3 tracking-tight">Vos messages</h3>
                <p class="text-gray-600 dark:text-gray-400 text-base mb-6">
                  Envoyez des messages privés à d'autres utilisateurs pour échanger facilement.
              </p>
              <button 
                @click="showNewMessageModal = true"
                  class="px-6 py-3 text-base font-medium text-white bg-blue-500 hover:bg-blue-600 rounded-full transition-all hover:shadow-md active:scale-95"
              >
                Nouveau message
              </button>
              </div>
            </div>
            
            <!-- Conversation active -->
            <div v-else class="flex-1 flex flex-col">
              <!-- En-tête de la conversation -->
              <div class="py-3 px-4 border-b border-gray-100 dark:border-gray-800 flex items-center sticky top-0 bg-white/95 dark:bg-black/95 backdrop-blur-md z-10">
                <div class="flex-shrink-0 mr-3.5 relative">
                  <img 
                    v-if="getOtherParticipant(selectedConversation)?.avatar_url" 
                    :src="getOtherParticipant(selectedConversation).avatar_url" 
                    alt="Avatar" 
                    class="h-12 w-12 rounded-full object-cover border-2 border-transparent"
                  />
                  <div 
                    v-else 
                    class="h-12 w-12 rounded-full bg-gradient-to-tr from-blue-500 to-blue-400 dark:from-blue-600 dark:to-blue-400 flex items-center justify-center text-white font-bold text-base shadow-sm"
                  >
                    {{ getInitials(getOtherParticipant(selectedConversation)?.first_name, getOtherParticipant(selectedConversation)?.last_name) }}
                  </div>
                  <!-- Indicateur en ligne -->
                  <div 
                    v-if="isUserOnline(getOtherParticipant(selectedConversation)?.id)"
                    class="absolute bottom-0 right-0 h-3 w-3 bg-green-500 rounded-full border-2 border-white dark:border-black ring-2 ring-white dark:ring-black"
                  ></div>
                </div>
                <div class="flex-1">
                  <h2 class="text-lg font-bold text-black dark:text-white">
                    {{ getOtherParticipant(selectedConversation)?.first_name }} {{ getOtherParticipant(selectedConversation)?.last_name }}
                  </h2>
                  <div class="flex items-center">
                    <p v-if="getOtherParticipant(selectedConversation)?.is_expert" class="text-xs text-blue-500 font-medium mr-2 px-2 py-0.5 rounded-full bg-blue-50 dark:bg-blue-900/30">
                    Expert
                  </p>
                    <p v-if="isUserOnline(getOtherParticipant(selectedConversation)?.id)" class="text-xs text-green-500 flex items-center font-medium">
                      <span class="h-1.5 w-1.5 bg-green-500 rounded-full mr-1.5"></span>
                      En ligne
                    </p>
                  </div>
                </div>
              </div>
              
              <!-- Messages -->
              <div 
                ref="messagesContainer"
                class="flex-1 p-4 overflow-y-auto hide-scrollbar space-y-3"
              >
                <div v-if="isLoadingMessages" class="flex justify-center items-center h-full">
                  <div class="flex flex-col items-center">
                    <Loader2 class="h-7 w-7 text-blue-500 animate-spin mb-3" />
                    <p class="text-sm text-gray-500 dark:text-gray-400">Chargement...</p>
                  </div>
                </div>
                
                <div v-else-if="messages.length === 0" class="flex justify-center items-center h-full">
                  <div class="text-center">
                    <MessageSquare class="h-12 w-12 text-gray-300 dark:text-gray-600 mx-auto mb-3" />
                    <p class="text-base text-gray-500 dark:text-gray-400">
                      Aucun message. Commencez la conversation!
                    </p>
                  </div>
                </div>
                
                <template v-else>
                  <div v-for="(message, index) in messages" :key="message.id" class="message-group">
                    <!-- Date separator -->
                    <div v-if="index === 0 || shouldShowDateSeparator(message, messages[index - 1])" class="flex justify-center my-5">
                      <div class="bg-gray-100 dark:bg-gray-900 text-gray-500 dark:text-gray-400 px-4 py-1.5 rounded-full text-xs font-medium shadow-sm">
                        {{ formatMessageDate(message.created_at) }}
                      </div>
                    </div>
                    
                    <div 
                    :class="[message.sender_id === user.id ? 'flex justify-end' : 'flex justify-start']"
                      class="group"
                  >
                    <div 
                        class="max-w-[75%] px-4 py-3 rounded-2xl break-words message relative"
                      :class="[
                        message.sender_id === user.id 
                            ? 'bg-gradient-to-r from-blue-500 to-blue-600 text-white shadow-sm' 
                            : 'bg-gray-100 dark:bg-gray-900 text-black dark:text-white shadow-sm'
                      ]"
                    >
                        <p class="text-base">{{ message.content }}</p>
                      <div 
                          class="text-xs mt-1.5 text-right flex items-center justify-end"
                        :class="[
                          message.sender_id === user.id 
                              ? 'text-blue-100' 
                            : 'text-gray-500 dark:text-gray-400'
                        ]"
                      >
                        {{ formatTime(message.created_at) }}
                          
                          <!-- Statut de lecture pour les messages envoyés -->
                          <span v-if="message.sender_id === user.id && message.is_read" class="ml-1.5">
                            <CheckCheck class="h-3.5 w-3.5 text-white inline-block" />
                          </span>
                          <span v-else-if="message.sender_id === user.id" class="ml-1.5">
                            <Check class="h-3.5 w-3.5 text-blue-100 inline-block" />
                          </span>
                      </div>
                      </div>
                    </div>
                  </div>
                </template>
              </div>
              
              <!-- Zone de saisie -->
              <div class="p-4 border-t border-gray-100 dark:border-gray-800 sticky bottom-0 bg-white/95 dark:bg-black/95 backdrop-blur-md">
                <form @submit.prevent="sendMessage" class="flex items-center">
                  <input 
                    v-model="newMessage" 
                    type="text" 
                    placeholder="Message..." 
                    class="flex-1 bg-gray-100 dark:bg-gray-900 border-none rounded-full py-3 px-5 text-base focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-500 dark:text-white transition-all placeholder:text-gray-500"
                    @input="handleTyping"
                  />
                  <button 
                    type="submit"
                    class="ml-3 p-3 rounded-full bg-blue-500 text-white hover:bg-blue-600 focus:outline-none disabled:opacity-50 transition-all active:scale-90 shadow-md hover:shadow-lg"
                    :disabled="!newMessage.trim()"
                  >
                    <Send class="h-5 w-5" />
                  </button>
                </form>
                
                <!-- Indicateur de frappe -->
                <div v-if="isTyping" class="text-xs text-gray-500 dark:text-gray-400 mt-2 flex items-center font-medium">
                  <div class="flex space-x-1 mr-2">
                    <div class="w-1.5 h-1.5 bg-blue-500 rounded-full animate-typing" style="animation-delay: 0s"></div>
                    <div class="w-1.5 h-1.5 bg-blue-500 rounded-full animate-typing" style="animation-delay: 0.2s"></div>
                    <div class="w-1.5 h-1.5 bg-blue-500 rounded-full animate-typing" style="animation-delay: 0.4s"></div>
                  </div>
                  {{ getOtherParticipant(selectedConversation)?.first_name }} écrit...
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Modal pour nouvelle conversation (style X 2024 - Impactful) -->
        <div v-if="showNewMessageModal" class="fixed inset-0 z-50 overflow-y-auto">
          <div class="flex items-center justify-center min-h-screen px-4">
            <div class="fixed inset-0 bg-black bg-opacity-75 backdrop-blur-sm transition-opacity" @click="showNewMessageModal = false"></div>
            
            <div class="relative bg-white dark:bg-black rounded-2xl max-w-md w-full p-6 shadow-2xl border border-gray-100 dark:border-gray-800 animate-modal-in">
              <div class="flex justify-between items-center mb-5">
                <h3 class="text-xl font-extrabold text-black dark:text-white tracking-tight">Nouvelle conversation</h3>
                <button 
                  @click="showNewMessageModal = false"
                  class="text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-900 transition-all active:scale-90"
                >
                  <X class="h-5 w-5" />
                </button>
              </div>
              
              <!-- Tabs pour choisir le mode -->
              <div class="flex gap-1 mb-5 p-1 bg-gray-100 dark:bg-gray-900 rounded-full">
                <button 
                  @click="connectionMode = 'message'" 
                  class="flex-1 py-2 px-4 rounded-full text-sm font-bold transition-all" 
                  :class="connectionMode === 'message' ? 'bg-white dark:bg-black text-blue-500 shadow-sm' : 'text-gray-500 hover:text-gray-700 dark:hover:text-gray-300'"
                >
                  Message
                </button>
                <button 
                  @click="connectionMode = 'connect'" 
                  class="flex-1 py-2 px-4 rounded-full text-sm font-bold transition-all" 
                  :class="connectionMode === 'connect' ? 'bg-white dark:bg-black text-blue-500 shadow-sm' : 'text-gray-500 hover:text-gray-700 dark:hover:text-gray-300'"
                >
                  Connexion rapide
                </button>
              </div>
              
              <!-- Recherche de destinataire -->
              <div class="mb-5">
                <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">
                  À:
                </label>
                <div class="relative">
                  <input 
                    v-model="recipientSearch"
                    type="text"
                    placeholder="Rechercher un utilisateur..."
                    class="block w-full bg-gray-100 dark:bg-gray-900 border-none rounded-lg py-3 px-4 text-base focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-500 dark:text-white shadow-sm"
                    @focus="showRecipientResults = true"
                  />
                  
                  <!-- Résultats de recherche -->
                  <div 
                    v-if="showRecipientResults && filteredUsers.length > 0" 
                    class="absolute z-10 mt-1 w-full bg-white dark:bg-black shadow-xl max-h-60 rounded-lg py-1 text-sm overflow-auto border border-gray-100 dark:border-gray-800"
                  >
                    <div 
                      v-for="user in filteredUsers" 
                      :key="user.id"
                      class="cursor-pointer py-2.5 px-4 hover:bg-gray-50 dark:hover:bg-gray-900 transition-all"
                      @click="selectRecipient(user)"
                    >
                      <div class="flex items-center">
                        <div class="relative">
                        <img 
                          v-if="user.avatar_url" 
                          :src="user.avatar_url" 
                          alt="Avatar" 
                            class="h-10 w-10 rounded-full object-cover mr-3 border border-gray-100 dark:border-gray-700"
                        />
                        <div 
                          v-else 
                            class="h-10 w-10 rounded-full bg-gradient-to-tr from-blue-500 to-blue-400 dark:from-blue-600 dark:to-blue-400 flex items-center justify-center text-white font-bold text-base mr-3 shadow-sm"
                        >
                          {{ getInitials(user.first_name, user.last_name) }}
                        </div>
                          <!-- Indicateur en ligne -->
                          <div 
                            v-if="isUserOnline(user.id)"
                            class="absolute bottom-0 right-0 h-2.5 w-2.5 bg-green-500 rounded-full border-2 border-white dark:border-black ring-1 ring-white dark:ring-black mr-2"
                          ></div>
                        </div>
                        <div>
                          <span class="font-bold text-black dark:text-white">
                          {{ user.first_name }} {{ user.last_name }}
                        </span>
                        </div>
                      </div>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- Destinataire sélectionné -->
              <div v-if="selectedRecipient" class="mt-2 mb-4 inline-flex items-center bg-blue-50 dark:bg-blue-900/20 rounded-full py-1.5 px-3 shadow-sm">
                <span class="text-sm font-medium text-black dark:text-white">
                    {{ selectedRecipient.first_name }} {{ selectedRecipient.last_name }}
                  </span>
                  <button 
                    @click="selectedRecipient = null"
                  class="ml-2 text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 p-0.5 rounded-full transition-all active:scale-90"
                  >
                    <X class="h-4 w-4" />
                  </button>
              </div>
              
              <!-- Premier message (facultatif en mode connexion rapide) -->
              <div v-if="connectionMode === 'message'" class="mb-6">
                <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">
                  Message:
                </label>
                <textarea 
                  v-model="firstMessage"
                  rows="4"
                  class="block w-full bg-gray-100 dark:bg-gray-900 border-none rounded-lg py-3 px-4 text-base focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-500 dark:text-white resize-none shadow-sm"
                  placeholder="Écrivez votre message..."
                ></textarea>
              </div>

              <!-- Message de connexion rapide -->
              <div v-else class="mb-6">
                <div class="rounded-lg p-4 bg-blue-50 dark:bg-blue-900/20 text-sm text-blue-800 dark:text-blue-200">
                  <Users class="h-5 w-5 inline-block mr-2 text-blue-500" />
                  Une invitation à se connecter sera envoyée à {{ selectedRecipient ? selectedRecipient.first_name : 'cet utilisateur' }} sans message initial.
                </div>
              </div>
              
              <!-- Boutons d'action -->
              <div class="flex justify-end">
                <button 
                  @click="showNewMessageModal = false"
                  class="mr-3 px-4 py-2.5 text-sm font-bold text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-900 rounded-full transition-all active:scale-95"
                >
                  Annuler
                </button>
                
                <button 
                  @click="createConversation"
                  class="px-5 py-2.5 text-sm font-bold text-white bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 rounded-full disabled:opacity-50 transition-all active:scale-95 shadow-md hover:shadow-lg"
                  :disabled="!selectedRecipient || (connectionMode === 'message' && !firstMessage.trim()) || isCreatingConversation"
                >
                  <span v-if="isCreatingConversation" class="flex items-center">
                    <Loader2 class="h-4 w-4 animate-spin mr-2" />
                    {{ connectionMode === 'message' ? 'Envoi...' : 'Connexion...' }}
                  </span>
                  <span v-else>{{ connectionMode === 'message' ? 'Envoyer' : 'Se connecter' }}</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted, onUnmounted, nextTick, watch } from 'vue'
  import { useSupabaseClient, useSupabaseUser } from '#imports'
  import { 
    MessageSquare, 
    Edit, 
    Search, 
    Send, 
    Loader2, 
    MessageSquareOff,
    ArrowLeft,
    X,
    Check,
    CheckCheck,
    Clock,
    PlusCircle,
    Mic,
    Users
  } from 'lucide-vue-next'
  
  const supabase = useSupabaseClient()
  const user = useSupabaseUser()
  
  // États
  const conversations = ref([])
  const selectedConversation = ref(null)
  const messages = ref([])
  const newMessage = ref('')
  const isLoading = ref(true)
  const isLoadingMessages = ref(false)
  const searchQuery = ref('')
  const showNewMessageModal = ref(false)
  const recipientSearch = ref('')
  const showRecipientResults = ref(false)
  const users = ref([])
  const selectedRecipient = ref(null)
  const firstMessage = ref('')
  const isCreatingConversation = ref(false)
  const messagesContainer = ref(null)
  const mobileMessagesContainer = ref(null)
  const isMobileView = ref(window?.innerWidth < 768)
  const isTyping = ref(false)
  const typingTimeout = ref(null)
  const messageSubscription = ref(null)
  const typingSubscription = ref(null)
  const connectionMode = ref('message') // 'message' ou 'connect'
  
  // État en ligne des utilisateurs
  const onlineUsers = ref(new Set())
  const onlineUsersSubscription = ref(null)
  
  // Filtrer les conversations en fonction de la recherche
  const filteredConversations = computed(() => {
    if (!searchQuery.value) return conversations.value
    
    const query = searchQuery.value.toLowerCase()
    return conversations.value.filter(conversation => {
      const otherParticipant = getOtherParticipant(conversation)
      if (!otherParticipant) return false
      
      const fullName = `${otherParticipant.first_name} ${otherParticipant.last_name}`.toLowerCase()
      return fullName.includes(query) || (conversation.last_message && conversation.last_message.toLowerCase().includes(query))
    })
  })
  
  // Filtrer les utilisateurs pour la nouvelle conversation
  const filteredUsers = computed(() => {
    if (!recipientSearch.value) return users.value
    
    const query = recipientSearch.value.toLowerCase()
    return users.value.filter(u => {
      const fullName = `${u.first_name} ${u.last_name}`.toLowerCase()
      return fullName.includes(query)
    })
  })
  
  // Récupérer les conversations
  const fetchConversations = async () => {
    isLoading.value = true
    
    try {
      // Récupérer les conversations où l'utilisateur est participant
      const { data: participations, error: participationsError } = await supabase
        .from('conversation_participants')
        .select('conversation_id')
        .eq('profile_id', user.value.id)
      
      if (participationsError) throw participationsError
      
      if (participations.length === 0) {
        conversations.value = []
        isLoading.value = false
        return
      }
      
      const conversationIds = participations.map(p => p.conversation_id)
      
      // Récupérer les détails des conversations
      const { data: conversationsData, error: conversationsError } = await supabase
        .from('conversations')
        .select(`
          *,
          conversation_participants!inner(
            profile_id,
            profiles(*)
          )
        `)
        .in('id', conversationIds)
        .order('last_message_at', { ascending: false })
      
      if (conversationsError) throw conversationsError
      
      // Formater les données des conversations
      conversations.value = conversationsData.map(conversation => {
        // Extraire les participants
        const participants = conversation.conversation_participants.map(p => p.profiles)
        
        // Calculer le nombre de messages non lus
        const unreadCount = 0 // À implémenter avec une requête supplémentaire si nécessaire
        
        return {
          id: conversation.id,
          participants,
          last_message: conversation.last_message,
          last_message_at: conversation.last_message_at,
          unread_count: unreadCount
        }
      })
    } catch (err) {
      console.error('Error fetching conversations:', err)
    } finally {
      isLoading.value = false
    }
  }
  
  // Récupérer les messages d'une conversation
  const fetchMessages = async (conversationId) => {
    if (!conversationId) {
      console.warn("fetchMessages appelé sans ID de conversation valide")
      return
    }
    
    console.log(`Début du chargement des messages pour la conversation: ${conversationId}`)
    isLoadingMessages.value = true
    messages.value = [] // Réinitialiser les messages pour éviter des problèmes d'affichage
    
    try {
      console.log(`Requête Supabase pour les messages de la conversation: ${conversationId}`)
      
      const { data, error } = await supabase
        .from('messages')
        .select('*, message_reactions(*)')
        .eq('conversation_id', conversationId)
        .order('created_at')
      
      if (error) {
        console.error("Erreur Supabase lors de la récupération des messages:", error)
        throw error
      }
      
      console.log(`Messages récupérés: ${data ? data.length : 0} pour la conversation ${conversationId}`)
      
      if (data && data.length > 0) {
        // Filtrer les messages invalides et s'assurer que chaque message a un ID
        const validMessages = data.filter(message => message && message.id && message.content)
        console.log(`Messages valides filtrés: ${validMessages.length}`)
        
        // Mettre à jour la liste des messages
        messages.value = validMessages
        
        // Vérifier si les messages sont correctement affectés
        console.log(`État final des messages.value: longueur = ${messages.value.length}`)
        if (messages.value.length > 0) {
          console.log(`Premier message: ${JSON.stringify(messages.value[0].id)}`)
          console.log(`Dernier message: ${JSON.stringify(messages.value[messages.value.length - 1].id)}`)
        }
      } else {
        messages.value = []
        console.log("Aucun message trouvé pour cette conversation")
      }
      
      // Marquer les messages comme lus
      await markMessagesAsRead(conversationId)
      
      // Faire défiler vers le bas
      await nextTick(() => {
        console.log("Défilement vers le bas après chargement des messages")
        scrollToBottom()
      })
    } catch (err) {
      console.error('Erreur lors du chargement des messages:', err)
      messages.value = [] // En cas d'erreur, s'assurer que messages est vide
    } finally {
      isLoadingMessages.value = false
      console.log(`Fin du chargement des messages. État final: ${isLoadingMessages.value ? 'chargement' : 'terminé'}`)
    }
  }
  
  // Marquer les messages comme lus
  const markMessagesAsRead = async (conversationId) => {
    try {
      const now = new Date().toISOString()
      
      const { error } = await supabase
        .from('messages')
        .update({ 
          is_read: true,
          read_at: now
        })
        .eq('conversation_id', conversationId)
        .neq('sender_id', user.value.id)
        .eq('is_read', false)
      
      if (error) throw error
    } catch (err) {
      console.error('Error marking messages as read:', err)
    }
  }
  
  // Envoyer un message
  const sendMessage = async () => {
    // Vérifier que le message n'est pas vide et qu'une conversation est sélectionnée
    if (!newMessage.value.trim() || !selectedConversation.value) {
      console.warn("Tentative d'envoi d'un message vide ou sans conversation sélectionnée")
      return
    }
    
    const messageContent = newMessage.value.trim()
    console.log(`Préparation à l'envoi du message: "${messageContent}" dans la conversation: ${selectedConversation.value.id}`)
    
    // Vider le champ de saisie immédiatement pour une meilleure UX
    newMessage.value = ''
    
    try {
      // Vérifier si messages.value est bien un tableau
      if (!Array.isArray(messages.value)) {
        console.warn("Le tableau des messages n'est pas correctement initialisé")
        messages.value = []
      }
      
      console.log(`Envoi du message à Supabase: "${messageContent}"`)
      
      // Ajouter le message à la base de données
      const { data, error } = await supabase
        .from('messages')
        .insert({
          conversation_id: selectedConversation.value.id,
          sender_id: user.value.id,
          content: messageContent,
          is_delivered: true
        })
        .select()
      
      if (error) {
        console.error("Erreur lors de l'envoi du message:", error)
        throw error
      }
      
      console.log("Message envoyé avec succès, données reçues:", data)
      
      // Ajouter le message à l'interface immédiatement
      if (data && data.length > 0) {
        const newMsg = data[0]
        console.log(`Ajout du message (ID: ${newMsg.id}) à l'interface`)
        
        // Vérifier que le message n'existe pas déjà dans le tableau
        const messageExists = messages.value.some(m => m.id === newMsg.id)
        
        if (!messageExists) {
          messages.value.push(newMsg)
          console.log(`Nombre de messages après ajout: ${messages.value.length}`)
          
          // Faire défiler vers le bas pour montrer le nouveau message
          nextTick(() => {
            scrollToBottom()
          })
        } else {
          console.log("Le message existe déjà dans la liste, pas besoin de l'ajouter")
        }
      } else {
        console.warn("Données de message vides après insertion dans Supabase")
      }
      
      // Mettre à jour les informations de la conversation
      console.log("Mise à jour des métadonnées de la conversation")
      await supabase
        .from('conversations')
        .update({
          last_message: messageContent,
          last_message_at: new Date().toISOString()
        })
        .eq('id', selectedConversation.value.id)
      
      // Arrêter l'indicateur de frappe
      clearTimeout(typingTimeout.value)
      setTypingStatus(false)
    } catch (err) {
      console.error('Erreur lors de l\'envoi du message:', err)
      // On pourrait ici implémenter une logique de réessai ou afficher une notification à l'utilisateur
    }
  }
  
  // Sélectionner une conversation
  const selectConversation = async (conversation) => {
    // Désabonner des souscriptions précédentes
    if (messageSubscription.value) {
      messageSubscription.value.unsubscribe()
    }
    
    if (typingSubscription.value) {
      typingSubscription.value.unsubscribe()
    }
    
    selectedConversation.value = conversation
    messages.value = []
    
    if (conversation) {
      await fetchMessages(conversation.id)
    }
  }
  
  // Obtenir l'autre participant d'une conversation
  const getOtherParticipant = (conversation) => {
    if (!conversation || !conversation.participants) return null
    return conversation.participants.find(p => p.id !== user.value.id)
  }
  
  // Formater la date d'un message
  const formatDate = (dateString) => {
    if (!dateString) return ''
    
    const date = new Date(dateString)
    const now = new Date()
    
    // Si c'est aujourd'hui, afficher l'heure
    if (date.toDateString() === now.toDateString()) {
      return formatTime(dateString)
    }
    
    // Si c'est cette année, afficher le jour et le mois
    if (date.getFullYear() === now.getFullYear()) {
      return date.toLocaleDateString(undefined, { day: 'numeric', month: 'short' })
    }
    
    // Sinon afficher le jour, le mois et l'année
    return date.toLocaleDateString(undefined, { day: 'numeric', month: 'short', year: 'numeric' })
  }
  
  // Formater l'heure d'un message
  const formatTime = (dateString) => {
    if (!dateString) return ''
    const date = new Date(dateString)
    return date.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit' })
  }
  
  // Formater la date d'un message pour l'affichage dans les séparateurs
  const formatMessageDate = (dateString) => {
    if (!dateString) return ''
    
    const date = new Date(dateString)
    const now = new Date()
    const yesterday = new Date(now)
    yesterday.setDate(yesterday.getDate() - 1)
    
    // Si c'est aujourd'hui
    if (date.toDateString() === now.toDateString()) {
      return "Aujourd'hui"
    }
    
    // Si c'est hier
    if (date.toDateString() === yesterday.toDateString()) {
      return "Hier"
    }
    
    // Si c'est cette semaine (dans les 7 derniers jours)
    const oneWeekAgo = new Date(now)
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7)
    if (date >= oneWeekAgo) {
      return date.toLocaleDateString(undefined, { weekday: 'long' })
    }
    
    // Si c'est cette année
    if (date.getFullYear() === now.getFullYear()) {
      return date.toLocaleDateString(undefined, { day: 'numeric', month: 'long' })
    }
    
    // Sinon afficher la date complète
    return date.toLocaleDateString(undefined, { day: 'numeric', month: 'long', year: 'numeric' })
  }
  
  // Vérifier si on doit afficher un séparateur de date entre deux messages
  const shouldShowDateSeparator = (message, previousMessage) => {
    if (!previousMessage) return true
    
    const messageDate = new Date(message.created_at)
    const previousMessageDate = new Date(previousMessage.created_at)
    
    // Afficher le séparateur si les messages sont de jours différents
    return messageDate.toDateString() !== previousMessageDate.toDateString()
  }
  
  // Faire défiler vers le bas
  const scrollToBottom = () => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
    }
    if (mobileMessagesContainer.value) {
      mobileMessagesContainer.value.scrollTop = mobileMessagesContainer.value.scrollHeight
    }
  }
  
  // Gestion du redimensionnement de la fenêtre
  const handleResize = () => {
    isMobileView.value = window?.innerWidth < 768
  }
  
  // Définir le statut de frappe
  const setTypingStatus = async (isTyping) => {
    if (!selectedConversation.value) return
    
    try {
      await supabase
        .from('typing_status')
        .upsert({ 
          conversation_id: selectedConversation.value.id,
          user_id: user.value.id,
          is_typing: isTyping,
          updated_at: new Date().toISOString()
        })
    } catch (err) {
      console.error('Error updating typing status:', err)
    }
  }
  
  // Gérer la frappe
  const handleTyping = () => {
    clearTimeout(typingTimeout.value)
    
    setTypingStatus(true)

    // Ajouter un délai avant de réinitialiser le statut de frappe
    typingTimeout.value = setTimeout(() => {
      setTypingStatus(false)
    }, 3000)
  }

  // Obtenir les initiales d'un utilisateur
  const getInitials = (firstName, lastName) => {
    if (!firstName) return '?'
    return (firstName.charAt(0) + (lastName ? lastName.charAt(0) : '')).toUpperCase()
  }

  // Ajouter une réaction à un message
  const addReaction = async (messageId, reaction) => {
    try {
      const { error } = await supabase
        .from('message_reactions')
        .upsert({ 
          message_id: messageId,
          user_id: user.value.id,
          reaction: reaction
        })
      
      if (error) throw error
    } catch (err) {
      console.error('Error adding reaction:', err)
    }
  }

  // Grouper les réactions par type
  const groupReactions = (reactions) => {
    if (!reactions || !reactions.length) return {}
    
    return reactions.reduce((groups, reaction) => {
      const key = reaction.reaction
      if (!groups[key]) {
        groups[key] = []
      }
      groups[key].push(reaction)
      return groups
    }, {})
  }

  // Obtenir le nombre total de réactions
  const getTotalReactions = (reactions) => {
    if (!reactions || !reactions.length) return 0
    return reactions.length
  }

  // Sélectionner un destinataire pour une nouvelle conversation
  const selectRecipient = (user) => {
    selectedRecipient.value = user
    showRecipientResults.value = false
  }

  // Créer une nouvelle conversation
  const createConversation = async () => {
    if (!selectedRecipient.value) return
    
    // Vérifier qu'un message est présent si en mode message
    if (connectionMode.value === 'message' && !firstMessage.value.trim()) return
    
    isCreatingConversation.value = true
    
    try {
      // 1. Créer la conversation
      const { data: conversationData, error: conversationError } = await supabase
        .from('conversations')
        .insert({
          last_message: connectionMode.value === 'message' 
            ? firstMessage.value 
            : `${user.value.user_metadata.first_name || 'Un utilisateur'} vous a envoyé une invitation de connexion.`,
          last_message_at: new Date().toISOString()
        })
        .select()
      
      if (conversationError) throw conversationError
      
      const conversationId = conversationData[0].id
      
      // 2. Ajouter les participants
      const participants = [
        { 
          conversation_id: conversationId, 
          profile_id: user.value.id 
        },
        { 
          conversation_id: conversationId, 
          profile_id: selectedRecipient.value.id 
        }
      ]
      
      const { error: participantsError } = await supabase
        .from('conversation_participants')
        .insert(participants)
      
      if (participantsError) throw participantsError
      
      // 3. Ajouter le premier message si en mode message
      if (connectionMode.value === 'message') {
        const { error: messageError } = await supabase
          .from('messages')
          .insert({
            conversation_id: conversationId,
            sender_id: user.value.id,
            content: firstMessage.value,
            is_delivered: true
          })
        
        if (messageError) throw messageError
      } else {
        // En mode connexion rapide, ajouter un message système indiquant une invitation de connexion
        const { error: messageError } = await supabase
          .from('messages')
          .insert({
            conversation_id: conversationId,
            sender_id: user.value.id,
            content: `👋 ${user.value.user_metadata.first_name || 'Un utilisateur'} vous a envoyé une invitation de connexion.`,
            is_delivered: true,
            is_system_message: true
          })
        
        if (messageError) throw messageError
      }
      
      // 4. Fermer le modal et réinitialiser les champs
      showNewMessageModal.value = false
      selectedRecipient.value = null
      firstMessage.value = ''
      connectionMode.value = 'message' // Réinitialiser au mode message par défaut
      
      // 5. Rafraîchir la liste des conversations
      await fetchConversations()
      
      // 6. Sélectionner la nouvelle conversation
      const newConversation = conversations.value.find(c => c.id === conversationId)
      if (newConversation) {
        selectConversation(newConversation)
      }
    } catch (err) {
      console.error('Error creating conversation:', err)
    } finally {
      isCreatingConversation.value = false
    }
  }

  // Récupérer la liste des utilisateurs
  const fetchUsers = async () => {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .neq('id', user.value.id);
      
      if (error) throw error;
      
      users.value = data || [];
    } catch (err) {
      console.error('Error fetching users:', err);
    }
  };

// Subscribe to typing status
const subscribeToTypingStatus = (conversationId) => {
  return supabase
    .channel(`typing:${conversationId}`)
    .on('postgres_changes', { 
      event: '*', 
      schema: 'public', 
      table: 'typing_status',
      filter: `conversation_id=eq.${conversationId} AND user_id=neq.${user.value.id}`
    }, (payload) => {
        // Mettre à jour l'état de frappe
        if (payload.new) {
          isTyping.value = payload.new.is_typing
        }
    })
    .subscribe();
};

// Écouter les nouveaux messages
const setupMessagesSubscription = (conversationId) => {
  console.log(`Configuration de l'abonnement aux messages pour la conversation: ${conversationId}`)
  
  return supabase
    .channel(`messages:${conversationId}`)
    .on('postgres_changes', { 
      event: 'INSERT', 
      schema: 'public', 
      table: 'messages',
      filter: `conversation_id=eq.${conversationId}`
    }, (payload) => {
      console.log('Nouveau message reçu:', payload.new)
      
      // Vérifier que le message est valide et appartient à la conversation actuelle
      if (payload.new && 
          payload.new.conversation_id === selectedConversation.value?.id &&
          payload.new.content) {
        
        // Éviter les doublons en vérifiant si le message existe déjà
        const messageExists = messages.value.some(m => m.id === payload.new.id)
        
        // Ne pas ajouter les messages que nous avons envoyés (ils sont déjà ajoutés dans sendMessage)
        if (payload.new.sender_id !== user.value.id && !messageExists) {
          console.log('Ajout du message reçu à la conversation')
          messages.value.push(payload.new)
          
          // Faire défiler vers le bas
          nextTick(() => {
            scrollToBottom()
          })
          
          // Marquer comme lu
          markMessagesAsRead(conversationId)
    } else {
          console.log('Message ignoré (envoyé par nous-mêmes ou déjà existant)')
        }
      } else {
        console.warn('Message reçu non valide ou appartenant à une autre conversation')
      }
    })
    .subscribe((status) => {
      console.log(`Statut de l'abonnement aux messages: ${status}`)
    })
}

  // S'abonner au statut en ligne des utilisateurs
  const subscribeToOnlineStatus = () => {
    return supabase
      .channel('online-users')
      .on('presence', { event: 'sync' }, () => {
        // Mettre à jour la liste des utilisateurs en ligne
        const newOnlineUsers = new Set();
        const presenceState = onlineUsersSubscription.value.presenceState();
        
        Object.keys(presenceState).forEach(presence => {
          presenceState[presence].forEach(user => {
            if (user.user_id) {
              newOnlineUsers.add(user.user_id);
            }
          });
        });
        
        onlineUsers.value = newOnlineUsers;
      })
      .subscribe(async (status) => {
        if (status === 'SUBSCRIBED') {
          await onlineUsersSubscription.value.track({
            user_id: user.value.id,
            online_at: new Date().toISOString()
          });
        }
      });
  };

  // Vérifier si un utilisateur est en ligne
  const isUserOnline = (userId) => {
    return onlineUsers.value.has(userId);
};

// Hooks de cycle de vie
onMounted(async () => {
  await fetchConversations();
  await fetchUsers();
    
    // S'abonner au statut en ligne
    onlineUsersSubscription.value = subscribeToOnlineStatus();
  
  window.addEventListener('resize', handleResize);
});

onUnmounted(() => {
    // Nettoyer les souscriptions
    if (messageSubscription.value) {
      messageSubscription.value.unsubscribe();
    }
    
    if (typingSubscription.value) {
      typingSubscription.value.unsubscribe();
    }
    
    if (onlineUsersSubscription.value) {
      onlineUsersSubscription.value.unsubscribe();
    }
    
  window.removeEventListener('resize', handleResize);
});

// Observer les changements de conversation sélectionnée
watch(selectedConversation, async (newConversation, oldConversation) => {
  console.log("Changement de conversation:", newConversation?.id)
  
  // Annuler les abonnements précédents
  if (messageSubscription.value) {
    console.log("Désabonnement des messages précédents")
    messageSubscription.value.unsubscribe()
    messageSubscription.value = null
  }
  
  if (typingSubscription.value) {
    console.log("Désabonnement du statut de frappe précédent")
    typingSubscription.value.unsubscribe()
    typingSubscription.value = null
  }
  
  // Réinitialiser l'état
  messages.value = []
  isLoadingMessages.value = false
  
  // Si une nouvelle conversation est sélectionnée
  if (newConversation?.id) {
    console.log("Chargement de la nouvelle conversation:", newConversation.id)
    
    // Récupérer les messages
    await fetchMessages(newConversation.id)
    
    // Mettre en place les nouvelles souscriptions
    console.log("Mise en place des abonnements pour la nouvelle conversation")
    messageSubscription.value = setupMessagesSubscription(newConversation.id)
    typingSubscription.value = subscribeToTypingStatus(newConversation.id)
    
    // Vérifier si les messages sont correctement chargés
    console.log("Nombre de messages chargés:", messages.value.length)
  }
});
</script>
<style scoped>
.hide-scrollbar::-webkit-scrollbar {
  width: 2px;
}

.hide-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.hide-scrollbar::-webkit-scrollbar-thumb {
  background-color: rgba(156, 163, 175, 0.2);
  border-radius: 20px;
}

.hide-scrollbar::-webkit-scrollbar-thumb:hover {
  background-color: rgba(156, 163, 175, 0.4);
}

.message-group > div {
  margin-bottom: 8px;
}

/* Animation pour les nouveaux messages - plus impactful */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.message {
  animation: fadeInUp 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  backface-visibility: hidden;
}

/* Animation pour le modal - plus impactful */
@keyframes modalInScale {
  from {
    opacity: 0;
    transform: scale(0.92);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.animate-modal-in {
  animation: modalInScale 0.35s cubic-bezier(0.16, 1, 0.3, 1);
}

/* Animations plus fluides pour tous les éléments interactifs */
button, input, textarea {
  transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}

/* Animation améliorée pour l'indicateur de frappe */
@keyframes typing {
  0%, 100% {
    opacity: 0.3;
    transform: translateY(0);
  }
  50% {
    opacity: 1;
    transform: translateY(-1px);
  }
}

.animate-typing {
  animation: typing 1.2s ease-in-out infinite;
}

/* Effet de survol pour les bulles de message */
.message:hover {
  transform: translateY(-1px);
  transition: transform 0.2s ease;
}

/* Animation pour les avatars */
@keyframes pulseLight {
  0% {
    box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.4);
  }
  70% {
    box-shadow: 0 0 0 6px rgba(59, 130, 246, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(59, 130, 246, 0);
  }
}

.conversation-selected {
  animation: pulseLight 2s infinite;
}
</style>
