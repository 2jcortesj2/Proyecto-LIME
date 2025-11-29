<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 500px;">
      <div class="modal-header">
        <div class="modal-title">✅ Operación Exitosa</div>
        <button class="close-btn" @click="$emit('close')">&times;</button>
      </div>
      <div class="modal-body">
        <div class="alert alert-success" style="cursor: default;">
          <span style="font-size: 48px;">✅</span>
          <div style="font-size: 16px;">La operación se completó correctamente.</div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" @click="$emit('close')">Aceptar</button>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  show: {
    type: Boolean,
    required: true
  }
})

defineEmits(['close'])
</script>

<style scoped>
/* Modal Styles */
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
.btn-primary { background: #006633; color: white; }
.btn-primary:hover { background: #2d5016; transform: translateY(-2px); }

.alert { padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 12px; cursor: pointer; transition: all 0.3s; }
.alert-success { background: rgba(76, 175, 80, 0.1); color: #4CAF50; border-left: 4px solid #4CAF50; }
</style>
