<script setup>
const client = useSupabaseClient()
const router = useRouter()

// Gérer le retour OAuth
onMounted(async () => {
  const { data: { user }, error } = await client.auth.getUser()
  
  if (error) {
    console.error('Erreur callback:', error.message)
    router.push('/auth/login')
    return
  }

  if (user) {
    // Vérifier si le profil existe déjà
    const { data: profile } = await client
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()

    if (profile?.role === 'admin') {
      router.push('/admin')
    } else {
      router.push('/dashboard')
    }
  } else {
    router.push('/auth/login')
  }
})
</script>

<template>
  <div class="min-h-screen flex items-center justify-center">
    <div class="text-center">
      <h2 class="text-xl font-medium text-gray-900">Connexion en cours...</h2>
      <p class="mt-2 text-sm text-gray-500">Veuillez patienter</p>
    </div>
  </div>
</template> 