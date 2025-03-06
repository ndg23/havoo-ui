<template>
  <div 
    class="bg-white rounded-xl border border-gray-200 p-6 relative overflow-hidden group hover:border-primary-100 transition-all duration-300"
    :class="{ 
      'hover:shadow-md': !hoverable, 
      'hover:shadow-lg hover:scale-[1.02]': hoverable,
      'cursor-pointer transform transition-transform': hoverable && clickable
    }"
    @click="clickable && $emit('click')"
  >
    <!-- Indicateur coloré subtil en arrière-plan -->
    <div 
      class="absolute top-0 left-0 w-full h-1 opacity-70 transform origin-left transition-transform duration-300 group-hover:scale-x-100"
      :class="[`bg-${color}-500`]"
      :style="{ transform: 'scaleX(0.5)' }"
    ></div>
    
    <div class="flex items-center">
      <div 
        class="h-14 w-14 rounded-full flex items-center justify-center transition-all duration-300 group-hover:scale-110"
        :class="[`bg-${color}-50`, `group-hover:bg-${color}-100`]"
      >
        <component 
          :is="icon" 
          class="h-6 w-6 transition-colors duration-300" 
          :class="[`text-${color}-500`, `group-hover:text-${color}-600`]" 
        />
      </div>
      <div class="ml-4">
        <p class="text-sm font-medium text-gray-500">{{ title }}</p>
        <div class="flex items-baseline gap-2">
          <p class="mt-1 text-2xl font-semibold text-gray-900 transition-all duration-300 group-hover:text-primary-800">
            {{ typeof value === 'number' ? new Intl.NumberFormat().format(value) : value }}
          </p>
          <p v-if="trend" 
            class="text-xs font-medium flex items-center"
            :class="trendClass"
          >
            <component :is="trendIcon" class="h-3.5 w-3.5 mr-0.5" />
            {{ trendValue }}
          </p>
        </div>
      </div>
    </div>
    
    <!-- Graphique miniature (optionnel) -->
    <div v-if="chartData && chartData.length > 0" class="mt-3">
      <div class="h-10 flex items-end space-x-1">
        <div 
          v-for="(point, i) in chartData" 
          :key="i"
          class="flex-1 bg-opacity-20 rounded-sm transition-all duration-200 hover:opacity-80"
          :class="[`bg-${color}-400`]"
          :style="{ height: `${(point / maxChartValue) * 100}%` }"
        ></div>
      </div>
    </div>

    <!-- Message sous le titre (optionnel) -->
    <p v-if="subtitle" class="mt-2 text-xs text-gray-500">{{ subtitle }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { TrendingUp, TrendingDown, ArrowRight } from 'lucide-vue-next'

const props = defineProps({
  title: {
    type: String,
    required: true
  },
  value: {
    type: [String, Number],
    required: true
  },
  subtitle: {
    type: String,
    default: ''
  },
  icon: {
    type: Object,
    required: true
  },
  color: {
    type: String,
    default: 'blue',
    validator: (value) => ['blue', 'green', 'red', 'yellow', 'purple', 'indigo', 'pink', 'amber', 'emerald', 'cyan', 'violet'].includes(value)
  },
  trend: {
    type: Number,
    default: null
  },
  chartData: {
    type: Array,
    default: () => []
  },
  hoverable: {
    type: Boolean,
    default: true
  },
  clickable: {
    type: Boolean,
    default: false
  }
})

defineEmits(['click'])

const trendValue = computed(() => {
  if (props.trend === null) return '';
  const absValue = Math.abs(props.trend);
  return absValue === 0 ? '0%' : `${absValue}%`;
})

const trendClass = computed(() => {
  if (props.trend === null) return '';
  return props.trend > 0 
    ? 'text-green-600' 
    : props.trend < 0 
      ? 'text-red-600' 
      : 'text-gray-500';
})

const trendIcon = computed(() => {
  if (props.trend === null) return null;
  return props.trend > 0 
    ? TrendingUp 
    : props.trend < 0 
      ? TrendingDown 
      : ArrowRight;
})

const maxChartValue = computed(() => {
  if (!props.chartData || props.chartData.length === 0) return 0;
  return Math.max(...props.chartData);
})
</script> 