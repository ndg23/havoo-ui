<template>
  <div class="max-w-3xl mx-auto px-4 pt-5 pb-16">
    <!-- En-tête -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Modifier mon profil</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">
        Gérez vos informations personnelles et paramètres
      </p>
    </div>

    <!-- Formulaire avec sections -->
    <div class="space-y-6">
      <!-- Section photo de profil -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Photo de profil
        </h2>
        
        <div class="flex items-center gap-6">
          <div class="relative">
            <img 
              :src="profileData.avatar_url || '/img/default-avatar.png'" 
              alt="Photo de profil"
              class="w-24 h-24 rounded-full object-cover border border-gray-200 dark:border-gray-700"
            />
            <button 
              class="absolute -bottom-1 -right-1 bg-gray-100 dark:bg-gray-700 p-1.5 rounded-full border border-gray-300 dark:border-gray-600 hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
            >
              <Edit3 class="h-4 w-4 text-gray-600 dark:text-gray-300" />
            </button>
          </div>
          
          <div>
            <p class="text-sm text-gray-500 dark:text-gray-400 mb-2">
              Choisissez une photo de profil claire. Une bonne photo augmente la confiance des utilisateurs.
            </p>
            <div class="flex gap-2">
              <button class="px-3 py-1.5 bg-primary-600 hover:bg-primary-700 text-white text-sm rounded-lg">
                Changer la photo
              </button>
              <button v-if="profileData.avatar_url" class="px-3 py-1.5 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 text-sm rounded-lg">
                Supprimer
              </button>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Section informations personnelles -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Informations personnelles
        </h2>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prénom</label>
            <input 
              type="text" 
              v-model="profileData.first_name" 
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom</label>
            <input 
              type="text" 
              v-model="profileData.last_name" 
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">À propos de moi</label>
            <textarea 
              v-model="profileData.bio" 
              rows="3"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            ></textarea>
            <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
              {{ 500 - (profileData.bio?.length || 0) }} caractères restants
            </p>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Date de naissance</label>
            <input 
              type="date" 
              v-model="profileData.birth_date" 
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Genre</label>
            <select 
              v-model="profileData.gender" 
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              <option value="">Sélectionner</option>
              <option value="male">Homme</option>
              <option value="female">Femme</option>
              <option value="other">Autre</option>
              <option value="prefer_not_to_say">Je préfère ne pas préciser</option>
            </select>
          </div>
        </div>
      </div>
      
      <!-- Section coordonnées -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Coordonnées
        </h2>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Email</label>
            <input 
              type="email" 
              v-model="profileData.email" 
              disabled
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white cursor-not-allowed"
            />
            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
              L'email ne peut pas être modifié
            </p>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Téléphone</label>
            <input 
              type="tel" 
              v-model="profileData.phone" 
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Adresse</label>
            <input 
              type="text" 
              v-model="profileData.location"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Ville</label>
            <input 
              type="text" 
              v-model="profileData.city"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Code postal</label>
            <input 
              type="text" 
              v-model="profileData.zip_code" 
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Pays</label>
            <select 
              v-model="profileData.country" 
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            >
              <option value="Sénégal">Sénégal</option>
              <option value="Mali">Mali</option>
              <option value="Côte d'Ivoire">Côte d'Ivoire</option>
              <option value="Burkina Faso">Burkina Faso</option>
              <option value="Guinée">Guinée</option>
            </select>
          </div>
        </div>
      </div>
      
      <!-- Section profil professionnel (uniquement pour les experts) -->
      <div v-if="isExpert" class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Profil professionnel
        </h2>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Spécialité</label>
            <input 
              type="text" 
              v-model="profileData.specialty" 
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Années d'expérience</label>
            <input 
              type="number" 
              v-model="profileData.years_of_experience" 
              min="0"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Compétences</label>
            <div class="flex flex-wrap gap-2 p-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 min-h-[100px]">
              <div 
                v-for="skill in profileData.skills" 
                :key="skill"
                class="flex items-center bg-primary-100 text-primary-800 dark:bg-primary-900/20 dark:text-primary-400 px-2 py-1 rounded-full text-sm"
              >
                {{ skill }}
                <button @click="removeSkill(skill)" class="ml-1.5 text-primary-600 dark:text-primary-400 hover:text-primary-800 dark:hover:text-primary-300">
                  <X class="h-3 w-3" />
                </button>
              </div>
              
              <div class="relative flex-grow min-w-[150px]">
                <input 
                  type="text" 
                  v-model="newSkill"
                  @keydown.enter.prevent="addSkill"
                  placeholder="Ajouter une compétence" 
                  class="w-full bg-transparent border-none focus:ring-0 text-gray-900 dark:text-white text-sm py-1 px-2"
                />
              </div>
            </div>
            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
              Appuyez sur Entrée pour ajouter une compétence
            </p>
          </div>
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Diplômes et certifications</label>
            <textarea 
              v-model="profileData.education" 
              rows="3"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            ></textarea>
          </div>
          
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Disponibilité</label>
            <div class="flex items-center gap-3 mt-1">
              <Switch v-model="profileData.is_available" @change="updateAvailability" />
              <span class="text-sm text-gray-700 dark:text-gray-300">
                {{ profileData.is_available ? 'Disponible pour de nouveaux projets' : 'Non disponible pour le moment' }}
              </span>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Section paramètres du compte -->
      <div class="bg-white dark:bg-gray-800 rounded-xl p-5 border border-gray-200 dark:border-gray-700 shadow-sm">
        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Paramètres du compte
        </h2>
        
        <div class="space-y-4">
          <div>
            <label class="flex items-center gap-3">
              <Switch v-model="profileData.email_notifications" />
              <span class="text-sm text-gray-700 dark:text-gray-300">
                Recevoir des notifications par email
              </span>
            </label>
            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1 ml-11">
              Nouvelles demandes, messages et mises à jour de contrats
            </p>
          </div>
          
          <div>
            <label class="flex items-center gap-3">
              <Switch v-model="profileData.sms_notifications" />
              <span class="text-sm text-gray-700 dark:text-gray-300">
                Recevoir des notifications par SMS
              </span>
            </label>
            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1 ml-11">
              Alertes importantes et rappels
            </p>
          </div>
          
          <div v-if="isExpert">
            <label class="flex items-center gap-3">
              <Switch v-model="profileData.profile_public" />
              <span class="text-sm text-gray-700 dark:text-gray-300">
                Profil public
              </span>
            </label>
            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1 ml-11">
              Rendre votre profil visible pour les clients potentiels
            </p>
          </div>
        </div>
      </div>
      
      <!-- Boutons de soumission -->
      <div class="flex justify-end gap-3 pt-2">
        <NuxtLink 
          to="/" 
          class="px-5 py-2.5 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 font-medium rounded-lg"
        >
          Annuler
        </NuxtLink>
        
        <button 
          @click="saveProfile" 
          class="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white font-medium rounded-lg"
          :disabled="isSaving"
        >
          <span v-if="isSaving" class="flex items-center">
            <div class="h-4 w-4 border-2 border-white/20 border-t-white rounded-full animate-spin mr-2"></div>
            Enregistrement...
          </span>
          <span v-else>Enregistrer les modifications</span>
        </button>
      </div>
    </div>
    
    <!-- Notification de succès -->
    <div 
      v-if="showSuccess" 
      class="fixed bottom-6 right-6 bg-green-100 dark:bg-green-900/30 border-l-4 border-green-500 text-green-700 dark:text-green-400 p-4 rounded-lg shadow-lg max-w-sm animated fadeInUp"
    >
      <div class="flex">
        <CheckCircle class="h-5 w-5 mt-0.5 mr-3" />
        <div>
          <p class="font-medium">Modifications enregistrées</p>
          <p class="text-sm">Votre profil a été mis à jour avec succès.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import Switch from '@/components/ui/Switch.vue'
import { 
  Edit3, 
  Check, 
  X,
  CheckCircle,
} from 'lucide-vue-next'

const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

// État local
const isSaving = ref(false)
const showSuccess = ref(false)
const newSkill = ref('')

// Données du profil
const profileData = ref({
  first_name: 'Amadou',
  last_name: 'Diallo',
  email: 'amadou.diallo@example.com',
  phone: '+221 77 123 45 67',
  avatar_url: '/img/avatars/user1.jpg',
  birth_date: '1990-05-15',
  gender: 'male',
  location: '123 Rue Léopold Sédar Senghor',
  city: 'Dakar',
  zip_code: '12000',
  country: 'Sénégal',
  bio: 'Développeur web passionné avec plus de 8 ans d\'expérience dans la création de solutions digitales pour les entreprises en Afrique de l\'Ouest.',
  is_expert: true,
  specialty: 'Développement web & mobile',
  years_of_experience: 8,
  skills: ['JavaScript', 'Vue.js', 'Node.js', 'WordPress', 'UI/UX Design'],
  education: 'Master en Informatique, Université Cheikh Anta Diop, 2015\nCertification AWS Developer Associate, 2020',
  is_available: true,
  email_notifications: true,
  sms_notifications: false,
  profile_public: true
})

// Computed
const isExpert = computed(() => profileData.value.is_expert)

// Méthodes
const fetchProfile = async () => {
  try {
    // Dans un environnement réel, nous récupérerions le profil depuis Supabase
    /*
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()

    if (error) throw error
    profileData.value = data
    */
  } catch (error) {
    console.error('Erreur lors du chargement du profil:', error)
  }
}

const addSkill = () => {
  if (newSkill.value.trim() && !profileData.value.skills.includes(newSkill.value.trim())) {
    profileData.value.skills.push(newSkill.value.trim())
    newSkill.value = ''
  }
}

const removeSkill = (skill) => {
  profileData.value.skills = profileData.value.skills.filter(s => s !== skill)
}

const updateAvailability = () => {
  console.log('Disponibilité mise à jour:', profileData.value.is_available)
}

const saveProfile = async () => {
  try {
    isSaving.value = true
    
    // Dans un environnement réel, nous sauvegarderions le profil dans Supabase
    /*
    const { error } = await supabase
      .from('profiles')
      .update(profileData.value)
      .eq('id', user.value.id)

    if (error) throw error
    */
    
    // Simuler un délai de sauvegarde
    setTimeout(() => {
      isSaving.value = false
      showSuccess.value = true
      
      // Masquer la notification après 3 secondes
      setTimeout(() => {
        showSuccess.value = false
      }, 3000)
    }, 1000)
  } catch (error) {
    console.error('Erreur lors de la sauvegarde du profil:', error)
    isSaving.value = false
  }
}

// Initialisation
onMounted(() => {
  fetchProfile()
})

definePageMeta({
  layout: 'default'
})
</script>

<style scoped>
.animated {
  animation-duration: 0.4s;
  animation-fill-mode: both;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translate3d(0, 10px, 0);
  }
  to {
    opacity: 1;
    transform: translate3d(0, 0, 0);
  }
}

.fadeInUp {
  animation-name: fadeInUp;
}
</style> 