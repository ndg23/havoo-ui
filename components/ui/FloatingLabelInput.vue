<template>
  <div class="input-container relative w-full">
    <!-- Préfixe (devise) -->
    <div v-if="currency && type === 'number'" class="absolute left-4 top-6 text-sm text-gray-500 pointer-events-none z-10">
      {{ currency }}
    </div>
    
    <!-- Champ de saisie -->
    <input 
      :id="id"
      ref="input"
      :type="type === 'number' ? 'text' : type"
      :value="type === 'number' ? displayValue : modelValue"
      @input="handleInput"
      @blur="handleBlur"
      @focus="handleFocus"
      placeholder=" " 
      class="input-field w-full border border-1 border-[#363636] rounded-lg px-4 pt-6 pb-2 transition-all focus:outline-none focus:border-primary-500 focus:ring-2 focus:ring-primary-500 focus:ring-opacity-30"
      :class="{
        'border-red-500': error,
        'pl-12': currency && type === 'number',
        'pr-10': suffix && type === 'number'
      }"
      :aria-required="required"
      v-bind="$attrs"
    />
    
    <!-- Suffixe (unité) -->
    <div v-if="suffix && type === 'number'" class="absolute right-4 top-6 text-sm text-gray-500 pointer-events-none z-10">
      {{ suffix }}
    </div>
    
    <label 
      :for="id" 
      class="input-label absolute left-4 top-2 text-sm text-zinc-500 pointer-events-none transition-all"
    >
      {{ label }}
    </label>
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
    default: 'text'
  },
  required: {
    type: Boolean,
    default: false
  },
  error: {
    type: Boolean,
    default: false
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