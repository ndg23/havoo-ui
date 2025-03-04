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
    <div class="flex items-center gap-2">
      <!-- Logo Icon -->
      <div class="relative">
        <div class="w-8 h-8 bg-primary-500 rounded-xl rotate-45 transform transition-transform group-hover:rotate-90 duration-300"></div>
        <div class="absolute inset-0 flex items-center justify-center">
          <span class="text-lg font-bold text-white -rotate-45">H</span>
        </div>
      </div>
      
      <!-- Text with Modern Colors -->
      <div v-if="!iconOnly" class="flex flex-col">
        <div class="flex items-baseline">
          <span class="text-2xl font-bold bg-gradient-to-r from-primary-600 to-primary-500 bg-clip-text text-transparent">
            Havoo
          </span>
          <span class="text-lg font-medium text-gray-600 ml-1.5">
            Services
          </span>
        </div>
        <span class="text-[11px] text-gray-500 ml-0.5">
          Trouvez votre expert en quelques clics
        </span>
      </div>
    </div>
  </NuxtLink>
</template>

<script setup>
defineProps({
  iconOnly: {
    type: Boolean,
    default: false
  }
})
</script>

<style scoped>
/* Animation subtile au hover */
.group:hover {
  opacity: 0.9;
  transition: opacity 0.2s ease-in-out;
}

.bg-clip-text {
  -webkit-background-clip: text;
}
</style> 