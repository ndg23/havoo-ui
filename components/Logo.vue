<template>
  <div 
 
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
  <img src="/assets/icons/logo.png" alt="Keetaf" width="100" height="100" :class="{ 'logo-small': small }">

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
 width: 100px;
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