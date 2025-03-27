<template>
    <div class="relative">
      <img
        :src="src || '/assets/icons/avatar.svg'"
        :alt="alt"
        :class="[
          'rounded-full object-cover',
          sizeClasses[size] || sizeClasses.md
        ]"
        @error="handleImageError"
      />
    </div>
  </template>
  
  <script setup>
  const props = defineProps({
    src: {
      type: String,
      default: ''
    },
    alt: {
      type: String,
      default: 'Photo de profil'
    },
    size: {
      type: String,
      default: 'md',
      validator: (value) => ['xs', 'sm', 'md', 'lg', 'xl'].includes(value)
    }
  })
  
  const sizeClasses = {
    xs: 'h-6 w-6',
    sm: 'h-8 w-8',
    md: 'h-12 w-12',
    lg: 'h-16 w-16',
    xl: 'h-32 w-32'
  }
  
  const handleImageError = (e) => {
    e.target.src = '/assets/icons/avatar.svg'
  }
  </script>