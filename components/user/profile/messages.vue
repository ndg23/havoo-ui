<template>
    <div class="flex h-[calc(100vh-80px)]">
      <!-- Liste des conversations -->
      <div class="w-80 border-r border-gray-200 bg-white">
        <div class="p-4 border-b border-gray-200">
          <input
            type="text"
            placeholder="Rechercher une conversation..."
            class="w-full px-4 py-2 rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
          />
        </div>
  
        <div class="overflow-y-auto h-[calc(100%-73px)]">
          <ConversationItem
            v-for="conversation in conversations"
            :key="conversation.id"
            :conversation="conversation"
            :active="currentConversation?.id === conversation.id"
            @click="selectConversation(conversation)"
          />
        </div>
      </div>
  
      <!-- Zone de chat -->
      <div class="flex-1 flex flex-col bg-gray-50">
        <template v-if="currentConversation">
          <!-- En-tête de la conversation -->
          <div class="p-4 bg-white border-b border-gray-200">
            <div class="flex items-center space-x-4">
              <img
                :src="currentConversation.participant.avatar"
                alt="Avatar"
                class="w-10 h-10 rounded-full"
              />
              <div>
                <h3 class="font-medium text-gray-900">
                  {{ currentConversation.participant.name }}
                </h3>
                <p class="text-sm text-gray-500">
                  {{ currentConversation.itemTitle }}
                </p>
              </div>
            </div>
          </div>
  
          <!-- Messages -->
          <div class="flex-1 overflow-y-auto p-4" ref="messagesContainer">
            <MessageBubble
              v-for="message in currentMessages"
              :key="message.id"
              :message="message"
              :is-sender="message.senderId === currentUserId"
            />
          </div>
  
          <!-- Zone de saisie -->
          <div class="p-4 bg-white border-t border-gray-200">
            <form @submit.prevent="sendMessage" class="flex space-x-4">
              <input
                v-model="newMessage"
                type="text"
                placeholder="Votre message..."
                class="flex-1 px-4 py-2 rounded-lg border border-gray-200 focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
              />
              <button
                type="submit"
                class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
              >
                <PaperAirplaneIcon class="w-5 h-5" />
              </button>
            </form>
          </div>
        </template>
  
        <!-- État vide -->
        <div
          v-else
          class="flex-1 flex items-center justify-center text-gray-500"
        >
          Sélectionnez une conversation
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { PaperAirplaneIcon } from '@heroicons/vue/24/outline'
  import ConversationItem from '~/components/user/profile/ConversationItem.vue'
  import MessageBubble from '~/components/user/profile/MessageBubble.vue'

  const conversations = ref([]) 
  const currentConversation = ref(null)
  const currentMessages = ref([])
  const newMessage = ref('')
  const currentUserId = ref('')

  const selectConversation = (conversation) => {
    currentConversation.value = conversation
    currentMessages.value = conversation.messages
  }

  const sendMessage = () => {
    console.log('Message envoyé:', newMessage.value)
    newMessage.value = ''
  }

  onMounted(() => {
    fetchConversations()
  })    

  const fetchConversations = async () => {
    const response = await fetch('/api/conversations')
    conversations.value = await response.json()
  }

  const fetchMessages = async (conversationId) => {
    const response = await fetch(`/api/conversations/${conversationId}/messages`)
    currentMessages.value = await response.json()
  }

  const fetchUser = async (userId) => {
    const response = await fetch(`/api/users/${userId}`)
    return await response.json()
  } 
</script>
