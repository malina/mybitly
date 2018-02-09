import Vue from 'vue'
//import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'
import VueMaterial from 'vue-material'
import 'vue-material/dist/vue-material.min.css'
import Form from '../components/form.vue'
import store from '../store'

Vue.use(VueMaterial)
Vue.component('url-form', Form)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    store,
    el: '#app',
    render: h => h(App)
  })
})
