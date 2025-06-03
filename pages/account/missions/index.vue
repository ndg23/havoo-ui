<template>
  <div class="min-h-screen bg-white dark:bg-gray-950 text-gray-900 dark:text-gray-100 font-sans">
    <!-- Header with dynamic background -->
    <div class="sticky top-0 z-10 bg-white/90 dark:bg-gray-950/90 backdrop-blur-xl border-b border-gray-100 dark:border-gray-800">
      <div class="max-w-3xl mx-auto px-6 pt-12 pb-4">
        <h1 class="text-3xl font-bold tracking-tight">Missions</h1>

        <div class="flex flex-cols justify-between gap-6">
          <!-- Page title -->
          
          <!-- Primary filter - Segmented control -->
          <div class="flex rounded-full bg-gray-100 dark:bg-gray-800 p-1 self-start">
            <button 
              v-for="tab in tabs" 
              :key="tab.value"
              @click="filter = tab.value"
              class="relative px-5 py-2 text-sm font-medium transition-all rounded-full"
              :class="filter === tab.value ? 'text-gray-900 dark:text-white' : 'text-gray-500 dark:text-gray-400'"
            >
              <span class="relative z-10">{{ tab.label }}</span>
              <span 
                v-if="filter === tab.value"
                class="absolute inset-0 bg-white dark:bg-gray-700 rounded-full shadow--sm transition-all duration-300"
              ></span>
            </button>
          </div>
          
          <!-- Secondary filter - Work type pills -->
          <div class="flex gap-2 overflow-x-auto py-1 no-scrollbar">
            <button 
              @click="workTypeFilter = 'all'"
              class="px-4 py-1.5 text-sm rounded-full whitespace-nowrap transition-all border"
              :class="workTypeFilter === 'all' 
                ? 'bg-gray-900 text-white dark:bg-white dark:text-gray-900 border-transparent shadow--sm' 
                : 'bg-transparent border-gray-200 dark:border-gray-700 text-gray-500 dark:text-gray-400'"
            >
              Tous
            </button>
            <button 
              @click="workTypeFilter = 'remote'"
              class="px-4 py-1.5 text-sm rounded-full whitespace-nowrap transition-all border flex items-center gap-1.5"
              :class="workTypeFilter === 'remote' 
                ? 'bg-gray-900 text-white dark:bg-white dark:text-gray-900 border-transparent shadow--sm' 
                : 'bg-transparent border-gray-200 dark:border-gray-700 text-gray-500 dark:text-gray-400'"
            >
              <UIcon name="i-heroicons-globe-alt" class="w-4 h-4" />
              À distance
            </button>
            <button 
              @click="workTypeFilter = 'on_site'"
              class="px-4 py-1.5 text-sm rounded-full whitespace-nowrap transition-all border flex items-center gap-1.5"
              :class="workTypeFilter === 'on_site' 
                ? 'bg-gray-900 text-white dark:bg-white dark:text-gray-900 border-transparent shadow--sm' 
                : 'bg-transparent border-gray-200 dark:border-gray-700 text-gray-500 dark:text-gray-400'"
            >
              <UIcon name="i-heroicons-map-pin" class="w-4 h-4" />
              Sur place
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Main content area -->
    <div class="max-w-3xl mx-auto px-6 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex justify-center py-16">
        <div class="w-8 h-8 rounded-full border-2 border-gray-300 dark:border-gray-700 border-t-primary-500 animate-spin"></div>
      </div>
      
      <!-- Empty state -->
      <div v-else-if="filteredMissions.length === 0" class="py-16 text-center">
        <div class="w-20 h-20 mx-auto mb-6 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center">
          <UIcon name="i-heroicons-document-text" class="w-10 h-10 text-gray-300 dark:text-gray-600" />
        </div>
        <h3 class="text-xl font-semibold mb-2">Aucune mission trouvée</h3>
        <p class="text-gray-500 dark:text-gray-400 mb-8 max-w-md mx-auto">
          Il n'y a pas de missions correspondant à vos critères actuels.
        </p>
        <button class="bg-primary-500 hover:bg-primary-600 active:bg-primary-700 text-white px-6 py-3 rounded-full text-sm font-medium transition-all flex items-center gap-2 mx-auto shadow--sm">
          <UIcon name="i-heroicons-plus" class="w-4 h-4" />
          Créer une nouvelle mission
        </button>
      </div>

      <!-- Missions list -->
      <TransitionGroup 
        name="list" 
        tag="div" 
        class="space-y-4"
      >
        <div 
          v-for="mission in filteredMissions" 
          :key="mission.id"
          class="relative bg-white dark:bg-gray-900 rounded-2xl p-6 transition-all shadow--sm hover:shadow--md"
          :class="[
            mission.proposal_count > 0 ? 'border-2 border-primary-500' : 'border border-gray-100 dark:border-gray-800'
          ]"
        >
          <!-- Proposal badge -->
          <div 
            v-if="mission.proposal_count > 0" 
            class="absolute -top-3 right-4 flex items-center gap-2 px-3 py-1 bg-primary-500 text-white rounded-full font-medium shadow--sm"
          >
            <span class="relative flex h-2 w-2">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-white opacity-75"></span>
              <span class="relative inline-flex rounded-full h-2 w-2 bg-white"></span>
            </span>
            {{ mission.proposal_count }} nouvelle{{ mission.proposal_count > 1 ? 's' : '' }}
          </div>

          <!-- Mission header -->
          <div class="flex justify-between items-center mb-5">
            <div class="flex items-center gap-4">
              <div 
                class="w-12 h-12 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center"
                :class="{
                  'bg-green-50 dark:bg-green-900/30': mission.status === 'open',
                  'bg-blue-50 dark:bg-blue-900/30': mission.status === 'in_progress' || mission.status === 'assigned',
                  'bg-gray-100 dark:bg-gray-800': mission.status === 'completed',
                  'bg-red-50 dark:bg-red-900/30': mission.status === 'cancelled'
                }"
              >
                <UIcon 
                  :name="mission.work_type === 'remote' ? 'i-heroicons-globe-alt' : 'i-heroicons-map-pin'" 
                  class="w-6 h-6"
                  :class="{
                    'text-green-500': mission.status === 'open',
                    'text-blue-500': mission.status === 'in_progress' || mission.status === 'assigned',
                    'text-gray-400': mission.status === 'completed',
                    'text-red-500': mission.status === 'cancelled'
                  }"
                />
              </div>
              <div>
                <div class="flex items-center gap-2 mb-1">
                  <span 
                    class="inline-block w-2 h-2 rounded-full"
                    :class="{
                      'bg-green-500': mission.status === 'open',
                      'bg-blue-500': mission.status === 'in_progress' || mission.status === 'assigned',
                      'bg-gray-400': mission.status === 'completed',
                      'bg-red-500': mission.status === 'cancelled'
                    }"
                  ></span>
                  <span class="text-xs font-medium uppercase tracking-wide text-gray-500 dark:text-gray-400">
                    {{ getStatusLabel(mission.status) }}
                  </span>
                </div>
                <h2 class="text-lg font-semibold">{{ mission.title }}</h2>
              </div>
            </div>

            <!-- Deal status pill -->
            <div 
              v-if="mission.deal_id"
              class="px-3 py-1 rounded-full text-xs font-medium"
              :class="{
                'bg-yellow-50 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-400': mission.deal_status === 'proposal',
                'bg-blue-50 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400': mission.deal_status === 'active' || mission.deal_status === 'accepted',
                'bg-green-50 text-green-700 dark:bg-green-900/30 dark:text-green-400': mission.deal_status === 'completed',
                'bg-gray-50 text-gray-700 dark:bg-gray-800 dark:text-gray-300': mission.deal_status === 'rejected' || mission.deal_status === 'cancelled'
              }"
            >
              {{ getDealStatusLabel(mission.deal_status) }}
            </div>
          </div>

          <!-- Mission details -->
          <p class="text-gray-600 dark:text-gray-400 line-clamp-2 mb-5 text-sm">
            {{ mission.description }}
          </p>
          
          <!-- Key details grid -->
          <div class="grid grid-cols-2 gap-4 mb-5">
            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center">
                <UIcon name="i-heroicons-academic-cap" class="w-4 h-4 text-gray-400" />
              </div>
              <div>
                <div class="text-xs text-gray-500 dark:text-gray-400">Profession</div>
                <div class="text-sm font-medium">{{ mission.profession_name || 'Non spécifié' }}</div>
              </div>
            </div>
            
            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center">
                <UIcon name="i-heroicons-currency-dollar" class="w-4 h-4 text-gray-400" />
              </div>
              <div>
                <div class="text-xs text-gray-500 dark:text-gray-400">Budget</div>
                <div class="text-sm font-medium">{{ formatPrice(mission.budget) }}</div>
              </div>
            </div>

            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center">
                <UIcon name="i-heroicons-clock" class="w-4 h-4 text-gray-400" />
              </div>
              <div>
                <div class="text-xs text-gray-500 dark:text-gray-400">Durée</div>
                <div class="text-sm font-medium">
                  <span v-if="mission.deal_id">
                    {{ mission.deal_duration }} {{ formatDurationUnit(mission.deal_duration_unit) }}
                  </span>
                  <span v-else>Non spécifié</span>
                </div>
              </div>
            </div>

            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center">
                <UIcon name="i-heroicons-calendar" class="w-4 h-4 text-gray-400" />
              </div>
              <div>
                <div class="text-xs text-gray-500 dark:text-gray-400">Échéance</div>
                <div class="text-sm font-medium">
                  <span v-if="mission.deadline">{{ formatDate(mission.deadline) }}</span>
                  <span v-else>Sans délai</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Expert info (if deal exists) -->
          <div v-if="mission.other_party_id" class="pt-4 border-t border-gray-100 dark:border-gray-800 mb-5">
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-3">
                <UAvatar
                  :src="mission.other_party_avatar_url"
                  :alt="mission.other_party_first_name"
                  size="md"
                  class="rounded-full shadow--sm border border-white dark:border-gray-800"
                />
                <div>
                  <div class="text-xs text-gray-500 dark:text-gray-400">Expert</div>
                  <div class="font-medium">{{ mission.other_party_first_name }} {{ mission.other_party_last_name }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Actions -->
          <div class="flex justify-end gap-3 pt-3">
            <!-- Dynamic buttons based on status -->
            <template v-if="mission.status === 'open'">
              <UButton
                v-if="mission.proposal_count > 0"
                color="primary"
                variant="solid"
                class="rounded-full"
                size="md"
                @click="router.push(`/account/missions/${mission.id}/proposals`)"
              >
                Voir {{ mission.proposal_count }} proposition{{ mission.proposal_count > 1 ? 's' : '' }}
              </UButton>
            </template>

            <template v-else-if="mission.status === 'in_progress'">
              <UButton
                color="primary"
                variant="solid"
                class="rounded-full"
                size="md"
                @click="openRatingModal(mission)"
              >
                Terminer la mission
              </UButton>
            </template>

            <template v-else-if="mission.status === 'completed' && !mission.rating">
              <UButton
                color="primary"
                variant="solid"
                class="rounded-full"
                size="md"
                @click="openRatingModal(mission)"
              >
                Noter
              </UButton>
            </template>
          </div>

          <!-- Rating UI (shown when needed) -->
          <TransitionRoot appear :show="showRating === mission.id" as="template">
            <div class="relative">
              <div 
                class="bg-white dark:bg-gray-800 rounded-xl shadow--md border border-gray-100 dark:border-gray-700 mt-4 transform transition-all duration-300 overflow-hidden"
                :class="showRating === mission.id ? 'max-h-[200px] opacity-100' : 'max-h-0 opacity-0'"
              >
                <!-- Stars -->
                <div class="p-5 flex justify-center gap-2">
                  <button
                    v-for="star in 5"
                    :key="star"
                    @click="ratings[mission.id] = star"
                    class="p-1 transition-transform hover:scale-110"
                    :class="star <= (ratings[mission.id] || 0) ? 'animate-bounce-small' : ''"
                    :style="`animation-delay: ${star * 50}ms`"
                  >
                    <UIcon
                      :name="star <= (ratings[mission.id] || 0) ? 'i-heroicons-star-solid' : 'i-heroicons-star'"
                      class="w-8 h-8"
                      :class="star <= (ratings[mission.id] || 0) ? 'text-yellow-400' : 'text-gray-300'"
                    />
                  </button>
                </div>

                <!-- Actions -->
                <div class="px-5 pb-5 flex gap-2">
                  <button
                    @click="showRating = null"
                    class="flex-1 py-2.5 rounded-xl text-gray-700 dark:text-gray-300 bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors text-sm font-medium"
                  >
                    Annuler
                  </button>
                  <button
                    @click="submitRating(mission, ratings[mission.id])"
                    :disabled="!ratings[mission.id]"
                    class="flex-1 py-2.5 rounded-xl text-white bg-primary-500 hover:bg-primary-600 disabled:opacity-50 disabled:cursor-not-allowed transition-colors text-sm font-medium"
                  >
                    Valider
                  </button>
                </div>
              </div>
            </div>
          </TransitionRoot>

          <!-- Ajouter un menu d'actions pour chaque mission -->
          <div class="absolute top-4 right-4">
            <UDropdown
              :items="[
                [
                  {
                    label: 'Voir les détails',
                    icon: 'i-heroicons-eye',
                    click: () => router.push(`/account/missions/${mission.id}`)
                  }
                ],
                [
                  {
                    label: 'Supprimer',
                    icon: 'i-heroicons-trash',
                    click: () => confirmDeleteMission(mission.id),
                    class: 'text-red-500 hover:text-red-600 dark:text-red-400 dark:hover:text-red-300'
                  }
                ]
              ]"
            >
              <UButton
                color="gray"
                variant="ghost"
                icon="i-heroicons-ellipsis-vertical"
                class="h-8 w-8 p-0"
              />
            </UDropdown>
          </div>
        </div>
      </TransitionGroup>
    </div>

    <!-- Proposals modal -->
    <TransitionRoot appear :show="showProposalsModal" as="template">
      <Dialog as="div" class="relative z-50" @close="showProposalsModal = false">
        <!-- Modal backdrop with blur -->
        <TransitionChild
          as="template"
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/30 backdrop-blur-sm" />
        </TransitionChild>

        <!-- Modal content -->
        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full items-center justify-center p-4">
            <TransitionChild
              as="template"
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel 
                class="w-full sm:max-w-xl bg-white dark:bg-gray-900 rounded-3xl overflow-hidden shadow--xl"
              >
                <!-- Header -->
                <div class="relative h-36 bg-gradient-to-br from-primary-500 to-primary-600">
                  <!-- Close button -->
                  <button 
                    @click="showProposalsModal = false"
                    class="absolute top-4 right-4 w-8 h-8 rounded-full bg-black/10 hover:bg-black/20 flex items-center justify-center transition-colors"
                  >
                    <UIcon name="i-heroicons-x-mark" class="w-5 h-5 text-white" />
                  </button>

                  <div class="absolute bottom-6 left-6">
                    <h3 class="text-2xl font-semibold text-white">
                      Propositions reçues
                    </h3>
                    <p class="text-white/90 text-sm mt-1">
                      {{ currentMission?.title }}
                    </p>
                  </div>
                </div>

                <!-- Stats summary -->
                <div class="grid grid-cols-3 gap-4 px-6 py-4 border-b border-gray-100 dark:border-gray-800">
                  <div>
                    <div class="text-xs text-gray-500 dark:text-gray-400 uppercase tracking-wide font-medium">Total</div>
                    <div class="text-lg font-semibold mt-1">
                      {{ currentMission?.deals?.length || 0 }}
                    </div>
                  </div>
                  <div>
                    <div class="text-xs text-gray-500 dark:text-gray-400 uppercase tracking-wide font-medium">Prix moyen</div>
                    <div class="text-lg font-semibold mt-1">
                      {{ formatPrice(getAveragePrice()) }}
                    </div>
                  </div>
                  <div>
                    <div class="text-xs text-gray-500 dark:text-gray-400 uppercase tracking-wide font-medium">Durée moy.</div>
                    <div class="text-lg font-semibold mt-1">
                      {{ getAverageDuration() }}j
                    </div>
                  </div>
                </div>

                <!-- Proposals list -->
                <div class="p-6 space-y-4 max-h-[60vh] overflow-y-auto">
                  <div 
                    v-for="proposal in currentMission?.deals" 
                    :key="proposal.id"
                    class="rounded-xl overflow-hidden shadow--sm border border-gray-100 dark:border-gray-800"
                  >
                    <!-- Expert info -->
                    <div class="p-4 bg-gray-50 dark:bg-gray-800/50 flex items-center gap-3">
                      <UAvatar 
                        :src="proposal.expert?.avatar_url" 
                        :alt="proposal.expert?.first_name"
                        size="md"
                        class="rounded-full border-2 border-white dark:border-gray-700"
                      />
                      <div>
                        <div class="font-medium">
                          {{ proposal.expert?.first_name }} {{ proposal.expert?.last_name }}
                        </div>
                        <div class="text-xs text-gray-500 dark:text-gray-400">
                          {{ formatTimeAgo(proposal.created_at) }}
                        </div>
                      </div>
                    </div>

                    <!-- Terms -->
                    <div class="grid grid-cols-2 gap-4 p-4">
                      <div class="bg-gray-50 dark:bg-gray-800/50 rounded-xl p-3">
                        <div class="text-xs text-gray-500 dark:text-gray-400 mb-1 uppercase tracking-wide font-medium">Prix</div>
                        <div class="text-lg font-semibold">{{ formatPrice(proposal.price) }}</div>
                      </div>
                      <div class="bg-gray-50 dark:bg-gray-800/50 rounded-xl p-3">
                        <div class="text-xs text-gray-500 dark:text-gray-400 mb-1 uppercase tracking-wide font-medium">Durée</div>
                        <div class="text-lg font-semibold">
                          {{ proposal.duration }} {{ formatDurationUnit(proposal.duration_unit) }}
                        </div>
                      </div>
                    </div>

                    <!-- Message -->
                    <div class="p-4 border-t border-gray-100 dark:border-gray-800">
                      <div class="text-xs text-gray-500 dark:text-gray-400 mb-2 uppercase tracking-wide font-medium">Message</div>
                      <p class="text-gray-600 dark:text-gray-300 text-sm">
                        {{ proposal.message }}
                      </p>
                    </div>

                    <!-- Actions -->
                    <div class="flex justify-end p-4 bg-gray-50 dark:bg-gray-800/50 border-t border-gray-100 dark:border-gray-800">
                      <div class="flex gap-3">
                        <UButton
                          color="gray"
                          variant="ghost"
                          class="rounded-full"
                          @click="showRejectConfirmation(proposal.id)"
                        >
                          Refuser
                        </UButton>
                        <UButton
                          color="primary"
                          variant="solid"
                          class="rounded-full"
                          @click="acceptProposal(proposal.id)"
                        >
                          Accepter
                        </UButton>
                      </div>
                    </div>
                  </div>
                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
    
    <!-- Reject confirmation modal -->
    <UModal v-model="isRejectModalOpen" :ui="{ width: 'sm:max-w-md' }" class="rounded-3xl">
      <div class="p-6">
        <h3 class="text-lg font-semibold mb-2">Refuser cette proposition ?</h3>
        <p class="text-sm text-gray-500 dark:text-gray-400 mb-6">
          L'expert sera notifié que sa proposition a été refusée.
        </p>
        <div class="flex justify-end gap-3">
          <UButton
            color="gray"
            variant="ghost"
            class="rounded-full"
            @click="isRejectModalOpen = false"
          >
            Annuler
          </UButton>
          <UButton
            color="red"
            variant="solid"
            class="rounded-full"
            @click="confirmReject"
          >
            Refuser
          </UButton>
        </div>
      </div>
    </UModal>

    <!-- Modal de confirmation de suppression -->
    <UModal v-model="showDeleteConfirm">
      <div class="p-4 sm:p-6">
        <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-red-100 dark:bg-red-900/20">
          <UIcon name="i-heroicons-exclamation-triangle" class="h-6 w-6 text-red-600 dark:text-red-400" />
        </div>
        <div class="mt-3 text-center sm:mt-5">
          <h3 class="text-lg font-medium text-gray-900 dark:text-white">
            Supprimer cette mission ?
          </h3>
          <div class="mt-2">
            <p class="text-sm text-gray-500 dark:text-gray-400">
              Cette action est irréversible. Toutes les propositions associées seront également supprimées.
            </p>
          </div>
        </div>
        <div class="mt-5 flex gap-3 sm:mt-6">
          <UButton
            color="gray"
            variant="soft"
            block
            @click="showDeleteConfirm = false"
          >
            Annuler
          </UButton>
          <UButton
            color="red"
            block
            @click="deleteMission"
          >
            Supprimer
          </UButton>
        </div>
      </div>
    </UModal>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { format } from 'date-fns'
import { fr } from 'date-fns/locale'
import { TransitionRoot, TransitionChild, Dialog, DialogPanel } from '@headlessui/vue'
import { useRouter } from 'vue-router'

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()
const { showToast } = useCustomToast()

// States
const missions = ref([])
const isLoading = ref(true)
const error = ref(null)
const filter = ref('all')
const workTypeFilter = ref('all')
const showRating = ref(null)
const ratings = ref({})
const showProposalsModal = ref(false)
const currentMission = ref(null)
const isRejectModalOpen = ref(false)
const pendingRejectId = ref(null)
const showDeleteConfirm = ref(false)
const missionToDelete = ref(null)

// Tabs for main filter
const tabs = [
  { label: 'Tous', value: 'all' },
  { label: 'En cours', value: 'active' },
  { label: 'Terminés', value: 'completed' }
]

// Fetch missions
const fetchMissions = async () => {
  isLoading.value = true
  error.value = null
  
  try {
    const { data, error: err } = await supabase
      .from('missions')
      .select(`
        *,
        profession:professions(*),
        deal:deals(
          id,
          status,
          price,
          duration,
          duration_unit,
          expert:expert_id(
            id,
            first_name,
            last_name,
            avatar_url
          )
        )
      `)
      .eq('client_id', user.value.id)
      .order('created_at', { ascending: false })
    
    if (err) throw err
    
    // Process missions to add proposal count and other party info
    missions.value = data.map(mission => {
      // Get active deal if exists
      const activeDeal = mission.deal?.find(d => 
        ['active', 'accepted', 'in_progress', 'completed'].includes(d.status)
      )
      
      // Count proposals
      const proposalCount = mission.deal?.filter(d => d.status === 'proposal').length || 0
      
      return {
        ...mission,
        proposal_count: proposalCount,
        deal_id: activeDeal?.id,
        other_party_id: activeDeal?.expert?.id,
        other_party_first_name: activeDeal?.expert?.first_name,
        other_party_last_name: activeDeal?.expert?.last_name,
        other_party_avatar_url: activeDeal?.expert?.avatar_url
      }
    })
    
  } catch (err) {
    console.error('Error fetching missions:', err)
    error.value = "Une erreur est survenue lors du chargement des missions"
    
    // Show toast notification
    showToast.error("Une erreur est survenue lors du chargement des missions")
  } finally {
    isLoading.value = false
  }
}

// Filter missions based on selected filters
const filteredMissions = computed(() => {
  if (!missions.value) return []
  
  return missions.value.filter(mission => {
    // Status filter
    const statusMatch = filter.value === 'all' || 
                       (filter.value === 'active' && ['open', 'assigned', 'in_progress'].includes(mission.status)) ||
                       (filter.value === 'completed' && mission.status === 'completed')
    
    // Work type filter
    const workTypeMatch = workTypeFilter.value === 'all' || 
                         mission.work_type === workTypeFilter.value
    
    return statusMatch && workTypeMatch
  })
})

// Utility functions
const formatDate = (date) => {
  if (!date) return ''
  return format(new Date(date), 'dd MMM yyyy', { locale: fr })
}

const formatPrice = (price) => {
  if (!price) return 'À négocier'
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'XOF',
    maximumFractionDigits: 0
  }).format(price)
}

const getStatusLabel = (status) => {
  const labels = {
    'open': 'Nouveau',
    'assigned': 'Assigné',
    'in_progress': 'En cours',
    'completed': 'Terminé',
    'cancelled': 'Annulé'
  }
  return labels[status] || status
}

const getDealStatusLabel = (status) => {
  const labels = {
    'proposal': 'Proposition',
    'active': 'En cours',
    'accepted': 'En cours',
    'completed': 'Terminé',
    'rejected': 'Rejeté',
    'cancelled': 'Annulé'
  }
  return labels[status] || status
}

const formatDurationUnit = (unit) => {
  const units = {
    'days': 'jour(s)',
    'weeks': 'semaine(s)',
    'months': 'mois'
  }
  return units[unit] || unit
}

const formatTimeAgo = (date) => {
  if (!date) return ''
  
  const now = new Date()
  const past = new Date(date)
  const diffTime = Math.abs(now - past)
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  const diffHours = Math.ceil(diffTime / (1000 * 60 * 60))
  const diffMinutes = Math.ceil(diffTime / (1000 * 60))

  if (diffMinutes < 60) {
    return `Il y a ${diffMinutes} minute${diffMinutes > 1 ? 's' : ''}`
  }
  
  if (diffHours < 24) {
    return `Il y a ${diffHours} heure${diffHours > 1 ? 's' : ''}`
  }

  if (diffDays === 1) return "Hier"
  if (diffDays < 7) return `Il y a ${diffDays} jour${diffDays > 1 ? 's' : ''}`
  if (diffDays < 30) {
    const weeks = Math.floor(diffDays / 7)
    return `Il y a ${weeks} semaine${weeks > 1 ? 's' : ''}`
  }
  
  return format(past, 'dd MMM yyyy', { locale: fr })
}

// Ajouter ces méthodes utilitaires
const getAveragePrice = () => {
  if (!currentMission.value?.deals?.length) return 0
  const total = currentMission.value.deals.reduce((sum, deal) => sum + deal.price, 0)
  return Math.round(total / currentMission.value.deals.length)
}

const getAverageDuration = () => {
  if (!currentMission.value?.deals?.length) return 0
  const total = currentMission.value.deals.reduce((sum, deal) => {
    // Convertir en jours
    const days = {
      'days': 1,
      'weeks': 7,
      'months': 30
    }[deal.duration_unit] || 1
    return sum + (deal.duration * days)
  }, 0)
  return Math.round(total / currentMission.value.deals.length)
}

// Mettre à jour la méthode submitRating
const submitRating = async (mission, rating) => {
  try {
    // Mettre à jour le deal
    const { error: dealError } = await supabase
      .from('deals')
      .update({ 
        status: 'completed',
        client_rating: rating,
        client_has_rated: true,
        completed_at: new Date().toISOString()
      })
      .eq('id', mission.deal_id)

    if (dealError) throw dealError

    // Mettre à jour la mission
    const { error: missionError } = await supabase
      .from('missions')
      .update({ 
        status: 'completed',
        completed_at: new Date().toISOString()
      })
      .eq('id', mission.id)

    if (missionError) throw missionError

    // Notification
    showToast.success("Mission terminée avec succès")

    // Réinitialiser l'état
    showRating.value = null
    
    // Recharger les missions
    await fetchMissions()

  } catch (error) {
    console.error('Error:', error)
    showToast.error("Une erreur est survenue lors de la notation")
  }
}

// Mettre à jour la méthode openRatingModal
const openRatingModal = (mission) => {
  showRating.value = mission.id
  // Initialiser avec la note existante ou 0
  if (!ratings[mission.id]) {
    ratings[mission.id] = 0
  }
}

// Ajouter cette fonction pour afficher la confirmation
const confirmDeleteMission = (missionId) => {
  missionToDelete.value = missionId
  showDeleteConfirm.value = true
}

// Ajouter cette fonction pour supprimer la mission
const deleteMission = async () => {
  if (!missionToDelete.value) return
  
  try {
    const { error } = await supabase
      .from('missions')
      .delete()
      .eq('id', missionToDelete.value)
      .eq('client_id', user.value.id) // Sécurité supplémentaire
    
    if (error) throw error
    
    // Notification de succès
    showToast.success('Mission supprimée avec succès')
    
    // Recharger les missions
    await fetchMissions()
  } catch (error) {
    console.error('Error deleting mission:', error)
    showToast.error('Erreur lors de la suppression')
  } finally {
    // Réinitialiser les états
    showDeleteConfirm.value = false
    missionToDelete.value = null
  }
}

onMounted(() => {
  fetchMissions()
})
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;  
  overflow: hidden;
}

/* Animations */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fadeIn {
  animation: fadeIn 0.3s ease-out forwards;
}

/* Animation pour les étoiles */
@keyframes bounce-small {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-4px); }
}

.animate-bounce-small {
  animation: bounce-small 0.8s ease-in-out;
}

.animation-delay-100 { animation-delay: 0.1s; }
.animation-delay-200 { animation-delay: 0.2s; }
.animation-delay-300 { animation-delay: 0.3s; }
.animation-delay-400 { animation-delay: 0.4s; }
.animation-delay-500 { animation-delay: 0.5s; }

button {
  -webkit-tap-highlight-color: transparent;
}
</style> 