<template>
  <div 
    class="logo" 
    :class="{ 'logo-small': small }"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <!-- Logo Icon - Design moderne pour Keetaf -->
    <div class="logo-icon-container">
      <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24"><g fill="none" stroke="#08a819" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"><path d="M6.133 21C4.955 21 4 20.02 4 18.81v-8.802c0-.665.295-1.295.8-1.71l5.867-4.818a2.09 2.09 0 0 1 2.666 0l5.866 4.818c.506.415.801 1.045.801 1.71v8.802c0 1.21-.955 2.19-2.133 2.19z"/><path d="M9 16c.85.63 1.885 1 3 1s2.15-.37 3-1m-5.5-4.5V11m5 .5V11"/></g></svg>    </div>
    
    <!-- Texte du logo avec séparation visuelle pour Keetaf Services -->
    <div v-if="!iconOnly" class="logo-text" :class="{ 'logo-text-hovered': isHovered }">
      <span class="brand-name">Keetaf</span>
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
  gap: 8px;
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
  color: #222222; /* Keetaf texte foncé */
  transition: color 0.4s ease;
}

.service-text {
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.2px;
  text-transform: lowercase;
  margin-top: 1px;
  color: var(--primary-color); /* Couleur primaire de l'app */
  transition: color 0.3s ease, transform 0.3s ease;
}

/* Support du mode sombre */
@media (prefers-color-scheme: dark) {
  .brand-name {
    color: #ffffff;
  }
}

.logo:hover .service-text {
  background: linear-gradient(90deg, var(--primary-color, #FF385C) 0%, var(--primary-color-light, #FF7779) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
</style>