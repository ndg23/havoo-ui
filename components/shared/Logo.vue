<template>
  <!-- <NuxtLink 
    to="/" 
    class="inline-flex items-center space-x-2 text-xl font-bold text-gray-900 hover:opacity-80 transition-opacity"
  >
    <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-orange-500 to-orange-600 flex items-center justify-center text-white">
      K
    </div>
    <span>KILOU</span>
  </NuxtLink> -->
  <NuxtLink to="/" class="flex-shrink-0 group">
    <div class="flex flex-col">
      <div class="flex items-center gap-2">
        <!-- Logo Icon -->
        <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-indigo-500 to-indigo-600 flex items-center justify-center text-white font-bold text-xl">
          H
        </div>
        
        <!-- Text with Modern Colors -->
        <div class="flex flex-col">
          <span class="text-2xl font-bold tracking-tight flex items-baseline">
            <span class="text-indigo-500">Havoo</span>
            <span class="text-gray-600 ml-1.5 text-lg font-medium">Services</span>
          </span>
          <span class="text-[11px] text-gray-500 ml-0.5">Trouvez votre expert en quelques clics</span>
        </div>
      </div>
    </div>
  </NuxtLink>
</template>

<script setup>
// Le composant est purement présentationnel, pas besoin de logique
</script>

<style scoped>
/* Animation subtile au hover */
.group:hover {
  opacity: 0.9;
  transition: opacity 0.2s ease-in-out;
}
</style> 