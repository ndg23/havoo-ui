import { defineStore } from 'pinia'

export const useUserProfileStore = defineStore('userProfile', {
  state: () => ({
    profile: null,
    isLoading: false,
    error: null
  }),

  getters: {
    isExpert: (state) => state.profile?.role === 'expert',
    isClient: (state) => state.profile?.role === 'client',
    isAdmin: (state) => state.profile?.role === 'admin',
    fullName: (state) => 
      state.profile 
        ? `${state.profile.first_name} ${state.profile.last_name}` 
        : '',
  },

  actions: {
    async fetchProfile() {
      const supabase = useSupabaseClient()
      const user = useSupabaseUser()

      if (!user.value) return

      try {
        this.isLoading = true
        const { data, error } = await supabase
          .from('profiles')
          .select('*')
          .eq('id', user.value.id)
          .single()

        if (error) throw error

        this.profile = data
      } catch (error) {
        this.error = error.message
        console.error('Error fetching profile:', error)
      } finally {
        this.isLoading = false
      }
    },

    clearProfile() {
      this.profile = null
      this.error = null
    }
  }
})