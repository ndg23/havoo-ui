<template>
  <div class=" mx-auto px-4 py-8">
    <!-- En-tête de la page -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Modifier mon profil</h1>
      <p class="text-gray-600 dark:text-gray-400 mt-1">Mettez à jour vos informations personnelles et vos préférences</p>
    </div>
    
    <!-- Alerte de statut -->
    <ErrorAlert 
      v-if="statusMessage.show"
      :type="statusMessage.type"
      :message="statusMessage.message"
      dismissible
      @dismiss="statusMessage.show = false"
      class="mb-6"
    />
    
    <!-- Section chargement -->
    <div v-if="isLoading" class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 p-16 animate-pulse shadow-sm">
      <div class="flex flex-col items-center justify-center">
        <div class="h-10 w-10 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400 font-medium">Chargement de vos informations...</p>
      </div>
    </div>
    
    <form v-else @submit.prevent="updateProfile" class="space-y-8">
      <!-- Photo de profil -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <Image class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Photo de profil
          </h2>
        </div>
        
        <div class="p-6">
          <div class="flex flex-col md:flex-row items-center gap-6">
            <div class="relative">
              <img 
                :src="avatarPreview || form.profileImage || '/img/default-avatar.png'" 
                alt="Photo de profil"
                class="w-28 h-28 rounded-full object-cover border-2 border-white dark:border-gray-700 shadow-sm"
              />
              <button 
                type="button"
                @click="$refs.fileInput.click()"
                class="absolute bottom-0 right-0 w-9 h-9 rounded-full bg-primary-600 flex items-center justify-center border-2 border-white dark:border-gray-800 shadow-md hover:bg-primary-700 transition-colors"
              >
                <Camera class="w-5 h-5 text-white" />
              </button>
            </div>
            
            <div>
              <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Photo de profil</h3>
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-3">
                Une photo claire de votre visage aidera les clients à vous reconnaître. <br>
                Formats acceptés: JPG, PNG, GIF (max 2MB)
              </p>
              
              <div class="flex flex-wrap gap-3">
                <button 
                  type="button"
                  @click="$refs.fileInput.click()"
                  class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center"
                >
                  <Upload class="h-4 w-4 mr-1.5" />
                  Télécharger
                </button>
                
                <button 
                  v-if="avatarFile || avatarPreview"
                  type="button"
                  @click="removeAvatar"
                  class="px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-red-600 dark:text-red-400 text-sm font-medium rounded-full hover:bg-gray-50 dark:hover:bg-gray-600 transition-colors flex items-center"
                >
                  <Trash2 class="h-4 w-4 mr-1.5" />
                  Supprimer
                </button>
              </div>
              
              <input 
                ref="fileInput" 
                type="file" 
                accept="image/*" 
                class="hidden" 
                @change="handleFileUpload" 
              />
            </div>
          </div>
        </div>
      </div>
      
      <!-- Informations personnelles -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <User class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Informations personnelles
          </h2>
        </div>
        
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Prénom -->
            <div>
              <FloatingLabelInput
                id="first_name"
                label="Prénom"
                v-model="form.firstName"
                required
              />
            </div>
            
            <!-- Nom -->
            <div>
              <FloatingLabelInput
                id="last_name"
                label="Nom"
                v-model="form.lastName"
                required
              />
            </div>
            
            <!-- Email -->
            <div>
              <FloatingLabelInput
                id="email"
                label="Email"
                type="email"
                v-model="form.email"
                disabled
              />
              <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">L'email ne peut pas être modifié</p>
            </div>
            
            <!-- Date de naissance -->
            <div>
              <FloatingLabelInput
                id="birthdate"
                label="Date de naissance"
                type="date"
                v-model="form.birthdate"
              />
            </div>
            
            <!-- Genre -->
            <div>
              <FloatingLabelInput
                id="gender"
                label="Genre"
                v-model="form.gender"
                as="select"
              >
                <option value="male">Homme</option>
                <option value="female">Femme</option>
                <option value="other">Autre</option>
                <option value="prefer_not_to_say">Préfère ne pas préciser</option>
              </FloatingLabelInput>
            </div>
            
            <!-- Téléphone -->
            <div>
              <FloatingLabelInput
                id="phone"
                label="Téléphone"
                type="tel"
                v-model="form.phone"
              />
            </div>
          </div>
        </div>
      </div>
      
      <!-- Coordonnées -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <MapPin class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Coordonnées
          </h2>
        </div>
        
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Adresse -->
            <div class="md:col-span-2">
              <FloatingLabelInput
                id="address"
                label="Adresse"
                v-model="form.address"
              />
            </div>
            
            <!-- Ville -->
            <div>
              <FloatingLabelInput
                id="city"
                label="Ville"
                v-model="form.city"
              />
            </div>
            
            <!-- Pays -->
            <div>
              <FloatingLabelInput
                id="country"
                label="Pays"
                v-model="form.country"
              />
            </div>
            
            <!-- Site web -->
            <div class="md:col-span-2">
              <FloatingLabelInput
                id="website"
                label="Site web"
                type="url"
                v-model="form.website"
              />
            </div>
          </div>
        </div>
      </div>
      
      <!-- Biographie -->
      <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
            <FileText class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
            Biographie
          </h2>
        </div>
        
        <div class="p-6">
          <FloatingLabelInput
            id="bio"
            label="Parlez-nous de vous"
            v-model="form.bio"
            as="textarea"
            rows="5"
          />
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">
            Votre biographie permettra aux autres utilisateurs de mieux vous connaître
          </p>
        </div>
      </div>
      
      <!-- Informations professionnelles (pour les experts) -->
      <div v-if="isExpert" class="p-6-">
          <!-- Compétences -->
          <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 overflow-hidden shadow-sm">
            <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
              <h2 class="text-lg font-medium text-gray-900 dark:text-white flex items-center">
                <Briefcase class="h-5 w-5 mr-2 text-primary-600 dark:text-primary-400" />
                Compétences
              </h2>
            </div>
            
            <div class="p-6">
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">
                Ajoutez les compétences que vous maîtrisez pour aider les clients à vous trouver plus facilement.
              </p>
              
              <!-- Dropdown style Google -->
              <div class="relative mb-6">
                <div class="flex flex-wrap gap-2 p-2 border border-gray-300 dark:border-gray-600 rounded-lg min-h-[56px] focus-within:ring-2 focus-within:ring-primary-500 focus-within:border-primary-500">
                  <!-- Compétences sélectionnées -->
                  <div 
                    v-for="skill in selectedSkills" 
                    :key="skill.id"
                    class="inline-flex items-center px-2.5 py-1.5 rounded-full text-sm font-medium bg-primary-100 dark:bg-primary-900 text-primary-800 dark:text-primary-200"
                  >
                    {{ skill.name }}
                <button 
                  type="button"
                      @click="removeSkill(skill)"
                      class="ml-1 inline-flex items-center justify-center w-4 h-4 rounded-full text-primary-600 dark:text-primary-400 hover:bg-primary-200 dark:hover:bg-primary-800 focus:outline-none"
                >
                      <X class="h-3 w-3" />
                </button>
            </div>
            
                  <!-- Dropdown trigger -->
                  <div class="relative flex-grow">
                    <select
                      v-model="selectedSkillId"
                      @change="addSelectedSkill"
                      class="w-full py-1.5 px-2 bg-transparent border-0 focus:ring-0 focus:outline-none text-gray-700 dark:text-gray-300 appearance-none"
                    >
                      <option value="" disabled selected>Ajouter une compétence...</option>
                      <optgroup 
                        v-for="category in skillCategories" 
                        :key="category.id" 
                        :label="category.name"
                      >
                        <option 
                          v-for="skill in category.skills" 
                          :key="skill.id" 
                          :value="skill.id"
                          :disabled="isSkillSelected(skill.id)"
                        >
                          {{ skill.name }}
                        </option>
                      </optgroup>
                      <optgroup label="Autres compétences">
                        <option 
                          v-for="skill in uncategorizedSkills" 
                          :key="skill.id" 
                          :value="skill.id"
                          :disabled="isSkillSelected(skill.id)"
                        >
                          {{ skill.name }}
                        </option>
                      </optgroup>
                    </select>
        </div>
      </div>
      
                <div v-if="selectedSkills.length === 0" class="mt-2 text-sm text-gray-500 dark:text-gray-400">
                  Sélectionnez au moins une compétence pour améliorer votre visibilité
        </div>
            </div>
            
              <!-- Suggestions de compétences populaires -->
              <div>
                <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Suggestions populaires :</h3>
                <div class="flex flex-wrap gap-2">
                  <button 
                    v-for="skill in popularSkills" 
                    :key="skill.id"
                    type="button"
                    @click="addSkill(skill)"
                    :disabled="isSkillSelected(skill.id)"
                    class="px-3 py-1 text-sm rounded-full border border-gray-300 dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    + {{ skill.name }}
                  </button>
              </div>
              </div>
            </div>
          </div>
        </div>
      
      
     
      
      <!-- Boutons d'action -->
      <div class="flex flex-wrap items-center justify-end gap-3 mt-8">
        <NuxtLink 
          to="/account" 
          class="px-6 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          Annuler
        </NuxtLink>
        
        <button 
          type="button" 
          @click="resetForm"
          class="px-6 py-2.5 border border-gray-300 dark:border-gray-600 rounded-full text-gray-700 dark:text-gray-300 font-medium hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          Réinitialiser
        </button>
        
        <button 
          type="submit"
          class="px-6 py-2.5 bg-primary-600 hover:bg-primary-700 rounded-full text-white font-medium transition-colors flex items-center"
          :disabled="isSaving"
        >
          <span v-if="isSaving" class="mr-2 h-4 w-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
          {{ isSaving ? 'Enregistrement...' : 'Enregistrer les modifications' }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import { 
  User, 
  MapPin, 
  Camera, 
  FileText, 
  Bell, 
  Image, 
  Upload, 
  Trash2, 
  Briefcase, 
  X, 
  Plus,
  ChevronDown
} from 'lucide-vue-next'
import FloatingLabelInput from '~/components/ui/FloatingLabelInput.vue'

// État
const user = useSupabaseUser()
const router = useRouter()
const supabase = useSupabaseClient()

const isLoading = ref(true)
const isSaving = ref(false)
const fileInput = ref(null)
const avatarFile = ref(null)
const avatarPreview = ref(null)
const initialForm = ref({})
const statusMessage = ref({
  show: false,
  type: 'info',
  message: ''
})

// Nouvelles variables à ajouter au script
const isExpert = ref(false)
const newSkill = ref('')
const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim']
const hours = [
  '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
  '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
  '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00'
]

// État pour les compétences
const selectedSkillId = ref('');
const allSkills = ref([]);
const selectedSkills = ref([]);
const skillCategories = ref([]);
const uncategorizedSkills = ref([]);
const showSkillResults = ref(false);

// Données du formulaire
const form = ref({
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  birthdate: '',
  gender: 'male',
  address: '',
  city: '',
  country: '',
  bio: '',
  profileImage: '',
  emailNotifications: true,
  pushNotifications: true,
  website: '',
  hourlyRate: '',
  availabilityStatus: 'available',
  skills: [],
  availableDays: [true, true, true, true, true, false, false],
  availableHours: [
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '09:00', end: '18:00' },
    { start: '10:00', end: '15:00' },
    { start: '10:00', end: '15:00' }
  ]
})

// Vérifier si l'utilisateur est connecté
const checkUser = computed(() => {
  if (!user.value) {
    router.push('/auth/login')
    return false
  }
  return true
})

// Récupérer les données du profil
const fetchProfile = async () => {
  if (!checkUser.value) return
  
  try {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single()
    
    if (error) throw error
    
    form.value = {
      firstName: data.first_name || '',
      lastName: data.last_name || '',
      email: user.value.email || '',
      phone: data.phone || '',
      birthdate: data.birthdate || '',
      gender: data.gender || 'male',
      address: data.address || '',
      city: data.city || '',
      country: data.country || '',
      bio: data.bio || '',
      profileImage: data.avatar_url || '',
      emailNotifications: data.email_notifications ?? true,
      pushNotifications: data.push_notifications ?? true,
      website: data.website || '',
      hourlyRate: data.hourly_rate || '',
      availabilityStatus: data.availability_status || 'available',
      skills: data.skills || [],
      availableDays: data.available_days || [true, true, true, true, true, false, false],
      availableHours: data.available_hours || [
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '09:00', end: '18:00' },
        { start: '10:00', end: '15:00' },
        { start: '10:00', end: '15:00' }
      ]
    }
    
    // Sauvegarder les valeurs initiales pour la réinitialisation
    initialForm.value = { ...form.value }
    
    // Après avoir récupéré les données du profil
    isExpert.value = data.is_expert || data.role === 'expert'
    
  } catch (error) {
    console.error('Erreur lors du chargement du profil:', error)
    showStatusMessage('error', 'Erreur lors du chargement de votre profil')
  } finally {
    isLoading.value = false
  }
}

// Gestion du fichier avatar
const handleFileUpload = (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  // Valider le type de fichier
  const allowedTypes = ['image/jpeg', 'image/png', 'image/gif']
  if (!allowedTypes.includes(file.type)) {
    showStatusMessage('error', 'Type de fichier non pris en charge. Utilisez JPG, PNG ou GIF')
    return
  }
  
  // Valider la taille du fichier (max 2MB)
  if (file.size > 2 * 1024 * 1024) {
    showStatusMessage('error', 'La taille du fichier ne doit pas dépasser 2MB')
    return
  }
  
  avatarFile.value = file
  
  // Créer un aperçu de l'image
  const reader = new FileReader()
  reader.onload = (e) => {
    avatarPreview.value = e.target.result
  }
  reader.readAsDataURL(file)
  
  // Réinitialiser l'input file pour permettre de réuploader le même fichier
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

// Supprimer l'avatar
const removeAvatar = () => {
  avatarFile.value = null
  avatarPreview.value = null
  form.value.profileImage = ''
  
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

// Télécharger l'avatar si un nouveau fichier est sélectionné
const uploadAvatar = async () => {
  if (!avatarFile.value) return form.value.profileImage
  
  try {
    // Créer un nom de fichier unique
    const fileExt = avatarFile.value.name.split('.').pop()
    const fileName = `${user.value.id}-${Date.now()}.${fileExt}`
    const filePath = `avatars/${fileName}`
    
    // Télécharger le fichier
    const { error: uploadError } = await supabase
      .storage
      .from('avatars')
      .upload(filePath, avatarFile.value)
    
    if (uploadError) throw uploadError
    
    // Obtenir l'URL publique
    const { data } = supabase
      .storage
      .from('avatars')
      .getPublicUrl(filePath)
    
    return data.publicUrl
  } catch (error) {
    console.error('Erreur lors du téléchargement de l\'avatar:', error)
    showStatusMessage('error', 'Erreur lors du téléchargement de l\'avatar')
    return form.value.profileImage
  }
}

// Charger toutes les compétences depuis la base de données
const fetchSkills = async () => {
  try {
    // Récupérer les catégories
    const { data: categoriesData, error: categoriesError } = await supabase
      .from('categories')
      .select('id, name')
      .order('name');
    
    if (categoriesError) throw categoriesError;
    
    // Récupérer les compétences avec leurs catégories
    const { data: skillsData, error: skillsError } = await supabase
      .from('skills')
      .select('id, name, category_id')
      .order('name');
    
    if (skillsError) throw skillsError;
    
    // Stocker toutes les compétences
    allSkills.value = skillsData || [];
    
    // Organiser les compétences par catégorie
    skillCategories.value = categoriesData.map(category => ({
      ...category,
      skills: skillsData.filter(skill => skill.category_id === category.id)
    }));
    
    // Compétences sans catégorie
    uncategorizedSkills.value = skillsData.filter(skill => !skill.category_id);
    
  } catch (err) {
    console.error('Erreur lors du chargement des compétences:', err);
  }
};

// Charger les compétences de l'utilisateur
const fetchUserSkills = async () => {
  try {
    const { data, error } = await supabase
      .from('user_skills')
      .select('skill_id, skills(id, name)')
      .eq('user_id', user.value.id);
    
    if (error) throw error;
    
    selectedSkills.value = data.map(item => item.skills) || [];
  } catch (err) {
    console.error('Erreur lors du chargement des compétences de l\'utilisateur:', err);
  }
};

// Vérifier si une compétence est déjà sélectionnée
const isSkillSelected = (skillId) => {
  return selectedSkills.value.some(skill => skill.id === skillId);
};

// Ajouter la compétence sélectionnée
const addSelectedSkill = () => {
  if (!selectedSkillId.value) return;
  
  const skill = allSkills.value.find(s => s.id === selectedSkillId.value);
  if (skill && !isSkillSelected(skill.id)) {
    selectedSkills.value.push(skill);
    selectedSkillId.value = ''; // Réinitialiser la sélection
  }
};

// Supprimer une compétence
const removeSkill = (skill) => {
  selectedSkills.value = selectedSkills.value.filter(s => s.id !== skill.id);
};

// Sauvegarder les compétences de l'utilisateur
const saveUserSkills = async () => {
  try {
    // Supprimer toutes les compétences existantes
    const { error: deleteError } = await supabase
      .from('user_skills')
      .delete()
      .eq('user_id', user.value.id);
    
    if (deleteError) throw deleteError;
    
    // Ajouter les nouvelles compétences
    if (selectedSkills.value.length > 0) {
      const skillsToInsert = selectedSkills.value.map(skill => ({
        user_id: user.value.id,
        skill_id: skill.id
      }));
      
      const { error: insertError } = await supabase
        .from('user_skills')
        .insert(skillsToInsert);
      
      if (insertError) throw insertError;
    }
  } catch (err) {
    console.error('Erreur lors de la sauvegarde des compétences:', err);
    throw err;
  }
};

// Mettre à jour le profil
const updateProfile = async () => {
  isSaving.value = true
  
  try {
    // Validation des champs requis
    if (!form.value.firstName || !form.value.lastName) {
      showStatusMessage('error', 'Le prénom et le nom sont requis')
      isSaving.value = false
      return
    }
    
    // Télécharger l'avatar si nécessaire
    const avatarUrl = await uploadAvatar()
    
    // Préparer les données
    const updates = {
      first_name: form.value.firstName,
      last_name: form.value.lastName,
      phone: form.value.phone,
      birthdate: form.value.birthdate,
      // gender: form.value.gender,
      address: form.value.address,
      city: form.value.city,
      country: form.value.country,
      bio: form.value.bio,
      avatar_url: avatarUrl,
      website: form.value.website,
      // skills: form.value.skills,
      updated_at: new Date().toISOString()
    }
    
    // Mettre à jour le profil
    const { error } = await supabase
      .from('profiles')
      .update(updates)
      .eq('id', user.value.id)
    
    if (error) throw error
    
    // Sauvegarder les compétences
    await saveUserSkills()
    
    // Mettre à jour les valeurs initiales
    initialForm.value = { ...form.value }
    
    // Réinitialiser l'état du téléchargement
    avatarFile.value = null
    avatarPreview.value = null
    
    showStatusMessage('success', 'Profil mis à jour avec succès')
    
    // Rediriger vers la page de profil
    setTimeout(() => {
      router.push('/account')
    }, 1000)
    
  } catch (error) {
    console.error('Erreur lors de la mise à jour du profil:', error)
    showStatusMessage('error', 'Erreur lors de la mise à jour de votre profil')
  } finally {
    isSaving.value = false
  }
}

const resetForm = () => {
  // Réinitialiser le formulaire avec les valeurs initiales
  form.value = { ...initialForm.value }
  
  // Réinitialiser l'avatar
  avatarFile.value = null
  avatarPreview.value = null
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

const showStatusMessage = (type, message, duration = 5000) => {
  statusMessage.value = {
    show: true,
    type,
    message
  }
  
  setTimeout(() => {
    statusMessage.value.show = false
  }, duration)
}

// Fermer le dropdown des compétences en cliquant ailleurs
const handleClickOutside = (event) => {
  if (showSkillResults.value && !event.target.closest('.skills-dropdown')) {
    showSkillResults.value = false;
  }
};

// Initialisation
onMounted(() => {
  fetchProfile()
  fetchSkills()
  fetchUserSkills()
  document.addEventListener('click', handleClickOutside)
})

// Ajouter à onBeforeUnmount
onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
})

// Vous pouvez ajouter ce bloc en haut de chaque fichier
definePageMeta({
  layout: 'default',
  middleware: 'auth'
})

// Compétences populaires (à adapter selon votre domaine)
const popularSkills = computed(() => {
  // Filtrer les compétences déjà sélectionnées
  return [
    { id: 1, name: 'JavaScript' },
    { id: 2, name: 'Design UX/UI' },
    { id: 3, name: 'Marketing Digital' },
    { id: 4, name: 'Rédaction Web' },
    { id: 5, name: 'SEO' },
    { id: 6, name: 'Photographie' },
    { id: 7, name: 'Montage Vidéo' },
    { id: 8, name: 'Traduction' }
  ].filter(skill => {
    // Vérifier si la compétence existe dans allSkills
    const existingSkill = allSkills.value.find(s => s.name === skill.name);
    // Si elle existe, utiliser son ID réel
    if (existingSkill) {
      skill.id = existingSkill.id;
      // Ne pas l'afficher si déjà sélectionnée
      return !isSkillSelected(existingSkill.id);
    }
    return true;
  });
});

// Ajouter une compétence (modifié pour gérer les compétences populaires)
const addSkill = async (skill) => {
  // Si la compétence n'existe pas dans la base de données
  if (!allSkills.value.some(s => s.id === skill.id)) {
    try {
      // Créer la compétence dans la base de données
      const { data, error } = await supabase
        .from('skills')
        .insert({ name: skill.name })
        .select()
        .single();
      
      if (error) throw error;
      
      // Mettre à jour l'ID avec celui de la base de données
      skill = data;
      // Ajouter à la liste des compétences
      allSkills.value.push(skill);
    } catch (err) {
      console.error('Erreur lors de la création de la compétence:', err);
      return;
    }
  }
  
  // Ajouter à la sélection si pas déjà présente
  if (!selectedSkills.value.some(s => s.id === skill.id)) {
    selectedSkills.value.push(skill);
  }
};
definePageMeta({
  layout: 'account',
  middleware: 'auth'
})
</script>

<style scoped>
.switch {
  position: relative;
  display: inline-block;
  width: 44px;
  height: 24px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: .3s;
  border-radius: 34px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .3s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #4f46e5;
}

input:focus + .slider {
  box-shadow: 0 0 1px #4f46e5;
}

input:checked + .slider:before {
  transform: translateX(20px);
}

/* Dark mode styles */
.dark input:checked + .slider {
  background-color: #6366f1;
}

.dark input:focus + .slider {
  box-shadow: 0 0 1px #6366f1;
}

/* Ajoutez ces styles pour les interrupteurs de disponibilité */
.switch-toggle {
  width: 36px;
  height: 20px;
  background-color: #ccc;
  border-radius: 34px;
  position: relative;
  transition: .3s;
}

.switch-toggle:before {
  content: "";
  position: absolute;
  height: 16px;
  width: 16px;
  left: 2px;
  bottom: 2px;
  background-color: white;
  border-radius: 50%;
  transition: .3s;
}

input:checked + .switch-toggle {
  background-color: #4f46e5;
}

input:checked + .switch-toggle:before {
  transform: translateX(16px);
}

.dark input:checked + .switch-toggle {
  background-color: #6366f1;
}
</style> 