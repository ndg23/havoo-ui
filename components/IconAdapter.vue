<template>
  <component :is="resolvedIcon" v-if="!isEmoji" v-bind="$attrs" />
  <span v-else class="text-2xl" v-bind="$attrs">{{ name }}</span>
</template>

<script setup>
import { computed } from 'vue'
import { Home, Leaf, Tool, Baby, BookOpen, Laptop, Wrench, LayoutGrid } from 'lucide-vue-next'

// Mappage entre les noms d'icônes et les composants
const iconMap = {
  'Home': Home,
  'Leaf': Leaf, 
  'Tool': Tool,
  'Baby': Baby,
  'BookOpen': BookOpen,
  'Laptop': Laptop,
  'Wrench': Wrench
}

const props = defineProps({
  name: {
    type: String,
    required: true
  }
})

// Détermine si le nom est un emoji
const isEmoji = computed(() => {
  return /\p{Emoji}/u.test(props.name)
})

// Résout l'icône en fonction du nom
const resolvedIcon = computed(() => {
  return iconMap[props.name] || LayoutGrid
})
</script> 