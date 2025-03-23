<template>
    <div class="min-h-screen bg-white dark:bg-gray-900">
      <div class="max-w-5xl mx-auto">
        <!-- Interface de messagerie style Twitter -->
        <div class="flex h-[calc(100vh-64px)]">
          <!-- Liste des conversations (colonne gauche) -->
          <div class="w-full md:w-80 lg:w-96 border-r border-gray-200 dark:border-gray-700 flex flex-col">
            <!-- En-tête de la liste -->
            <div class="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
              <h1 class="text-xl font-bold text-gray-900 dark:text-white">Messages</h1>
              <button 
                class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-500 dark:text-gray-400"
                @click="showNewMessageModal = true"
              >
                <Edit class="h-5 w-5" />
              </button>
            </div>
            
            <!-- Barre de recherche -->
            <div class="p-3 border-b border-gray-200 dark:border-gray-700">
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Search class="h-4 w-4 text-gray-400" />
                </div>
                <input 
                  type="text" 
                  v-model="searchQuery"
                  placeholder="Rechercher dans les messages" 
                  class="block w-full pl-10 pr-3 py-2 border border-gray-300 dark:border-gray-700 rounded-full text-sm placeholder-gray-500 dark:placeholder-gray-400 focus:outline-none focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-800 dark:text-white"
                />
              </div>
            </div>
            
            <!-- Liste des conversations -->
            <div class="flex-1 overflow-y-auto hide-scrollbar">
              <div v-if="isLoading" class="flex justify-center items-center h-32">
                <Loader2 class="h-6 w-6 text-gray-400 animate-spin" />
              </div>
              
              <div v-else-if="filteredConversations.length === 0" class="p-4 text-center text-gray-500 dark:text-gray-400">
                <MessageSquareOff class="h-12 w-12 mx-auto mb-2 text-gray-400" />
                <p v-if="searchQuery">Aucun résultat pour "{{ searchQuery }}"</p>
                <p v-else>Aucune conversation</p>
                <button 
                  @click="showNewMessageModal = true"
                  class="mt-3 text-sm font-medium text-primary-600 dark:text-primary-400 hover:text-primary-700 dark:hover:text-primary-300"
                >
                  Démarrer une nouvelle conversation
                </button>
              </div>
              
              <div v-else>
                <button
                  v-for="conversation in filteredConversations"
                  :key="conversation.id"
                  @click="selectConversation(conversation)"
                  class="w-full p-3 flex items-start hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
                  :class="[selectedConversation?.id === conversation.id ? 'bg-gray-100 dark:bg-gray-800' : '']"
                >
                  
                    <!-- Avatar -->
                    <div class="flex-shrink-0 mr-3">
                      <img 
                        v-if="getOtherParticipant(conversation)?.avatar_url" 
                        :src="getOtherParticipant(conversation).avatar_url" 
                        alt="Avatar" 
                        class="h-10 w-10 rounded-full"
                      />
                      <div 
                        v-else 
                        class="h-10 w-10 rounded-full bg-primary-100 dark:bg-primary-900 flex items-center justify-center text-primary-700 dark:text-primary-300 font-medium"
                      >
                        {{ getInitials(getOtherParticipant(conversation)?.first_name, getOtherParticipant(conversation)?.last_name) }}
                      </div>
                    </div>
                    
                    <!-- Infos de la conversation -->
                    <div class="flex-1 min-w-0">
                      <div class="flex justify-between items-baseline">
                        <h3 class="text-sm font-medium text-gray-900 dark:text-white truncate">
                          {{ getOtherParticipant(conversation)?.first_name }} {{ getOtherParticipant(conversation)?.last_name }}
                        </h3>
                        <span class="text-xs text-gray-500 dark:text-gray-400">
                          {{ formatDate(conversation.last_message_at) }}
                        </span>
                      </div>
                      <p class="text-sm text-gray-500 dark:text-gray-400 truncate">
                        {{ conversation.last_message || 'Nouvelle conversation' }}
                      </p>
                      <div v-if="conversation.unread_count > 0" class="mt-1">
                        <span class="inline-flex items-center justify-center h-5 w-5 rounded-full bg-primary-500 text-white text-xs font-medium">
                          {{ conversation.unread_count }}
                        </span>
                      </div>
                    </div>
                </button>
              </div>
            </div>
          </div>
          
          <!-- Zone de conversation (colonne droite) -->
          <div class="hidden md:flex md:flex-1 flex-col">
            <!-- État vide (aucune conversation sélectionnée) -->
            <div v-if="!selectedConversation" class="flex-1 flex flex-col items-center justify-center p-6 text-center">
              <MessageSquare class="h-16 w-16 text-gray-300 dark:text-gray-700 mb-4" />
              <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Vos messages</h3>
              <p class="text-gray-500 dark:text-gray-400 max-w-sm">
                Sélectionnez une conversation ou démarrez-en une nouvelle pour commencer à échanger.
              </p>
              <button 
                @click="showNewMessageModal = true"
                class="mt-4 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-full shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
              >
                <Edit class="h-4 w-4 mr-2" />
                Nouveau message
              </button>
            </div>
            
            <!-- Conversation active -->
            <div v-else class="flex-1 flex flex-col">
              <!-- En-tête de la conversation -->
              <div class="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center">
                <div class="flex-shrink-0 mr-3">
                  <img 
                    v-if="getOtherParticipant(selectedConversation)?.avatar_url" 
                    :src="getOtherParticipant(selectedConversation).avatar_url" 
                    alt="Avatar" 
                    class="h-10 w-10 rounded-full"
                  />
                  <div 
                    v-else 
                    class="h-10 w-10 rounded-full bg-primary-100 dark:bg-primary-900 flex items-center justify-center text-primary-700 dark:text-primary-300 font-medium"
                  >
                    {{ getInitials(getOtherParticipant(selectedConversation)?.first_name, getOtherParticipant(selectedConversation)?.last_name) }}
                  </div>
                </div>
                <div>
                  <h2 class="text-base font-medium text-gray-900 dark:text-white">
                    {{ getOtherParticipant(selectedConversation)?.first_name }} {{ getOtherParticipant(selectedConversation)?.last_name }}
                  </h2>
                  <p v-if="getOtherParticipant(selectedConversation)?.is_expert" class="text-xs text-primary-600 dark:text-primary-400">
                    Expert
                  </p>
                </div>
              </div>
              
              <!-- Messages -->
              <div 
                ref="messagesContainer"
                class="flex-1 p-4 overflow-y-auto hide-scrollbar space-y-4"
              >
                <div v-if="isLoadingMessages" class="flex justify-center items-center h-32">
                  <Loader2 class="h-6 w-6 text-gray-400 animate-spin" />
                </div>
                
                <div v-else-if="messages.length === 0" class="flex justify-center items-center h-full">
                  <div class="text-center">
                    <p class="text-gray-500 dark:text-gray-400">
                      Aucun message. Commencez la conversation !
                    </p>
                  </div>
                </div>
                
                <template v-else>
                  <div 
                    v-for="(message, index) in messages" 
                    :key="message.id"
                    :class="[message.sender_id === user.id ? 'flex justify-end' : 'flex justify-start']"
                  >
                    <div 
                      class="max-w-[70%] rounded-lg px-4 py-2 break-words"
                      :class="[
                        message.sender_id === user.id 
                          ? 'bg-primary-500 text-white' 
                          : 'bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white'
                      ]"
                    >
                      <p>{{ message.content }}</p>
                      <div 
                        class="text-xs mt-1 text-right"
                        :class="[
                          message.sender_id === user.id 
                            ? 'text-primary-100' 
                            : 'text-gray-500 dark:text-gray-400'
                        ]"
                      >
                        {{ formatTime(message.created_at) }}
                      </div>
                      
                      <!-- Statut de lecture -->
                      <div v-if="message.sender_id === user.id && message.is_read" class="text-xs text-gray-400 mt-1">
                        Lu {{ formatTime(message.read_at) }}
                      </div>
                      
                      <!-- Réactions aux messages -->
                      <div class="message-reactions flex space-x-1 mt-1">
                        <button 
                          v-for="reaction in ['👍', '❤️', '😂', '😮', '😢', '👏']"
                          @click="addReaction(message.id, reaction)"
                          class="hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full p-1"
                        >
                          {{ reaction }}
                        </button>
                      </div>
                      
                      <!-- Affichage des réactions -->
                      <div v-if="message.reactions && message.reactions.length > 0" class="flex flex-wrap gap-1 mt-1">
                        <div 
                          v-for="(reactionGroup, reaction) in groupReactions(message.reactions)" 
                          :key="reaction"
                          class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-gray-100 dark:bg-gray-700"
                        >
                          <span>{{ reaction }}</span>
                          <span class="ml-1 text-gray-500 dark:text-gray-400">{{ reactionGroup.length }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </template>
              </div>
              
              <!-- Zone de saisie -->
              <div class="p-3 border-t border-gray-200 dark:border-gray-700">
                <form @submit.prevent="sendMessage" class="flex items-center">
                  <input 
                    v-model="newMessage" 
                    type="text" 
                    placeholder="Écrivez un message..." 
                    class="flex-1 border border-gray-300 dark:border-gray-700 rounded-full py-2 px-4 focus:outline-none focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-800 dark:text-white"
                    @input="handleTyping"
                  />
                  <button 
                    type="submit"
                    class="ml-2 p-2 rounded-full bg-primary-500 text-white hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 disabled:opacity-50"
                    :disabled="!newMessage.trim()"
                  >
                    <Send class="h-5 w-5" />
                  </button>
                </form>
                
                <!-- Indicateur de frappe -->
                <div v-if="isTyping" class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  {{ getOtherParticipant(selectedConversation)?.first_name }} est en train d'écrire...
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Modal pour nouvelle conversation -->
        <div v-if="showNewMessageModal" class="fixed inset-0 z-50 overflow-y-auto">
          <div class="flex items-center justify-center min-h-screen px-4">
            <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" @click="showNewMessageModal = false"></div>
            
            <div class="relative bg-white dark:bg-gray-800 rounded-lg max-w-md w-full p-6 shadow-xl">
              <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg font-medium text-gray-900 dark:text-white">Nouveau message</h3>
                <button 
                  @click="showNewMessageModal = false"
                  class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300"
                >
                  <X class="h-5 w-5" />
                </button>
              </div>
              
              <!-- Recherche de destinataire -->
              <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  À:
                </label>
                <div class="relative">
                  <input 
                    v-model="recipientSearch"
                    type="text"
                    placeholder="Rechercher un utilisateur..."
                    class="block w-full border border-gray-300 dark:border-gray-700 rounded-md py-2 px-3 focus:outline-none focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-800 dark:text-white"
                    @focus="showRecipientResults = true"
                  />
                  
                  <!-- Résultats de recherche -->
                  <div 
                    v-if="showRecipientResults && filteredUsers.length > 0" 
                    class="absolute z-10 mt-1 w-full bg-white dark:bg-gray-800 shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm"
                  >
                    <div 
                      v-for="user in filteredUsers" 
                      :key="user.id"
                      class="cursor-pointer select-none relative py-2 pl-3 pr-9 hover:bg-gray-100 dark:hover:bg-gray-700"
                      @click="selectRecipient(user)"
                    >
                      <div class="flex items-center">
                        <img 
                          v-if="user.avatar_url" 
                          :src="user.avatar_url" 
                          alt="Avatar" 
                          class="h-8 w-8 rounded-full mr-3"
                        />
                        <div 
                          v-else 
                          class="h-8 w-8 rounded-full bg-primary-100 dark:bg-primary-900 flex items-center justify-center text-primary-700 dark:text-primary-300 font-medium mr-3"
                        >
                          {{ getInitials(user.first_name, user.last_name) }}
                        </div>
                        <span class="block truncate">
                          {{ user.first_name }} {{ user.last_name }}
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- Destinataire sélectionné -->
                <div v-if="selectedRecipient" class="mt-2 flex items-center bg-gray-100 dark:bg-gray-700 rounded-full py-1 px-3 w-fit">
                  <span class="text-sm text-gray-900 dark:text-white">
                    {{ selectedRecipient.first_name }} {{ selectedRecipient.last_name }}
                  </span>
                  <button 
                    @click="selectedRecipient = null"
                    class="ml-2 text-gray-500 hover:text-gray-700 dark:hover:text-gray-300"
                  >
                    <X class="h-4 w-4" />
                  </button>
                </div>
              </div>
              
              <!-- Premier message -->
              <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Message:
                </label>
                <textarea 
                  v-model="firstMessage"
                  rows="4"
                  class="block w-full border border-gray-300 dark:border-gray-700 rounded-md py-2 px-3 focus:outline-none focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-800 dark:text-white"
                  placeholder="Écrivez votre message..."
                ></textarea>
              </div>
              
              <!-- Boutons d'action -->
              <div class="flex justify-end">
                <button 
                  @click="showNewMessageModal = false"
                  class="mr-3 px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 hover:text-gray-500 focus:outline-none"
                >
                  Annuler
                </button>
                
                <button 
                  @click="createConversation"
                  class="px-4 py-2 text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 rounded-md focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2 disabled:opacity-50"
                  :disabled="!selectedRecipient || !firstMessage.trim() || isCreatingConversation"
                >
                  <span v-if="isCreatingConversation">
                    <Loader2 class="h-4 w-4 animate-spin inline mr-1" />
                    Envoi...
                  </span>
                  <span v-else>Envoyer</span>
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
    Clock
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
  const isMobileView = ref(window.innerWidth < 768)
  const isTyping = ref(false)
  const typingTimeout = ref(null)
  const messageSubscription = ref(null)
  const typingSubscription = ref(null)
  const isLoadingMoreMessages = ref(false)
  const hasMoreMessages = ref(true)
  
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
    isLoadingMessages.value = true
    
    try {
      const { data, error } = await supabase
        .from('messages')
        .select('*, message_reactions(*)')
        .eq('conversation_id', conversationId)
        .order('created_at')
      
      if (error) throw error
      
      messages.value = data || []
      
      // Marquer les messages comme lus
      await markMessagesAsRead(conversationId)
      
      // Faire défiler vers le bas
      await nextTick(() => {
        scrollToBottom()
      })
      
      // S'abonner aux nouveaux messages et au statut de frappe
      setupSubscriptions(conversationId)
    } catch (err) {
      console.error('Error fetching messages:', err)
    } finally {
      isLoadingMessages.value = false
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
    if (!newMessage.value.trim() || !selectedConversation.value) return
    
    const messageContent = newMessage.value
    newMessage.value = ''
    
    try {
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
      
      if (error) throw error
      
      // Mettre à jour la conversation
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
      console.error('Error sending message:', err)
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
}


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
      // Handle typing status changes
    })
    .subscribe();
};
// Écouter les nouveaux messages
const setupMessagesSubscription = (conversationId) => {
  return supabase
    .channel(`messages:${conversationId}`)
    .on('postgres_changes', { 
      event: 'INSERT', 
      schema: 'public', 
      table: 'messages',
      filter: `conversation_id=eq.${conversationId}`
    }, (payload) => {
      // Ajouter le nouveau message à la conversation
      if (payload.new && payload.new.conversation_id === selectedConversation.value?.id) {
        messages.value.push(payload.new);
        nextTick(() => {
          scrollToBottom();
        });
        
        // Marquer comme lu si ce n'est pas notre message
        if (payload.new.sender_id !== user.value.id) {
          markMessagesAsRead(conversationId);
        }
      }
    })
    .subscribe();
};

const loadMoreMessages = async () => {
  if (isLoadingMoreMessages.value || !hasMoreMessages.value) return;
  
  isLoadingMoreMessages.value = true;
  const oldestMessageId = messages.value[0]?.id;
  
  try {
    const { data, error } = await supabase
      .from('messages')
      .select('*')
      .eq('conversation_id', selectedConversation.value.id)
      .lt('id', oldestMessageId)
      .order('created_at', { ascending: false })
      .limit(20);
    
    if (error) throw error;
    
    if (data.length === 0) {
      hasMoreMessages.value = false;
    } else {
      messages.value = [...data.reverse(), ...messages.value];
    }
  } catch (err) {
    console.error('Error loading more messages:', err);
  } finally {
    isLoadingMoreMessages.value = false;
  }
};


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

// Hooks de cycle de vie
onMounted(async () => {
  await fetchConversations();
  await fetchUsers();
  
  window.addEventListener('resize', handleResize);
});

onUnmounted(() => {
  window.removeEventListener('resize', handleResize);
});

// Observer les changements de conversation sélectionnée
watch(selectedConversation, (newConversation, oldConversation) => {
  if (newConversation?.id) {
    fetchMessages(newConversation.id);
    
    // Mettre en place une subscription pour les nouveaux messages
    const subscription = setupMessagesSubscription(newConversation.id);
    
    // Nettoyer l'ancienne subscription si nécessaire
    if (oldConversation?.id) {
      supabase.removeChannel(`messages:${oldConversation.id}`);
    }
  } else {
    messages.value = [];
  }
});
</script>
<style scoped>
.message-container {
  max-height: 400px;
  overflow-y: auto;
}



</style>