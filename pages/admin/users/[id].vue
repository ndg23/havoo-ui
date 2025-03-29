<template>
  <div class="space-y-6 p-4 sm:p-6 lg:p-8">
    <!-- Loading state -->
    <template v-if="isLoading">
      <div class="flex items-center justify-center py-12">
        <UIcon name="i-heroicons-arrow-path" class="h-8 w-8 animate-spin" />
      </div>
    </template>

    <template v-else-if="user">
      <!-- Header avec actions -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div class="flex items-center gap-3">
          <UButton
            icon="i-heroicons-arrow-left"
            color="gray"
            variant="ghost"
            class="h-10 w-10 rounded-full"
            @click="$router.back()"
          />
          <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
              {{ user.first_name }} {{ user.last_name }}
            </h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 flex items-center gap-2">
              <UIcon name="i-heroicons-envelope" class="h-4 w-4" />
              {{ user.email }}
            </p>
          </div>
        </div>

        <div class="flex items-center gap-3">
          <UDropdown
            :items="actionItems"
            :popper="{ placement: 'bottom-end' }"
          >
            <UButton
              color="gray"
              variant="ghost"
              icon="i-heroicons-ellipsis-horizontal"
              class="h-10 w-10 rounded-full"
            />
          </UDropdown>
          <UButton
            icon="i-heroicons-pencil-square"
            label="Modifier"
            class="rounded-full"
            @click="editMode = true"
          />
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Colonne principale -->
        <div class="lg:col-span-2 space-y-6">
          <!-- Carte de profil -->
          <UCard>
            <div class="relative">
              <!-- Bannière -->
              <div class="h-32 bg-gradient-to-r from-primary-100 to-blue-50 dark:from-primary-900/20 dark:to-blue-900/20 rounded-t-lg" />
              
              <!-- Avatar -->
              <div class="absolute -bottom-12 left-6">
                <UAvatar
                  :src="user.avatar_url"
                  :alt="`${user.first_name} ${user.last_name}`"
                  :text="getInitials(`${user.first_name} ${user.last_name}`)"
                  size="2xl"
                  class="ring-4 ring-white dark:ring-gray-900"
                />
              </div>
            </div>

            <div class="pt-16 pb-4">
              <!-- Badges de statut -->
              <div class="flex flex-wrap gap-2 mb-4">
                <UBadge
                  :color="getRoleColor(user.role)"
                  :label="formatRole(user.role)"
                  variant="subtle"
                  class="rounded-full"
                >
                  <template #prefix>
                    <UIcon :name="getRoleIcon(user.role)" class="h-3.5 w-3.5" />
                  </template>
                </UBadge>

                <UBadge
                  :color="user.is_active ? 'green' : 'red'"
                  :label="user.is_active ? 'Actif' : 'Inactif'"
                  variant="subtle"
                  class="rounded-full"
                >
                  <template #prefix>
                    <div class="h-1.5 w-1.5 rounded-full" 
                         :class="user.is_active ? 'bg-green-500' : 'bg-red-500'" />
                  </template>
                </UBadge>

                <UBadge
                  v-if="user.role === 'expert'"
                  :color="user.is_verified ? 'blue' : 'gray'"
                  :label="user.is_verified ? 'Vérifié' : 'Non vérifié'"
                  variant="subtle"
                  class="rounded-full"
                >
                  <template #prefix>
                    <UIcon :name="user.is_verified ? 'i-heroicons-shield-check' : 'i-heroicons-shield'" 
                          class="h-3.5 w-3.5" />
                  </template>
                </UBadge>
              </div>

              <!-- Informations de contact -->
              <div class="space-y-4">
                <div v-if="user.phone" class="flex items-center gap-2 text-gray-500 dark:text-gray-400">
                  <UIcon name="i-heroicons-phone" class="h-4 w-4" />
                  {{ user.phone }}
                </div>
                <div v-if="user.location" class="flex items-center gap-2 text-gray-500 dark:text-gray-400">
                  <UIcon name="i-heroicons-map-pin" class="h-4 w-4" />
                  {{ user.location }}
                </div>
                <div v-if="user.website" class="flex items-center gap-2 text-gray-500 dark:text-gray-400">
                  <UIcon name="i-heroicons-globe-alt" class="h-4 w-4" />
                  <a :href="user.website" target="_blank" class="hover:text-primary-500">
                    {{ user.website }}
                  </a>
                </div>
              </div>
            </div>
          </UCard>

          <!-- Bio -->
          <UCard v-if="user.bio">
            <template #header>
              <h2 class="text-lg font-semibold">Bio</h2>
            </template>
            <p class="text-gray-700 dark:text-gray-300 whitespace-pre-line">{{ user.bio }}</p>
          </UCard>
        </div>

        <!-- Sidebar -->
        <div class="space-y-6">
          <!-- Actions rapides - Version minimaliste -->
          <div class="space-y-6">
            <!-- Titre simple -->
            <div class="flex items-center justify-between">
              <h3 class="text-base font-medium text-gray-500 dark:text-gray-400">
                Actions rapides
              </h3>
              <UBadge
                v-if="user?.is_admin"
                color="blue"
                variant="subtle"
                class="rounded-full px-3 py-0.5"
              >
                <template #default>
                  <span class="flex items-center gap-1.5 text-xs">
                    <UIcon name="i-heroicons-shield-check" class="h-3.5 w-3.5" />
                    Admin
                  </span>
                </template>
              </UBadge>
            </div>

            <!-- Boutons avec largeur fixe -->
            <div class="space-y-2 w-full">
              <!-- Droits Admin -->
              <UTooltip text="Cette action est irréversible">
                <button 
                  @click="showAdminModal = true"
                  :disabled="isLoading"
                  class="w-full p-2.5 bg-white hover:bg-gray-50 text-gray-700 dark:text-gray-200 dark:hover:bg-gray-800 border border-gray-200 dark:border-gray-700 font-medium rounded-full transition-colors flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <UIcon 
                    :name="user?.is_admin ? 'i-heroicons-shield-check' : 'i-heroicons-shield'"
                    class="h-4 w-4 flex-shrink-0"
                    :class="user?.is_admin ? 'text-red-500' : 'text-blue-500'"
                  />
                  <span class="truncate">{{ user?.is_admin ? 'Révoquer les droits admin' : 'Promouvoir comme admin' }}</span>
                </button>
              </UTooltip>

              <!-- Bannissement -->
              <UTooltip text="Cette action est irréversible">
                <button 
                  @click="showBanModal = true"
                  :disabled="isLoading"
                  class="w-full p-2.5 bg-white hover:bg-gray-50 text-gray-700 dark:text-gray-200 dark:hover:bg-gray-800 border border-gray-200 dark:border-gray-700 font-medium rounded-full transition-colors flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <UIcon 
                    :name="user?.banned_until ? 'i-heroicons-lock-open' : 'i-heroicons-lock-closed'"
                    class="h-4 w-4 flex-shrink-0"
                    :class="user?.banned_until ? 'text-green-500' : 'text-red-500'"
                  />
                  <span class="truncate">{{ user?.banned_until ? 'Débannir l\'utilisateur' : 'Bannir l\'utilisateur' }}</span>
                </button>
              </UTooltip>

              <!-- Vérification Expert -->
              <button 
                v-if="user?.role === 'expert' && !user?.is_verified"
                @click="verifyExpert"
                :disabled="isLoading"
                class="w-full p-2.5 bg-white hover:bg-gray-50 text-gray-700 dark:text-gray-200 dark:hover:bg-gray-800 border border-gray-200 dark:border-gray-700 font-medium rounded-full transition-colors flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <UIcon 
                  name="i-heroicons-check-badge"
                  class="h-4 w-4 flex-shrink-0 text-primary-500"
                />
                <span class="truncate">Vérifier l'expert</span>
              </button>

              <!-- Activation/Désactivation -->
              <UTooltip text="Cette action est irréversible">
                <button 
                  @click="toggleUserStatus"
                  :disabled="isLoading"
                  class="w-full p-2.5 bg-white hover:bg-gray-50 text-gray-700 dark:text-gray-200 dark:hover:bg-gray-800 border border-gray-200 dark:border-gray-700 font-medium rounded-full transition-colors flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <UIcon 
                    :name="user?.is_active ? 'i-heroicons-x-circle' : 'i-heroicons-check-circle'"
                    class="h-4 w-4 flex-shrink-0"
                    :class="user?.is_active ? 'text-red-500' : 'text-green-500'"
                  />
                  <span class="truncate">{{ user?.is_active ? 'Désactiver le compte' : 'Activer le compte' }}</span>
                </button>
              </UTooltip>

              <!-- Email -->
              <button 
                @click="sendEmail"
                :disabled="isLoading"
                class="w-full p-2.5 bg-white hover:bg-gray-50 text-gray-700 dark:text-gray-200 dark:hover:bg-gray-800 border border-gray-200 dark:border-gray-700 font-medium rounded-full transition-colors flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <UIcon 
                  name="i-heroicons-envelope"
                  class="h-4 w-4 flex-shrink-0 text-gray-500"
                />
                <span class="truncate">Envoyer un email</span>
              </button>
            </div>

            <!-- Mini stats -->
            <div class="grid grid-cols-2 gap-4">
              <div class="text-center">
                <div class="text-sm font-medium text-gray-500 dark:text-gray-400">Missions</div>
                <div class="mt-1 text-xl font-semibold text-gray-900 dark:text-white">{{ userStats.missions || 0 }}</div>
              </div>
              <div class="text-center">
                <div class="text-sm font-medium text-gray-500 dark:text-gray-400">Avis</div>
                <div class="mt-1 text-xl font-semibold text-gray-900 dark:text-white">{{ userStats.reviews || 0 }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>

    <!-- Modal de bannissement -->
    <UModal v-model="showBanModal">
      <UCard>
        <template #header>
          <h3 class="text-lg font-semibold">
            {{ user.banned_until ? 'Débannir l\'utilisateur' : 'Bannir l\'utilisateur' }}
          </h3>
        </template>

        <div class="space-y-4">
          <template v-if="!user.banned_until">
            <p class="text-sm text-gray-500">
              Choisissez la durée du bannissement pour {{ user.first_name }} {{ user.last_name }}
            </p>

            <USelect
              v-model="banDuration"
              :options="banDurations"
              option-attribute="label"
              value-attribute="value"
              placeholder="Sélectionner une durée"
            />

            <UTextarea
              v-model="banReason"
              label="Raison du bannissement"
              placeholder="Expliquez la raison du bannissement..."
            />
          </template>
          <template v-else>
            <p class="text-sm text-gray-500">
              Cet utilisateur est banni jusqu'au {{ formatDate(user.banned_until) }}
            </p>
            <p class="text-sm font-medium">Voulez-vous lever le bannissement ?</p>
          </template>
        </div>

        <template #footer>
          <div class="flex justify-end gap-3">
            <UButton
              color="gray"
              variant="ghost"
              label="Annuler"
              @click="showBanModal = false"
            />
            <UButton
              :color="user.banned_until ? 'green' : 'red'"
              :label="user.banned_until ? 'Débannir' : 'Bannir'"
              :loading="isBanning"
              @click="handleBanUser"
            />
          </div>
        </template>
      </UCard>
    </UModal>

    <!-- Modal de confirmation admin -->
    <UModal v-model="showAdminModal">
      <UCard>
        <template #header>
          <h3 class="text-lg font-semibold">
            {{ user?.is_admin ? 'Révoquer les droits admin' : 'Promouvoir comme admin' }}
          </h3>
        </template>

        <div class="space-y-4">
          <p class="text-sm text-gray-500">
            {{ user?.is_admin 
              ? `Êtes-vous sûr de vouloir révoquer les droits administrateur de ${user.first_name} ${user.last_name} ?`
              : `Êtes-vous sûr de vouloir donner les droits administrateur à ${user.first_name} ${user.last_name} ?`
            }}
          </p>

          <UAlert
            v-if="!user?.is_admin"
            type="warning"
            title="Attention"
            description="Cette action donnera à l'utilisateur un accès complet à toutes les fonctionnalités d'administration."
            class="mt-4"
          />
        </div>

        <template #footer>
          <div class="flex justify-end gap-3">
            <UButton
              color="gray"
              variant="ghost"
              label="Annuler"
              @click="showAdminModal = false"
            />
            <UButton
              :color="user?.is_admin ? 'red' : 'blue'"
              :label="user?.is_admin ? 'Révoquer' : 'Promouvoir'"
              :loading="isUpdatingAdmin"
              @click="handleAdminStatus"
            />
          </div>
        </template>
      </UCard>
    </UModal>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { useSupabaseClient } from '#imports'
import { useRoute, useRouter } from 'vue-router'
import { addDays } from 'date-fns'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'

const route = useRoute()
const router = useRouter()
const supabase = useSupabaseClient()

// État
const user = ref(null)
const isLoading = ref(true)
const editMode = ref(false)
const userStats = reactive({
  missions: 0,
  reviews: 0
})

const showBanModal = ref(false)
const isBanning = ref(false)
const banDuration = ref(null)
const banReason = ref('')

const showAdminModal = ref(false)
const isUpdatingAdmin = ref(false)

const banDurations = [
  { label: '24 heures', value: 1 },
  { label: '7 jours', value: 7 },
  { label: '30 jours', value: 30 },
  { label: 'Permanent', value: 36500 } // ~100 ans
]

// Chargement des données
const loadUser = async () => {
  isLoading.value = true
  try {
    // Charger les données du profil
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', route.params.id)
      .single()

    if (profileError) throw profileError

    // Charger les données auth via l'API admin
    const { data: authData } = await useFetch(`/api/admin/users/${route.params.id}`)

    user.value = {
      ...profile,
      banned_until: authData.value?.banned_until,
      user_metadata: authData.value?.user_metadata
    }

    await loadUserStats()
  } catch (error) {
    console.error('Error loading user:', error)
  } finally {
    isLoading.value = false
  }
}

// Chargement des statistiques
const loadUserStats = async () => {
  try {
    // Charger le nombre de missions
    const { count: missionsCount } = await supabase
      .from('missions')
      .select('*', { count: 'exact' })
      .eq('client_id', route.params.id)

    // Charger le nombre d'avis
    const { count: reviewsCount } = await supabase
      .from('reviews')
      .select('*', { count: 'exact' })
      .eq('user_id', route.params.id)

    userStats.missions = missionsCount
    userStats.reviews = reviewsCount
  } catch (error) {
    console.error('Error loading user stats:', error)
  }
}

// Helpers
const getInitials = (name) => {
  if (!name) return ''
  return name
    .split(' ')
    .map(word => word[0])
    .join('')
    .toUpperCase()
}

const getRoleColor = (role) => {
  const colors = {
    admin: 'blue',
    expert: 'primary',
    client: 'gray'
  }
  return colors[role] || 'gray'
}

const getRoleIcon = (role) => {
  const icons = {
    admin: 'i-heroicons-shield-check',
    expert: 'i-heroicons-academic-cap',
    client: 'i-heroicons-user'
  }
  return icons[role] || 'i-heroicons-user'
}

const formatRole = (role) => {
  const labels = {
    admin: 'Administrateur',
    expert: 'Expert',
    client: 'Client'
  }
  return labels[role] || role
}

const formatDate = (date) => {
  if (!date) return ''
  return format(new Date(date), 'dd/MM/yyyy HH:mm', { locale: fr })
}

// Actions
const actionItems = computed(() => [
  [
    {
      label: 'Modifier',
      icon: 'i-heroicons-pencil-square',
      click: () => editMode.value = true
    }
  ],
  [
    {
      label: user.value?.is_active ? 'Désactiver' : 'Activer',
      icon: user.value?.is_active ? 'i-heroicons-lock-closed' : 'i-heroicons-lock-open',
      click: toggleUserStatus
    }
  ]
])

const verifyExpert = async () => {
  try {
    const { error } = await supabase
      .from('profiles')
      .update({ is_verified: true })
      .eq('id', route.params.id)

    if (error) throw error
    
    user.value.is_verified = true
  } catch (error) {
    console.error('Error verifying expert:', error)
  }
}

const toggleUserStatus = async () => {
  try {
    const { error } = await supabase
      .from('profiles')
      .update({ is_active: !user.value.is_active })
      .eq('id', route.params.id)

    if (error) throw error
    
    user.value.is_active = !user.value.is_active
  } catch (error) {
    console.error('Error toggling user status:', error)
  }
}

const sendEmail = () => {
  // Implémenter l'envoi d'email
  console.log('Send email to:', user.value.email)
}

const handleBanUser = async () => {
  if (!user.value) return
  
  isBanning.value = true
  try {
    // Appeler l'API admin
    const { data, error } = await useFetch('/api/admin/users/ban', {
      method: 'POST',
      body: {
        userId: user.value.id,
        banDuration: user.value.banned_until ? 0 : banDuration.value,
        reason: banReason.value
      }
    })

    if (error.value) throw error.value
    
    await loadUser()
    showBanModal.value = false
  } catch (error) {
    console.error('Error updating ban status:', error)
  } finally {
    isBanning.value = false
    banDuration.value = null
    banReason.value = ''
  }
}

const handleAdminStatus = async () => {
  if (!user.value) return
  
  isUpdatingAdmin.value = true
  try {
    const { data, error } = await useFetch('/api/admin/users/promote', {
      method: 'POST',
      body: {
        userId: user.value.id,
        isAdmin: !user.value.is_admin
      }
    })

    if (error.value) throw error.value
    
    // Mettre à jour l'interface
    user.value.is_admin = !user.value.is_admin
    user.value.role = user.value.is_admin ? 'admin' : 'client'
    
    showAdminModal.value = false
    
    // Afficher une notification
    const toast = useToast()
    toast.add({
      title: user.value.is_admin ? 'Droits admin accordés' : 'Droits admin révoqués',
      description: `Le statut de ${user.value.first_name} ${user.value.last_name} a été mis à jour avec succès.`,
      icon: user.value.is_admin ? 'i-heroicons-shield-check' : 'i-heroicons-shield',
      color: user.value.is_admin ? 'blue' : 'gray'
    })
  } catch (error) {
    console.error('Error updating admin status:', error)
    // Afficher une notification d'erreur
    const toast = useToast()
    toast.add({
      title: 'Erreur',
      description: 'Impossible de mettre à jour le statut admin',
      color: 'red'
    })
  } finally {
    isUpdatingAdmin.value = false
  }
}

// Initialisation
onMounted(() => {
  loadUser()
})

definePageMeta({
  layout: 'admin'
})
</script>