<template>
  <div class="min-h-screen flex items-center justify-center bg-white dark:bg-black p-4">
    <div class="max-w-md w-full space-y-8 text-center">
      <!-- Error illustration -->
      <div class="relative mx-auto w-48 h-48">
        <img 
          src="/images/404-illustration.svg" 
          alt="Page non trouvée"
          class="w-full h-full object-contain dark:invert"
        />
      </div>

      <!-- Error message -->
      <div class="space-y-3">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
          Page non trouvée
        </h1>
        <p class="text-gray-600 dark:text-gray-400">
          Désolé, la page que vous recherchez n'existe pas ou a été supprimée.
        </p>
      </div>

      <!-- Action buttons -->
      <div class="space-y-3 pt-4">
        <!-- Main action -->
        <NuxtLink
          to="/"
          class="block w-full px-4 py-3.5 rounded-xl text-base font-bold
                 bg-blue-500 text-white
                 hover:bg-blue-600 transition-colors active:scale-98"
        >
          Retourner à l'accueil
        </NuxtLink>

        <!-- Secondary actions -->
        <div class="flex gap-3">
          <button
            @click="openReportModal"
            class="flex-1 px-4 py-3.5 rounded-xl text-base font-medium
                   border border-gray-200/40 dark:border-gray-700/40
                   bg-white dark:bg-gray-800
                   text-gray-700 dark:text-gray-300
                   hover:bg-gray-50 dark:hover:bg-gray-700/50
                   transition-all duration-200"
          >
            Signaler un problème
          </button>

          <NuxtLink
            to="/requests/new"
            class="flex-1 px-4 py-3.5 rounded-xl text-base font-medium
                   border border-gray-200/40 dark:border-gray-700/40
                   bg-white dark:bg-gray-800
                   text-gray-700 dark:text-gray-300
                   hover:bg-gray-50 dark:hover:bg-gray-700/50
                   transition-all duration-200"
          >
            Créer une mission
          </NuxtLink>
        </div>
      </div>
    </div>

    <!-- Report Modal -->
    <TransitionRoot appear :show="showReportModal" as="template">
      <Dialog as="div" @close="closeReportModal" class="relative z-50">
        <TransitionChild
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/50 backdrop-blur-sm" />
        </TransitionChild>

        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full items-center justify-center p-4">
            <TransitionChild
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel class="w-full max-w-md transform overflow-hidden rounded-2xl bg-white dark:bg-gray-900 p-6 text-left align-middle shadow-xl transition-all">
                <DialogTitle as="h3" class="text-lg font-bold text-gray-900 dark:text-white">
                  Signaler un problème
                </DialogTitle>

                <div class="mt-4">
                  <textarea
                    v-model="reportMessage"
                    rows="4"
                    placeholder="Décrivez le problème rencontré..."
                    class="w-full px-4 py-3 text-base rounded-xl
                           border border-gray-200/40 dark:border-gray-700/40
                           bg-white dark:bg-gray-800
                           focus:outline-none
                           focus:border-gray-300 dark:focus:border-gray-600
                           focus:ring-0
                           placeholder:text-gray-400/80 dark:placeholder:text-gray-500/80
                           text-gray-900 dark:text-white
                           shadow-sm
                           resize-none
                           transition-all duration-200"
                  />
                </div>

                <div class="mt-6 flex gap-3">
                  <button
                    @click="submitReport"
                    :disabled="!reportMessage.trim()"
                    class="flex-1 px-4 py-2.5 rounded-xl text-sm font-bold
                           bg-blue-500 text-white
                           disabled:opacity-50 disabled:cursor-not-allowed
                           hover:bg-blue-600 transition-colors"
                  >
                    Envoyer
                  </button>
                  <button
                    @click="closeReportModal"
                    class="flex-1 px-4 py-2.5 rounded-xl text-sm font-bold
                           border border-gray-200/40 dark:border-gray-700/40
                           text-gray-700 dark:text-gray-300
                           hover:bg-gray-50 dark:hover:bg-gray-700/50
                           transition-all duration-200"
                  >
                    Annuler
                  </button>
                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Dialog, DialogPanel, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'
import { useToast } from '@nuxt/ui'

const toast = useToast()
const showReportModal = ref(false)
const reportMessage = ref('')

const openReportModal = () => {
  showReportModal.value = true
}

const closeReportModal = () => {
  showReportModal.value = false
  reportMessage.value = ''
}

const submitReport = async () => {
  try {
    // Here you would typically send the report to your backend
    // await $fetch('/api/report', {
    //   method: 'POST',
    //   body: {
    //     message: reportMessage.value,
    //     path: window.location.pathname
    //   }
    // })

    toast.add({
      title: 'Merci pour votre signalement',
      description: 'Nous allons examiner le problème rapidement.',
      color: 'green'
    })

    closeReportModal()
  } catch (error) {
    toast.add({
      title: 'Erreur',
      description: 'Impossible d\'envoyer le signalement. Veuillez réessayer.',
      color: 'red'
    })
  }
}

// SEO
useHead({
  title: 'Page non trouvée | Votre Plateforme',
  meta: [
    { name: 'description', content: 'La page que vous recherchez n\'existe pas ou a été supprimée.' }
  ]
})
</script> 