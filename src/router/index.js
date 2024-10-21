import LoginAdmin from '@/views/login/LoginAdmin.vue'
import { createRouter, createWebHistory } from 'vue-router'
import Layout from '@/views/Layout/layout.vue'
import Home from '@/views/Home/goods.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/loginAdmin',
      component: LoginAdmin
    },
    {
      path: '/',
      component: Layout,
      children:[
        {
          path: '',
          component: Home
        }
      ]
    }
  ]
})

export default router
