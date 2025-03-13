<template>
    <div v-if="!isProfileConfirmed" class="flex items-center justify-between bg-white rounded-xl p-4 mb-4 border border-gray-100 hover:bg-gray-50 transition-colors">
      <div class="flex items-center gap-3">
        <div class="flex-shrink-0 w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center">
          <Badge class="w-5 h-5 text-white" />
        </div>
        <div>
          <h3 class="font-bold text-base">Vérifiez votre profil</h3>
          <p class="text-gray-500 text-sm">Obtenez <span class="font-bold">3×</span> plus de demandes</p>
        </div>
      </div>
      <NuxtLink 
        to="/account/verification" 
        class="group relative flex items-center gap-1.5 bg-gradient-to-r from-blue-600 to-blue-500 hover:from-blue-700 hover:to-blue-600 text-white font-bold px-5 py-2 rounded-full transition-all shadow-sm hover:shadow-md"
      >
        <span>Vérifier maintenant</span>
        <ArrowRight class="w-4 h-4 transition-transform group-hover:translate-x-1" />
        <span class="absolute inset-0 rounded-full bg-white/10 opacity-0 group-hover:opacity-100 transition-opacity"></span>
      </NuxtLink>
    </div>
  </template>
  
  <script setup>
  import { Badge, ArrowRight } from 'lucide-vue-next';
  const isProfileConfirmed = ref(false);
  </script>