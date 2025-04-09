import { ref } from 'vue'

export const useUsers = () => {
    const users = ref([])
    const loading = ref(false)
    const error = ref(null)

    const fetchUsers = async(options = {}) => {
        const {
            page = 1,
                perPage = 10,
                sortBy = null,
                filters = {},
                search = ''
        } = options

        loading.value = true
        error.value = null

        try {
            let query = useSupabaseClient()
                .from('profiles')
                .select('*', { count: 'exact' })

            // Recherche
            if (search) {
                query = query.or(
                    `first_name.ilike.%${search}%`,
                    `last_name.ilike.%${search}%`,
                    `email.ilike.%${search}%`,
                    `phone.ilike.%${search}%`
                )
            }

            // Filtres
            if (filters.role) {
                query = query.eq('role', filters.role)
            }
            if (filters.verification_status) {
                query = query.eq('verification_status', filters.verification_status)
            }
            if (filters.is_expert !== undefined) {
                query = query.eq('is_expert', filters.is_expert)
            }

            // Tri
            if (sortBy && sortBy.key) {
                query = query.order(sortBy.key, {
                    ascending: sortBy.direction === 'asc'
                })
            } else {
                // Tri par défaut
                query = query.order('created_at', { ascending: false })
            }

            // Pagination
            const from = (page - 1) * perPage
            const to = from + perPage - 1
            query = query.range(from, to)

            const { data, count, error: supabaseError } = await query

            if (supabaseError) throw supabaseError

            if (!data) return { data: [], total: 0 }

            return {
                data: data.map(user => ({
                    ...user,
                    fullName: `${user.first_name} ${user.last_name}`,
                    status: user.verification_status === 'verified'
                })),
                total: count || 0
            }

        } catch (err) {
            console.error('Erreur dans fetchUsers:', err)
            error.value = err.message
            return { data: [], total: 0 }
        } finally {
            loading.value = false
        }
    }

    const toggleUserStatus = async(userId) => {
        try {
            const { data: user } = await useSupabaseClient()
                .from('profiles')
                .select('verification_status')
                .eq('id', userId)
                .single()

            const newStatus = user.verification_status === 'verified' ? 'pending' : 'verified'

            const { error: updateError } = await useSupabaseClient()
                .from('profiles')
                .update({
                    verification_status: newStatus,
                    verified_at: newStatus === 'verified' ? new Date().toISOString() : null
                })
                .eq('id', userId)

            if (updateError) throw updateError

            return newStatus === 'verified'
        } catch (err) {
            error.value = err.message
            throw err
        }
    }

    const deleteUser = async(userId) => {
        try {
            const { error: deleteError } = await useSupabaseClient()
                .from('profiles')
                .delete()
                .eq('id', userId)

            if (deleteError) throw deleteError
        } catch (err) {
            error.value = err.message
            throw err
        }
    }

    return {
        users,
        loading,
        error,
        fetchUsers,
        toggleUserStatus,
        deleteUser
    }
}