<template>
  <div v-if="show" class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Nuevo Responsable</h2>
        <button class="modal-close" @click="$emit('close')"><AppIcon name="close" size="16" /></button>
      </div>
      
      <div class="modal-body">
        <div v-if="successMessage" class="success-message">{{ successMessage }}</div>
        <div v-if="formErrors.submit" class="error-message">{{ formErrors.submit }}</div>
        
        <form @submit.prevent="$emit('submit')">
          <div class="form-group">
            <label class="form-label required">Nombre Completo</label>
            <input 
              type="text" 
              v-model="localForm.nombre_completo" 
              class="form-input"
              :class="{ 'input-error': formErrors.nombre_completo }"
              placeholder="Ej: Juan Pérez"
            >
            <span v-if="formErrors.nombre_completo" class="error-text">{{ formErrors.nombre_completo }}</span>
          </div>

          <div class="form-group">
            <label class="form-label required">Rol</label>
            <input 
              type="text" 
              v-model="localForm.rol" 
              class="form-input"
              :class="{ 'input-error': formErrors.rol }"
              placeholder="Ej: Ingeniero Biomédico"
            >
            <span v-if="formErrors.rol" class="error-text">{{ formErrors.rol }}</span>
          </div>

          <div class="form-group">
            <label class="form-label required">Email</label>
            <input 
              type="email" 
              v-model="localForm.email" 
              class="form-input"
              :class="{ 'input-error': formErrors.email }"
              placeholder="Ej: juan.perez@hospital.com"
            >
            <span v-if="formErrors.email" class="error-text">{{ formErrors.email }}</span>
          </div>

          <div class="form-group">
            <label class="form-label">Teléfono</label>
            <input 
              type="text" 
              v-model="localForm.telefono" 
              class="form-input"
              placeholder="Ej: +57 300 123 4567"
            >
          </div>

          <div class="form-actions">
            <button type="button" class="btn-secondary" @click="$emit('close')" :disabled="submitLoading">
              Cancelar
            </button>
            <button type="submit" class="btn-primary" :disabled="submitLoading">
              {{ submitLoading ? 'Guardando...' : 'Guardar' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  show: Boolean,
  formData: Object,
  formErrors: Object,
  successMessage: String,
  submitLoading: Boolean
})

const emit = defineEmits(['close', 'submit', 'update:formData'])

const localForm = computed({
  get: () => props.formData,
  set: (value) => emit('update:formData', value)
})
</script>

<style scoped>
@import '@/assets/styles/modal.css';
</style>
