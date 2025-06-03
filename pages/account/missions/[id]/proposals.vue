<template>
  <div class="min-h-screen bg-white dark:bg-gray-900 antialiased">
    <!-- Floating header with blur effect -->
    <div class="sticky top-0 z-10 bg-white/90 dark:bg-gray-900/90 backdrop-blur-xl border-b border-gray-100 dark:border-gray-800">
      <div class="max-w-4xl mx-auto px-6 py-4">
        <!-- Back button and title -->
        <div class="flex items-center gap-3 mb-4">
          <NuxtLink 
            :to="`/account/missions/${route.params.id}`"
            class="w-10 h-10 rounded-full flex items-center justify-center hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
            aria-label="Return to mission details"
          >
            <UIcon name="i-heroicons-chevron-left" class="w-5 h-5" />
          </NuxtLink>
          
          <div>
            <h1 class="text-2xl font-semibold">Proposals</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ mission?.title }}</p>
          </div>
        </div>

        <!-- Quick stats cards with subtle shadows -->
        <div class="grid grid-cols-3 gap-4 mt-2">
          <div class="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
            <div class="text-xs text-gray-500 dark:text-gray-400 uppercase tracking-wide font-medium">Total</div>
            <div class="text-3xl font-semibold mt-1">{{ proposals.length }}</div>
          </div>
          
          <div class="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
            <div class="text-xs text-gray-500 dark:text-gray-400 uppercase tracking-wide font-medium">Average Price</div>
            <div class="text-3xl font-semibold mt-1">{{ formatPrice(averagePrice) }}</div>
          </div>
          
          <div class="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
            <div class="text-xs text-gray-500 dark:text-gray-400 uppercase tracking-wide font-medium">Average Duration</div>
            <div class="text-3xl font-semibold mt-1">{{ averageDuration }}d</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Main content -->
    <div class="max-w-4xl mx-auto px-6 py-6">
      <!-- Loading state -->
      <div v-if="isLoading" class="flex justify-center py-12">
        <UIcon name="i-heroicons-arrow-path" class="w-8 h-8 text-gray-400 animate-spin" />
      </div>
      
      <!-- Empty state -->
      <div v-else-if="proposals.length === 0" class="text-center py-12">
        <UIcon name="i-heroicons-inbox" class="w-16 h-16 mx-auto text-gray-300 dark:text-gray-600" />
        <h3 class="mt-4 text-lg font-medium">No proposals yet</h3>
        <p class="text-gray-500 mt-2">Check back later for incoming proposals</p>
      </div>
      
      <!-- Proposals list -->
      <TransitionGroup 
        name="proposal-list" 
        tag="div" 
        class="space-y-4"
      >
        <div 
          v-for="proposal in proposals" 
          :key="proposal.id"
          class="bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-sm border border-gray-100 dark:border-gray-700"
        >
          <!-- Expert info with avatar -->
          <div class="flex items-center gap-4 mb-6">
            <UAvatar 
              :src="proposal.expert?.avatar_url" 
              :alt="proposal.expert?.first_name"
              size="lg"
              class="rounded-full ring-2 ring-white dark:ring-gray-700 shadow-sm"
            />
            <div>
              <div class="font-medium text-lg">
                {{ proposal.expert?.first_name }} {{ proposal.expert?.last_name }}
              </div>
              <div class="text-xs text-gray-500 dark:text-gray-400 mt-1">
                {{ formatTimeAgo(proposal.created_at) }}
              </div>
            </div>
          </div>

          <!-- Price and duration in elegantly styled cards -->
          <div class="grid grid-cols-2 gap-4 mb-6">
            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-2xl p-4">
              <div class="text-xs text-gray-500 dark:text-gray-400 uppercase tracking-wide font-medium mb-1">Price</div>
              <div class="text-2xl font-semibold">{{ formatPrice(proposal.price) }}</div>
            </div>
            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-2xl p-4">
              <div class="text-xs text-gray-500 dark:text-gray-400 uppercase tracking-wide font-medium mb-1">Timeframe</div>
              <div class="text-2xl font-semibold">
                {{ proposal.duration }} {{ formatDurationUnit(proposal.duration_unit) }}
              </div>
            </div>
          </div>

          <!-- Message with elegant styling -->
          <div class="bg-gray-50 dark:bg-gray-700/50 rounded-2xl p-5 mb-6">
            <div class="text-xs text-gray-500 dark:text-gray-400 uppercase tracking-wide font-medium mb-2">Message</div>
            <p class="text-gray-700 dark:text-gray-300 text-sm leading-relaxed">
              {{ proposal.message }}
            </p>
          </div>

          <!-- Action buttons with elegant design -->
          <div class="flex justify-end gap-3">
            <UButton
              color="gray"
              variant="ghost"
              size="lg"
              class="rounded-full px-6 py-2"
              @click="showRejectConfirmation(proposal.id)"
            >
              Decline
            </UButton>
            <UButton
              color="primary"
              variant="solid"
              size="lg"
              class="rounded-full px-6 py-2"
              @click="acceptProposal(proposal.id)"
            >
              Accept
            </UButton>
          </div>
        </div>
      </TransitionGroup>
    </div>
    
    <!-- Confirmation modal for rejections -->
    <UModal v-model="isConfirmModalOpen" :ui="{ width: 'sm:max-w-md' }">
      <div class="p-6">
        <h3 class="text-lg font-medium mb-4">Decline this proposal?</h3>
        <p class="text-gray-500 dark:text-gray-400 mb-6">
          The expert will be notified that their proposal wasn't selected.
        </p>
        <div class="flex justify-end gap-3">
          <UButton
            color="gray"
            variant="ghost"
            @click="isConfirmModalOpen = false"
          >
            Cancel
          </UButton>
          <UButton
            color="red"
            @click="confirmReject"
          >
            Decline
          </UButton>
        </div>
      </div>
    </UModal>
  </div>
</template>

<script setup>
const route = useRoute()
const router = useRouter()
const supabase = useSupabaseClient()

// States
const mission = ref(null)
const proposals = ref([])
const isLoading = ref(true)
const isConfirmModalOpen = ref(false)
const pendingRejectId = ref(null)

// Computed
const averagePrice = computed(() => {
  if (!proposals.value.length) return 0
  const total = proposals.value.reduce((sum, p) => sum + p.price, 0)
  return Math.round(total / proposals.value.length)
})

const averageDuration = computed(() => {
  if (!proposals.value.length) return 0
  const total = proposals.value.reduce((sum, p) => {
    const days = { days: 1, weeks: 7, months: 30 }[p.duration_unit] || 1
    return sum + (p.duration * days)
  }, 0)
  return Math.round(total / proposals.value.length)
})

// Data loading
const loadData = async () => {
  isLoading.value = true
  try {
    // Load mission data
    const { data: missionData, error: missionError } = await supabase
      .from('missions')
      .select('*')
      .eq('id', route.params.id)
      .single()
    
    if (missionError) throw missionError
    mission.value = missionData

    // Load proposals with expert info
    const { data: proposalsData, error: proposalsError } = await supabase
      .from('deals')
      .select(`
        *,
        expert:profiles!expert_id (
          id,
          first_name,
          last_name,
          avatar_url
        )
      `)
      .eq('mission_id', route.params.id)
      .eq('status', 'proposal')
      .order('created_at', { ascending: false })

    if (proposalsError) throw proposalsError
    proposals.value = proposalsData || []
  } catch (error) {
    console.error('Error loading data:', error)
    useToast().add({
      title: 'Error loading data',
      description: 'Please try again later',
      color: 'red'
    })
  } finally {
    isLoading.value = false
  }
}

// Helper functions
const formatPrice = (price) => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR',
    maximumFractionDigits: 0
  }).format(price)
}

const formatTimeAgo = (date) => {
  // Simple implementation - replace with your preferred time formatting
  const now = new Date()
  const then = new Date(date)
  const diffInDays = Math.floor((now - then) / (1000 * 60 * 60 * 24))
  
  if (diffInDays === 0) return 'Today'
  if (diffInDays === 1) return 'Yesterday'
  if (diffInDays < 30) return `${diffInDays} days ago`
  
  const diffInMonths = Math.floor(diffInDays / 30)
  return `${diffInMonths} ${diffInMonths === 1 ? 'month' : 'months'} ago`
}

const formatDurationUnit = (unit) => {
  const units = {
    'days': 'days',
    'weeks': 'weeks',
    'months': 'months'
  }
  return units[unit] || unit
}

// Actions
const acceptProposal = async (id) => {
  try {
    const { error } = await supabase
      .from('deals')
      .update({ 
        status: 'accepted',
        accepted_at: new Date().toISOString()
      })
      .eq('id', id)

    if (error) throw error
    
    // Show success toast
    useToast().add({
      title: 'Proposal accepted',
      description: 'The expert has been notified',
      color: 'green'
    })
    
    // Redirect to mission page
    router.push(`/account/missions/${route.params.id}`)
  } catch (error) {
    console.error('Error accepting proposal:', error)
    useToast().add({
      title: 'Error accepting proposal',
      description: 'Please try again',
      color: 'red'
    })
  }
}

const showRejectConfirmation = (id) => {
  pendingRejectId.value = id
  isConfirmModalOpen.value = true
}

const confirmReject = async () => {
  if (!pendingRejectId.value) return
  
  try {
    const { error } = await supabase
      .from('deals')
      .update({ status: 'rejected' })
      .eq('id', pendingRejectId.value)

    if (error) throw error
    
    isConfirmModalOpen.value = false
    pendingRejectId.value = null
    
    // Show success toast
    useToast().add({
      title: 'Proposal declined',
      color: 'gray'
    })
    
    // Reload proposals
    loadData()
  } catch (error) {
    console.error('Error rejecting proposal:', error)
    useToast().add({
      title: 'Error declining proposal',
      description: 'Please try again',
      color: 'red'
    })
  }
}

// Initialize
onMounted(() => {
  loadData()
})

// CSS transitions
const css = `
.proposal-list-move,
.proposal-list-enter-active,
.proposal-list-leave-active {
  transition: all 0.5s ease;
}

.proposal-list-enter-from,
.proposal-list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

.proposal-list-leave-active {
  position: absolute;
}
`
useHead({
  style: [{ children: css }]
})
</script>