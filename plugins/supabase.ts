import type { Database } from '~/types/database'

// Ajouter le type à useSupabaseClient
declare module '#app' {
  interface NuxtApp {
    $supabase: ReturnType<typeof useSupabaseClient<Database>>
  }
}

export default defineNuxtPlugin(() => {
  // Le client est déjà fourni par le module, on ajoute juste le typage
  const client = useSupabaseClient<Database>()
  
  return {
    provide: {
      // Vous pouvez soit étendre les fonctionnalités soit utiliser un nom différent
      supabaseTyped: client // OU supabaseClient, supabaseDB, etc.
    }
  }
}) 