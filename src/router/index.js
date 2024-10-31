import { createRouter, createWebHistory } from 'vue-router'
import LoginAdmin from '@/views/login/LoginAdmin.vue'
import LayoutPage from '@/views/layout/LayoutPage.vue'
import ProductsPage from '@/views/home/ProductsPage.vue'
import LoginUser from '@/views/login/LoginUser.vue'
import TestPage from '@/views/test/TestPage.vue'
import PersonalPage from '@/views/users/PersonalPage.vue'
import RegisterUser from '@/views/login/RegisterUser.vue'
import Detail from '@/views/detail/DetailPage.vue'
import Order from '@/views/users/OrderPage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/user/order',
      component: Order
    },
    {
      path: '/detail/:id',
      component: Detail
    },
    {
      path: '/test',
      component: TestPage
    },
    {
      path: '/user',
      component: PersonalPage
    },
    {
      path: '/admin/login',
      component: LoginAdmin
    },
    {
      path: '/login',
      component: LoginUser
    },
    {
      path: '/register',
      component: RegisterUser
    },
    {
      path: '/',
      component: LayoutPage,
      children: [
        {
          path: '',
          component: ProductsPage
        }
      ]
    }
  ]
})

export default router
