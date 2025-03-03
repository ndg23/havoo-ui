<template>
  <div 
    class="relative rounded-full overflow-hidden"
    :class="[sizeClasses[size]]"
  >
    <img 
      v-if="src"
      :src="src"
      :alt="alt"
      class="w-full h-full object-cover"
    />
    <div 
      v-else
      class="w-full h-full flex items-center justify-center bg-gray-100"
    >
      <UserIcon 
        :class="[iconSizeClasses[size]]"
        class="text-gray-400"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { UserIcon } from 'lucide-vue-next'

const props = withDefaults(defineProps<{
  src?: string
  alt?: string
  size?: 'sm' | 'md' | 'lg' | 'xl'
}>(), {
  size: 'md'
})

const sizeClasses = {
  sm: 'w-8 h-8',
  md: 'w-10 h-10',
  lg: 'w-12 h-12',
  xl: 'w-20 h-20'
}

const iconSizeClasses = {
  sm: 'w-4 h-4',
  md: 'w-5 h-5',
  lg: 'w-6 h-6',
  xl: 'w-10 h-10'
}
</script> 