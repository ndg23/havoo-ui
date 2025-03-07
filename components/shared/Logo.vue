<template>
  <div class="logo-container" :class="{ 'logo-small': small }">
    <div class="logo-icon">
      <div class="logo-shape-1"></div>
      <div class="logo-shape-2"></div>
    </div>
    <div v-if="!iconOnly" class="logo-text">
      <span class="logo-text-main">Havoo</span>
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
.logo-container {
  display: flex;
  align-items: center;
  gap: 10px;
}

.logo-small {
  transform: scale(0.85);
  transform-origin: left center;
}

.logo-icon {
  position: relative;
  width: 28px;
  height: 28px;
  border-radius: 4px;
  background: linear-gradient(135deg, var(--color-primary-600), var(--color-primary-500));
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(var(--color-primary-600-rgb), 0.25);
}

.logo-shape-1 {
  position: absolute;
  width: 12px;
  height: 12px;
  background-color: green;
  border-radius: 50%;
  top: 4px;
  left: 4px;
}

.logo-shape-2 {
  position: absolute;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  bottom: 4px;
  right: 4px;
  background-color: rgba(255, 255, 255, 0.9);
}

.logo-text {
  font-size: 20px;
  font-weight: 700;
  letter-spacing: -0.5px;
  line-height: 1;
}

.logo-text-main {
  color: var(--color-gray-800);
}

.dark .logo-text-main {
  color: white;
}

.logo-text-accent {
  color: var(--color-primary-600);
}

/* Définir des variables CSS pour les couleurs */
:root {
  --color-primary-500: #4f46e5;
  --color-primary-600: #4338ca;
  --color-primary-600-rgb: 67, 56, 202;
  --color-gray-800: #1f2937;
}

.dark {
  --color-gray-800: #f9fafb;
}
</style>