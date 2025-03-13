<template>
  <div 
    class="logo" 
    :class="{ 'logo-small': small }"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <!-- Logo Icon - Design moderne pour Havoo -->
    <div class="logo-icon-container">
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg" class="logo-icon">
        <!-- Fond avec dégradé moderne -->
        <rect width="32" height="32" rx="10" fill="url(#paint0_linear)" />
        
        <!-- Toit en V au-dessus du H -->
        <path 
          d="M16 7L9 14" 
          stroke="white" 
          stroke-width="2.5" 
          stroke-linecap="round" 
          stroke-linejoin="round"
        />
        <path 
          d="M16 7L23 14" 
          stroke="white" 
          stroke-width="2.5" 
          stroke-linecap="round" 
          stroke-linejoin="round"
        />
        
        <!-- H clairement visible -->
        <path 
          d="M11 14V25" 
          stroke="white" 
          stroke-width="2.5" 
          stroke-linecap="round" 
          stroke-linejoin="round"
        />
        <path 
          d="M21 14V25" 
          stroke="white" 
          stroke-width="2.5" 
          stroke-linecap="round" 
          stroke-linejoin="round"
        />
        <path 
          d="M11 19.5H21" 
          stroke="white" 
          stroke-width="2.5" 
          stroke-linecap="round" 
          stroke-linejoin="round"
        />
        
        <!-- Effet de survol subtil -->
        <circle 
          cx="16" 
          cy="16" 
          r="14" 
          :stroke="isHovered ? 'rgba(255, 255, 255, 0.4)' : 'rgba(255, 255, 255, 0)'" 
          stroke-width="1.5"
          fill="none"
          class="pulse-circle"
        />
        
        <defs>
          <linearGradient id="paint0_linear" x1="0" y1="0" x2="32" y2="32" gradientUnits="userSpaceOnUse">
            <stop stop-color="#FF5A5F" /> <!-- Rouge Airbnb -->
            <stop offset="1" stop-color="#FF385C" /> <!-- Rouge Airbnb foncé -->
          </linearGradient>
        </defs>
      </svg>
    </div>
    
    <!-- Texte du logo avec séparation visuelle pour Havoo Services -->
    <div v-if="!iconOnly" class="logo-text" :class="{ 'logo-text-hovered': isHovered }">
      <span class="brand-name">havoo</span>
      <span class="service-text">services</span>
    </div>
  </div>
</template>

<script setup>
const isHovered = ref(false);

defineProps({
  small: {
    type: Boolean,
    default: false
  },
  iconOnly: {
    type: Boolean,
    default: false
  }
});
</script>

<style scoped>
.logo {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  transition: transform 0.3s ease;
}

.logo-small {
  transform: scale(0.85);
  transform-origin: left center;
}

/* Container de l'icône avec effets subtils */
.logo-icon-container {
  position: relative;
  flex-shrink: 0;
}

.logo-icon {
  filter: drop-shadow(0 2px 5px rgba(0, 0, 0, 0.15));
  transition: transform 0.3s ease;
}

.logo:hover .logo-icon {
  transform: scale(1.05) translateY(-1px);
}

/* Animation pour le cercle pulsant */
.pulse-circle {
  transition: stroke 0.4s ease, stroke-dasharray 1.2s ease;
}

/* Style du texte - Approche Trivago/Airbnb */
.logo-text {
  display: flex;
  flex-direction: column;
  font-family: 'Cereal', -apple-system, BlinkMacSystemFont, Roboto, 'Helvetica Neue', sans-serif;
  line-height: 1;
  transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
}

.logo-text-hovered {
  transform: translateX(3px);
}

.brand-name {
  font-size: 24px;
  font-weight: 600;
  letter-spacing: -0.4px;
  color: #222222; /* Havoo texte foncé */
  transition: color 0.4s ease;
}

.service-text {
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.2px;
  text-transform: lowercase;
  margin-top: 1px;
  color: #FF385C; /* Havoo rouge */
  transition: color 0.3s ease, transform 0.3s ease;
}

/* Support du mode sombre */
@media (prefers-color-scheme: dark) {
  .brand-name {
    color: #ffffff;
  }
}

.logo:hover .service-text {
  background: linear-gradient(90deg, #FF385C 0%, #FF7779 100%); /* Dégradé amélioré */
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
</style>