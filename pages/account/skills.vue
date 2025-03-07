<template>
    <div>
      <!-- En-tête de la section -->
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900 dark:text-white">Mes compétences et spécialités</h2>
        
        <button 
          v-if="!isExpert && currentUser"
          @click="becomeExpert"
          class="inline-flex items-center px-4 py-2 bg-primary-600 rounded-full text-sm font-medium text-white hover:bg-primary-700"
        >
          <Star class="h-4 w-4 mr-2" />
          Devenir expert
        </button>
      </div>
      
      <!-- Notification pour utilisateurs non-experts -->
      <div v-if="!isExpert && currentUser" class="bg-amber-50 border border-amber-200 rounded-xl p-4 mb-6">
        <div class="flex">
          <Info class="h-5 w-5 text-amber-500 mr-3 flex-shrink-0" />
          <div>
            <p class="text-sm text-amber-800">
              Vous devez devenir expert pour pouvoir gérer vos compétences et proposer vos services. 
              Cliquez sur "Devenir expert" pour commencer.
            </p>
          </div>
        </div>
      </div>
      
      <!-- Section expertise (seulement pour les experts) -->
      <div v-if="isExpert">
        <!-- Gestion des compétences -->
        <div class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden shadow-sm border border-gray-100 dark:border-gray-700 mb-8">
          <div class="p-5 border-b border-gray-100 dark:border-gray-700 flex justify-between items-center">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Compétences</h3>
            <button 
              @click="showAddSkillModal = true"
              class="text-sm font-medium text-primary-600 dark:text-primary-400 hover:underline flex items-center"
            >
              <Plus class="h-4 w-4 mr-1" />
              Ajouter
            </button>
          </div>
          
          <div class="p-5">
            <div v-if="userSkills.length > 0" class="flex flex-wrap gap-2">
              <div 
                v-for="skill in userSkills" 
                :key="skill.id"
                class="group flex items-center bg-gray-100 dark:bg-gray-700 rounded-full pl-3 pr-2 py-1 text-sm"
              >
                <span class="text-gray-800 dark:text-gray-200">{{ skill.name }}</span>
                <button 
                  @click="removeSkill(skill.id)"
                  class="ml-2 h-5 w-5 rounded-full bg-gray-200 dark:bg-gray-600 text-gray-500 dark:text-gray-400 flex items-center justify-center hover:bg-gray-300 dark:hover:bg-gray-500 transition-colors"
                >
                  <X class="h-3 w-3" />
                </button>
              </div>
            </div>
            
            <div v-else class="text-center py-4">
              <div class="text-gray-500 dark:text-gray-400 text-sm">
                Aucune compétence ajoutée
              </div>
            </div>
          </div>
        </div>
        
        <!-- Catégories de services -->
        <div class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden shadow-sm border border-gray-100 dark:border-gray-700 mb-8">
          <div class="p-5 border-b border-gray-100 dark:border-gray-700">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Catégories de services</h3>
            <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
              Sélectionnez les catégories dans lesquelles vous proposez vos services
            </p>
          </div>
          
          <div class="p-5">
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div 
                v-for="category in serviceCategories" 
                :key="category.id"
                class="flex items-start"
              >
                <input 
                  type="checkbox"
                  :id="`category-${category.id}`"
                  v-model="selectedCategories"
                  :value="category.id"
                  class="h-5 w-5 rounded text-primary-600 border-gray-300 focus:ring-primary-500 mt-0.5"
                />
                <label 
                  :for="`category-${category.id}`"
                  class="ml-3 text-sm text-gray-700 dark:text-gray-300"
                >
                  {{ category.name }}
                  <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                    {{ category.description }}
                  </p>
                </label>
              </div>
            </div>
            
            <div class="mt-6 flex justify-end">
              <button 
                @click="saveCategories"
                class="px-4 py-2 bg-primary-600 text-white rounded-md text-sm font-medium hover:bg-primary-700"
              >
                Enregistrer les catégories
              </button>
            </div>
          </div>
        </div>
        
        <!-- Tarifs -->
        <div class="bg-white dark:bg-gray-800 rounded-xl overflow-hidden shadow-sm border border-gray-100 dark:border-gray-700">
          <div class="p-5 border-b border-gray-100 dark:border-gray-700">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Tarifs horaires</h3>
            <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
              Définissez votre tarif horaire par défaut
            </p>
          </div>
          
          <div class="p-5">
            <div class="mb-4">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Tarif horaire (€)
              </label>
              <div class="relative">
                <input 
                  v-model="hourlyRate"
                  type="number" 
                  min="1" 
                  step="1"
                  class="pl-3 pr-10 py-2 block w-full border-gray-300 dark:border-gray-700 dark:bg-gray-800 rounded-md focus:ring-primary-500 focus:border-primary-500"
                />
                <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                  <span class="text-gray-500">€/h</span>
                </div>
              </div>
            </div>
            
            <div class="flex justify-end">
              <button 
                @click="saveHourlyRate"
                class="px-4 py-2 bg-primary-600 text-white rounded-md text-sm font-medium hover:bg-primary-700"
              >
                Enregistrer le tarif
              </button>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Modal d'ajout de compétence -->
      <div v-if="showAddSkillModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
        <div class="bg-white dark:bg-gray-800 rounded-xl p-6 max-w-md w-full">
          <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Ajouter une compétence</h3>
          
          <div class="relative">
            <input 
              v-model="newSkill"
              type="text" 
              placeholder="Tapez une compétence..."
              @input="searchSkills"
              class="block w-full border-gray-300 dark:border-gray-700 dark:bg-gray-800 rounded-md focus:ring-primary-500 focus:border-primary-500"
            />
            
            <div 
              v-if="filteredSkills.length > 0 && newSkill.length > 0"
              class="absolute z-10 mt-1 w-full bg-white dark:bg-gray-800 shadow-lg rounded-md border border-gray-200 dark:border-gray-700 max-h-60 overflow-auto"
            >
              <div
                v-for="skill in filteredSkills"
                :key="skill.id"
                @click="selectSkill(skill)"
                class="px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-700 cursor-pointer text-sm text-gray-700 dark:text-gray-300"
              >
                {{ skill.name }}
              </div>
            </div>
          </div>
          
          <div class="flex justify-end gap-3 mt-6">
            <button 
              @click="showAddSkillModal = false"
              class="px-4 py-2 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-md text-sm font-medium hover:bg-gray-200 dark:hover:bg-gray-600"
            >
              Annuler
            </button>
            <button 
              @click="addSkill()"
              :disabled="newSkill.trim().length === 0"
              class="px-4 py-2 bg-primary-600 text-white rounded-md text-sm font-medium hover:bg-primary-700 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Ajouter
            </button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue'
  import { useSupabaseClient, useSupabaseUser } from '#imports'
  import {
    Star, Plus, X, Info
  } from 'lucide-vue-next'
  
  // Composables
  const supabase = useSupabaseClient()
  const currentUser = useSupabaseUser()
  
  // États
  const userData = ref(null)
  const isExpert = ref(false)
  const userSkills = ref([])
  const availableSkills = ref([])
  const serviceCategories = ref([])
  const selectedCategories = ref([])
  const showAddSkillModal = ref(false)
  const newSkill = ref('')
  const filteredSkills = ref([])
  const hourlyRate = ref(0)
  
  // Méthodes
  const fetchData = async () => {
    try {
      // Récupérer les compétences
      const { data: skills, error: skillsError } = await supabase
        .from('skills')
        .select('*')
        .order('name')
      
      if (skillsError) throw skillsError
      availableSkills.value = skills
      
      // Récupérer les catégories de services
      const { data: categories, error: categoriesError } = await supabase
        .from('service_categories')
        .select('*')
        .order('name')
      
      if (categoriesError) throw categoriesError
      serviceCategories.value = categories
      
      // Récupérer les données de l'utilisateur
      const { data: user, error: userError } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', currentUser.value.id)
        .single()
      
      if (userError) throw userError
      userData.value = user
      isExpert.value = user.is_expert || false
      hourlyRate.value = user.hourly_rate || 25
      
      // Si l'utilisateur est un expert, récupérer ses compétences
      if (isExpert.value) {
        await fetchUserSkills()
        await fetchUserCategories()
      }
    } catch (error) {
      console.error('Erreur lors du chargement des données:', error)
    }
  }
  
  // Récupérer les compétences de l'utilisateur
  const fetchUserSkills = async () => {
    try {
      const { data, error } = await supabase
        .from('profile_skills')
        .select(`
          skill_id,
          skills:skill_id (
            id,
            name
          )
        `)
        .eq('profile_id', currentUser.value.id)
      
      if (error) throw error
      
      userSkills.value = data.map(item => ({
        id: item.skills.id,
        name: item.skills.name
      }))
    } catch (error) {
      console.error('Erreur lors du chargement des compétences:', error)
    }
  }
  
  // Récupérer les catégories de services de l'utilisateur
  const fetchUserCategories = async () => {
    try {
      const { data, error } = await supabase
        .from('expert_services')
        .select('service_id')
        .eq('expert_id', currentUser.value.id)
      
      if (error) throw error
      
      selectedCategories.value = data.map(item => item.service_id)
    } catch (error) {
      console.error('Erreur lors du chargement des catégories:', error)
    }
  }
  
  // Rechercher des compétences
  const searchSkills = () => {
    if (newSkill.value.trim() === '') {
      filteredSkills.value = []
      return
    }
    
    const search = newSkill.value.toLowerCase().trim()
    filteredSkills.value = availableSkills.value
      .filter(skill => 
        skill.name.toLowerCase().includes(search) &&
        !userSkills.value.some(s => s.id === skill.id)
      )
      .slice(0, 10)
  }
  
  // Sélectionner une compétence existante
  const selectSkill = (skill) => {
    addSkill(skill.id)
  }
  
  // Devenir expert
  const becomeExpert = async () => {
    try {
      const { data, error } = await supabase
        .from('profiles')
        .update({
          is_expert: true,
          expert_since: new Date().toISOString(),
          hourly_rate: 25,
          verification_status: 'pending'
        })
        .eq('id', currentUser.value.id)
      
      if (error) throw error
      
      // Créer une entrée dans la table experts
      const { error: expertError } = await supabase
        .from('experts')
        .insert({
          id: currentUser.value.id,
          status: 'active',
          visibility: 'public'
        })
      
      if (expertError) throw expertError
      
      // Mise à jour de l'état
      isExpert.value = true
      hourlyRate.value = 25
      
      // Notification à l'utilisateur
      alert('Félicitations ! Vous êtes maintenant un expert. Complétez votre profil pour commencer à recevoir des demandes.')
    } catch (error) {
      console.error('Erreur lors de la conversion en expert:', error)
      alert('Une erreur est survenue. Veuillez réessayer.')
    }
  }
  
  // Ajouter une compétence
  const addSkill = async (skillId = null) => {
    try {
      let skillToAdd
      
      if (skillId) {
        // Compétence existante
        skillToAdd = availableSkills.value.find(s => s.id === skillId)
      } else {
        // Nouvelle compétence à créer
        const skillName = newSkill.value.trim()
        if (!skillName) return
        
        // Vérifier si la compétence existe déjà
        const existingSkill = availableSkills.value.find(
          s => s.name.toLowerCase() === skillName.toLowerCase()
        )
        
        if (existingSkill) {
          skillToAdd = existingSkill
        } else {
          // Créer une nouvelle compétence
          const { data, error } = await supabase
            .from('skills')
            .insert({ name: skillName })
            .select()
            .single()
          
          if (error) throw error
          
          skillToAdd = data
          availableSkills.value.push(skillToAdd)
        }
      }
      
      // Vérifier si l'utilisateur a déjà cette compétence
      if (userSkills.value.some(s => s.id === skillToAdd.id)) {
        showAddSkillModal.value = false
        newSkill.value = ''
        return
      }
      
      // Ajouter la compétence à l'utilisateur
      const { error } = await supabase
        .from('profile_skills')
        .insert({
          profile_id: currentUser.value.id,
          skill_id: skillToAdd.id
        })
      
      if (error) throw error
      
      // Ajouter à la liste locale
      userSkills.value.push({
        id: skillToAdd.id,
        name: skillToAdd.name
      })
      
      showAddSkillModal.value = false
      newSkill.value = ''
    } catch (error) {
      console.error('Erreur lors de l\'ajout de la compétence:', error)
    }
  }
  
  // Supprimer une compétence
  const removeSkill = async (skillId) => {
    try {
      const { error } = await supabase
        .from('profile_skills')
        .delete()
        .eq('profile_id', currentUser.value.id)
        .eq('skill_id', skillId)
      
      if (error) throw error
      
      // Supprimer de la liste locale
      userSkills.value = userSkills.value.filter(s => s.id !== skillId)
    } catch (error) {
      console.error('Erreur lors de la suppression de la compétence:', error)
    }
  }
  
  // Sauvegarder les catégories
  const saveCategories = async () => {
    try {
      // Supprimer toutes les catégories existantes
      const { error: deleteError } = await supabase
        .from('expert_services')
        .delete()
        .eq('expert_id', currentUser.value.id)
      
      if (deleteError) throw deleteError
      
      // Aucune catégorie sélectionnée
      if (selectedCategories.value.length === 0) return
      
      // Ajouter les nouvelles catégories
      const servicesToInsert = selectedCategories.value.map(serviceId => ({
        expert_id: currentUser.value.id,
        service_id: serviceId
      }))
      
      const { error } = await supabase
        .from('expert_services')
        .insert(servicesToInsert)
      
      if (error) throw error
      
      // Notification de succès
      alert('Catégories enregistrées avec succès')
    } catch (error) {
      console.error('Erreur lors de la sauvegarde des catégories:', error)
    }
  }
  
  // Sauvegarder le tarif horaire
  const saveHourlyRate = async () => {
    try {
      const rate = parseFloat(hourlyRate.value)
      if (isNaN(rate) || rate <= 0) {
        alert('Veuillez saisir un tarif horaire valide')
        return
      }
      
      const { error } = await supabase
        .from('profiles')
        .update({
          hourly_rate: rate
        })
        .eq('id', currentUser.value.id)
      
      if (error) throw error
      
      // Notification de succès
      alert('Tarif horaire mis à jour avec succès')
    } catch (error) {
      console.error('Erreur lors de la mise à jour du tarif:', error)
    }
  }
  
  // Initialisation
  onMounted(() => {
    fetchData()
  })
  </script>
  
    