import { defineNuxtPlugin } from '#app'
import CustomToast from '~/components/CustomToast.vue'

export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp.component('CustomToast', CustomToast)
}) 