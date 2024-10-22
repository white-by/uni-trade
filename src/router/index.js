import LoginAdmin from '@/views/login/LoginAdmin.vue'
import { createRouter, createWebHistory } from 'vue-router'
import LayoutPage from '@/views/layout/LayoutPage.vue'
import GoodsPage from '@/views/home/GoodsPage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/admin/login',
      component: LoginAdmin
    },
    {
      path: '/',
      component: LayoutPage,
      children: [
        {
          path: '',
          component: GoodsPage
        }
      ]
    }
  ]
})

export default router
