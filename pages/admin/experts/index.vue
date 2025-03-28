<template>
    <div class="space-y-6 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Header -->
      <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold text-gray-900 dark:text-white tracking-tight">Experts</h1>
          <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez les experts de la plateforme</p>
        </div>
        
        <div class="flex items-center gap-3">
          <UButton 
            icon="i-heroicons-arrow-down-tray" 
            color="gray" 
            variant="ghost" 
            @click="exportData"
          >
            Exporter
          </UButton>
          <UButton 
            icon="i-heroicons-plus" 
            @click="openModal()"
          >
            Ajouter
          </UButton>
        </div>
      </div>
  
      <!-- Table -->
      <UCard>
        <UTable
          :rows="experts"
          :columns="columns"
          :loading="isLoading"
          :search-value="search"
          @update:search-value="search = $event"
        >
          <!-- Expert cell -->
          <template #expert-data="{ row }">
            <div class="flex items-center gap-3">
              <UAvatar
                :src="row.avatar_url"
                :alt="row.first_name + ' ' + row.last_name"
                :text="getInitials(row.first_name + ' ' + row.last_name)"
                size="lg"
              />
              <div>
                <p class="text-sm font-medium text-gray-900 dark:text-white">
                  {{ row.first_name }} {{ row.last_name }}
                </p>
                <p class="text-xs text-gray-500 dark:text-gray-400">
                  {{ row.email }}
                </p>
              </div>
            </div>
          </template>
  
          <!-- Profession cell -->
          <template #profession-data="{ row }">
            <UBadge
              color="gray"
              variant="subtle"
              size="sm"
            >
              {{ row.profession?.name || 'Non définie' }}
            </UBadge>
          </template>
  
          <!-- Status cell -->
          <template #status-data="{ row }">
            <UBadge
              :color="getStatusColor(row.status)"
              variant="subtle"
              size="sm"
            >
              <div class="flex items-center gap-1">
                <div 
                  class="w-1.5 h-1.5 rounded-full"
                  :class="getStatusDotColor(row.status)"
                />
                {{ formatStatus(row.status) }}
              </div>
            </UBadge>
          </template>
  
          <!-- Rating cell -->
          <template #rating-data="{ row }">
            <div class="flex items-center gap-1">
              <UIcon name="i-heroicons-star" class="w-4 h-4 text-amber-400" />
              <span class="text-sm">{{ row.rating || '0' }}</span>
            </div>
          </template>
  
          <!-- Date cell -->
          <template #created_at-data="{ row }">
            {{ formatDate(row.created_at) }}
          </template>
  
          <!-- Actions cell -->
          <template #actions-data="{ row }">
            <UDropdown
              :items="[
                [
                  {
                    label: 'Modifier',
                    icon: 'i-heroicons-pencil-square',
                    click: () => openModal(row)
                  },
                  {
                    label: 'Voir le profil',
                    icon: 'i-heroicons-eye',
                    click: () => viewExpert(row)
                  }
                ],
                [
                  {
                    label: getNextStatusLabel(row.status),
                    icon: getNextStatusIcon(row.status),
                    click: () => updateStatus(row)
                  }
                ]
              ]"
            >
              <UButton
                color="gray"
                variant="ghost"
                icon="i-heroicons-ellipsis-horizontal"
              />
            </UDropdown>
          </template>
        </UTable>
      </UCard>
  
      <!-- Modal -->
      <UModal v-model="showModal">
        <UCard>
          <template #header>
            <div class="flex items-center justify-between">
              <h3 class="text-xl font-semibold">
                {{ editMode ? 'Modifier l\'expert' : 'Ajouter un expert' }}
              </h3>
              <UButton
                color="gray"
                variant="ghost"
                icon="i-heroicons-x-mark"
                class="-my-1"
                @click="showModal = false"
              />
            </div>
          </template>
  
          <form @submit.prevent="saveExpert" class="space-y-6">
            <!-- Personal Information -->
            <div class="grid grid-cols-2 gap-4">
              <UFormGroup label="Prénom" required>
                <UInput
                  v-model="form.first_name"
                  placeholder="ex: John"
                  required
                />
              </UFormGroup>
  
              <UFormGroup label="Nom" required>
                <UInput
                  v-model="form.last_name"
                  placeholder="ex: Doe"
                  required
                />
              </UFormGroup>
            </div>
  
            <UFormGroup label="Email" required>
              <UInput
                v-model="form.email"
                type="email"
                placeholder="ex: john.doe@example.com"
                required
              />
            </UFormGroup>
  
            <UFormGroup label="Téléphone">
              <UInput
                v-model="form.phone"
                type="tel"
                placeholder="ex: +33 6 12 34 56 78"
              />
            </UFormGroup>
  
            <UFormGroup label="Profession">
              <USelect
                v-model="form.profession_id"
                :options="professions"
                option-label="name"
                option-value="id"
                placeholder="Sélectionnez une profession"
              />
            </UFormGroup>
  
            <UFormGroup label="Bio">
              <UTextarea
                v-model="form.bio"
                placeholder="Description de l'expert..."
                rows="4"
              />
            </UFormGroup>
  
            <UFormGroup label="Statut">
              <USelect
                v-model="form.status"
                :options="[
                  { label: 'En attente', value: 'PENDING' },
                  { label: 'Actif', value: 'ACTIVE' },
                  { label: 'Inactif', value: 'INACTIVE' }
                ]"
              />
            </UFormGroup>
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
                :loading="isSaving"
                @click="saveExpert"
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
  import { ref, computed, onMounted } from 'vue'
  import { useRouter } from 'vue-router'
  import { useSupabaseClient } from '#imports'
  import { format } from 'date-fns'
  import { fr } from 'date-fns/locale'
  
  const router = useRouter()
  const supabase = useSupabaseClient()
  const search = ref('')
  const isLoading = ref(true)
  const isSaving = ref(false)
  const showModal = ref(false)
  const experts = ref([])
  const professions = ref([])
  const editMode = ref(false)
  
  const form = ref({
    first_name: '',
    last_name: '',
    email: '',
    phone: '',
    profession_id: null,
    bio: '',
    status: 'PENDING'
  })
  
  // Table columns configuration
  const columns = [
    {
      key: 'expert',
      label: 'Expert',
      sortable: true
    },
    {
      key: 'profession',
      label: 'Profession',
      sortable: true
    },
    {
      key: 'status',
      label: 'Statut',
      sortable: true
    },
    {
      key: 'rating',
      label: 'Note',
      sortable: true
    },
    {
      key: 'created_at',
      label: 'Date d\'inscription',
      sortable: true
    },
    {
      key: 'actions',
      label: '',
      sortable: false
    }
  ]
  
  // Helper functions
  const formatDate = (dateString) => {
    if (!dateString) return '-'
    return format(new Date(dateString), 'dd MMM yyyy', { locale: fr })
  }
  
  const getInitials = (name) => {
    return name
      .split(' ')
      .map(word => word.charAt(0))
      .join('')
      .toUpperCase()
  }
  
  const getStatusColor = (status) => {
    const colors = {
      PENDING: 'yellow',
      ACTIVE: 'green',
      INACTIVE: 'red'
    }
    return colors[status] || 'gray'
  }
  
  const getStatusDotColor = (status) => {
    const colors = {
      PENDING: 'bg-yellow-500',
      ACTIVE: 'bg-green-500',
      INACTIVE: 'bg-red-500'
    }
    return colors[status] || 'bg-gray-500'
  }
  
  const formatStatus = (status) => {
    const statuses = {
      PENDING: 'En attente',
      ACTIVE: 'Actif',
      INACTIVE: 'Inactif'
    }
    return statuses[status] || 'Inconnu'
  }
  
  const getNextStatusLabel = (status) => {
    const labels = {
      PENDING: 'Activer',
      ACTIVE: 'Désactiver',
      INACTIVE: 'Réactiver'
    }
    return labels[status] || 'Changer le statut'
  }
  
  const getNextStatusIcon = (status) => {
    const icons = {
      PENDING: 'i-heroicons-check',
      ACTIVE: 'i-heroicons-lock-closed',
      INACTIVE: 'i-heroicons-lock-open'
    }
    return icons[status] || 'i-heroicons-arrow-path'
  }
  
  // Actions
  const openModal = (expert = null) => {
    if (expert) {
      form.value = { ...expert }
      editMode.value = true
    } else {
      form.value = {
        first_name: '',
        last_name: '',
        email: '',
        phone: '',
        profession_id: null,
        bio: '',
        status: 'PENDING'
      }
      editMode.value = false
    }
    showModal.value = true
  }
  
  const viewExpert = (expert) => {
    router.push(`/admin/experts/${expert.id}`)
  }
  
  const updateStatus = async (expert) => {
    const nextStatus = {
      PENDING: 'ACTIVE',
      ACTIVE: 'INACTIVE',
      INACTIVE: 'ACTIVE'
    }
  
    try {
      const { error } = await supabase
        .from('experts')
        .update({ status: nextStatus[expert.status] })
        .eq('id', expert.id)
  
      if (error) throw error
      
      loadData()
    } catch (error) {
      console.error('Error updating status:', error)
    }
  }
  
  const saveExpert = async () => {
    isSaving.value = true
    try {
      const { error } = editMode.value
        ? await supabase
            .from('experts')
            .update(form.value)
            .eq('id', form.value.id)
        : await supabase
            .from('experts')
            .insert([form.value])
  
      if (error) throw error
      
      showModal.value = false
      loadData()
    } catch (error) {
      console.error('Error saving expert:', error)
    } finally {
      isSaving.value = false
    }
  }
  
  const exportData = () => {
    // Implement your export logic here
  }
  
  // Load data
  const loadData = async () => {
    isLoading.value = true
    try {
      const [expertsData, professionsData] = await Promise.all([
        supabase
          .from('experts')
          .select(`
            *,
            profession:professions(*)
          `)
          .order('created_at', { ascending: false }),
        supabase
          .from('professions')
          .select('*')
          .order('name')
      ])
  
      if (expertsData.error) throw expertsData.error
      if (professionsData.error) throw professionsData.error
  
      experts.value = expertsData.data || []
      professions.value = professionsData.data || []
    } catch (error) {
      console.error('Error loading data:', error)
    } finally {
      isLoading.value = false
    }
  }
  
  // Initial load
  onMounted(() => {
    loadData()
  })
  
  definePageMeta({
    layout: 'admin'
  })
  </script>