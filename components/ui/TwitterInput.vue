<template>
    <div class="twitter-input-wrapper relative w-full">
      <div class="relative">
        <!-- Input standard -->
        <input 
          v-if="type !== 'textarea' && !isSelect && !readonly"
          :id="id"
          :type="type"
          :value="modelValue"
          @input="$emit('update:modelValue', $event.target.value)"
          @focus="isFocused = true"
          @blur="isFocused = modelValue ? true : false"
          :disabled="disabled"
          class="twitter-input w-full bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-xl px-3 pt-5 pb-1.5 text-gray-900 dark:text-white transition-all peer"
          :class="{
            'pl-10': prefix, 
            'border-primary-500': isFocused,
            'bg-gray-50 dark:bg-gray-900 text-gray-500 dark:text-gray-400': disabled,
            'pr-10': isSelect
          }"
          :placeholder="' '"
        />
        
        <!-- Champ en lecture seule -->
        <div 
          v-if="readonly"
          class="twitter-input w-full bg-gray-50 dark:bg-gray-900 border border-gray-300 dark:border-gray-700 rounded-xl px-3 pt-5 pb-1.5 text-gray-500 dark:text-gray-400 peer"
        >
          {{ modelValue || '—' }}
        </div>
        
        <!-- Textarea -->
        <textarea 
          v-else-if="type === 'textarea'"
          :id="id"
          :value="modelValue"
          @input="$emit('update:modelValue', $event.target.value)"
          @focus="isFocused = true"
          @blur="isFocused = modelValue ? true : false"
          :rows="rows"
          :disabled="disabled"
          class="twitter-input w-full bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-xl px-3 pt-5 pb-1.5 text-gray-900 dark:text-white transition-all resize-none peer"
          :class="{
            'border-primary-500': isFocused,
            'bg-gray-50 dark:bg-gray-900 text-gray-500 dark:text-gray-400': disabled
          }"
          :placeholder="' '"
        ></textarea>
        
        <!-- Select -->
        <div v-else-if="isSelect" class="relative">
          <select
            :id="id"
            :value="modelValue"
            @input="$emit('update:modelValue', $event.target.value)"
            @focus="isFocused = true"
            @blur="isFocused = modelValue ? true : false"
            :disabled="disabled"
            class="twitter-input w-full bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-xl px-3 pt-5 pb-1.5 pr-10 text-gray-900 dark:text-white transition-all appearance-none peer"
            :class="{
              'border-primary-500': isFocused,
              'bg-gray-50 dark:bg-gray-900 text-gray-500 dark:text-gray-400': disabled
            }"
          >
            <slot></slot>
          </select>
          <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-500 dark:text-gray-400">
            <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
          </div>
        </div>
        
        <!-- Floating label with required indicator -->
        <label 
          :for="id" 
          class="absolute text-gray-500 duration-300 transform -translate-y-3 scale-75 top-3 z-10 origin-[0] left-3 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-3"
        >
          {{ placeholder }} <span v-if="required" class="text-red-500">*</span>
        </label>
        
        <!-- Prefix (e.g. FCFA) -->
        <div v-if="prefix" class="absolute left-0 top-0 h-full px-2.5 flex items-center text-gray-500 dark:text-gray-400">
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
  import { ref, onMounted, watch, computed } from 'vue';
  
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
    },
    disabled: {
      type: Boolean,
      default: false
    },
    readonly: {
      type: Boolean,
      default: false
    },
    isSelect: {
      type: Boolean,
      default: false
    }
  });
  
  defineEmits(['update:modelValue']);
  
  // Track focus state for animation
  const isFocused = ref(false);
  
  // Computed property to determine if the field is a select
  const isSelectType = computed(() => {
    return props.type === 'select' || props.isSelect;
  });
  
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
  .twitter-input.pl-10 + label {
    left: 2rem;
  }
  </style>