<template>
  <div 
    class="logo" 
    :class="{ 'logo-small': small }"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <!-- Logo Icon with GAFAM influence - more rounded corners like Google/Apple, 
         simplicity like Microsoft, gradient like Instagram -->
    <div class="logo-icon-container">
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg" class="logo-icon">
        <!-- Base background with softer gradient (Airbnb red tones) -->
        <rect width="32" height="32" rx="8" fill="url(#paint0_linear)" />
        
        <!-- Simplified icon shape (similar to Airbnb's house concept, but for Havoo) -->
        <path d="M16 8C18.2091 8 20 9.79086 20 12C20 13.0252 19.5892 13.9615 18.9171 14.6578C20.7762 15.6483 22 17.6945 22 20V24C22 24.5523 21.5523 25 21 25C20.4477 25 20 24.5523 20 24V20C20 17.7909 18.2091 16 16 16C13.7909 16 12 17.7909 12 20V24C12 24.5523 11.5523 25 11 25C10.4477 25 10 24.5523 10 24V20C10 17.6945 11.2238 15.6483 13.0829 14.6578C12.4108 13.9615 12 13.0252 12 12C12 9.79086 13.7909 8 16 8Z" fill="white"/>
        
        <!-- Animation effect - subtle pulse circle (inspired by Google Assistant) -->
        <circle 
          cx="16" 
          cy="16" 
          r="14" 
          :stroke="isHovered ? 'rgba(255, 255, 255, 0.3)' : 'rgba(255, 255, 255, 0)'" 
          stroke-width="1.5"
          fill="none"
          class="pulse-circle"
        />
        
        <defs>
          <linearGradient id="paint0_linear" x1="0" y1="0" x2="32" y2="32" gradientUnits="userSpaceOnUse">
            <stop stop-color="#FF5A5F" /> <!-- Airbnb primary red -->
            <stop offset="1" stop-color="#FF385C" /> <!-- Airbnb darker red -->
          </linearGradient>
        </defs>
      </svg>
    </div>
    
    <!-- Logo Text - with Airbnb-style typography and cleaner GAFAM-inspired approach -->
    <div v-if="!iconOnly" class="logo-text" :class="{ 'logo-text-hovered': isHovered }">
      <span class="brand-name">Havoo</span>
      <span class="service-text">Services</span>
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
  gap: 10px;
  cursor: pointer;
  transition: transform 0.3s ease;
}

.logo-small {
  transform: scale(0.85);
  transform-origin: left center;
}

/* Icon container with subtle effects */
.logo-icon-container {
  position: relative;
  flex-shrink: 0;
}

.logo-icon {
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
  transition: transform 0.3s ease;
}

.logo:hover .logo-icon {
  transform: scale(1.05);
}

/* Animation for pulse circle (Google-inspired) */
.pulse-circle {
  transition: stroke 0.3s ease, stroke-width 0.3s ease;
}

/* Text styling - Airbnb-inspired typography */
.logo-text {
  display: flex;
  flex-direction: column;
  font-family: 'Circular', -apple-system, BlinkMacSystemFont, Roboto, 'Helvetica Neue', sans-serif; /* Airbnb-like font stack */
  line-height: 1;
  transition: transform 0.3s ease;
}

.logo-text-hovered {
  transform: translateX(2px);
}

.brand-name {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: -0.5px;
  color: #222222; /* Airbnb dark text */
}

.service-text {
  font-size: 16px;
  font-weight: 500;
  letter-spacing: -0.2px;
  color: #FF385C; /* Airbnb red */
  transition: color 0.3s ease, transform 0.3s ease;
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
  .brand-name {
    color: #ffffff;
  }
}

.logo:hover .service-text {
  background: linear-gradient(90deg, #FF385C 0%, #FF5A5F 100%); /* Airbnb reds */
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
</style>