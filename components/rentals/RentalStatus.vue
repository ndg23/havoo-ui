<template>
  <span 
    class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium"
    :class="statusClasses[status]"
  >
    <component 
      :is="statusIcons[status]" 
      class="w-3 h-3 mr-1"
    />
    {{ statusLabels[status] }}
  </span>
</template>

<script setup lang="ts">
import { Clock, Check, XCircle, Loader2 } from 'lucide-vue-next'

const props = defineProps<{
  status: 'pending' | 'active' | 'completed' | 'cancelled'
}>()

const statusLabels = {
  pending: 'En attente',
  active: 'En cours',
  completed: 'Terminée',
  cancelled: 'Annulée'
}

const statusClasses = {
  pending: 'bg-yellow-100 text-yellow-700',
  active: 'bg-green-100 text-green-700',
  completed: 'bg-gray-100 text-gray-700',
  cancelled: 'bg-red-100 text-red-700'
}

const statusIcons = {
  pending: Clock,
  active: Loader2,
  completed: Check,
  cancelled: XCircle
}
</script> 