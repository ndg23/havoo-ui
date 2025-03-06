import type { Database } from '~/types/database.types'

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
      // Ne pas redéfinir supabase
      supabaseTyped: client
    }
  }
}) 