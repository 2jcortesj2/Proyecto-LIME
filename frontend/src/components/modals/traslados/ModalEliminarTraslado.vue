<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 400px;">
      <div class="modal-header" style="background: #ffebee;">
        <h3 class="modal-title" style="color: #d32f2f;">🗑️ Eliminar Traslado</h3>
        <button class="close-btn" @click="$emit('close')">×</button>
      </div>
      <div class="modal-body" style="text-align: center; padding: 30px;">
        <p style="font-size: 16px; color: #616161; margin-bottom: 20px;">
          ¿Estás seguro de que deseas eliminar este registro de traslado?
        </p>
        <div style="background: #f5f5f5; padding: 15px; border-radius: 8px; text-align: left;">
          <div style="font-weight: 600; color: #212121;">{{ selectedTraslado?.equipo_nombre }}</div>
          <div style="font-size: 13px; color: #616161;">{{ formatFecha(selectedTraslado?.fecha_traslado) }}</div>
        </div>
        <p style="font-size: 13px; color: #f44336; margin-top: 20px;">
          ⚠️ Esta acción no se puede deshacer.
        </p>
      </div>
      <div class="modal-footer" style="justify-content: center;">
        <button class="btn btn-secondary" @click="$emit('close')">Cancelar</button>
        <button class="btn btn-danger" @click="$emit('confirm')">Sí, Eliminar</button>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  show: Boolean,
  selectedTraslado: Object,
  formatFecha: Function
})

defineEmits(['close', 'confirm'])
</script>

<style scoped>
/* Estilos copiados de Traslados.vue */
.modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 1000; backdrop-filter: blur(4px); }
.modal.active { display: flex; align-items: center; justify-content: center; }
.modal-content { background: white; border-radius: 12px; width: 95%; max-width: 1100px; max-height: 90vh; display: flex; flex-direction: column; box-shadow: 0 10px 40px rgba(0,0,0,0.3); }
.modal-header { padding: 25px; border-bottom: 2px solid #e0e0e0; display: flex; justify-content: space-between; align-items: center; background: linear-gradient(90deg, rgba(0,102,51,0.05) 0%, transparent 100%); flex-shrink: 0; }
.modal-title { font-size: 22px; color: #006633; font-weight: 600; }
.close-btn { background: none; border: none; font-size: 28px; cursor: pointer; color: #616161; }
.close-btn:hover { color: #f44336; }
.modal-body { padding: 25px; overflow-y: auto; flex: 1; }
.modal-footer { padding: 20px 25px; border-top: 1px solid #e0e0e0; display: flex; justify-content: flex-end; gap: 12px; background: #f5f5f5; flex-shrink: 0; }

/* Button Styles */
.btn { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
.btn-secondary { background: #e0e0e0; }
.btn-secondary:hover { background: #d0d0d0; }
.btn-danger { background: #f44336; color: white; }
.btn-danger:hover { background: #d32f2f; }
</style>
