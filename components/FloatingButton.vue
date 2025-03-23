 
  <!-- FloatingActionButton.vue -->
  <template>
    <div class="fixed bottom-6 right-6 z-10">
      <button 
        class="floating-button"
        @click="$emit('toggle')"
      >
        <icon :name="showActions ? 'x' : 'plus'" class="h-6 w-6" />
      </button>
      
      <div 
        v-if="showActions" 
        class="absolute bottom-16 right-0 space-y-2 floating-actions"
      >
        <NuxtLink 
          to="/requests/new" 
          class="floating-action"
          @click="$emit('close')"
        >
          <icon name="file-text" class="h-4 w-4 mr-2" />
          Nouvelle demande
        </NuxtLink>
        
        <NuxtLink 
          v-if="isExpert"
          to="/account/services/new" 
          class="floating-action"
          @click="$emit('close')"
        >
          <icon name="briefcase" class="h-4 w-4 mr-2" />
          Nouveau service
        </NuxtLink>
      </div>
    </div>
  </template>
  
  <script setup>
  defineProps({
    isExpert: Boolean,
    showActions: Boolean
  })
  
  defineEmits(['toggle', 'close'])
  </script>
  
  <style scoped>
  .floating-button {
    @apply h-14 w-14 rounded-full bg-primary-500 hover:bg-primary-600 text-white flex items-center justify-center shadow-lg transition-colors;
  }
  
  .floating-action {
    @apply flex items-center bg-primary-500 text-white rounded-full pl-3 pr-5 py-2 shadow-md;
  }
  
  .floating-actions {
    animation: slideUp 0.2s ease forwards;
  }
  
  @keyframes slideUp {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }
  </style>