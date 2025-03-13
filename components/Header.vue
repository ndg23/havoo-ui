// components/Header.vue
<template>
  <header>
    <div class="header-content">
      <div class="logo" @click="$router.push('/')">ServiceSen</div>
      <div class="search-container">
        <i class="fas fa-search"></i>
        <input 
          type="text" 
          class="search-input" 
          placeholder="Rechercher un expert"
          v-model="searchQuery"
          @keyup.enter="performSearch"
        >
      </div>
    </div>
  </header>
</template>

<script>
export default {
  data() {
    return {
      searchQuery: ''
    }
  },
  
  methods: {
    performSearch() {
      this.$emit('search', this.searchQuery)
    }
  }
}
</script>

<style scoped>
header {
  position: sticky;
  top: 0;
  backdrop-filter: blur(12px);
  background-color: rgba(255, 255, 255, 0.85);
  border-bottom: 1px solid var(--border-color);
  padding: var(--space-md);
  z-index: 10;
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  max-width: 600px;
  margin: 0 auto;
}

.logo {
  font-weight: 700;
  font-size: 20px;
  color: var(--primary-color);
  cursor: pointer;
}

.search-container {
  background-color: var(--bg-secondary);
  border-radius: 9999px;
  padding: var(--space-sm) var(--space-md);
  display: flex;
  align-items: center;
  width: 240px;
}

.search-container i {
  color: var(--text-secondary);
  margin-right: var(--space-sm);
}

.search-input {
  border: none;
  background: transparent;
  outline: none;
  width: 100%;
  font-size: 15px;
}

@media (max-width: 600px) {
  .search-container {
    width: 160px;
  }
}
</style>