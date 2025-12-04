<template>
  <div v-if="show" class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content modal-small">
      <div class="modal-header">
        <h2>Confirmar Eliminación</h2>
        <button class="modal-close" @click="$emit('close')">❌</button>
      </div>
      
      <div class="modal-body">
        <p style="margin-bottom: 20px;">
          ¿Está seguro que desea eliminar al responsable <strong>{{ responsable?.nombre_completo }}</strong>?
        </p>
        <p style="color: #d32f2f; font-size: 14px;">
          Esta acción no se puede deshacer.
        </p>
        
        <div class="form-actions">
          <button type="button" class="btn-secondary" @click="$emit('close')" :disabled="submitLoading">
            Cancelar
          </button>
          <button type="button" class="btn-danger" @click="$emit('confirm')" :disabled="submitLoading">
            {{ submitLoading ? 'Eliminando...' : 'Eliminar' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  show: Boolean,
  responsable: Object,
  submitLoading: Boolean
})

defineEmits(['close', 'confirm'])
</script>

<style scoped>
@import '@/assets/styles/modal.css';
</style>
