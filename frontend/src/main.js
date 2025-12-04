import { createApp } from 'vue'
import './style.css'
import './assets/styles/components.css'
import './assets/styles/filter-styles.css'
import App from './App.vue'
import AppIcon from './components/common/AppIcon.vue'

const app = createApp(App)
app.component('AppIcon', AppIcon)
app.mount('#app')

