// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: false },
  modules: [
    '@nuxt/ui',
    '@nuxtjs/tailwindcss',
    '@nuxtjs/color-mode',
    'nuxt-vue3-google-signin',
    '@nuxtjs/supabase',
    '@nuxtjs/robots',
  ], 
  css: ['@fontsource/inter/400.css',
    '@fontsource/inter/500.css',
    '@fontsource/inter/700.css'],
  build: {
    transpile: ["oh-vue-icons"]
  },
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
      title: '% - Trouvez votre expert en quelques clics',
      charset: 'utf-8',
      viewport: 'width=device-width, initial-scale=1',
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
        { rel: 'canonical', href: 'https://keetaf.com' }
      ],
      meta: [
        { name: 'format-detection', content: 'telephone=no' },
        { name: 'apple-mobile-web-app-capable', content: 'yes' },
        { name: 'apple-mobile-web-app-status-bar-style', content: 'default' }
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
      },
      cloudinary: {
        cloudName: process.env.CLOUDINARY_CLOUD_NAME,
        apiKey: process.env.CLOUDINARY_API_KEY,
        apiSecret: process.env.CLOUDINARY_API_SECRET,
      }
    }
  },
  robots: {
    UserAgent: '*',
    Allow: '/',
    Disallow: ['/account', '/admin', '/api'],
    Sitemap: 'https://keetaf.com/sitemap.xml'
  }
})