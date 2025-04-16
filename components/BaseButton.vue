<template>
  <button
    :type="type"
    :class="[
      'inline-flex items-center justify-center gap-2 px-4 py-2.5 text-sm font-bold transition-all duration-200',
      'focus:outline-none focus:ring-2 focus:ring-offset-2',
      'disabled:opacity-50 disabled:cursor-not-allowed',
      variants[variant][color],
      sizes[size],
      fullWidth ? 'w-full' : '',
      className
    ]"
    :disabled="disabled || loading"
    v-bind="$attrs"
  >
    <!-- Loading spinner amélioré -->
    <div 
      v-if="loading" 
      class="relative flex"
    >
      <div class="dots-flow">
        <div></div>
        <div></div>
        <div></div>
      </div>
    </div>

    <!-- Leading icon -->
    <slot v-if="!loading" name="leading" />

    <!-- Label -->
    <span :class="{ 'opacity-0': loading }">
      <slot>{{ label }}</slot>
    </span>

    <!-- Trailing icon -->
    <slot v-if="!loading" name="trailing" />
  </button>
</template>

<script setup>
const props = defineProps({
  label: String,
  type: {
    type: String,
    default: 'button'
  },
  variant: {
    type: String,
    default: 'solid',
    validator: (value) => ['solid', 'outline', 'ghost'].includes(value)
  },
  color: {
    type: String,
    default: 'primary',
    validator: (value) => ['primary', 'gray', 'red'].includes(value)
  },
  size: {
    type: String,
    default: 'md',
    validator: (value) => ['sm', 'md', 'lg', 'xl'].includes(value)
  },
  fullWidth: Boolean,
  loading: Boolean,
  disabled: Boolean,
  className: String
})

// Variantes de style
const variants = {
  solid: {
    primary: 'rounded-full bg-green-500 text-white hover:bg-green-800 dark:bg-white dark:text-gray-900 dark:hover:bg-gray-100 focus:ring-gray-500',
    gray: 'rounded-full bg-gray-100 text-gray-700 hover:bg-gray-200 dark:bg-gray-800 dark:text-gray-300 dark:hover:bg-gray-700 focus:ring-gray-500',
    red: 'rounded-full bg-red-500 text-white hover:bg-red-600 dark:bg-red-600 dark:hover:bg-red-700 focus:ring-red-500'
  },
  outline: {
    primary: 'rounded-full border-2 border-gray-200 text-gray-700 hover:bg-gray-50 dark:border-gray-700 dark:text-gray-300 dark:hover:bg-gray-800 focus:ring-gray-500',
    gray: 'rounded-full border-2 border-gray-200 text-gray-700 hover:bg-gray-50 dark:border-gray-700 dark:text-gray-300 dark:hover:bg-gray-800 focus:ring-gray-500',
    red: 'rounded-full border-2 border-red-200 text-red-500 hover:bg-red-50 hover:border-red-300 dark:border-red-800 dark:hover:bg-red-900/30 focus:ring-red-500'
  },
  ghost: {
    primary: 'rounded-full text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-800 focus:ring-gray-500',
    gray: 'rounded-full text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-800 focus:ring-gray-500',
    red: 'rounded-full text-red-500 hover:bg-red-50 dark:text-red-400 dark:hover:bg-red-900/30 focus:ring-red-500'
  }
}

// Tailles
const sizes = {
  sm: 'text-xs px-3 py-1.5',
  md: 'text-sm px-4 py-2',
  lg: 'text-base px-5 py-2.5',
  xl: 'text-lg px-6 py-3'
}
</script>

<style scoped>
.dots-flow {
  display: flex;
  align-items: center;
  gap: 2px;
  height: 16px;
}

.dots-flow div {
  width: 4px;
  height: 4px;
  border-radius: 50%;
  background-color: currentColor;
  animation: bounce 0.5s infinite alternate;
}

.dots-flow div:nth-child(1) {
  animation-delay: -0.3s;
}

.dots-flow div:nth-child(2) {
  animation-delay: -0.15s;
}

.dots-flow div:nth-child(3) {
  animation-delay: 0s;
}

@keyframes bounce {
  from {
    transform: translateY(-2px);
    opacity: 0.8;
  }
  to {
    transform: translateY(2px);
    opacity: 0.3;
  }
}
</style> 