<!-- Switch Component for Toggle -->
<script>
// Switch.vue
export default {
  name: 'Switch',
  props: {
    modelValue: {
      type: Boolean,
      default: false
    }
  },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const toggle = () => {
      emit('update:modelValue', !props.modelValue);
    };

    return {
      toggle
    };
  }
};
</script>

<template>
  <button
    type="button"
    @click="toggle"
    class="focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
  >
    <slot></slot>
  </button>
</template>

<!-- Checkbox Component -->
<script>
// Checkbox.vue
export default {
  name: 'Checkbox',
  props: {
    checked: {
      type: Boolean,
      default: false
    }
  },
  emits: ['change'],
  setup(props, { emit }) {
    const toggle = () => {
      emit('change', !props.checked);
    };

    return {
      toggle
    };
  }
};
</script>

<template>
  <button
    type="button"
    @click="toggle"
    class="focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
  >
    <svg
      v-if="checked"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="currentColor"
      class="w-5 h-5 text-blue-500"
    >
      <path d="M4 3h16a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1z" />
      <path
        d="M10.5 13.2L7.9 10.6a.7.7 0 0 0-1 1L10 14.8a.7.7 0 0 0 1 0l6-6a.7.7 0 0 0-1-1l-5.5 5.4z"
        fill="white"
      />
    </svg>
    <svg
      v-else
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      stroke="currentColor"
      fill="none"
      class="w-5 h-5 text-gray-400 dark:text-gray-500"
    >
      <rect x="4" y="4" width="16" height="16" rx="1" strokeWidth="2" />
    </svg>
  </button>
</template>