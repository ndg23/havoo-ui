import { ref } from 'vue'
import { useSupabaseClient } from '#imports'
import type { Database } from '~/types/database'

// Types pour les paramètres et données
interface RequestFilters {
  status?: string;
  categoryId?: number;
  urgent?: boolean;
  search?: string;
}

interface RequestClient {
  id: string;
  firstName: string;
  lastName: string;
  avatarUrl: string | null;
}

interface RequestCategory {
  id: number;
  name: string;
}

interface RequestProposal {
  id: number;
  expertId: string;
  expertName: string;
  expertAvatar: string | null;
  expertProfession: string | null;
  isVerified: boolean;
  price: number;
  formattedPrice: string;
  duration: number;
  message: string;
  status: string;
  createdAt: string;
  formattedCreatedAt: string;
}

interface Request {
  id: number;
  title: string;
  description: string;
  budget: number | null;
  deadline: string | null;
  status: string;
  skills: string[];
  createdAt: string;
  client: RequestClient;
  professions: RequestCategory[];
  proposalsCount: number;
}

interface RequestDetail extends Request {
  formattedBudget: string;
  formattedDeadline: string;
  formattedCreatedAt: string;
  proposals: RequestProposal[];
}

export function useRequests() {
  const supabase = useSupabaseClient<Database>()
  
  // État réactif
  const missions = ref<Request[]>([])
  const currentRequest = ref<RequestDetail | null>(null)
  const isLoading = ref<boolean>(false)
  const error = ref<string | null>(null)
  
  /**
   * Récupère toutes les demandes avec filtrage optionnel
   */
  const fetchRequests = async (filters: RequestFilters = {}) => {
    isLoading.value = true
    error.value = null
    
    try {
      let query = supabase
        .from('missions')
        .select(`
         *
        `)
        .order('created_at', { ascending: false })
      
      // Appliquer les filtres si spécifiés
      if (filters.status && filters.status !== 'all') {
        query = query.eq('status', filters.status)
      }
      
      if (filters.categoryId) {
        query = query.eq('professions.id', filters.categoryId)
      }
      
      if (filters.urgent) {
        // On considère comme urgent une demande avec une deadline dans les 7 jours
        const sevenDaysFromNow = new Date();
        sevenDaysFromNow.setDate(sevenDaysFromNow.getDate() + 7);
        query = query
          .lte('deadline', sevenDaysFromNow.toISOString())
          .gt('deadline', new Date().toISOString());
      }
      
      if (filters.search) {
        query = query.or(`title.ilike.%${filters.search}%,description.ilike.%${filters.search}%`)
      }
      
      const { data, error: apiError } = await query
      
      if (apiError) throw apiError
      
      // Formater les données
      missions.value = data.map(mission => {
        // Accès sécurisé aux données imbriquées
        const profileData = Array.isArray(mission.profiles) ? mission.profiles[0] : mission.profiles;
        
        return {
          id: mission.id,
          title: mission.title,
          description: mission.description,
          budget: mission.budget,
          deadline: mission.deadline,
          status: mission.status,
          skills: mission.skills_required || [],
          createdAt: mission.created_at,
          client: {
            id: profileData?.id || '',
            firstName: profileData?.first_name || '',
            lastName: profileData?.last_name || '',
            avatarUrl: profileData?.avatar_url
          },
          professions: mission.professions || [],
          proposalsCount: Array.isArray(mission.proposals) ? mission.proposals.length : 0
        }
      })
      
      return missions.value
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'Erreur inconnue';
      console.error('Error fetching missions:', e)
      error.value = errorMessage || 'Erreur lors du chargement des demandes'
      return []
    } finally {
      isLoading.value = false
    }
  }
  
  /**
   * Récupère une demande par son ID
   */
  const fetchRequestById = async (id: number): Promise<RequestDetail | null> => {
    isLoading.value = true
    error.value = null
    
    try {
      const { data, error: apiError } = await supabase
        .from('missions')
        .select(`
          id,
          client_id,
          title,
          description,
          budget,
          deadline,
          status,
          skills_required,
          created_at,
          updated_at,
          profiles!missions_client_id_fkey(id, first_name, last_name, avatar_url),
          professions(id, name),
          proposals(
            id, 
            expert_id,
            price,
            duration,
            message,
            status,
            created_at,
            profiles!proposals_expert_id_fkey(id, first_name, last_name, avatar_url, profession, is_verified)
          )
        `)
        .eq('id', id)
        .single()
      
      if (apiError) throw apiError
      
      // Accès sécurisé aux données imbriquées
      const profileData = Array.isArray(data.profiles) ? data.profiles[0] : data.profiles;
      
      // Formater la demande
      currentRequest.value = {
        id: data.id,
        title: data.title,
        description: data.description,
        budget: data.budget,
        formattedBudget: formatCurrency(data.budget || 0),
        deadline: data.deadline,
        formattedDeadline: formatDate(data.deadline),
        status: data.status,
        skills: data.skills_required || [],
        createdAt: data.created_at,
        formattedCreatedAt: formatDate(data.created_at),
        client: {
          id: profileData?.id || '',
          firstName: profileData?.first_name || '',
          lastName: profileData?.last_name || '',
          avatarUrl: profileData?.avatar_url
        },
        professions: data.professions || [],
        proposals: (data.proposals || []).map(proposal => {
          // Accès sécurisé aux données imbriquées des profils dans les propositions
          const proposalProfileData = Array.isArray(proposal.profiles) ? proposal.profiles[0] : proposal.profiles;
          
          return {
            id: proposal.id,
            expertId: proposal.expert_id,
            expertName: `${proposalProfileData?.first_name || ''} ${proposalProfileData?.last_name || ''}`,
            expertAvatar: proposalProfileData?.avatar_url,
            expertProfession: proposalProfileData?.profession || '',
            isVerified: proposalProfileData?.is_verified || false,
            price: proposal.price,
            formattedPrice: formatCurrency(proposal.price),
            duration: proposal.duration,
            message: proposal.message,
            status: proposal.status,
            createdAt: proposal.created_at,
            formattedCreatedAt: formatDate(proposal.created_at)
          }
        })
      }
      
      return currentRequest.value
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'Erreur inconnue';
      console.error('Error fetching mission:', e)
      error.value = errorMessage || 'Erreur lors du chargement de la demande'
      return null
    } finally {
      isLoading.value = false
    }
  }
  
  /**
   * Crée une nouvelle demande
   */
  const createRequest = async (missionData: Partial<Database['public']['Tables']['missions']['Insert']>) => {
    isLoading.value = true
    error.value = null
    
    try {
      const { data, error: apiError } = await supabase
        .from('missions')
        .insert(missionData)
        .select()
      
      if (apiError) throw apiError
      
      return data?.[0] || null
    } catch (e: unknown) {
      const errorMessage = e instanceof Error ? e.message : 'Erreur inconnue';
      console.error('Error creating mission:', e)
      error.value = errorMessage || 'Erreur lors de la création de la demande'
      return null
    } finally {
      isLoading.value = false
    }
  }
  
  // Fonction utilitaire pour formater la devise
  const formatCurrency = (amount: string | number | bigint): string => {
    return new Intl.NumberFormat('fr-FR', { 
      style: 'currency', 
      currency: 'XOF',
      maximumFractionDigits: 0 
    }).format(Number(amount))
  }
  
  // Fonction utilitaire pour formater les dates
  const formatDate = (dateString: string | null): string => {
    if (!dateString) return 'Non spécifié'
    
    const date = new Date(dateString)
    return new Intl.DateTimeFormat('fr-FR', { 
      day: 'numeric', 
      month: 'long', 
      year: 'numeric' 
    }).format(date)
  }
  
  return {
    missions,
    currentRequest,
    isLoading,
    error,
    fetchRequests,
    fetchRequestById,
    createRequest,
    formatCurrency,
    formatDate
  }
} 