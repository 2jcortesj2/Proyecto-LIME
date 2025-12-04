<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 500px;">
      <div class="modal-header" style="background: rgba(244, 67, 54, 0.05);">
        <h3 class="modal-title" style="color: #d32f2f;"><AppIcon name="trash" size="16" /> Eliminar Traslado</h3>
        <button class="close-btn" @click="$emit('close')">&times;</button>
      </div>
      <div class="modal-body" style="text-align: center; padding: 30px;">
        <p style="font-size: 16px; color: #616161; margin-bottom: 20px;">
          ¿Estás seguro de que deseas eliminar este registro de traslado?
        </p>
        
        <div class="info-box" style="text-align: left;">
          <div style="font-weight: 600; color: #212121; margin-bottom: 8px;">
            {{ traslado?.equipo_nombre }}
          </div>
          <div style="font-size: 13px; color: #666; margin-bottom: 4px;">
            <strong>Código:</strong> {{ traslado?.equipo_codigo }}
          </div>
          <div style="font-size: 13px; color: #666; margin-bottom: 4px;">
            <strong>Fecha:</strong> {{ formatFecha(traslado?.fecha_traslado) }}
          </div>
          <div style="font-size: 13px; color: #666;">
            <strong>Origen → Destino:</strong> {{ traslado?.sede_origen_nombre }} → {{ traslado?.sede_destino_nombre }}
          </div>
        </div>
        
        <div class="alert alert-warning" style="margin-top: 20px;">
          <AppIcon name="alert" size="16" /> Esta acción no se puede deshacer
        </div>
      </div>
      <div class="modal-footer" style="justify-content: center;">
        <button class="btn btn-secondary" @click="$emit('close')">Cancelar</button>
        <button class="btn btn-danger" @click="handleConfirm" :disabled="isDeleting">
          {{ isDeleting ? 'Eliminando...' : 'Sí, Eliminar' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  show: Boolean,
  traslado: Object
})

const emit = defineEmits(['close', 'confirm'])

const isDeleting = ref(false)

function formatFecha(fecha) {
  if (!fecha) return 'N/A'
  const date = new Date(fecha)
  return date.toLocaleDateString('es-CO', { year: 'numeric', month: 'long', day: 'numeric' })
}

async function handleConfirm() {
  isDeleting.value = true
  try {
    await emit('confirm')
  } finally {
    isDeleting.value = false
  }
}
</script>

<style scoped>
@import '../inventario/modal-styles.css';
</style>
