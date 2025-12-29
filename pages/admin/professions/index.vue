<template>
  <div class="space-y-6 p-4 sm:p-6 lg:p-8">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Professions</h1>
        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
          Gérez les catégories et sous-catégories de professions
        </p>
      </div>
      
        <UButton 
          icon="i-heroicons-plus" 
        @click="openAddModal"
        >
        Ajouter une catégorie
        </UButton>
    </div>

    <!-- Arbre des professions -->
    <ProfessionTree @select="editProfession" />

    <!-- Modal d'ajout/modification -->
    <UModal v-model="showModal">
    <UCard>
        <template #header>
          <div class="flex items-center gap-2">
            <UIcon 
              :name="editMode ? 'i-heroicons-pencil-square' : 'i-heroicons-plus'" 
              class="h-5 w-5" 
            />
            <h3 class="text-lg font-semibold">
              {{ editMode ? 'Modifier la catégorie' : 'Ajouter une catégorie' }}
            </h3>
          </div>
        </template>

        <form @submit.prevent="saveProfession" class="space-y-6">
          <!-- Nom -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">
                        Nom
                      </label>
                      <input
                        v-model="form.name"
                        type="text"
                        required
              class="block w-full rounded-lg border border-gray-300 dark:border-gray-600 px-4 py-2.5"
              placeholder="Ex: Électricité"
                      />
                    </div>

                    <!-- Description -->
                    <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">
                        Description
                      </label>
                      <textarea
                        v-model="form.description"
              rows="3"
              class="block w-full rounded-lg border border-gray-300 dark:border-gray-600 px-4 py-2.5"
              placeholder="Description de la catégorie..."
            />
                    </div>

          <!-- Catégorie parente -->
                    <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">
              Catégorie parente
                      </label>
            <select
              v-model="form.parent_id"
              class="block w-full rounded-lg border border-gray-300 dark:border-gray-600 px-4 py-2.5"
            >
              <option :value="null">Aucune (catégorie principale)</option>
              <option
                v-for="profession in availableParents"
                :key="profession.id"
                :value="profession.id"
              >
                {{ profession.name }}
              </option>
            </select>
          </div>

          <!-- Icône -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">
              Icône
            </label>
            <input
              v-model="form.icon"
              type="text"
              class="block w-full rounded-lg border border-gray-300 dark:border-gray-600 px-4 py-2.5"
              placeholder="Ex: i-heroicons-wrench"
            />
          </div>

          <!-- Ordre d'affichage -->
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">
              Ordre d'affichage
            </label>
            <input
              v-model.number="form.sort_order"
              type="number"
              min="0"
              class="block w-full rounded-lg border border-gray-300 dark:border-gray-600 px-4 py-2.5"
            />
          </div>

          <!-- Statut -->
          <div class="flex items-center gap-3">
            <USwitch v-model="form.is_active" />
            <span class="text-sm text-gray-700 dark:text-gray-200">
              Catégorie active
                        </span>
                      </div>
        </form>

        <template #footer>
          <div class="flex justify-end gap-3">
            <UButton
              color="gray"
              variant="ghost"
                      @click="showModal = false"
                    >
                      Annuler
            </UButton>
            <UButton
              color="primary"
              :loading="isSaving"
              @click="saveProfession"
            >
              {{ editMode ? 'Enregistrer' : 'Ajouter' }}
            </UButton>
          </div>
        </template>
      </UCard>
    </UModal>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useSupabaseClient } from '#imports'

const supabase = useSupabaseClient()

// États
const showModal = ref(false)
const editMode = ref(false)
const isSaving = ref(false)
const selectedProfession = ref(null)

// Formulaire
const form = ref({
  name: '',
  description: '',
  parent_id: null,
  icon: '',
  sort_order: 0,
  is_active: true
})

// Computed
const availableParents = computed(() => {
  // Filtrer les catégories qui peuvent être parentes
  // (exclure la catégorie en cours d'édition et ses sous-catégories)
  return professions.value.filter(p => {
    if (!editMode.value) return !p.parent_id
    if (p.id === selectedProfession.value?.id) return false
    // TODO: Ajouter la logique pour exclure les sous-catégories
    return !p.parent_id
  })
})

// Méthodes
const openAddModal = () => {
  editMode.value = false
  selectedProfession.value = null
    form.value = {
      name: '',
      description: '',
    parent_id: null,
      icon: '',
    sort_order: 0,
      is_active: true
  }
  showModal.value = true
}

const editProfession = (profession) => {
  editMode.value = true
  selectedProfession.value = profession
  form.value = {
    name: profession.name,
    description: profession.description,
    parent_id: profession.parent_id,
    icon: profession.icon,
    sort_order: profession.sort_order,
    is_active: profession.is_active
  }
  showModal.value = true
}

const saveProfession = async () => {
  isSaving.value = true
  try {
    if (editMode.value) {
      const { error } = await supabase
          .from('professions')
        .update({
          name: form.value.name,
          description: form.value.description,
          parent_id: form.value.parent_id,
          icon: form.value.icon,
          sort_order: form.value.sort_order,
          is_active: form.value.is_active,
          updated_at: new Date().toISOString()
        })
        .eq('id', selectedProfession.value.id)

      if (error) throw error
    } else {
      const { error } = await supabase
          .from('professions')
        .insert({
          name: form.value.name,
          description: form.value.description,
          parent_id: form.value.parent_id,
          icon: form.value.icon,
          sort_order: form.value.sort_order,
          is_active: form.value.is_active
        })

    if (error) throw error
    }
    
    showModal.value = false
    const toast = useToast()
    toast.add({
      title: 'Succès',
      description: editMode.value ? 'Catégorie mise à jour' : 'Catégorie ajoutée',
      color: 'green'
    })
  } catch (error) {
    console.error('Error saving profession:', error)
    const toast = useToast()
    toast.add({
      title: 'Erreur',
      description: 'Impossible de sauvegarder la catégorie',
      color: 'red'
    })
  } finally {
    isSaving.value = false
  }
}

definePageMeta({
  layout: 'admin'
})
</script>