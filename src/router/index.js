import LoginAdmin from '@/views/login/LoginAdmin.vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/loginAdmin',
      component: LoginAdmin
    }
  ]
})

export default router
