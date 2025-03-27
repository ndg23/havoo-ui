<template>
  <div class="input-container relative w-full">
    <div class="relative">
      <!-- Préfixe (devise) -->
      <div v-if="currency && type === 'number'" class="absolute left-4 top-1/2 -translate-y-1/2 text-sm text-gray-500 pointer-events-none z-10">
        {{ currency }}
      </div>
      
      <!-- Input ou Select -->
      <template v-if="type === 'select'">
        <select
          :id="id"
          ref="input"
          :value="modelValue"
          @input="handleInput"
          @blur="handleBlur"
          @focus="handleFocus"
          class="block w-full px-4 pt-6 pb-2 text-base text-gray-900 border rounded-lg appearance-none transition-all duration-200 ease-in-out focus:outline-none focus:border-primary-500 focus:ring-2 focus:ring-primary-500 focus:ring-opacity-30"
          :class="{
            'border-red-500': error,
            'border-gray-300': !error && !isFocused,
            'border-primary-500': isFocused && !error,
            'text-gray-500': !modelValue
          }"
          :aria-required="required"
          v-bind="$attrs"
        >
          <option value="" disabled selected>{{ placeholder || 'Sélectionner...' }}</option>
          <slot></slot>
        </select>
        <!-- Icône select -->
        <div class="absolute right-4 top-1/2 -translate-y-1/2 pointer-events-none">
          <svg class="w-4 h-4 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
          </svg>
        </div>
      </template>
      <template v-else>
        <input 
          :id="id"
          ref="input"
          :type="type === 'number' ? 'text' : type"
          :value="type === 'number' ? displayValue : modelValue"
          @input="handleInput"
          @blur="handleBlur"
          @focus="handleFocus"
          class="block w-full px-4 pt-6 pb-2 text-base text-gray-900 border rounded-lg transition-all duration-200 ease-in-out focus:outline-none focus:border-primary-500 focus:ring-2 focus:ring-primary-500 focus:ring-opacity-30"
          :class="{
            'border-red-500': error,
            'border-gray-300': !error && !isFocused,
            'border-primary-500': isFocused && !error,
            'pl-12': currency && type === 'number',
            'pr-10': suffix && type === 'number'
          }"
          :aria-required="required"
          v-bind="$attrs"
        />
      </template>
      
      <!-- Label flottant -->
      <label 
        :for="id" 
        class="absolute left-4 top-2 z-20 pointer-events-none transition-all duration-200 ease-in-out flex items-center gap-1"
        :class="{
          'transform-active': modelValue || isFocused,
          'transform-inactive': !modelValue && !isFocused,
          'text-primary-500': isFocused && !error,
          'text-red-500': error,
          'text-gray-400': !isFocused && !error,
          'left-12': currency && type === 'number'
        }"
      >
        {{ label }}
        <span v-if="required" class="text-red-500">*</span>
      </label>
      
      <!-- Suffixe (unité) -->
      <div v-if="suffix && type === 'number'" class="absolute right-4 top-1/2 -translate-y-1/2 text-sm text-gray-500 pointer-events-none z-10">
        {{ suffix }}
      </div>
    </div>
    
    <!-- Message d'erreur -->
    <div v-if="error && errorMessage" class="mt-1 text-sm text-red-500">
      {{ errorMessage }}
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';

const props = defineProps({
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
    default: 'text',
    validator: (value) => ['text', 'number', 'email', 'password', 'select'].includes(value)
  },
  required: {
    type: Boolean,
    default: false
  },
  error: {
    type: Boolean,
    default: false
  },
  errorMessage: {
    type: String,
    default: ''
  },
  placeholder: {
    type: String,
    default: ''
  },
  min: {
    type: Number,
    default: null
  },
  max: {
    type: Number,
    default: null
  },
  step: {
    type: Number,
    default: 1
  },
  precision: {
    type: Number,
    default: 2
  },
  currency: {
    type: String,
    default: null
  },
  suffix: {
    type: String,
    default: null
  }
});

const emit = defineEmits(['update:modelValue']);
const input = ref(null);
const rawValue = ref('');
const isFocused = ref(false);

// Formater la valeur pour l'affichage (pour les champs numériques)
const displayValue = computed(() => {
  if (props.type !== 'number') {
    return props.modelValue;
  }
  
  if (isFocused.value) {
    return rawValue.value;
  }
  
  if (props.modelValue === null || props.modelValue === undefined || props.modelValue === '') {
    return '';
  }
  
  // Formater le nombre avec la précision demandée
  try {
    return Number(props.modelValue).toLocaleString('fr-FR', {
      minimumFractionDigits: props.precision,
      maximumFractionDigits: props.precision
    });
  } catch (e) {
    return props.modelValue;
  }
});

// Convertir la valeur saisie en nombre (pour les champs numériques)
const parseValue = (value) => {
  if (value === null || value === undefined || value === '') {
    return null;
  }
  
  // Remplacer la virgule par un point et supprimer les espaces et autres caractères non numériques
  const cleanValue = value.toString()
    .replace(/\s/g, '')
    .replace(/,/g, '.')
    .replace(/[^\d.-]/g, '');
  
  if (cleanValue === '' || cleanValue === '.' || cleanValue === '-') {
    return null;
  }
  
  const numValue = parseFloat(cleanValue);
  
  // Appliquer les contraintes min/max
  if (props.min !== null && numValue < props.min) {
    return props.min;
  }
  
  if (props.max !== null && numValue > props.max) {
    return props.max;
  }
  
  return numValue;
};

// Gérer la saisie
const handleInput = (event) => {
  if (props.type === 'number') {
    const value = event.target.value;
    rawValue.value = value;
    
    const parsedValue = parseValue(value);
    emit('update:modelValue', parsedValue);
  } else {
    emit('update:modelValue', event.target.value);
  }
};

// Gérer la perte de focus
const handleBlur = () => {
  isFocused.value = false;
  
  // Arrondir à la précision demandée pour les champs numériques
  if (props.type === 'number' && props.modelValue !== null && props.modelValue !== undefined) {
    const rounded = Math.round(props.modelValue * Math.pow(10, props.precision)) / Math.pow(10, props.precision);
    emit('update:modelValue', rounded);
  }
};

// Gérer le focus
const handleFocus = (event) => {
  isFocused.value = true;
  
  // Pour les champs numériques, convertir la valeur formatée en valeur brute pour l'édition
  if (props.type === 'number' && props.modelValue !== null && props.modelValue !== undefined) {
    rawValue.value = props.modelValue.toString().replace('.', ',');
  }
  
  // Sélectionner tout le texte
  event.target.select();
};

// Observer les changements de modelValue pour les champs numériques
watch(() => props.modelValue, (newValue) => {
  if (props.type === 'number' && !isFocused.value && newValue !== null && newValue !== undefined) {
    // Mettre à jour la valeur brute si le modèle change et que le champ n'est pas en focus
    rawValue.value = newValue.toString().replace('.', ',');
  }
});

// Initialisation
onMounted(() => {
  if (props.type === 'number' && props.modelValue !== null && props.modelValue !== undefined) {
    rawValue.value = props.modelValue.toString().replace('.', ',');
  }
});
</script>

<style scoped>
.transform-inactive {
  transform: translateY(0.7rem);
  font-size: 1rem;
  color: #6b7280;
}

.transform-active {
  transform: translateY(0) scale(0.85);
  font-size: 0.875rem;
}

/* Animation fluide */
label {
  transform-origin: 0 0;
  line-height: 1;
}

/* État focus */
input:focus {
  border-color: theme('colors.primary.500');
  box-shadow: 0 0 0 2px rgba(var(--color-primary-500), 0.3);
}

/* État d'erreur */
input.error {
  border-color: theme('colors.red.500');
}

input.error:focus {
  box-shadow: 0 0 0 2px rgba(239, 68, 68, 0.3);
}

/* Support pour les champs désactivés */
input:disabled {
  background-color: theme('colors.gray.100');
  border-color: theme('colors.gray.300');
  cursor: not-allowed;
}

input:disabled + label {
  color: theme('colors.gray.400');
}

/* Ajustement de la hauteur du conteneur pour éviter les sauts */
.input-container {
  min-height: 3.5rem;
}

input {
  height: 56px; /* Hauteur fixe pour l'input */
}

/* Styles spécifiques pour le select */
select {
  background-color: transparent;
}

select:required:invalid {
  color: gray;
}

option {
  color: #2d3748;
}

option[value=""][disabled] {
  display: none;
}

/* Ajustement pour l'astérisque required */
.transform-active span {
  transform: scale(1.15);
}
</style> 