<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- En-tête -->
      <PageHeader 
        title="Vérification de votre profil" 
        subtitle="Complétez votre profil en fournissant les documents nécessaires pour devenir expert"
      >
        <template #stats>
          <StatCard 
            title="Statut"
            :value="verificationStatus"
            :icon="statusIcon"
            :color="statusColor"
            :subtitle="statusMessage"
          />
          
          <StatCard 
            title="Documents requis"
            :value="`${completedDocs}/${totalDocs}`"
            :icon="ClipboardList"
            color="blue"
            :subtitle="docsMessage"
          />
        </template>
      </PageHeader>
      
      <!-- Formulaire de documents -->
      <div class="space-y-6">
        <!-- Pièce d'identité -->
        <div class="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
          <div class="px-6 py-4 border-b border-gray-200">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <UserCheck class="h-5 w-5 mr-2 text-primary-500" />
              Pièce d'identité
            </h3>
            <p class="mt-1 text-sm text-gray-500">
              Carte d'identité ou passeport en cours de validité
            </p>
          </div>
          
          <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <!-- Recto -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Recto
                </label>
                <DocumentUpload
                  v-model="idFront"
                  accept="image/*,.pdf"
                  :preview="true"
                  @change="uploadDocument('id_front', $event)"
                />
              </div>
              
              <!-- Verso -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Verso
                </label>
                <DocumentUpload
                  v-model="idBack"
                  accept="image/*,.pdf"
                  :preview="true"
                  @change="uploadDocument('id_back', $event)"
                />
              </div>
            </div>
          </div>
        </div>
        
        <!-- Justificatif de domicile -->
        <div class="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
          <div class="px-6 py-4 border-b border-gray-200">
            <h3 class="text-lg font-semibold text-gray-900 flex items-center">
              <Home class="h-5 w-5 mr-2 text-primary-500" />
              Justificatif de domicile
            </h3>
            <p class="mt-1 text-sm text-gray-500">
              Document de moins de 3 mois (facture d'électricité, gaz, internet...)
            </p>
          </div>
          
          <div class="p-6">
            <DocumentUpload
              v-model="proofAddress"
              accept="image/*,.pdf"
              :preview="true"
              @change="uploadDocument('proof_location', $event)"
            />
          </div>
        </div>
        
        <!-- Diplômes et certifications -->
        <div class="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
          <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <div>
                <h3 class="text-lg font-semibold text-gray-900 flex items-center">
                  <GraduationCap class="h-5 w-5 mr-2 text-primary-500" />
                  Diplômes et certifications
                </h3>
                <p class="mt-1 text-sm text-gray-500">
                  Ajoutez vos diplômes et certifications professionnelles
                </p>
              </div>
              <button 
                @click="addCertification"
                class="px-3 py-1.5 bg-primary-50 text-primary-600 text-sm font-medium rounded-lg hover:bg-primary-100 transition-colors flex items-center"
              >
                <Plus class="h-4 w-4 mr-1.5" />
                Ajouter
              </button>
            </div>
          </div>
          
          <div class="divide-y divide-gray-200">
            <div 
              v-for="(cert, index) in certifications" 
              :key="index"
              class="p-6"
            >
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">
                    Nom du diplôme/certification
                  </label>
                  <input 
                    v-model="cert.name"
                    type="text"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">
                    Organisme
                  </label>
                  <input 
                    v-model="cert.issuing_authority"
                    type="text"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">
                    Date d'obtention
                  </label>
                  <input 
                    v-model="cert.issue_date"
                    type="date"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">
                    Document
                  </label>
                  <DocumentUpload
                    v-model="cert.file"
                    accept="image/*,.pdf"
                    :preview="true"
                    @change="uploadCertification(index, $event)"
                  />
                </div>
              </div>
              
              <div class="mt-4 flex justify-end">
                <button 
                  @click="removeCertification(index)"
                  class="px-3 py-1.5 bg-red-50 text-red-600 text-sm font-medium rounded-lg hover:bg-red-100 transition-colors flex items-center"
                >
                  <Trash class="h-4 w-4 mr-1.5" />
                  Supprimer
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Bouton de soumission -->
        <div class="flex justify-end">
          <button 
            @click="submitVerification"
            :disabled="saving || !isComplete"
            class="px-6 py-3 bg-primary-600 text-white text-sm font-medium rounded-xl hover:bg-primary-700 transition-colors flex items-center disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Loader2 v-if="saving" class="h-4 w-4 mr-2 animate-spin" />
            <Send v-else class="h-4 w-4 mr-2" />
            Soumettre pour vérification
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { 
  UserCheck, Home, GraduationCap, Plus, Trash, Send,
  ClipboardList, CheckCircle, Clock, AlertTriangle, Loader2
} from 'lucide-vue-next'

const client = useSupabaseClient()
const user = useSupabaseUser()

// État des documents
const idFront = ref(null)
const idBack = ref(null)
const proofAddress = ref(null)
const certifications = ref([])
const saving = ref(false)

// Statut de vérification
const verificationStatus = computed(() => {
  const status = user.value?.verification_status || 'pending'
  switch (status) {
    case 'approved': return 'Approuvé'
    case 'rejected': return 'Refusé'
    case 'pending': return 'En attente'
    default: return 'Non soumis'
  }
})

// Icône et couleur selon le statut
const statusIcon = computed(() => {
  const status = user.value?.verification_status
  switch (status) {
    case 'approved': return CheckCircle
    case 'rejected': return AlertTriangle
    case 'pending': return Clock
    default: return ClipboardList
  }
})

const statusColor = computed(() => {
  const status = user.value?.verification_status
  switch (status) {
    case 'approved': return 'green'
    case 'rejected': return 'red'
    case 'pending': return 'yellow'
    default: return 'gray'
  }
})

// Message selon le statut
const statusMessage = computed(() => {
  const status = user.value?.verification_status
  switch (status) {
    case 'approved': return 'Votre profil a été vérifié et approuvé'
    case 'rejected': return user.value?.verification_notes || 'Votre profil a été refusé'
    case 'pending': return 'Votre profil est en cours de vérification'
    default: return 'Complétez votre profil pour devenir expert'
  }
})

// Progression des documents
const completedDocs = computed(() => {
  let count = 0
  if (idFront.value) count++
  if (idBack.value) count++
  if (proofAddress.value) count++
  if (certifications.value.length > 0) count++
  return count
})

const totalDocs = 4

const docsMessage = computed(() => {
  return `${completedDocs.value} document${completedDocs.value > 1 ? 's' : ''} sur ${totalDocs} requis`
})

// Vérifier si le formulaire est complet
const isComplete = computed(() => {
  return idFront.value && 
    idBack.value && 
    proofAddress.value && 
    certifications.value.length > 0 &&
    certifications.value.every(cert => 
      cert.name && 
      cert.issuing_authority && 
      cert.issue_date && 
      cert.file_url
    )
})

// Ajouter une certification
const addCertification = () => {
  certifications.value.push({
    name: '',
    issuing_authority: '',
    issue_date: '',
    file: null,
    file_url: null
  })
}

// Supprimer une certification
const removeCertification = (index) => {
  certifications.value.splice(index, 1)
}

// Upload d'un document
const uploadDocument = async (type, file) => {
  try {
    const path = `experts/${user.value.id}/${type}`
    const { data, error } = await client.storage
      .from('documents')
      .upload(path, file)
    
    if (error) throw error
    
    // Mettre à jour le profil avec l'URL du document
    const { error: updateError } = await client
      .from('profiles')
      .update({ [type]: data.path })
      .eq('id', user.value.id)
    
    if (updateError) throw updateError
    
  } catch (error) {
    console.error('Erreur lors de l\'upload:', error)
  }
}

// Upload d'une certification
const uploadCertification = async (index, file) => {
  try {
    const path = `experts/${user.value.id}/certifications/${Date.now()}`
    const { data, error } = await client.storage
      .from('documents')
      .upload(path, file)
    
    if (error) throw error
    
    // Mettre à jour l'URL du fichier dans le tableau
    certifications.value[index].file_url = data.path
    
  } catch (error) {
    console.error('Erreur lors de l\'upload:', error)
  }
}

// Soumettre la vérification
const submitVerification = async () => {
  try {
    saving.value = true
    
    // Enregistrer les certifications
    const { error: certError } = await client
      .from('expert_certifications')
      .insert(
        certifications.value.map(cert => ({
          expert_id: user.value.id,
          name: cert.name,
          file_url: cert.file_url,
          issue_date: cert.issue_date,
          issuing_authority: cert.issuing_authority
        }))
      )
    
    if (certError) throw certError
    
    // Mettre à jour le statut
    const { error: statusError } = await client
      .from('profiles')
      .update({ 
        verification_status: 'pending',
        updated_at: new Date().toISOString()
      })
      .eq('id', user.value.id)
    
    if (statusError) throw statusError
    
    // Rediriger vers le dashboard
    navigateTo('/expert/dashboard')
    
  } catch (error) {
    console.error('Erreur lors de la soumission:', error)
  } finally {
    saving.value = false
  }
}

// Charger les données existantes
onMounted(async () => {
  if (!user.value) return
  
  const { data, error } = await client
    .from('expert_certifications')
    .select('*')
    .eq('expert_id', user.value.id)
  
  if (error) {
    console.error('Erreur lors du chargement des certifications:', error)
    return
  }
  
  certifications.value = data || []
})

definePageMeta({
  middleware: ['auth']
})
</script> 