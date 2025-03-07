<template>
  <div class="logo" :class="{ 'logo-small': small }">
    <!-- Logo Icon -->
    <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg" class="logo-icon">
      <rect width="32" height="32" rx="6" fill="url(#paint0_linear)" />
      <path d="M20 12C20 14.2091 18.2091 16 16 16C13.7909 16 12 14.2091 12 12C12 9.79086 13.7909 8 16 8C18.2091 8 20 9.79086 20 12Z" fill="white"/>
      <path d="M24 24C24 21.7909 22.2091 20 20 20C17.7909 20 16 21.7909 16 24" stroke="white" stroke-width="3" stroke-linecap="round"/>
      <path d="M16 16V24" stroke="white" stroke-width="3" stroke-linecap="round"/>
      <defs>
        <linearGradient id="paint0_linear" x1="0" y1="0" x2="32" y2="32" gradientUnits="userSpaceOnUse">
          <stop stop-color="#4F46E5"/>
          <stop offset="1" stop-color="#4338CA"/>
        </linearGradient>
      </defs>
    </svg>
    
    <!-- Logo Text -->
    <div v-if="!iconOnly" class="logo-text">
      <span class="text-gray-900 dark:text-white font-bold">Havoo</span>
      <span class="text-primary-600">Services</span>
    </div>
  </div>
</template>

<script setup>
defineProps({
  small: {
    type: Boolean,
    default: false
  },
  iconOnly: {
    type: Boolean,
    default: false
  }
})
</script>

<style scoped>
.logo {
  display: flex;
  align-items: center;
  gap: 8px;
}

.logo-small {
  transform: scale(0.85);
  transform-origin: left center;
}

.logo-icon {
  flex-shrink: 0;
}

.logo-text {
  font-size: 20px;
  font-weight: 700;
  letter-spacing: -0.5px;
  white-space: nowrap;
}

/* Style PayPal - léger dégradé sur le texte au survol */
.logo:hover .logo-text span:last-child {
  background: linear-gradient(90deg, #4338CA 0%, #6366F1 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  transition: all 0.3s ease;
}
</style>