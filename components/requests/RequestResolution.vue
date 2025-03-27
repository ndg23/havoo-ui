<template>
  <div class="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
    <!-- En-tête avec animation de progression -->
    <div class="px-6 py-4 border-b border-gray-200 relative">
      <div 
        class="absolute bottom-0 left-0 h-0.5 bg-gradient-to-r from-green-500 to-emerald-500"
        :style="{ width: `${resolutionProgress}%` }"
      ></div>
      
      <h3 class="text-lg font-semibold text-gray-900 flex items-center">
        <CheckCircle2 class="h-5 w-5 mr-2 text-primary-500" />
        Finalisation de la demande
      </h3>
    </div>
    
    <div class="p-6">
      <!-- État non résolu -->
      <div v-if="!mission.resolved_at" class="space-y-8">
        <!-- Étapes de résolution -->
        <div class="flex justify-between">
          <div 
            v-for="(step, index) in steps" 
            :key="index"
            class="flex flex-col items-center relative flex-1"
          >
            <div 
              class="w-8 h-8 rounded-full flex items-center justify-center mb-2 transition-colors"
              :class="[
                currentStep > index 
                  ? 'bg-green-500 text-white' 
                  : currentStep === index
                    ? 'bg-primary-500 text-white'
                    : 'bg-gray-100 text-gray-400'
              ]"
            >
              <component :is="step.icon" class="h-4 w-4" />
            </div>
            <div class="text-xs font-medium text-center" :class="[
              currentStep >= index ? 'text-gray-900' : 'text-gray-400'
            ]">
              {{ step.label }}
            </div>
            
            <!-- Ligne de connexion -->
            <div 
              v-if="index < steps.length - 1"
              class="absolute h-0.5 w-full top-4 left-1/2 -z-10"
              :class="[
                currentStep > index ? 'bg-green-500' : 'bg-gray-200'
              ]"
            ></div>
          </div>
        </div>
        
        <!-- Formulaire de résolution -->
        <form @submit.prevent="submitResolution" class="space-y-6">
          <!-- Note avec animation -->
          <div class="bg-gray-50 rounded-xl p-6">
            <label class="block text-sm font-medium text-gray-700 mb-4">
              Comment évaluez-vous la prestation ?
            </label>
            <div class="flex items-center justify-center gap-3">
              <button 
                v-for="star in 5" 
                :key="star"
                type="button"
                @click="rating = star"
                @mouseenter="hoverRating = star"
                @mouseleave="hoverRating = 0"
                class="focus:outline-none transition-transform hover:scale-110"
              >
                <Star 
                  :class="[
                    'h-10 w-10 transition-colors',
                    (hoverRating || rating) >= star
                      ? 'text-yellow-400 fill-yellow-400' 
                      : 'text-gray-300'
                  ]"
                />
              </button>
            </div>
            <p class="text-center mt-3 text-sm text-gray-600">
              {{ ratingLabels[rating - 1] || 'Sélectionnez une note' }}
            </p>
          </div>
          
          <!-- Commentaire avec suggestions -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2 flex items-center justify-between">
              <span>Votre avis détaillé</span>
              <span class="text-xs text-gray-500">{{ comment.length }}/500 caractères</span>
            </label>
            <div class="relative">
              <textarea
                v-model="comment"
                rows="4"
                maxlength="500"
                class="block w-full rounded-lg border border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 sm:text-sm resize-none"
                placeholder="Décrivez votre expérience..."
              ></textarea>
              
              <!-- Suggestions de commentaires -->
              <div v-if="!comment && showSuggestions" class="absolute inset-x-0 top-full mt-2 bg-white rounded-lg border border-gray-200 shadow-lg z-10">
                <div 
                  v-for="suggestion in commentSuggestions" 
                  :key="suggestion"
                  @click="comment = suggestion"
                  class="px-4 py-2 hover:bg-gray-50 cursor-pointer text-sm text-gray-700"
                >
                  {{ suggestion }}
                </div>
              </div>
            </div>
          </div>
          
          <!-- Photos (optionnel) -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Ajouter des photos (optionnel)
            </label>
            <div class="flex items-center gap-4">
              <div 
                v-for="(photo, index) in photos" 
                :key="index"
                class="relative group"
              >
                <img 
                  :src="photo.url" 
                  class="w-20 h-20 object-cover rounded-lg border border-gray-200"
                />
                <button 
                  @click="removePhoto(index)"
                  class="absolute -top-2 -right-2 bg-white rounded-full p-1 shadow-md opacity-0 group-hover:opacity-100 transition-opacity"
                >
                  <X class="w-4 h-4 text-gray-500" />
                </button>
              </div>
              
              <button
                v-if="photos.length < 3"
                type="button"
                @click="$refs.photoInput.click()"
                class="w-20 h-20 flex flex-col items-center justify-center border-2 border-dashed border-gray-300 rounded-lg hover:border-primary-500 transition-colors"
              >
                <Camera class="w-6 h-6 text-gray-400" />
                <span class="text-xs text-gray-500 mt-1">Ajouter</span>
              </button>
              <input
                ref="photoInput"
                type="file"
                accept="image/*"
                class="hidden"
                @change="addPhoto"
              />
            </div>
          </div>
          
          <!-- Actions -->
          <div class="flex justify-between items-center pt-4 border-t border-gray-200">
            <div class="flex items-center">
              <Switch
                v-model="isPublic"
                class="relative inline-flex h-6 w-11 items-center rounded-full"
                :class="[
                  isPublic ? 'bg-primary-600' : 'bg-gray-200'
                ]"
              >
                <span class="sr-only">Rendre public</span>
                <span
                  class="inline-block h-4 w-4 transform rounded-full bg-white transition"
                  :class="[
                    isPublic ? 'translate-x-6' : 'translate-x-1'
                  ]"
                />
              </Switch>
              <span class="ml-2 text-sm text-gray-600">Rendre mon avis public</span>
            </div>
            
            <button
              type="submit"
              :disabled="saving || !rating"
              class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-lg text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
            >
              <Loader2 v-if="saving" class="h-4 w-4 mr-2 animate-spin" />
              <CheckCircle v-else class="h-4 w-4 mr-2" />
              Finaliser
            </button>
          </div>
        </form>
      </div>
      
      <!-- État résolu avec animation -->
      <div 
        v-else 
        class="space-y-4"
        v-motion
        :initial="{ opacity: 0, y: 20 }"
        :enter="{ opacity: 1, y: 0 }"
      >
        <div class="text-center py-6">
          <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-green-100 mb-4">
            <CheckCircle class="h-8 w-8 text-green-500" />
          </div>
          <h4 class="text-lg font-medium text-gray-900">Demande finalisée</h4>
          <p class="text-sm text-gray-500 mt-1">
            Le {{ formatDate(mission.resolved_at) }}
          </p>
        </div>
        
        <div class="flex items-center justify-center">
          <div class="flex items-center">
            <Star 
              v-for="star in 5" 
              :key="star"
              :class="[
                'h-6 w-6',
                star <= mission.rating 
                  ? 'text-yellow-400 fill-yellow-400' 
                  : 'text-gray-300'
              ]"
            />
          </div>
        </div>
        
        <!-- Commentaire -->
        <div v-if="mission.review" class="bg-gray-50 rounded-xl p-4 text-sm text-gray-700">
          {{ mission.review }}
        </div>
        
        <!-- Photos -->
        <div v-if="mission.photos?.length" class="flex gap-4 mt-4">
          <img 
            v-for="(photo, index) in mission.photos"
            :key="index"
            :src="photo.url"
            class="w-20 h-20 object-cover rounded-lg border border-gray-200"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { 
  Star, CheckCircle, CheckCircle2, Loader2, 
  Camera, X, ThumbsUp, MessageSquare, Send
} from 'lucide-vue-next'
import { Switch } from '@headlessui/vue'

const props = defineProps({
  mission: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['resolved'])

// État local
const rating = ref(0)
const hoverRating = ref(0)
const comment = ref('')
const saving = ref(false)
const photos = ref([])
const isPublic = ref(true)
const showSuggestions = ref(false)
const currentStep = ref(1)

// Étapes de résolution
const steps = [
  { label: 'Évaluation', icon: Star },
  { label: 'Commentaire', icon: MessageSquare },
  { label: 'Validation', icon: Send }
]

// Labels des notes
const ratingLabels = [
  'Très insatisfait',
  'Insatisfait',
  'Correct',
  'Satisfait',
  'Très satisfait'
]

// Suggestions de commentaires
const commentSuggestions = [
  'Excellent service, très professionnel et ponctuel.',
  'Travail soigné et résultat conforme à mes attentes.',
  'Bonne communication et expertise appréciable.',
  'Je recommande vivement cet expert.'
]

// Progression de la résolution
const resolutionProgress = computed(() => {
  let progress = 0
  if (rating.value) progress += 40
  if (comment.value) progress += 40
  if (photos.value.length) progress += 20
  return progress
})

// Gérer l'ajout de photos
const addPhoto = async (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  try {
    // Simuler un upload
    const url = URL.createObjectURL(file)
    photos.value.push({ url })
  } catch (error) {
    console.error('Erreur lors de l\'upload:', error)
  }
}

// Supprimer une photo
const removePhoto = (index) => {
  photos.value.splice(index, 1)
}

// Soumettre la résolution
const submitResolution = async () => {
  try {
    saving.value = true
    const client = useSupabaseClient()
    
    // Mettre à jour la demande
    const { error: missionError } = await client
      .from('missions')
      .update({
        resolved_at: new Date().toISOString(),
        rating: rating.value,
        review: comment.value,
        photos: photos.value,
        is_public: isPublic.value
      })
      .eq('id', props.mission.id)
    
    if (missionError) throw missionError
    
    // Mettre à jour la note moyenne de l'expert
    const { data: expertData, error: expertError } = await client
      .from('profiles')
      .select('rating, reviews_count')
      .eq('id', props.mission.expert_id)
      .single()
    
    if (expertError) throw expertError
    
    const newCount = (expertData.reviews_count || 0) + 1
    const newRating = (
      ((expertData.rating || 0) * (expertData.reviews_count || 0)) + rating.value
    ) / newCount
    
    const { error: updateError } = await client
      .from('profiles')
      .update({
        rating: newRating,
        reviews_count: newCount
      })
      .eq('id', props.mission.expert_id)
    
    if (updateError) throw updateError
    
    // Envoyer une notification à l'expert
    await client.from('notifications').insert({
      user_id: props.mission.expert_id,
      type: 'mission_resolved',
      title: 'Nouvelle évaluation reçue',
      message: `Vous avez reçu une note de ${rating.value}/5 étoiles`,
      data: { 
        mission_id: props.mission.id,
        rating: rating.value,
        is_public: isPublic.value
      }
    })
    
    emit('resolved', {
      rating: rating.value,
      comment: comment.value,
      photos: photos.value,
      isPublic: isPublic.value
    })
    
  } catch (error) {
    console.error('Erreur lors de la résolution:', error)
  } finally {
    saving.value = false
  }
}

// Formater une date
const formatDate = (date) => {
  return new Date(date).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

// Mettre à jour l'étape en fonction des actions
watch([rating, comment], ([newRating, newComment]) => {
  if (newRating) currentStep.value = 2
  if (newComment) currentStep.value = 3
})
</script>

<style scoped>
.animate-progress {
  transition: width 0.3s ease-in-out;
}
</style> 