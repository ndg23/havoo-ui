/**
 * Composable pour la gestion des catégories
 */
export default function useCategories() {
    // Référence aux catégories
    const professions = ref([])
    const isLoading = ref(false)
    const error = ref(null)
    const supabase = useSupabaseClient()
        // Récupérer toutes les catégories
    const fetchCategories = async() => {
        isLoading.value = true
        error.value = null

        try {
            const { data, error: apiError } = await supabase
                .from('professions')
                .select('*')
                .order('name', { ascending: true })

            if (apiError) throw apiError

            professions.value = data || []
        } catch (err) {
            console.error('Erreur lors de la récupération des catégories:', err)
            error.value = err.message || 'Erreur lors de la récupération des catégories'
        } finally {
            isLoading.value = false
        }
    }

    // Obtenir le nom d'une catégorie par ID
    const getCategoryName = (categoryId) => {
        const category = professions.value.find(cat => cat.id === categoryId)
        return category ? category.name : 'Catégorie inconnue'
    }

    // Obtenir l'icône d'une catégorie par ID
    const getCategoryIcon = (categoryId) => {
        const category = professions.value.find(cat => cat.id === categoryId)
        return category ? .icon || 'QuestionMarkCircle'
    }

    // Obtenir une catégorie par son ID
    const getCategoryById = (categoryId) => {
        return professions.value.find(cat => cat.id === categoryId) || null
    }

    // Initialisation - charger les catégories au montage du composable
    onMounted(() => {
        fetchCategories()
    })

    return {
        professions,
        isLoading,
        error,
        fetchCategories,
        getCategoryName,
        getCategoryIcon,
        getCategoryById
    }
}