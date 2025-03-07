<template>
    <div class="min-h-screen bg-white">
      <!-- Navigation du compte - style Uber -->
      <div class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 z-40 md:relative md:border-t-0 md:border-b md:mb-8">
        <div class="max-w-4xl mx-auto px-2 md:px-5">
          <div class="flex justify-between items-center overflow-x-auto no-scrollbar">
            <NuxtLink 
              v-for="item in navItems" 
              :key="item.path"
              :to="item.path"
              class="flex flex-col items-center py-3 px-3 min-w-[72px] md:min-w-0 md:flex-row md:py-4"
              :class="$route.path === item.path ? 'text-black' : 'text-gray-400 hover:text-gray-600'"
            >
              <component :is="item.icon" class="h-6 w-6 mb-1 md:mr-2 md:mb-0" />
              <span class="text-xs md:text-sm font-medium">{{ item.name }}</span>
            </NuxtLink>
          </div>
        </div>
    </div>
    <div class="mt-16 max-w-7xl mx-auto px-4">
      <slot />
    </div>
     
    </div>
  </template>
  
  <script setup>
  import { ref, computed, reactive, onMounted } from 'vue'
  import { 
    User, Edit, Loader2, Mail, Phone, MapPin, Calendar, 
    Camera, Upload, LogOut, Home, Settings, FileText, 
    ShoppingBag, CalendarDays, AtSign, CreditCard
  } from 'lucide-vue-next'
  
  const router = useRouter()
  const client = useSupabaseClient()
  
  // États
  const loading = ref(true)
  const isEditing = ref(false)
  const isSaving = ref(false)
  const profile = ref({})
  const editedProfile = reactive({})
  
  // Menu de navigation
  const navItems = [
    { name: 'Profil', path: '/account', icon: User },
    { name: 'Demandes', path: '/account/my-demands', icon: FileText },
    { name: 'Services', path: '/account/my-services', icon: ShoppingBag },
    { name: 'Paiements', path: '/account/payments', icon: CreditCard },
    { name: 'Paramètres', path: '/account/settings', icon: Settings },
  ]
  
  // Formater la date
  const formatDate = (dateString) => {
    if (!dateString) return ''
    const date = new Date(dateString)
    return date.toLocaleDateString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    })
  }
  
  // Récupérer les données du profil
  const fetchProfile = async () => {
    try {
      loading.value = true
      
      // Récupérer l'utilisateur authentifié
      const { data: { user }, error: authError } = await client.auth.getUser()
      if (authError) throw authError
      if (!user) {
        // Rediriger vers la page de connexion si non authentifié
        router.push('/auth/login')
        return
      }
      
      // Récupérer les données du profil
      const { data, error } = await client
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .single()
      
      if (error) throw error
      
      profile.value = data || {}
      
      // Initialiser le formulaire d'édition
      Object.keys(profile.value).forEach(key => {
        editedProfile[key] = profile.value[key]
      })
    } catch (error) {
      console.error('Erreur lors de la récupération du profil:', error)
    } finally {
      loading.value = false
    }
  }
  
  // Sauvegarder les modifications du profil
  const saveProfile = async () => {
    try {
      // Validation des champs obligatoires
      if (!editedProfile.first_name?.trim() || !editedProfile.last_name?.trim()) {
        alert('Le prénom et le nom sont obligatoires')
        return
      }
      
      isSaving.value = true
      
      const { data: { user } } = await client.auth.getUser()
      if (!user) throw new Error('Non authentifié')
      
      const { error } = await client
        .from('profiles')
        .update({
          first_name: editedProfile.first_name,
          last_name: editedProfile.last_name,
          phone: editedProfile.phone,
          address: editedProfile.address,
          city: editedProfile.city,
          country: editedProfile.country,
          birthdate: editedProfile.birthdate,
          bio: editedProfile.bio,
          updated_at: new Date().toISOString()
        })
        .eq('id', user.id)
      
      if (error) throw error
      
      // Mettre à jour l'état local
      Object.keys(editedProfile).forEach(key => {
        profile.value[key] = editedProfile[key]
      })
      
      // Quitter le mode édition
      isEditing.value = false
    } catch (error) {
      console.error('Erreur lors de la mise à jour du profil:', error)
      alert('Une erreur est survenue lors de la mise à jour du profil')
    } finally {
      isSaving.value = false
    }
  }
  
  // Annuler les modifications
  const cancelEdit = () => {
    // Réinitialiser les valeurs du formulaire
    Object.keys(profile.value).forEach(key => {
      editedProfile[key] = profile.value[key]
    })
    isEditing.value = false
  }
  
  // Télécharger une nouvelle image de profil
  const uploadProfileImage = async (event) => {
    try {
      const file = event.target.files[0]
      if (!file) return
      
      const { data: { user } } = await client.auth.getUser()
      if (!user) throw new Error('Non authentifié')
      
      // Générer un nom de fichier unique
      const fileExt = file.name.split('.').pop()
      const fileName = `profile-${user.id}-${Date.now()}.${fileExt}`
      const filePath = `profile-images/${fileName}`
      
      // Télécharger le fichier
      const { error: uploadError } = await client.storage
        .from('avatars')
        .upload(filePath, file)
      
      if (uploadError) throw uploadError
      
      // Obtenir l'URL publique
      const { data } = client.storage
        .from('avatars')
        .getPublicUrl(filePath)
      
      const publicUrl = data.publicUrl
      
      // Mettre à jour le profil avec la nouvelle URL
      const { error: updateError } = await client
        .from('profiles')
        .update({ profile_image_url: publicUrl })
        .eq('id', user.id)
      
      if (updateError) throw updateError
      
      // Mettre à jour l'état local
      profile.value.profile_image_url = publicUrl
      editedProfile.profile_image_url = publicUrl
    } catch (error) {
      console.error('Erreur lors du téléchargement de l\'image:', error)
      alert('Une erreur est survenue lors du téléchargement de l\'image')
    }
  }
  
  // Télécharger une nouvelle image de bannière
  const uploadBannerImage = async (event) => {
    try {
      const file = event.target.files[0]
      if (!file) return
      
      const { data: { user } } = await client.auth.getUser()
      if (!user) throw new Error('Non authentifié')
      
      // Générer un nom de fichier unique
      const fileExt = file.name.split('.').pop()
      const fileName = `banner-${user.id}-${Date.now()}.${fileExt}`
      const filePath = `banner-images/${fileName}`
      
      // Télécharger le fichier
      const { error: uploadError } = await client.storage
        .from('avatars')
        .upload(filePath, file)
      
      if (uploadError) throw uploadError
      
      // Obtenir l'URL publique
      const { data } = client.storage
        .from('avatars')
        .getPublicUrl(filePath)
      
      const publicUrl = data.publicUrl
      
      // Mettre à jour le profil avec la nouvelle URL
      const { error: updateError } = await client
        .from('profiles')
        .update({ banner_image_url: publicUrl })
        .eq('id', user.id)
      
      if (updateError) throw updateError
      
      // Mettre à jour l'état local
      profile.value.banner_image_url = publicUrl
      editedProfile.banner_image_url = publicUrl
    } catch (error) {
      console.error('Erreur lors du téléchargement de la bannière:', error)
      alert('Une erreur est survenue lors du téléchargement de la bannière')
    }
  }
  
  // Déconnexion
  const logout = async () => {
    try {
      const { error } = await client.auth.signOut()
      if (error) throw error
      
      // Rediriger vers la page d'accueil
      router.push('/')
    } catch (error) {
      console.error('Erreur lors de la déconnexion:', error)
    }
  }
  
  // Charger les données lors du montage du composant
  onMounted(fetchProfile)
 
  </script> 
  
  <style scoped>
  /* Masquer la barre de défilement tout en permettant le défilement */
  .no-scrollbar::-webkit-scrollbar {
    display: none;
  }
  .no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }
  </style> 