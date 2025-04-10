
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
      "./components/**/*.{js,vue,ts}",
      "./layouts/**/*.vue",
      "./pages/**/*.vue",
      "./plugins/**/*.{js,ts}",
      "./app.vue",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#FF5F40',
          50: '#FFF1EE',
          100: '#FFE4DE',
          200: '#FFCABF',
          300: '#FFB1A0',
          400: '#FF9780',
          500: '#FF5F40', // Main color
          600: '#FF4D2B',
          700: '#FF3A15',
          800: '#FF2800',
          900: '#EB2500',
        },
        // Couleurs secondaires
        success: '#10b981',
        warning: '#f59e0b',
        error: '#ef4444',
      }
    }
  },
  plugins: []
}