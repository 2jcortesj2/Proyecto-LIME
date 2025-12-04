<script setup>
import { computed } from 'vue'
import { icons } from '@/icons.js'

const props = defineProps({
  name: {
    type: String,
    required: true
  },
  size: {
    type: [String, Number],
    default: 20
  },
  color: {
    type: String,
    default: 'currentColor'
  },
  strokeWidth: {
    type: [String, Number],
    default: 2
  }
})

const IconComponent = computed(() => {
  return icons[props.name] || null
})

const iconSize = computed(() => {
  return typeof props.size === 'number' ? `${props.size}px` : props.size
})
</script>

<template>
  <component 
    v-if="IconComponent" 
    :is="IconComponent" 
    :size="iconSize"
    :color="props.color"
    :stroke-width="props.strokeWidth"
    class="app-icon"
  />
  <span v-else class="app-icon-missing">?</span>
</template>

<style scoped>
.app-icon {
  display: inline-block;
  vertical-align: middle;
}

.app-icon-missing {
  display: inline-block;
  width: 20px;
  height: 20px;
  text-align: center;
  color: #ff0000;
  font-weight: bold;
}
</style>
