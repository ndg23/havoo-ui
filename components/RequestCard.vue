<template>
    <div class="p-4 border-b border-gray-200 flex gap-4 hover:bg-gray-50 transition-colors">
      <!-- Avatar -->
      <div class="w-12 h-12 rounded-full bg-gray-100 overflow-hidden flex-shrink-0">
        <img :src="request.avatarUrl || '/api/placeholder/48/48'" :alt="request.clientName" class="w-full h-full object-cover">
      </div>
      
      <!-- Content -->
      <div class="flex-1">
        <!-- Header with name -->
        <div class="flex items-center mb-2">
          <span class="font-bold text-base mr-1 text-gray-900">{{ request.clientName }}</span>
          <i v-if="request.verified" class="fas fa-check-circle text-blue-500 mr-1"></i>
          <span class="text-gray-500 text-xs">· {{ request.timeAgo }}</span>
        </div>
        
        <!-- Title and description -->
        <h3 class="font-semibold text-lg mb-1 text-gray-900">{{ request.title }}</h3>
        <p class="text-sm text-gray-700 mb-3 line-clamp-2">{{ request.description }}</p>
        
        <!-- Tags -->
        <div class="flex flex-wrap gap-1 mb-3">
          <span 
            v-for="(tag, index) in request.tags" 
            :key="index" 
            class="bg-blue-50 rounded px-2 py-0.5 text-xs text-blue-600 font-medium"
          >
            {{ tag }}
          </span>
        </div>
        
        <!-- Footer with price highlight and CTA -->
        <div class="flex justify-between items-center">
          <!-- Propositions counter -->
          <div class="text-xs text-gray-500 flex items-center gap-1">
            <i class="far fa-comment"></i>
            <span>{{ request.propositions }} proposition{{ request.propositions !== 1 ? 's' : '' }}</span>
          </div>
          
          <!-- Price - highlighted -->
          <div class="font-bold text-lg text-green-600">{{ request.budget }}</div>
          
          <!-- Action button -->
          <button class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-full text-sm font-medium transition-colors">
            Proposer
          </button>
        </div>
        
        <!-- Deadline indicator - small and subtle -->
        <div :class="['flex items-center gap-1 mt-2 text-xs', { 'text-pink-500 font-medium': request.isUrgent, 'text-gray-500': !request.isUrgent }]">
          <i class="far fa-clock"></i>
          <span>{{ request.deadline }}</span>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'RequestCard',
    props: {
      request: {
        type: Object,
        required: true
      }
    }
  }
  </script>