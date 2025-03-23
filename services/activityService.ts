import { useSupabaseClient } from '#imports'

/**
 * Service pour gérer les activités d'administration
 */
export default class ActivityService {
  private supabase = useSupabaseClient()

  /**
   * Récupère les activités récentes
   * @param limit Nombre maximum d'activités à récupérer
   * @param offset Position de départ pour la pagination
   * @param type Filtrer par type d'activité
   * @returns Liste des activités récentes
   */
  async getRecentActivities(limit = 10, offset = 0, type = null) {
    try {
      let query = this.supabase
        .from('activities')
        .select(`
          id,
          created_at,
          type,
          title,
          description,
          user_id,
          related_id,
          related_type,
          metadata,
          profiles:user_id(id, first_name, last_name, avatar_url)
        `)
        .order('created_at', { ascending: false })
        .range(offset, offset + limit - 1)
      
      // Appliquer le filtre par type si spécifié
      if (type) {
        query = query.eq('type', type)
      }

      const { data, error } = await query
      
      if (error) throw error
      
      return data || []
    } catch (error) {
      console.error('Erreur lors de la récupération des activités:', error)
      throw error
    }
  }

  /**
   * Enregistre une nouvelle activité manuellement
   * @param activityData Données de l'activité
   * @returns L'activité créée
   */
  async createActivity(activityData) {
    try {
      const { data, error } = await this.supabase
        .from('activities')
        .insert(activityData)
        .select()
      
      if (error) throw error
      
      return data?.[0] || null
    } catch (error) {
      console.error('Erreur lors de la création de l\'activité:', error)
      throw error
    }
  }

  /**
   * Récupère le nombre d'activités par type pour une période donnée
   * @param days Nombre de jours pour la période (7 pour la semaine dernière, 30 pour le mois dernier, etc.)
   * @returns Statistiques des activités par type
   */
  async getActivityStats(days = 30) {
    try {
      const startDate = new Date()
      startDate.setDate(startDate.getDate() - days)
      
      const { data, error } = await this.supabase
        .from('activities')
        .select('type, count')
        .gte('created_at', startDate.toISOString())
        .group('type')
      
      if (error) throw error
      
      return data || []
    } catch (error) {
      console.error('Erreur lors de la récupération des statistiques d\'activités:', error)
      throw error
    }
  }

  /**
   * Récupère les activités d'un utilisateur spécifique
   * @param userId ID de l'utilisateur
   * @param limit Nombre maximum d'activités à récupérer
   * @returns Liste des activités de l'utilisateur
   */
  async getUserActivities(userId, limit = 10) {
    try {
      const { data, error } = await this.supabase
        .from('activities')
        .select(`
          id,
          created_at,
          type,
          title,
          description,
          related_id,
          related_type,
          metadata
        `)
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .limit(limit)
      
      if (error) throw error
      
      return data || []
    } catch (error) {
      console.error(`Erreur lors de la récupération des activités pour l'utilisateur ${userId}:`, error)
      throw error
    }
  }

  /**
   * Recherche d'activités
   * @param searchTerm Terme de recherche
   * @param limit Nombre maximum d'activités à récupérer
   * @returns Liste des activités correspondant à la recherche
   */
  async searchActivities(searchTerm, limit = 20) {
    try {
      const { data, error } = await this.supabase
        .from('activities')
        .select(`
          id,
          created_at,
          type,
          title,
          description,
          user_id,
          related_id,
          related_type,
          metadata,
          profiles:user_id(id, first_name, last_name, avatar_url)
        `)
        .or(`title.ilike.%${searchTerm}%,description.ilike.%${searchTerm}%`)
        .order('created_at', { ascending: false })
        .limit(limit)
      
      if (error) throw error
      
      return data || []
    } catch (error) {
      console.error('Erreur lors de la recherche d\'activités:', error)
      throw error
    }
  }
}

// Fonction d'exportation pour utiliser le service comme un composable
export const useActivityService = () => {
  return new ActivityService()
} 