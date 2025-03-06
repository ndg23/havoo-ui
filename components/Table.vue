<template>
    <div class="w-full rounded-2xl z-10">
      <!-- Filters bar -->
      <div v-if="filters || dateRange" class="flex flex-wrap items-center gap-4 pb-4">
        <!-- Search bar -->
        <div class="flex-1 min-w-[240px]">
          <div class="relative">
            <div class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4">
              <client-only>
                <font-awesome-icon :icon="['fas', 'search']" />
              </client-only>
            </div>
            <input
              type="text"
              v-model="searchQuery"
              :placeholder="searchPlaceholder"
              class="w-full pl-10 pr-4 py-2 bg-white border border-gray-200 
                rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500
                transition-all duration-200"
              @input="debounceSearch"
            />
          </div>
        </div>
  
        <!-- Filters button -->
        <div v-if="filters" class="relative" ref="filtersRef">
          <button
            @click="showFilters = !showFilters"
            :class="`inline-flex items-center px-4 py-2 rounded-xl border
              transition-all duration-200 gap-2
              ${Object.keys(activeFilters).length > 0 
                ? 'bg-blue-50 border-blue-200 text-blue-600' 
                : 'bg-white border-gray-200 text-gray-700'}`"
          >
            <client-only>
              <font-awesome-icon :icon="['fas', 'filter']" class="w-4 h-4" />
            </client-only>
            Filtres
            <span v-if="Object.keys(activeFilters).length > 0" class="bg-blue-100 text-blue-600 px-2 py-0.5 rounded-full text-xs">
              {{ Object.keys(activeFilters).length }}
            </span>
          </button>
  
          <!-- Filter menu -->
          <Transition name="fade">
            <div 
              v-if="showFilters"
              class="absolute right-0 mt-2 w-72 bg-white rounded-2xl shadow-xl 
                border border-gray-100 overflow-hidden z-50"
            >
              <div class="p-4 space-y-4">
                <div v-for="filter in filterOptions" :key="filter.key" class="space-y-2">
                  <label class="text-sm font-medium text-gray-700">
                    {{ filter.label }}
                  </label>
                  <select
                    v-if="filter.type === 'select'"
                    v-model="activeFilters[filter.key]"
                    @change="handleFilterChange(filter.key, $event.target.value)"
                    class="w-full px-3 py-2 bg-gray-50 border border-gray-200 
                      rounded-xl focus:ring-2 focus:ring-blue-500/20"
                  >
                    <option value="">Tous</option>
                    <option 
                      v-for="option in filter.options" 
                      :key="option.value" 
                      :value="option.value"
                    >
                      {{ option.label }}
                    </option>
                  </select>
                </div>
  
                <!-- Actions -->
                <div class="flex justify-end gap-2 pt-2 border-t">
                  <button
                    @click="resetFilters"
                    class="px-3 py-1.5 text-sm text-gray-600 hover:text-gray-900"
                  >
                    Réinitialiser
                  </button>
                  <button
                    @click="showFilters = false"
                    class="px-3 py-1.5 text-sm bg-blue-600 text-white rounded-lg 
                      hover:bg-blue-700"
                  >
                    Appliquer
                  </button>
                </div>
              </div>
            </div>
          </Transition>
        </div>
  
        <!-- Date range picker -->
        <div v-if="dateRange">
          <!-- Date range component placeholder - implement with a date picker library -->
          <button class="inline-flex items-center px-4 py-2 bg-white 
            border border-gray-200 rounded-xl text-gray-700 gap-2
            hover:bg-gray-50 transition-colors">
            <client-only>
              <font-awesome-icon :icon="['fas', 'calendar-alt']" class="w-4 h-4" />
            </client-only>
            Sélectionner une période
          </button>
        </div>
      </div>
  
      <!-- Export actions -->
      <div class="flex items-center justify-end gap-2 mb-4">
        <div class="bg-white/80 p-2 flex items-center gap-2">
          <button
            @click="exportCSV"
            class="flex items-center gap-2 px-4 py-2 rounded-xl
              text-sm font-medium transition-all duration-200
              text-green-700
              border border-green-200/50 hover:border-green-300/50"
          >
            <div class="w-8 h-8 rounded-lg bg-green-100 flex items-center justify-center">
              <client-only>
                <font-awesome-icon :icon="['fas', 'file-csv']" class="w-4 h-4" />
              </client-only>
            </div>
            <span>CSV</span>
          </button>
  
          <button
            @click="exportExcel"
            class="flex items-center gap-2 px-4 py-2 rounded-xl
              text-sm font-medium transition-all duration-200
              text-blue-700 hover:text-blue-800
              border border-blue-200/50 hover:border-blue-300/50"
          >
            <div class="w-8 h-8 rounded-lg bg-blue-100 flex items-center justify-center">
              <client-only>
                <font-awesome-icon :icon="['fas', 'file-excel']" class="w-4 h-4" />
              </client-only>
            </div>
            <span>Excel</span>
          </button>
  
          <button
            @click="exportJSON"
            class="flex items-center gap-2 px-4 py-2 rounded-xl
              text-sm font-medium transition-all duration-200
              text-purple-700 hover:text-purple-800
              border border-purple-200/50 hover:border-purple-300/50"
          >
            <div class="w-8 h-8 rounded-lg bg-purple-100 flex items-center justify-center">
              <client-only>
                <font-awesome-icon :icon="['fas', 'file-code']" class="w-4 h-4" />
              </client-only>
            </div>
            <span>JSON</span>
          </button>
  
          <div class="w-px h-8 bg-gray-200/50"></div>
  
          <button
            @click="printTable"
            class="flex items-center gap-2 px-4 py-2 rounded-xl
              text-sm font-medium transition-all duration-200
              text-orange-700 hover:text-orange-800
              border border-orange-200/50 hover:border-orange-300/50"
          >
            <div class="w-8 h-8 rounded-lg bg-orange-100 flex items-center justify-center">
              <client-only>
                <font-awesome-icon :icon="['fas', 'print']" class="w-4 h-4" />
              </client-only>
            </div>
            <span>Imprimer</span>
          </button>
        </div>
      </div>
  
      <!-- Loading state -->
      <TableSkeleton v-if="loading" :rows="5" />
  
      <!-- Error state -->
      <ErrorView 
        v-else-if="error" 
        message="Erreur lors du chargement des données"
        @retry="$emit('retry')"
      />
  
      <!-- Empty state -->
      <EmptyView 
        v-else-if="!tableData.length"
        title="Aucune donnée disponible"
        message="Il n'y a aucune donnée à afficher pour le moment"
        :action="{
          label: 'Actualiser',
          onClick: () => $emit('retry')
        }"
      />
  
      <!-- Table -->
      <div v-else class="overflow-x-auto bg-white rounded-2xl border mt-5 border-gray-100">
        <table class="w-full relative">
          <thead class="bg-white border-b-2 border-gray-100 bg-gray-100">
            <tr class="border-b-1 border-gray-800">
              <th 
                v-for="column in displayColumns" 
                :key="column.key"
                class="text-left px-6 py-2 text-sm font-semibold font-mono text-gray-700"
                @click="sortTable(column.key)"
              >
                <div class="flex items-center gap-2">
                  {{ column.label }}
                  <span v-if="sortKey === column.key">
                    <client-only>
                      <font-awesome-icon 
                        :icon="['fas', sortDirection === 'asc' ? 'chevron-up' : 'chevron-down']" 
                        class="w-3 h-3 text-gray-500" 
                      />
                    </client-only>
                  </span>
                </div>
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr 
              v-for="(item, index) in paginatedData" 
              :key="index"
              class="px-6 py-1.5 hover:bg-gray-100/50 transition-colors duration-200 text-sm border-r border-gray-200 divide-x divide-gray-200 text-truncate text-gray-600 whitespace-wrap z-0"
            >
              <td 
                v-for="column in displayColumns" 
                :key="`${index}-${column.key}`"
                class="px-6 py-2 text-sm text-gray-600 whitespace-wrap"
                style="position: relative; z-index: 0;"
              >
                <!-- Render cell content based on column type -->
                <template v-if="column.key === 'actions'">
                  <div class="flex items-center relative justify-end gap-2 z-10">
                    <button 
                      v-if="hasAction('viewPoints')"
                      @click="$emit('viewPoints', item)"
                      class="p-2 text-gray-500 hover:text-blue-700 transition-colors"
                      title="Points de vente"
                    >
                      <client-only>
                        <font-awesome-icon :icon="['fas', 'store']" class="w-4 h-4" />
                      </client-only>
                    </button>
                    
                    <button 
                      v-if="hasAction('reversement')"
                      @click="$emit('reversement', item)"
                      class="p-2 text-gray-500 hover:text-blue-700 transition-colors"
                      title="Reversement"
                    >
                      <client-only>
                        <font-awesome-icon :icon="['fas', 'money-bill-wave']" class="w-4 h-4" />
                      </client-only>
                    </button>
                    
                    <button 
                      v-if="hasAction('switch')"
                      @click="$emit('switch', item)"
                      class="p-2 text-gray-500 hover:text-blue-700 transition-colors"
                      title="Gérer le compte"
                    >
                      <client-only>
                        <font-awesome-icon :icon="['fas', 'user-cog']" class="w-4 h-4" />
                      </client-only>
                    </button>
                    
                    <button 
                      v-if="hasAction('lock')"
                      @click="openWarningModal('lock', item)"
                      class="p-2"
                      :title="item.active || item.actif ? 'Désactiver' : 'Activer'"
                    >
                      <client-only>
                        <font-awesome-icon 
                          :icon="['fas', item.active || item.actif ? 'unlock' : 'lock']" 
                          :class="item.active || item.actif ? 'text-green-500' : 'text-red-500'"
                          class="w-4 h-4" 
                        />
                      </client-only>
                    </button>
  
                    <button 
                      v-if="hasAction('view')"
                      @click="$emit('view', item)"
                      class="p-2 text-gray-500 hover:text-blue-700 transition-colors"
                      title="Voir les détails"
                    >
                      <client-only>
                        <font-awesome-icon :icon="['fas', 'eye']" class="w-4 h-4" />
                      </client-only>
                    </button>
                    
                    <button 
                      v-if="hasAction('edit')"
                      @click="$emit('edit', item)"
                      class="p-2 text-gray-500 hover:text-blue-700 transition-colors"
                      title="Modifier"
                    >
                      <client-only>
                        <font-awesome-icon :icon="['fas', 'edit']" class="w-4 h-4" />
                      </client-only>
                    </button>
                    
                    <button 
                      v-if="item.status === 'FAILED'"
                      @click="openRetryModal(item)"
                      class="p-2 text-gray-500 hover:text-blue-700 transition-colors"
                      title="Réessayer"
                    >
                      <client-only>
                        <font-awesome-icon :icon="['fas', 'undo']" class="w-4 h-4" />
                      </client-only>
                    </button>
                    
                    <button 
                      v-if="hasAction('delete')"
                      @click="openWarningModal('delete', item)"
                      class="p-2"
                      title="Supprimer"
                    >
                      <client-only>
                        <font-awesome-icon :icon="['fas', 'trash']" class="w-4 h-4 text-red-500" />
                      </client-only>
                    </button>
                  </div>
                </template>
                <template v-else-if="column.key === 'createdAt' && showDate">
                  <div class="font-mono font-medium text-gray-900">
                    {{ formatDate(item[column.key]) }}
                  </div>
                </template>
                <template v-else>
                  {{ renderCellValue(item, column) }}
                </template>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  
      <!-- Pagination -->
      <Pagination
        v-if="!loading && !error && tableData.length > 0"
        :current-page="pagination.currentPage"
        :total-pages="pagination.totalPages"
        :total-items="pagination.totalItems"
        :page-size="pagination.pageSize"
        :page-size-options="pagination.pageSizeOptions"
        @page-change="handlePageChange"
        @page-size-change="handlePageSizeChange"
      />
  
      <!-- Retry Modal -->
      <Modal
        v-if="retryModal.open"
        :title="'Relancer la transaction'"
        @close="closeRetryModal"
      >
        <div class="space-y-6">
          <div class="bg-yellow-50 border border-yellow-200 rounded-xl p-4">
            <p class="text-sm text-yellow-700">
              Pour des raisons de sécurité, veuillez confirmer l'ID de la transaction 
              que vous souhaitez relancer.
            </p>
          </div>
  
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">
                ID de la transaction
              </label>
              <input
                type="text"
                v-model="retryId"
                :placeholder="retryModal.transaction?.id"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg 
                  focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
  
            <div class="bg-gray-50 rounded-lg p-4">
              <p class="text-sm text-gray-600">
                Transaction : <span class="font-medium">{{ retryModal.transaction?.ref }}</span>
              </p>
              <p class="text-sm text-gray-600">
                Montant : <span class="font-medium font-bold font-monospace text-lg">{{ retryModal.transaction?.montant }} F</span>
              </p>
            </div>
          </div>
  
          <div class="flex justify-end gap-3">
            <button
              @click="closeRetryModal"
              class="px-4 py-2 text-gray-700 hover:bg-gray-100 
                rounded-lg transition-colors"
            >
              Annuler
            </button>
            <button
              @click="confirmRetry"
              :disabled="retryId !== retryModal.transaction?.ref?.toString()"
              :class="`px-4 py-2 rounded-lg transition-colors
                ${retryId === retryModal.transaction?.ref?.toString()
                  ? 'bg-blue-600 text-white hover:bg-blue-700'
                  : 'bg-blue-100 text-blue-400 cursor-not-allowed'
                }`"
            >
              Relancer
            </button>
          </div>
        </div>
      </Modal>
  
      <!-- Warning Modal -->
      <WarningModal
        v-if="warningModal.show"
        :title="getWarningModalTitle()"
        :message="getWarningModalMessage()"
        :confirm-text="getWarningModalConfirmText()"
        :cancel-text="'Annuler'"
        :details="getWarningModalDetails()"
        :loading="warningModal.loading"
        @hide="closeWarningModal"
        @confirm="confirmWarningModal"
      />
    </div>
  </template>
  
  <script>
  export default {
    name: 'DataTable',
    props: {
      columns: {
        type: Array,
        required: true
      },
      data: {
        type: Array,
        default: () => []
      },
      loading: {
        type: Boolean,
        default: false
      },
      error: {
        type: Boolean,
        default: false
      },
      pagination: {
        type: Object,
        default: () => ({
          currentPage: 1,
          totalPages: 1,
          totalItems: 1,
          pageSize: 10,
          pageSizeOptions: [1, 5, 10, 25, 50, 100]
        })
      },
      filters: {
        type: Boolean,
        default: false
      },
      dateRange: {
        type: Boolean,
        default: false
      },
      searchPlaceholder: {
        type: String,
        default: "Taper une recherche..."
      },
      defaultFilters: {
        type: Object,
        default: () => ({})
      },
      filterOptions: {
        type: Array,
        default: () => []
      },
      showDate: {
        type: Boolean,
        default: false
      },
      entityType: {
        type: String,
        default: 'user'
      },
      availableActions: {
        type: Array,
        default: () => []
      }
    },
    data() {
      return {
        searchQuery: '',
        showFilters: false,
        activeFilters: { ...this.defaultFilters },
        sortKey: '',
        sortDirection: 'asc',
        retryModal: { 
          open: false, 
          transaction: null 
        },
        retryId: '',
        warningModal: {
          show: false,
          entity: null,
          action: null,
          loading: false
        }
      }
    },
    computed: {
      tableData() {
        return this.data || []
      },
      displayColumns() {
        // Build columns array including all needed columns
        const columns = [
          ...this.columns.filter(col => !['operations', 'statuss', 'modes'].includes(col.key)),
        ]
        
        // Add date column if needed
        if (this.showDate) {
          columns.push({
            key: 'createdAt',
            label: 'Créé le'
          })
        }
        
        // Add actions column
        columns.push({
          key: 'actions',
          label: ''
        })
        
        return columns
      },
      paginatedData() {
        // Return the current page of data
        // In a real implementation, this would be handled server-side with the pagination prop
        return this.tableData
      }
    },
    methods: {
      hasAction(action) {
        return this.availableActions.includes(action)
      },
      debounceSearch() {
        clearTimeout(this._searchTimeout)
        this._searchTimeout = setTimeout(() => {
          this.$emit('search', this.searchQuery)
        }, 500)
      },
      handleFilterChange(key, value) {
        this.activeFilters = { ...this.activeFilters, [key]: value }
        this.$emit('filter', this.activeFilters)
      },
      resetFilters() {
        this.activeFilters = {}
        this.$emit('filter', {})
      },
      sortTable(key) {
        if (this.sortKey === key) {
          this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc'
        } else {
          this.sortKey = key
          this.sortDirection = 'asc'
        }
        // Emit sort event for server-side sorting
        this.$emit('sort', { key: this.sortKey, direction: this.sortDirection })
      },
      handlePageChange(page) {
        this.$emit('page-change', page)
      },
      handlePageSizeChange(size) {
        this.$emit('page-size-change', size)
      },
      formatDate(dateStr) {
        if (!dateStr) return ''
        const date = new Date(dateStr)
        return new Intl.DateTimeFormat('fr-FR', {
          day: '2-digit',
          month: '2-digit',
          year: 'numeric',
          hour: '2-digit',
          minute: '2-digit'
        }).format(date)
      },
      renderCellValue(item, column) {
        // Handle different types of cell values
        const value = item[column.key]
        
        if (value === undefined || value === null) return ''
        
        if (typeof value === 'boolean') {
          return value ? 'Oui' : 'Non'
        }
        
        return value
      },
      openRetryModal(transaction) {
        this.retryModal = { 
          open: true, 
          transaction 
        }
        this.retryId = ''
      },
      closeRetryModal() {
        this.retryModal = { 
          open: false, 
          transaction: null 
        }
        this.retryId = ''
      },
      confirmRetry() {
        if (this.retryId === this.retryModal.transaction?.ref?.toString()) {
          this.$emit('retry', this.retryModal.transaction)
          this.closeRetryModal()
        }
      },
      openWarningModal(action, entity) {
        this.warningModal = {
          show: true,
          entity,
          action,
          loading: false
        }
      },
      closeWarningModal() {
        this.warningModal = {
          show: false, 
          entity: null, 
          action: null, 
          loading: false
        }
      },
      confirmWarningModal() {
        const { action, entity } = this.warningModal
        this.warningModal.loading = true
        
        try {
          if (action === 'delete') {
            this.$emit('delete', entity)
          } else if (action === 'lock') {
            this.$emit('lock', entity)
          }
          
          this.$nextTick(() => {
            this.closeWarningModal()
          })
        } catch (error) {
          console.error('Action failed:', error)
          this.warningModal.loading = false
        }
      },
      getWarningModalTitle() {
        const { action, entity } = this.warningModal
        const isActive = entity?.active || entity?.actif
        
        if (action === 'delete') {
          return `Supprimer ${this.entityType === 'user' ? 'l\'utilisateur' : 'l\'élément'}`
        } else if (action === 'lock') {
          return isActive 
            ? `Désactiver ${this.entityType === 'user' ? 'le compte' : 'l\'élément'}`
            : `Activer ${this.entityType === 'user' ? 'le compte' : 'l\'élément'}`
        }
        
        return ''
      },
      getWarningModalMessage() {
        const { action, entity } = this.warningModal
        const isActive = entity?.active || entity?.actif
        const name = entity?.nomComplet || entity?.numserie || 'cet élément'
        
        if (action === 'delete') {
          return `Êtes-vous sûr de vouloir supprimer "${name}" ?`
        } else if (action === 'lock') {
          return isActive 
            ? `Êtes-vous sûr de vouloir désactiver "${name}" ?`
            : `Êtes-vous sûr de vouloir activer "${name}" ?`
        }
        
        return ''
      },
      getWarningModalConfirmText() {
        const { action, entity } = this.warningModal
        const isActive = entity?.active || entity?.actif
        
        if (action === 'delete') {
          return "Supprimer"
        } else if (action === 'lock') {
          return isActive ? "Désactiver" : "Activer"
        }
        
        return "Confirmer"
      },
      getWarningModalDetails() {
        const { entity } = this.warningModal
        const isActive = entity?.active || entity?.actif
        
        const details = [
          { 
            label: "Nom",
            value: entity?.nomComplet || entity?.numserie || ''
          },
          { 
            label: "Statut",
            value: isActive ? "Actif" : "Inactif",
            type: "badge",
            variant: isActive ? "success" : "danger"
          }
        ]
        
        if (this.entityType === 'card' && entity?.solde !== undefined) {
          details.push({ 
            label: "Solde",
            value: entity.solde || 0,
            type: "money"
          })
        }
        
        return details
      },
      exportCSV() {
        const filename = `export-${this.entityType}-${new Date().toISOString().split('T')[0]}`
        const headers = this.columns
          .filter(col => col.key !== 'actions')
          .map(col => col.label)
          .join(',')
        
        const rows = this.tableData
          .map(item => 
            this.columns
              .filter(col => col.key !== 'actions')
              .map(col => {
                const value = item[col.key]
                if (typeof value === 'number') return value
                if (typeof value === 'object') return ''
                return `"${value || ''}"`
              })
              .join(',')
          )
          .join('\n')
        
        const csv = `${headers}\n${rows}`
        this.downloadFile(csv, `${filename}.csv`, 'text/csv')
      },
      exportExcel() {
        // In a real implementation, you might want to use a library like xlsx
        // This is a simplified version that uses TSV format
        const filename = `export-${this.entityType}-${new Date().toISOString().split('T')[0]}`
        const headers = this.columns
          .filter(col => col.key !== 'actions')
          .map(col => col.label)
          .join('\t')
        
        const rows = this.tableData
          .map(item => 
            this.columns
              .filter(col => col.key !== 'actions')
              .map(col => {
                const value = item[col.key]
                if (typeof value === 'number') return value
                if (typeof value === 'object') return ''
                return value || ''
              })
              .join('\t')
          )
          .join('\n')
        
        const tsv = `${headers}\n${rows}`
        this.downloadFile(tsv, `${filename}.xlsx`, 'text/tab-separated-values')
      },
      exportJSON() {
        const filename = `export-${this.entityType}-${new Date().toISOString().split('T')[0]}`
        const jsonData = this.tableData.map(item => {
          const newItem = {}
          this.columns
            .filter(col => col.key !== 'actions')
            .forEach(col => {
              newItem[col.label] = item[col.key]
            })
          return newItem
        })
        
        const json = JSON.stringify(jsonData, null, 2)
        this.downloadFile(json, `${filename}.json`, 'application/json')
      },
      downloadFile(content, filename, type) {
        const blob = new Blob([content], { type: `${type};charset=utf-8;` })
        const url = URL.createObjectURL(blob)
        const link = document.createElement('a')
        
        link.setAttribute('href', url)
        link.setAttribute('download', filename)
        link.style.visibility = 'hidden'
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
      },
      printTable() {
        const printWindow = window.open('', '_blank')
        const headers = this.columns
          .filter(col => col.key !== 'actions')
          .map(col => col.label)
        
        const tableHTML = `
          <html>
            <head>
              <title>Export ${this.entityType}</title>
              <style>
               body { 
  font-family: -apple-system, system-ui, sans-serif;
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}
table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 2rem;
}
thead {
  background-color: #f3f4f6;
}
th, td {
  padding: 0.75rem 1rem;
  text-align: left;
  border-bottom: 1px solid #e5e7eb;
}
th {
  font-weight: 600;
}
tr:nth-child(even) {
  background-color: #f9fafb;
}
.table-title {
  font-size: 1.5rem;
  margin-bottom: 1rem;
}
.print-footer {
  margin-top: 2rem;
  font-size: 0.875rem;
  color: #6b7280;
  text-align: center;
}
          </head>
          <body>
            <h1 class="table-title">Export ${this.entityType}</h1>
            <table>
              <thead>
                <tr>
                  ${headers.map(header => `<th>${header}</th>`).join('')}
                </tr>
              </thead>
              <tbody>
                ${this.tableData.map(item => `
                  <tr>
                    ${this.columns
                      .filter(col => col.key !== 'actions')
                      .map(col => `<td>${this.renderCellValue(item, col)}</td>`)
                      .join('')}
                  </tr>
                `).join('')}
              </tbody>
            </table>
            <div class="print-footer">
              Exporté le ${new Date().toLocaleDateString('fr-FR', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
              })}
            </div>
          </body>
        </html>
      `
      
      printWindow.document.write(tableHTML)
      printWindow.document.close()
      
      // Wait for content to load before printing
      printWindow.onload = function() {
        printWindow.print()
        printWindow.onafterprint = function() {
          printWindow.close()
        }
      }
    }
  },
  watch: {
    defaultFilters: {
      handler(newFilters) {
        this.activeFilters = { ...newFilters }
      },
      deep: true,
      immediate: true
    }
  },
  mounted() {
    // Close filters dropdown when clicking outside
    const handleClickOutside = (event) => {
      if (this.$refs.filtersRef && !this.$refs.filtersRef.contains(event.target)) {
        this.showFilters = false
      }
    }
    
    document.addEventListener('click', handleClickOutside)
    
    this.$once('hook:beforeDestroy', () => {
      document.removeEventListener('click', handleClickOutside)
    })
  }
}
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.2s, transform 0.2s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}
body { 
  font-family: -apple-system, system-ui, sans-serif;
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}
table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 2rem;
}
thead {
  background-color: #f3f4f6;
}
th, td {
  padding: 0.75rem 1rem;
  text-align: left;
  border-bottom: 1px solid #e5e7eb;
}
th {
  font-weight: 600;
}
tr:nth-child(even) {
  background-color: #f9fafb;
}
.table-title {
  font-size: 1.5rem;
  margin-bottom: 1rem;
}
.print-footer {
  margin-top: 2rem;
  font-size: 0.875rem;
  color: #6b7280;
  text-align: center;
}
</style>