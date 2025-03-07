import { ref, readonly } from 'vue'
import { useSupabaseClient } from '#imports'

const settingsCache = ref({})
const isLoading = ref(false)

export function useAppSettings() {
  const supabase = useSupabaseClient()
  
  const fetchSettings = async (forceRefresh = false) => {
    if (!forceRefresh && Object.keys(settingsCache.value).length > 0) {
      return settingsCache.value
    }
    
    isLoading.value = true
    try {
      const { data, error } = await supabase
        .from('app_settings')
        .select('key, value, is_public')
        .eq('is_public', true)
      
      if (error) throw error
      
      const settings = {}
      data.forEach(item => {
        settings[item.key] = item.value
      })
      
      settingsCache.value = settings
      return settings
    } catch (error) {
      console.error('Erreur lors du chargement des paramètres:', error)
      return {}
    } finally {
      isLoading.value = false
    }
  }
  
  const getSetting = async (key, defaultValue = null) => {
    if (Object.keys(settingsCache.value).length === 0) {
      await fetchSettings()
    }
    
    return settingsCache.value[key] !== undefined 
      ? settingsCache.value[key] 
      : defaultValue
  }
  
  return {
    settings: readonly(settingsCache),
    isLoading: readonly(isLoading),
    fetchSettings,
    getSetting
  }
} 