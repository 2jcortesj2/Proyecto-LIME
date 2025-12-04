<template>
  <div class="modal" :class="{ active: show }">
    <div class="modal-content" style="max-width: 500px;">
      <div class="modal-header">
        <div class="modal-title">{{ title }}</div>
        <button class="close-btn" @click="handleClose">&times;</button>
      </div>
      <div class="modal-body">
        <div class="alert alert-success" style="cursor: default;">
          <span style="font-size: 48px;">{{ icon }}</span>
          <div style="font-size: 16px;">{{ message }}</div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" @click="handleClose">Aceptar</button>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  show: {
    type: Boolean,
    required: true
  },
  title: {
    type: String,
    default: '<AppIcon name="check" size="16" /> Operación Exitosa'
  },
  message: {
    type: String,
    default: 'La operación se completó correctamente.'
  },
  icon: {
    type: String,
    default: '<AppIcon name="check" size="16" />'
  }
})

const emit = defineEmits(['close'])

function handleClose() {
  emit('close')
}
</script>

<style scoped>
@import './modal-styles.css';
</style>
