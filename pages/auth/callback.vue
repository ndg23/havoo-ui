<script setup>
const client = useSupabaseClient()
const router = useRouter()

definePageMeta({
  layout: 'auth'
})

// Gérer le retour OAuth
onMounted(async () => {
  try {
    const { data: { user }, error } = await client.auth.getUser()
  
    if (error) {
      console.error('Erreur auth:', error.message)
      router.push('/auth/login?error=auth_failed')
      return
    }

    if (user) {
      try {
        // Vérifier si le profil existe déjà
        const { data: profile, error: profileError } = await client
          .from('profiles')
          .select('*')
          .eq('id', user.id)
          .maybeSingle()

        if (profileError && profileError.code !== 'PGRST116') {
          throw profileError
        }

        if (!profile) {
          // Extraire le prénom et le nom
          const [firstName, ...lastNameParts] = user.user_metadata.full_name.split(' ')
          const lastName = lastNameParts.join(' ')

          // Créer le profil
          const { error: insertError } = await client
            .from('profiles')
            .insert({
              id: user.id,
              first_name: firstName,
              last_name: lastName,
              email: user.email,
              profile_image_url: user.user_metadata.avatar_url,
              is_expert: false,
              created_at: new Date().toISOString(),
              updated_at: new Date().toISOString()
            })
            .select('*')
            .single()

          if (insertError) {
            console.error('Erreur création profil:', insertError)
            throw insertError
          }

        

          router.push('/account/edit-profile')
        } else {
          // Le profil existe déjà
          router.push(profile.is_expert ? '/expert/dashboard' : '/account/edit-profile')
        }
      } catch (dbError) {
        console.error('Erreur DB:', dbError)
        // Déconnexion en cas d'erreur
        await client.auth.signOut()
        router.push('/auth/login?error=profile_creation_failed')
      }
    } else {
      router.push('/auth/login?error=no_user')
    }
  } catch (error) {
    console.error('Erreur générale:', error)
    router.push('/auth/login?error=unknown')
  }
})
</script>

<template>
  <div class="min-h-screen flex flex-col items-center justify-center bg-white px-4">
    <!-- Logo Animation -->
    <div class="relative mb-8">
      <div class="w-16 h-16 bg-primary-500 rounded-2xl rotate-45 transform">
        <div class="absolute inset-0 flex items-center justify-center -rotate-45">
          <span class="text-2xl font-oswald-bold text-white">H</span>
        </div>
      </div>
      <!-- Pulse Effect -->
      <div class="absolute inset-0 rounded-2xl bg-primary-500/30 rotate-45 animate-ping"></div>
    </div>

    <!-- Loading Text -->
    <h2 class="text-xl font-medium text-gray-900 mb-3">
      Connexion en cours
    </h2>
    
    <!-- Loading Dots -->
    <div class="flex gap-1.5">
      <div v-for="i in 3" :key="i"
        class="w-2 h-2 rounded-full bg-primary-500"
        :class="`animate-bounce-${i}`"
      ></div>
    </div>

    <!-- Subtle Message -->
    <p class="mt-6 text-sm text-gray-500">
      Redirection vers votre espace personnel
    </p>
  </div>
</template>

<style scoped>
.animate-bounce-1 {
  animation: bounce 1s infinite;
}
.animate-bounce-2 {
  animation: bounce 1s infinite;
  animation-delay: 0.2s;
}
.animate-bounce-3 {
  animation: bounce 1s infinite;
  animation-delay: 0.4s;
}

@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
    opacity: 0.5;
  }
  50% {
    transform: translateY(-8px);
    opacity: 1;
  }
}

.animate-ping {
  animation: ping 2s cubic-bezier(0, 0, 0.2, 1) infinite;
}

@keyframes ping {
  75%, 100% {
    transform: scale(1.5) rotate(45deg);
    opacity: 0;
  }
}
</style>
