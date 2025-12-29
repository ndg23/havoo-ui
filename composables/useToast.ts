import { ref } from 'vue'

interface Toast {
  id: string
  type: 'success' | 'error' | 'info' | 'warning'
  title: string
  message?: string
  duration?: number
}

const toasts = ref<Toast[]>([])

export const useToast = () => {
  const addToast = (toast: Omit<Toast, 'id'>) => {
    const id = Math.random().toString(36).substr(2, 9)
    const duration = toast.duration || 5000

    toasts.value.push({
      ...toast,
      id
    })

    setTimeout(() => {
      removeToast(id)
    }, duration)
  }

  const removeToast = (id: string) => {
    const index = toasts.value.findIndex(t => t.id === id)
    if (index > -1) {
      toasts.value.splice(index, 1)
    }
  }

  const success = (title: string, message?: string) => {
    addToast({
      type: 'success',
      title,
      message
    })
  }

  const error = (title: string, message?: string) => {
    addToast({
      type: 'error',
      title,
      message
    })
  }

  const info = (title: string, message?: string) => {
    addToast({
      type: 'info',
      title,
      message
    })
  }

  const warning = (title: string, message?: string) => {
    addToast({
      type: 'warning',
      title,
      message
    })
  }

  return {
    toasts,
    success,
    error,
    info,
    warning,
    remove: removeToast
  }
} 