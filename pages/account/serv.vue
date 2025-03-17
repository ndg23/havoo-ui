<template>
  <!-- Services grid -->
  <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
    <!-- Add new service card -->
    <div 
      @click="openAddServiceModal"
      class="relative bg-gray-50 border border-gray-100 rounded-xl p-6 h-full flex flex-col justify-center items-center cursor-pointer transition-all hover:border-gray-200 hover:shadow-sm group"
    >
      <div class="w-16 h-16 rounded-full bg-primary-50 flex items-center justify-center mb-4 group-hover:bg-primary-100 transition-colors">
        <svg class="w-8 h-8 text-primary-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M12 4v16m8-8H4" />
        </svg>
      </div>
      <h3 class="text-lg font-medium text-gray-800 mb-1">Ajouter un service</h3>
      <p class="text-gray-500 text-sm text-center">
        Proposez vos compétences aux clients
      </p>
    </div>
    
    <!-- Service cards -->
    <!-- ... rest of the services page content ... -->
  </div>
  
  <!-- ... modals and other components ... -->
</template>

<script setup>
// Define layout information
definePageMeta({
  layout: 'account',
  title: 'Mes services',
  description: 'Gérez vos services et compétences pour que les clients puissent vous trouver facilement'
})

// Rest of the script...
</script>