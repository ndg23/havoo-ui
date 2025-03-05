<template>
  <div class="space-y-4">
    <!-- Google -->
    <button
      @click="signInWithGoogle"
      class="w-full flex items-center justify-center gap-3 px-4 py-2 border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors"
    >
      <img src="/icons/google.svg" alt="Google" class="w-5 h-5" />
      <span class="text-sm font-medium text-gray-700">
        Continuer avec Google
      </span>
    </button>

    <!-- Facebook -->
    <button
      @click="signInWithFacebook"
      class="w-full flex items-center justify-center gap-3 px-4 py-2 bg-[#1877F2] text-white rounded-xl hover:bg-[#1874EA] transition-colors"
    >
      <img src="/icons/facebook.svg" alt="Facebook" class="w-5 h-5" />
      <span class="text-sm font-medium">
        Continuer avec Facebook
      </span>
    </button>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()

const handleOAuthResponse = async (response) => {
  const { data: { user }, error } = response
  
  if (error) {
    console.error('Erreur OAuth:', error.message)
    return
  }

  if (user) {
    // Rediriger selon le rôle
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
  }
}

const signInWithGoogle = async () => {
  const { data, error } = await client.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: `${window.location.origin}/auth/callback`,
      queryParams: {
        access_type: 'offline',
        prompt: 'consent'
      }
    }
  })
  await handleOAuthResponse({ data, error })
}

const signInWithFacebook = async () => {
  const { data, error } = await client.auth.signInWithOAuth({
    provider: 'facebook',
    options: {
      redirectTo: `${window.location.origin}/auth/callback`,
      scopes: 'email,public_profile'
    }
  })
  await handleOAuthResponse({ data, error })
}
</script> 