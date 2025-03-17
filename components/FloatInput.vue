<template>
  <div class="relative rounded-md shadow-sm">
    <!-- Préfixe (devise) -->
    <div v-if="currency" class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
      <span class="text-gray-500 sm:text-sm">{{ currency }}</span>
    </div>
    
    <!-- Champ de saisie -->
    <input 
      :id="id"
      ref="input"
      type="text"
      :value="displayValue"
      :placeholder="placeholder"
      :disabled="disabled"
      :required="required"
      :class="[
        'block w-full rounded-md border-gray-300 shadow-sm focus:border-black focus:ring-black sm:text-sm',
        currency ? 'pl-7' : '',
        suffix ? 'pr-10' : ''
      ]"
      @input="handleInput"
      @blur="handleBlur"
      @focus="handleFocus"
    />
    
    <!-- Suffixe (unité) -->
    <div v-if="suffix" class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
      <span class="text-gray-500 sm:text-sm">{{ suffix }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'

const props = defineProps({
  id: {
    type: String,
    default: null
  },
  modelValue: {
    type: [Number, String],
    default: null
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
  },
  disabled: {
    type: Boolean,
    default: false
  },
  required: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['update:modelValue'])
const input = ref(null)
const rawValue = ref('')
const isFocused = ref(false)

// Formater la valeur pour l'affichage
const displayValue = computed(() => {
  if (isFocused.value) {
    return rawValue.value
  }
  
  if (props.modelValue === null || props.modelValue === undefined || props.modelValue === '') {
    return ''
  }
  
  // Formater le nombre avec la précision demandée
  return Number(props.modelValue).toLocaleString('fr-FR', {
    minimumFractionDigits: props.precision,
    maximumFractionDigits: props.precision
  })
})

// Convertir la valeur saisie en nombre
const parseValue = (value) => {
  if (value === null || value === undefined || value === '') {
    return null
  }
  
  // Remplacer la virgule par un point et supprimer les espaces et autres caractères non numériques
  const cleanValue = value.toString()
    .replace(/\s/g, '')
    .replace(/,/g, '.')
    .replace(/[^\d.-]/g, '')
  
  if (cleanValue === '' || cleanValue === '.' || cleanValue === '-') {
    return null
  }
  
  const numValue = parseFloat(cleanValue)
  
  // Appliquer les contraintes min/max
  if (props.min !== null && numValue < props.min) {
    return props.min
  }
  
  if (props.max !== null && numValue > props.max) {
    return props.max
  }
  
  return numValue
}

// Gérer la saisie
const handleInput = (event) => {
  const value = event.target.value
  rawValue.value = value
  
  const parsedValue = parseValue(value)
  emit('update:modelValue', parsedValue)
}

// Gérer la perte de focus
const handleBlur = () => {
  isFocused.value = false
  
  // Arrondir à la précision demandée
  if (props.modelValue !== null && props.modelValue !== undefined) {
    const rounded = Math.round(props.modelValue * Math.pow(10, props.precision)) / Math.pow(10, props.precision)
    emit('update:modelValue', rounded)
  }
}

// Gérer le focus
const handleFocus = (event) => {
  isFocused.value = true
  
  // Convertir la valeur formatée en valeur brute pour l'édition
  if (props.modelValue !== null && props.modelValue !== undefined) {
    rawValue.value = props.modelValue.toString().replace('.', ',')
  } else {
    rawValue.value = ''
  }
  
  // Sélectionner tout le texte
  event.target.select()
}

// Observer les changements de modelValue
watch(() => props.modelValue, (newValue) => {
  if (!isFocused.value && newValue !== null && newValue !== undefined) {
    // Mettre à jour la valeur brute si le modèle change et que le champ n'est pas en focus
    rawValue.value = newValue.toString().replace('.', ',')
  }
})

// Initialisation
onMounted(() => {
  if (props.modelValue !== null && props.modelValue !== undefined) {
    rawValue.value = props.modelValue.toString().replace('.', ',')
  }
})
</script> 