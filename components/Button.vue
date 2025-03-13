<template>
  <button 
    :class="[
      'font-medium transition-all duration-300', 
      primary ? 'bg-blue-500 hover:bg-blue-600 active:bg-blue-700 text-white rounded-full' : 'bg-white/80 backdrop-blur-sm hover:bg-white text-gray-800 border border-gray-200 rounded-lg',
      sm ? 'px-4 py-1.5 text-sm' : 'px-6 py-3 text-base',
      block ? 'w-full' : ''
    ]"
    :style="primary ? 'box-shadow: 0 1px 2px rgba(0,0,0,0.05);' : ''"
    v-bind="$attrs"
  >
    <slot></slot>
  </button>
</template> 