import { useSupabaseClient } from '#imports'
import type { Expert } from '~/types/models'

export const useExpertService = () => {
  const supabase = useSupabaseClient()
  
  /**
   * Récupère tous les experts, avec filtrage optionnel par catégorie
   */
  const getExperts = async (categoryId: number | null = null) => {
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
        professions(id, name),
        skills(id, name)
      `)
      .eq('is_expert', true)
    
    // Ajouter le filtre par catégorie si spécifié
    if (categoryId) {
      query = query.eq('professions.id', categoryId)
    }
    
    const { data, error } = await query
    
    if (error) {
      console.error('Error fetching experts:', error)
      throw error
    }
    
    return data
  }
  
  /**
   * Récupère un expert par son ID
   */
  const getExpertById = async (id: string) => {
    const { data, error } = await supabase
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
        professions(id, name),
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
    
    if (error) {
      console.error('Error fetching expert:', error)
      throw error
    }
    
    return data
  }
  
  return {
    getExperts,
    getExpertById
  }
} 