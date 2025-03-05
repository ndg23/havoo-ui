// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  modules: [
    '@nuxt/ui',
    '@nuxtjs/tailwindcss',
    '@nuxtjs/color-mode',
    'nuxt-vue3-google-signin',
    '@nuxtjs/supabase'
  ], 
  googleSignIn: {
    clientId: process.env.GOOGLE_CLIENT_ID,
    scope: 'email profile',
    prompt: 'consent',
    access_type: 'offline',
    redirect_uri: 'http://localhost:3200/auth/callback'
  },
  facebookSignIn: {
    clientId: process.env.FACEBOOK_CLIENT_ID,
    scope: 'email profile',
    prompt: 'consent',
    access_type: 'offline',
    redirect_uri: 'http://localhost:3200/auth/callback'
  },
  tailwindcss: {
    cssPath: ["~/assets/css/tailwind.css", { injectPosition: 0 }],
    configPath: 'tailwind.config.js',

  },
  vite: {
    optimizeDeps: {
      include: [
        '@heroicons/vue/24/outline',
        '@headlessui/vue'
      ]
    }
  },
  supabase: {
    redirectOptions: {
      login: '/',
      callback: '/confirm',
      exclude: ['/api/*'],
      cookieRedirect: false,
    },
    redirect: false

  },
  app: {
    head: {
      title: 'Expert-Connect - Trouvez votre expert en quelques clics',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' }
      ]
    }
  },
  runtimeConfig: {
    public: {
      supabase: {
        url: process.env.SUPABASE_URL,
        key: process.env.SUPABASE_KEY,
        redirectOptions: {
          login: '/auth/login',
          callback: '/auth/callback'
        }
      }
    }
  }
})