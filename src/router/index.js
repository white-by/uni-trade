import { createRouter, createWebHistory } from 'vue-router'
import LoginAdmin from '@/views/login/LoginAdmin.vue'
import LayoutPage from '@/views/home/ProductsPage.vue'
import LoginUser from '@/views/login/LoginUser.vue'
import TestPage from '@/views/test/TestPage.vue'
import PersonalPage from '@/views/users/infomation/PersonalPage.vue'
import RegisterUser from '@/views/login/RegisterUser.vue'
import Detail from '@/views/detail/DetailPage.vue'
import Order from '@/views/users/orders/OrderPage.vue'
import ProfilesPage from '@/views/users/profiles/ProfilesPage.vue'
import ProfilesComment from '@/views/users/profiles/ProfilesComment.vue'
import ProfilesPublished from '@/views/users/profiles/ProfilesPublished.vue'
import ProfilesFinished from '@/views/users/profiles/ProfilesFinished.vue'
import AddressPage from '@/views/users/address/AddressPage.vue'
import CollectionsPage from '@/views/users/collections/CollectionsPage.vue'
import ResetPswUser from '@/views/login/ResetPswUser.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/user/collections',
      component: CollectionsPage
    },
    {
      path: '/user/address',
      component: AddressPage
    },
    {
      path: '/user/order',
      component: Order
    },
    {
      path: '/profiles',
      component: ProfilesPage,
      redirect: '/profiles/published',
      children: [
        {
          path: 'published',
          component: ProfilesPublished
        },
        {
          path: 'finished',
          component: ProfilesFinished
        },
        {
          path: 'comment',
          component: ProfilesComment
        }
      ]
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
      path: '/reset-psw',
      component: ResetPswUser
    },
    {
      path: '/',
      component: LayoutPage
    }
  ]
})

export default router
