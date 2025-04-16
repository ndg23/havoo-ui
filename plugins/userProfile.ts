// import { defineNuxtPlugin, useSupabaseUser } from '#app'
import { useUserProfileStore } from '~/stores/userProfile'

export default defineNuxtPlugin(async (nuxtApp) => {
  const userProfileStore = useUserProfileStore()
  const user = useSupabaseUser()

  // Écouter les changements d'authentification
  watch(user, async (newUser) => {
    if (newUser) {
      await userProfileStore.fetchProfile()
    } else {
      userProfileStore.clearProfile()
    }
  }, { immediate: true })
})