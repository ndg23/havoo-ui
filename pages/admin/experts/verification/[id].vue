<template>
  <div class="space-y-6">
    <PageHeader 
      title="Vérification d'expert" 
      subtitle="Examinez les documents et validez le profil de l'expert"
    >
      <template #actions>
        <NuxtLink 
          to="/admin/experts"
          class="px-4 py-2 bg-gray-100 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-200 transition-colors flex items-center"
        >
          <ArrowLeft class="h-4 w-4 mr-1.5" />
          Retour
        </NuxtLink>
      </template>
    </PageHeader>
    
    <ExpertVerification 
      v-if="expert"
      :expert="expert"
      @approved="onApproved"
      @rejected="onRejected"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowLeft } from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()
const client = useSupabaseClient()

const expert = ref(null)

// Charger les données de l'expert
const fetchExpert = async () => {
  const { data, error } = await client
    .from('profiles')
    .select(`
      *,
      certifications:expert_certifications(*)
    `)
    .eq('id', route.params.id)
    .single()
  
  if (error) {
    console.error('Erreur lors du chargement:', error)
    return
  }
  
  expert.value = data
}

// Gérer l'approbation
const onApproved = async ({ expertId, notes }) => {
  // Envoyer une notification à l'expert
  await client.from('notifications').insert({
    user_id: expertId,
    type: 'expert_approved',
    title: 'Profil approuvé',
    message: 'Votre profil d\'expert a été validé. Vous pouvez maintenant proposer vos services.',
    data: { notes }
  })
  
  router.push('/admin/experts')
}

// Gérer le refus
const onRejected = async ({ expertId, notes }) => {
  // Envoyer une notification à l'expert
  await client.from('notifications').insert({
    user_id: expertId,
    type: 'expert_rejected',
    title: 'Profil refusé',
    message: 'Votre profil d\'expert n\'a pas été validé. Veuillez consulter les notes pour plus d\'informations.',
    data: { notes }
  })
  
  router.push('/admin/experts')
}

onMounted(fetchExpert)

definePageMeta({
  layout: 'admin'
})
</script> 