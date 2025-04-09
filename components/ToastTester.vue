<template>
  <div class="fixed top-4 right-4 flex flex-col gap-2">
    <UButton
      color="green"
      @click="showToast.success('Succès!', 'Opération réussie avec succès')"
    >
      Test Success
    </UButton>

    <UButton
      color="red"
      @click="showToast.error('Erreur!', 'Une erreur est survenue')"
    >
      Test Error
    </UButton>

    <UButton
      color="blue"
      @click="showToast.info('Info', 'Voici une information importante')"
    >
      Test Info
    </UButton>

    <UButton
      color="yellow"
      @click="showToast.warning('Attention!', 'Attention à cette action')"
    >
      Test Warning
    </UButton>
  </div>
</template>

<script setup>
import { useCustomToast } from '~/composables/useCustomToast'

const { showToast } = useCustomToast()
</script> 