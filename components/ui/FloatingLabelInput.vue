<template>
  <div class="input-container relative w-full">
    <input 
      :id="id"
      :type="type"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
      placeholder=" " 
      class="input-field w-full border border-1 border-[#363636] rounded-lg px-4 pt-6 pb-2 transition-all focus:outline-none focus:border-primary-500 focus:ring-2 focus:ring-primary-500 focus:ring-opacity-30"
      :aria-required="required"
      v-bind="$attrs"
    />
    <label 
      :for="id" 
      class="input-label absolute left-4 top-2 text-sm text-zinc-500 pointer-events-none transition-all"
    >
      {{ label }}
    </label>
  </div>
</template>

<script setup>
defineProps({
  id: {
    type: String,
    required: true
  },
  label: {
    type: String,
    required: true
  },
  modelValue: {
    type: [String, Number],
    default: ''
  },
  type: {
    type: String,
    default: 'text'
  },
  required: {
    type: Boolean,
    default: false
  }
})

defineEmits(['update:modelValue'])
</script>

<style scoped>
/* Styles de base */
.input-field {
  width: 100%;
  padding: 1.5rem 1rem 0.5rem;
  transition: all 0.2s ease;
  border-color: rgb(184, 184, 184);
  border-width: 1px;
}

.input-label {
  font-size: 0.875rem;
  transition: all 0.2s ease;
}

/* État focus */
.input-field:focus {
  border-color: theme('colors.primary.500');
  box-shadow: 0 0 0 2px rgba(var(--color-primary-500), 0.3);
}

.input-field:focus + .input-label {
  color: theme('colors.primary.500');
}

/* État avec valeur */
.input-field:not(:placeholder-shown) + .input-label {
  color: theme('colors.zinc.500');
}

/* État d'erreur */
.input-field.error {
  border-color: theme('colors.red.500');
}

.input-field.error + .input-label {
  color: theme('colors.red.500');
}

.input-field.error:focus {
  box-shadow: 0 0 0 2px rgba(239, 68, 68, 0.3);
}

/* Support pour les champs désactivés */
.input-field:disabled {
  background-color: theme('colors.gray.100');
  border-color: theme('colors.gray.300');
  cursor: not-allowed;
}

.input-field:disabled + .input-label {
  color: theme('colors.gray.400');
}
</style> 