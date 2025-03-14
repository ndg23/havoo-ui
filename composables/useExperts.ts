import { ref, computed } from 'vue'
import { useSupabaseClient } from '#imports'
import type { Database } from '~/types/database'

export function useExperts() {
  const supabase = useSupabaseClient<Database>()
  
  // État réactif
  const experts = ref([])
  const currentExpert = ref(null)
  const isLoading = ref(false)
  const error = ref(null)
  
  /**
   * Récupère tous les experts, avec filtrage optionnel par catégorie
   */
  const fetchExperts = async (categoryId = null) => {
    isLoading.value = true
    error.value = null
    
    try {
      let query = supabase
        .from('profiles')
        .select(`
          id,
          first_name,
          last_name,
          avatar_url,
          profession,
          bio,
          experience,
          is_verified,
          is_available,
          hourly_rate,
          categories(id, name),
          skills(id, name)
        `)
        .eq('is_expert', true)
      
      // Ajouter le filtre par catégorie si spécifié
      if (categoryId) {
        query = query.eq('categories.id', categoryId)
      }
      
      const { data, error: apiError } = await query
      
      if (apiError) throw apiError
      
      // Formater les données si nécessaire
      experts.value = data.map(expert => ({
        id: expert.id,
        firstName: expert.first_name,
        lastName: expert.last_name,
        profile_image: expert.avatar_url,
        specialty: expert.profession,
        bio: expert.bio,
        skills: expert.skills?.map(s => s.name) || [],
        rating: 4.5, // À remplacer par une vraie moyenne de notes
        reviewCount: 15, // À remplacer par un vrai compteur
        hourlyRate: formatCurrency(expert.hourly_rate || 0),
        isVerified: expert.is_verified,
        isAvailable: expert.is_available,
        categories: expert.categories
      }))
      
      return experts.value
    } catch (e) {
      console.error('Error fetching experts:', e)
      error.value = e.message || 'Erreur lors du chargement des experts'
      return []
    } finally {
      isLoading.value = false
    }
  }
  
  /**
   * Récupère un expert par son ID
   */
  const fetchExpertById = async (id: string) => {
    isLoading.value = true
    error.value = null
    
    try {
      const { data, error: apiError } = await supabase
        .from('profiles')
        .select(`
          id,
          first_name,
          last_name,
          avatar_url,
          profession,
          bio,
          experience,
          is_verified,
          is_available,
          hourly_rate,
          categories(id, name),
          skills(id, name),
          reviews(
            id, 
            rating, 
            comment, 
            created_at,
            profiles(id, first_name, last_name, avatar_url)
          )
        `)
        .eq('id', id)
        .eq('is_expert', true)
        .single()
      
      if (apiError) throw apiError
      
      // Formater l'expert
      currentExpert.value = {
        id: data.id,
        firstName: data.first_name,
        lastName: data.last_name,
        profile_image: data.avatar_url,
        specialty: data.profession,
        bio: data.bio,
        skills: data.skills?.map(s => s.name) || [],
        rating: calculateAverageRating(data.reviews || []),
        reviewCount: data.reviews?.length || 0,
        hourlyRate: formatCurrency(data.hourly_rate || 0),
        isVerified: data.is_verified,
        isAvailable: data.is_available,
        categories: data.categories,
        reviews: data.reviews || []
      }
      
      return currentExpert.value
    } catch (e) {
      console.error('Error fetching expert:', e)
      error.value = e.message || 'Erreur lors du chargement de l\'expert'
      return null
    } finally {
      isLoading.value = false
    }
  }
  
  // Fonction utilitaire pour calculer la note moyenne
  const calculateAverageRating = (reviews: any[]) => {
    if (!reviews.length) return 0
    const sum = reviews.reduce((acc: number, review: any) => acc + review.rating, 0)
    return (sum / reviews.length).toFixed(1)
  }
  
  // Fonction utilitaire pour formater la devise
    const formatCurrency = (amount: string | number | bigint) => {
    return new Intl.NumberFormat('fr-FR', { 
      style: 'currency', 
      currency: 'XOF',
      maximumFractionDigits: 0 
    }).format(amount)
  }
  
  return {
    experts,
    currentExpert,
    isLoading,
    error,
    fetchExperts,
    fetchExpertById
  }
} 