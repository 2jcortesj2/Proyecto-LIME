<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title">📅 Reprogramar Mantenimiento</h3>
        <button class="close-btn" @click="$emit('close')">❌</button>
      </div>
      
      <div class="modal-body">
        <div class="equipo-info">
          <div class="info-label">Equipo:</div>
          <div class="info-value">{{ equipo?.nombre_equipo }}</div>
          <div class="info-sub">{{ equipo?.codigo_interno }} - {{ equipo?.marca }} {{ equipo?.modelo }}</div>
        </div>

        <div class="date-picker-container">
          <div class="year-selector">
            <button class="year-btn" @click="changeYear(-1)" :disabled="currentYear <= minYear">‹</button>
            <span class="current-year">{{ currentYear }}</span>
            <button class="year-btn" @click="changeYear(1)">›</button>
          </div>

          <div class="months-grid">
            <button 
              v-for="(mes, index) in meses" 
              :key="index"
              class="month-btn"
              :class="{ 
                'selected': isSelected(index),
                'disabled': isDisabled(index),
                'current': isCurrentMonth(index)
              }"
              @click="selectMonth(index)"
              :disabled="isDisabled(index)"
            >
              {{ mes }}
            </button>
          </div>
          
          <div class="selected-date-display" v-if="selectedDate">
            Nueva fecha: <strong>{{ formatDate(selectedDate) }}</strong>
          </div>
        </div>

        <div class="warning-note" v-if="selectedDate">
          ⚠️ Esta acción actualizará la fecha del próximo mantenimiento sin crear un registro histórico.
        </div>
      </div>

      <div class="modal-footer">
        <button class="btn btn-secondary" @click="$emit('close')">Cancelar</button>
        <button 
          class="btn btn-primary" 
          @click="confirmarReprogramacion"
          :disabled="!selectedDate"
        >
          Confirmar Reprogramación
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  show: Boolean,
  equipo: Object
})

const emit = defineEmits(['close', 'submit'])

const meses = [
  'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
  'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
]

const today = new Date()
const minYear = today.getFullYear()
const currentYear = ref(minYear)
const selectedMonth = ref(null) // 0-11

// Reset state when modal opens
watch(() => props.show, (newVal) => {
  if (newVal) {
    currentYear.value = minYear
    selectedMonth.value = null
  }
})

const selectedDate = computed(() => {
  if (selectedMonth.value === null) return null
  // Set to the first day of the selected month
  return new Date(currentYear.value, selectedMonth.value, 1)
})

function changeYear(delta) {
  currentYear.value += delta
  // If going back to current year, ensure selected month is valid
  if (currentYear.value === minYear && selectedMonth.value !== null && selectedMonth.value < today.getMonth()) {
    selectedMonth.value = null
  }
}

function isDisabled(monthIndex) {
  if (currentYear.value > minYear) return false
  // Disable only past months (allow current month and future months)
  return monthIndex < today.getMonth()
}

function isSelected(monthIndex) {
  return selectedMonth.value === monthIndex
}

function isCurrentMonth(monthIndex) {
  return currentYear.value === minYear && monthIndex === today.getMonth()
}

function selectMonth(monthIndex) {
  if (isDisabled(monthIndex)) return
  selectedMonth.value = monthIndex
}

function formatDate(date) {
  if (!date) return ''
  return date.toLocaleDateString('es-CO', { month: 'long', year: 'numeric' })
}

function confirmarReprogramacion() {
  if (!selectedDate.value) return
  
  // Format as YYYY-MM-DD
  const year = selectedDate.value.getFullYear()
  const monthIndex = selectedDate.value.getMonth()
  const month = String(monthIndex + 1).padStart(2, '0')
  
  // Set to last day of the month to avoid "Vencido" status if current month is selected
  const lastDay = new Date(year, monthIndex + 1, 0).getDate()
  const day = String(lastDay).padStart(2, '0')
  
  const fechaFormateada = `${year}-${month}-${day}`
  
  console.log('=== DEBUG REPROGRAMAR ===')
  console.log('selectedMonth.value (index 0-11):', selectedMonth.value)
  console.log('selectedDate.value:', selectedDate.value)
  console.log('year:', year)
  console.log('month (formatted):', month)
  console.log('fechaFormateada:', fechaFormateada)
  console.log('=========================')
  
  emit('submit', {
    equipoId: props.equipo.id,
    nuevaFecha: fechaFormateada
  })
}
</script>

<style scoped>
.modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 1000; backdrop-filter: blur(4px); }
.modal.active { display: flex; align-items: center; justify-content: center; }
.modal-content { background: white; border-radius: 16px; width: 90%; max-width: 450px; box-shadow: 0 10px 40px rgba(0,0,0,0.3); overflow: hidden; animation: slideUp 0.3s ease; }

@keyframes slideUp {
  from { transform: translateY(20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

.modal-header { padding: 20px 25px; border-bottom: 1px solid #f0f0f0; display: flex; justify-content: space-between; align-items: center; background: #fff; }
.modal-title { font-size: 18px; color: #212121; font-weight: 700; margin: 0; }
.close-btn { background: none; border: none; font-size: 24px; cursor: pointer; color: #999; transition: color 0.2s; }
.close-btn:hover { color: #f44336; }

.modal-body { padding: 25px; }

.equipo-info { margin-bottom: 25px; text-align: center; background: #f9f9f9; padding: 15px; border-radius: 8px; }
.info-label { font-size: 11px; text-transform: uppercase; color: #666; letter-spacing: 1px; margin-bottom: 4px; }
.info-value { font-size: 16px; font-weight: 700; color: #006633; margin-bottom: 2px; }
.info-sub { font-size: 12px; color: #666; }

/* Date Picker Styles */
.date-picker-container { background: white; border: 1px solid #e0e0e0; border-radius: 12px; padding: 15px; margin-bottom: 20px; }

.year-selector { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding: 0 10px; }
.current-year { font-size: 18px; font-weight: 700; color: #212121; }
.year-btn { background: none; border: none; font-size: 24px; color: #006633; cursor: pointer; padding: 0 10px; transition: opacity 0.2s; }
.year-btn:disabled { color: #ccc; cursor: not-allowed; }
.year-btn:hover:not(:disabled) { opacity: 0.7; }

.months-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; }
.month-btn { 
  padding: 10px 5px; 
  background: white; 
  border: 1px solid #eee; 
  border-radius: 6px; 
  font-size: 13px; 
  cursor: pointer; 
  transition: all 0.2s;
  color: #444;
}

.month-btn:hover:not(:disabled) { border-color: #006633; color: #006633; background: #f0fdf4; }
.month-btn.selected { background: #006633; color: white; border-color: #006633; font-weight: 600; box-shadow: 0 2px 5px rgba(0,102,51,0.3); }
.month-btn.disabled { background: #f5f5f5; color: #ccc; cursor: not-allowed; border-color: transparent; }
.month-btn.current { border: 1px dashed #006633; }

.selected-date-display { margin-top: 15px; text-align: center; font-size: 14px; color: #212121; padding-top: 10px; border-top: 1px solid #f0f0f0; }

.warning-note { font-size: 12px; color: #f57c00; background: #fff3e0; padding: 10px; border-radius: 6px; text-align: center; line-height: 1.4; }

.modal-footer { padding: 20px 25px; border-top: 1px solid #f0f0f0; display: flex; justify-content: flex-end; gap: 12px; background: #fafafa; }

.btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 14px; transition: all 0.2s; }
.btn-primary { background: #006633; color: white; }
.btn-primary:hover { background: #2d5016; transform: translateY(-1px); box-shadow: 0 4px 10px rgba(0,102,51,0.2); }
.btn-primary:disabled { background: #ccc; cursor: not-allowed; transform: none; box-shadow: none; }
.btn-secondary { background: #e0e0e0; color: #444; }
.btn-secondary:hover { background: #d0d0d0; }
</style>
