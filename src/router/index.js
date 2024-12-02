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
import ReceivedComments from '@/views/users/profiles/ReceivedComments.vue'
import GivenComments from '@/views/users/profiles/GivenComments.vue'
import ProfilesPublished from '@/views/users/profiles/ProfilesPublished.vue'
import ProfilesFinished from '@/views/users/profiles/ProfilesFinished.vue'
import AddressPage from '@/views/users/address/AddressPage.vue'
import CollectionsPage from '@/views/users/collections/CollectionsPage.vue'
import ResetPswUser from '@/views/login/ResetPswUser.vue'
import AdminManagement from '@/views/admins/AdminManagement.vue'
import AdminsInfo from '@/views/admins/accounts/AdminsInfo.vue'
import UsersInfo from '@/views/admins/accounts/UsersInfo.vue'
import OrdersInfo from '@/views/admins/sales/OrdersInfo.vue'
import AfterSale from '@/views/admins/sales/AfterSale.vue'
import AnnouncementInfo from '@/views/admins/contents/AnnouncementInfo.vue'
import CategoryInfo from '@/views/admins/contents/CategoryInfo.vue'
import CommentInfo from '@/views/admins/contents/CommentInfo.vue'
import AdminProfiles from '@/views/admins/AdminProfiles.vue'
import ProductsInfo from '@/views/admins/sales/ProductsInfo.vue'

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
      path: '/profiles/:id',
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
          path: 'receivedComment',
          component: ReceivedComments
        },
        {
          path: 'givenComment',
          component: GivenComments
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
    },
    // admin
    {
      path: '/admin',
      component: AdminManagement,
      redirect: '/admin/usersInfo',
      children: [
        {
          path: 'adminInfo',
          component: AdminsInfo
        },
        {
          path: 'usersInfo',
          component: UsersInfo
        },
         {
          path: 'productsInfo',
          component: ProductsInfo
        },
        {
          path: 'ordersInfo',
          component: OrdersInfo
        },
        {
          path: 'afterSale',
          component: AfterSale
        },
        {
          path: 'announcementInfo',
          component: AnnouncementInfo
        },
        {
          path: 'categoryInfo',
          component: CategoryInfo
        },
        {
          path: 'commentInfo',
          component: CommentInfo
        },
        {
          path: 'profiles',
          component: AdminProfiles
        }
      ]
    }
  ]
})

export default router
