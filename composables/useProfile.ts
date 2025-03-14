import { ref } from 'vue'
import { useSupabaseClient, useSupabaseUser } from '#imports'
import type { Database } from '~/types/database'

// Types pour le profil
interface NotificationPreferences {
  email: boolean;
  sms: boolean;
  app: boolean;
  messages: boolean;
  proposals: boolean;
  contracts: boolean;
  payments: boolean;
}

interface ExpertDetails {
  hourlyRate: number | null;
  profession: string | null;
  bio: string | null;
  experience: number | null;
  isAvailable: boolean;
  isVerified: boolean;
  skills: Array<{ id: number; name: string }>;
  categories: Array<{ id: number; name: string }>;
}

interface UserProfile {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string | null;
  avatarUrl: string | null;
  isExpert: boolean;
  notificationPreferences: NotificationPreferences;
  expertDetails?: ExpertDetails;
  createdAt: string;
}

interface ProfileUpdateData {
  firstName?: string;
  lastName?: string;
  email?: string;
  phone?: string;
}

interface ExpertProfileUpdateData {
  hourlyRate?: number;
  profession?: string;
  bio?: string;
  experience?: number;
  isAvailable?: boolean;
  skills?: number[];
  categories?: number[];
}

export function useProfile() {
  const supabase = useSupabaseClient<Database>()
  const user = useSupabaseUser()
  
  // État réactif
  const profile = ref<UserProfile | null>(null)
  const isLoading = ref<boolean>(false)
  const error = ref<string | null>(null)
  
  /**
   * Récupère le profil de l'utilisateur connecté
   */
  const fetchUserProfile = async (): Promise<UserProfile | null> => {
    if (!user.value?.id) {
      error.value = 'Utilisateur non connecté'
      return null
    }
    
    isLoading.value = true
    error.value = null
    
    try {
      const { data, error: apiError } = await supabase
        .from('profiles')
        .select(`
          *
        `)
        .eq('id', user.value.id)
        .single()
      
      if (apiError) throw apiError
      
      // Formater les données du profil
      profile.value = {
        id: data.id,
        firstName: data.first_name,
        lastName: data.last_name,
        email: data.email,
        phone: data.phone,
        avatarUrl: data.avatar_url,
        isExpert: data.is_expert,
        notificationPreferences: data.notification_preferences || {
          email: true,
          sms: true,
          app: true,
          messages: true,
          proposals: true,
          contracts: true,
          payments: true
        },
        createdAt: data.created_at
      }
      
      // Ajouter les détails d'expert si l'utilisateur est un expert
      if (data.is_expert) {
        profile.value.expertDetails = {
          hourlyRate: data.hourly_rate,
          profession: data.profession,
          bio: data.bio,
          experience: data.experience,
          isAvailable: data.is_available,
          isVerified: data.is_verified,
          skills: data.skills || [],
          categories: data.categories || []
        }
      }
      
      return profile.value
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'Erreur inconnue'
      console.error('Error fetching user profile:', e)
      error.value = errorMessage || 'Erreur lors du chargement du profil'
      return null
    } finally {
      isLoading.value = false
    }
  }
  
  /**
   * Met à jour les informations de base du profil
   */
  const updateProfile = async (profileData: ProfileUpdateData): Promise<boolean> => {
    if (!user.value?.id) {
      error.value = 'Utilisateur non connecté'
      return false
    }
    
    isLoading.value = true
    error.value = null
    
    try {
      // Mapper les données du format camelCase au format snake_case
      const updateData = {
        first_name: profileData.firstName,
        last_name: profileData.lastName,
        email: profileData.email,
        phone: profileData.phone
      }
      
      const { error: apiError } = await supabase
        .from('profiles')
        .update(updateData)
        .eq('id', user.value.id)
      
      if (apiError) throw apiError
      
      // Mettre à jour le profil en mémoire
      if (profile.value) {
        profile.value = {
          ...profile.value,
          firstName: profileData.firstName || profile.value.firstName,
          lastName: profileData.lastName || profile.value.lastName,
          email: profileData.email || profile.value.email,
          phone: profileData.phone || profile.value.phone
        }
      }
      
      return true
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'Erreur inconnue'
      console.error('Error updating profile:', e)
      error.value = errorMessage || 'Erreur lors de la mise à jour du profil'
      return false
    } finally {
      isLoading.value = false
    }
  }
  
  /**
   * Upload une nouvelle image de profil
   */
  const uploadAvatar = async (file: File): Promise<string | null> => {
    if (!user.value?.id) {
      error.value = 'Utilisateur non connecté'
      return null
    }
    
    isLoading.value = true
    error.value = null
    
    try {
      // Vérification de la taille et du type du fichier
      if (file.size > 2 * 1024 * 1024) {
        throw new Error('L\'image ne doit pas dépasser 2 Mo')
      }
      
      if (!file.type.match(/^image\/(jpeg|png|jpg)$/)) {
        throw new Error('Seuls les formats JPEG et PNG sont acceptés')
      }
      
      // Nom du fichier unique
      const fileExt = file.name.split('.').pop()
      const fileName = `${user.value.id}-${Date.now()}.${fileExt}`
      const filePath = `avatars/${fileName}`
      
      // Upload vers Supabase Storage
      const { error: uploadError } = await supabase
        .storage
        .from('profiles')
        .upload(filePath, file)
      
      if (uploadError) throw uploadError
      
      // Récupérer l'URL publique
      const { data: { publicUrl } } = supabase
        .storage
        .from('profiles')
        .getPublicUrl(filePath)
      
      // Mettre à jour le profil avec la nouvelle URL
      const { error: updateError } = await supabase
        .from('profiles')
        .update({ avatar_url: publicUrl })
        .eq('id', user.value.id)
      
      if (updateError) throw updateError
      
      // Mise à jour du profil en mémoire
      if (profile.value) {
        profile.value.avatarUrl = publicUrl
      }
      
      return publicUrl
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'Erreur inconnue'
      console.error('Error uploading avatar:', e)
      error.value = errorMessage || 'Erreur lors de l\'upload de l\'avatar'
      return null
    } finally {
      isLoading.value = false
    }
  }
  
  /**
   * Met à jour les préférences de notification
   */
  const updateNotificationPreferences = async (preferences: Partial<NotificationPreferences>): Promise<boolean> => {
    if (!user.value?.id || !profile.value) {
      error.value = 'Utilisateur non connecté ou profil non chargé'
      return false
    }
    
    isLoading.value = true
    error.value = null
    
    try {
      // Fusion des préférences existantes avec les nouvelles
      const updatedPreferences = {
        ...profile.value.notificationPreferences,
        ...preferences
      }
      
      const { error: apiError } = await supabase
        .from('profiles')
        .update({ notification_preferences: updatedPreferences })
        .eq('id', user.value.id)
      
      if (apiError) throw apiError
      
      // Mise à jour en mémoire
      profile.value.notificationPreferences = updatedPreferences
      
      return true
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'Erreur inconnue'
      console.error('Error updating notification preferences:', e)
      error.value = errorMessage || 'Erreur lors de la mise à jour des préférences'
      return false
    } finally {
      isLoading.value = false
    }
  }
  
  /**
   * Active ou désactive le statut d'expert
   */
  const toggleExpertStatus = async (becomeExpert: boolean): Promise<boolean> => {
    if (!user.value?.id) {
      error.value = 'Utilisateur non connecté'
      return false
    }
    
    isLoading.value = true
    error.value = null
    
    try {
      const { error: apiError } = await supabase
        .from('profiles')
        .update({ is_expert: becomeExpert })
        .eq('id', user.value.id)
      
      if (apiError) throw apiError
      
      // Mise à jour en mémoire
      if (profile.value) {
        profile.value.isExpert = becomeExpert
        
        // Initialiser les détails d'expert si l'utilisateur devient expert
        if (becomeExpert && !profile.value.expertDetails) {
          profile.value.expertDetails = {
            hourlyRate: null,
            profession: null,
            bio: null,
            experience: null,
            isAvailable: true,
            isVerified: false,
            skills: [],
            categories: []
          }
        }
      }
      
      return true
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'Erreur inconnue'
      console.error('Error toggling expert status:', e)
      error.value = errorMessage || 'Erreur lors du changement de statut d\'expert'
      return false
    } finally {
      isLoading.value = false
    }
  }
  
  /**
   * Met à jour le profil expert
   */
  const updateExpertProfile = async (expertData: ExpertProfileUpdateData): Promise<boolean> => {
    if (!user.value?.id || !profile.value?.isExpert) {
      error.value = 'Utilisateur non connecté ou n\'est pas un expert'
      return false
    }
    
    isLoading.value = true
    error.value = null
    
    try {
      // Mapper les données au format snake_case
      const updateData = {
        hourly_rate: expertData.hourlyRate,
        profession: expertData.profession,
        bio: expertData.bio,
        experience: expertData.experience,
        is_available: expertData.isAvailable
      }
      
      const { error: apiError } = await supabase
        .from('profiles')
        .update(updateData)
        .eq('id', user.value.id)
      
      if (apiError) throw apiError
      
      // Si des compétences sont fournies, les mettre à jour
      if (expertData.skills && expertData.skills.length > 0) {
        // D'abord supprimer les associations existantes
        await supabase
          .from('profile_skills')
          .delete()
          .eq('profile_id', user.value.id)
        
        // Puis ajouter les nouvelles
        const skillsToInsert = expertData.skills.map(skillId => ({
          profile_id: user.value.id,
          skill_id: skillId
        }))
        
        const { error: skillsError } = await supabase
          .from('profile_skills')
          .insert(skillsToInsert)
        
        if (skillsError) throw skillsError
      }
      
      // Si des catégories sont fournies, les mettre à jour
      if (expertData.categories && expertData.categories.length > 0) {
        // D'abord supprimer les associations existantes
        await supabase
          .from('profile_categories')
          .delete()
          .eq('profile_id', user.value.id)
        
        // Puis ajouter les nouvelles
        const categoriesToInsert = expertData.categories.map(categoryId => ({
          profile_id: user.value.id,
          category_id: categoryId
        }))
        
        const { error: categoriesError } = await supabase
          .from('profile_categories')
          .insert(categoriesToInsert)
        
        if (categoriesError) throw categoriesError
      }
      
      // Mettre à jour le profil en mémoire
      if (profile.value && profile.value.expertDetails) {
        profile.value.expertDetails = {
          ...profile.value.expertDetails,
          hourlyRate: expertData.hourlyRate ?? profile.value.expertDetails.hourlyRate,
          profession: expertData.profession ?? profile.value.expertDetails.profession,
          bio: expertData.bio ?? profile.value.expertDetails.bio,
          experience: expertData.experience ?? profile.value.expertDetails.experience,
          isAvailable: expertData.isAvailable ?? profile.value.expertDetails.isAvailable
        }
        
        // Recharger le profil complet pour avoir les données mises à jour
        await fetchUserProfile()
      }
      
      return true
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'Erreur inconnue'
      console.error('Error updating expert profile:', e)
      error.value = errorMessage || 'Erreur lors de la mise à jour du profil expert'
      return false
    } finally {
      isLoading.value = false
    }
  }
  
  /**
   * Formate le nom complet de l'utilisateur
   */
  const getFullName = computed(() => {
    if (!profile.value) return ''
    return `${profile.value.firstName} ${profile.value.lastName}`
  })
  
  return {
    profile,
    isLoading,
    error,
    fetchUserProfile,
    updateProfile,
    uploadAvatar,
    updateNotificationPreferences,
    toggleExpertStatus,
    updateExpertProfile,
    getFullName
  }
} 