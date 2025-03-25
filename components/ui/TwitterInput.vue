<template>
    <div class="twitter-input-wrapper relative w-full">
      <div class="relative">
        <!-- Input field -->
        <input 
          v-if="type !== 'textarea'"
          :id="id"
          :type="type"
          :value="modelValue"
          @input="$emit('update:modelValue', $event.target.value)"
          @focus="isFocused = true"
          @blur="isFocused = modelValue ? true : false"
          class="twitter-input w-full bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-xl px-4 pt-6 pb-2 text-gray-900 dark:text-white transition-all peer"
          :class="{'pl-12': prefix, 'border-primary-500': isFocused}"
          :placeholder="' '"
        />
        
        <!-- Textarea field -->
        <textarea 
          v-else
          :id="id"
          :value="modelValue"
          @input="$emit('update:modelValue', $event.target.value)"
          @focus="isFocused = true"
          @blur="isFocused = modelValue ? true : false"
          :rows="rows"
          class="twitter-input w-full bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-xl px-4 pt-6 pb-2 text-gray-900 dark:text-white transition-all resize-none peer"
          :class="{'border-primary-500': isFocused}"
          :placeholder="' '"
        ></textarea>
        
        <!-- Floating label with required indicator -->
        <label 
          :for="id" 
          class="absolute text-gray-500 duration-300 transform -translate-y-3 scale-75 top-4 z-10 origin-[0] left-4 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-3"
        >
          {{ placeholder }} <span v-if="required" class="text-red-500">*</span>
        </label>
        
        <!-- Prefix (e.g. FCFA) -->
        <div v-if="prefix" class="absolute left-0 top-0 h-full px-3 flex items-center text-gray-500 dark:text-gray-400">
          {{ prefix }}
        </div>
      </div>
  
      <!-- Character counter -->
      <div v-if="showCount && maxLength" class="mt-1 text-xs text-right text-gray-500 dark:text-gray-400">
        {{ modelValue?.length || 0 }}/{{ maxLength }}
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, watch } from 'vue';
  
  const props = defineProps({
    id: {
      type: String,
      required: true
    },
    modelValue: {
      type: [String, Number],
      default: ''
    },
    placeholder: {
      type: String,
      default: ''
    },
    type: {
      type: String,
      default: 'text'
    },
    prefix: {
      type: String,
      default: ''
    },
    rows: {
      type: Number,
      default: 3
    },
    maxLength: {
      type: Number,
      default: null
    },
    showCount: {
      type: Boolean,
      default: false
    },
    required: {
      type: Boolean,
      default: false
    }
  });
  
  defineEmits(['update:modelValue']);
  
  // Track focus state for animation
  const isFocused = ref(false);
  
  // Initialize label position based on whether there's a value
  onMounted(() => {
    if (props.modelValue) {
      isFocused.value = true;
    }
  });
  
  // Update focus state when model value changes externally
  watch(() => props.modelValue, (newVal) => {
    if (newVal && !isFocused.value) {
      isFocused.value = true;
    } else if (!newVal && !document.activeElement.id === props.id) {
      isFocused.value = false;
    }
  });
  </script>
  
  <style scoped>
  .twitter-input {
    transition: all 0.2s ease;
  }
  
  .twitter-input:focus {
    outline: none;
    border-width: 2px;
  }
  
  /* Hide the placeholder text when input is focused or has content */
  .twitter-input:focus::placeholder,
  .twitter-input:not(:placeholder-shown)::placeholder {
    opacity: 0;
  }
  
  /* Ensure the label stays up when input has content */
  .twitter-input:not(:placeholder-shown) + label {
    transform: translateY(-3px) scale(0.75);
  }
  
  /* Adjust padding when prefix is present */
  .twitter-input.pl-12 + label {
    left: 3rem;
  }
  </style>