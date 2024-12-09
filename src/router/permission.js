import { useAdminStore } from '@/store/adminStore'
import { useUserStore } from '@/store/userStore'
import router from '@/router' // 引入 router 实例

const whiteList = ['/admin/login', '/login', '/register', '/reset-psw'] // 定义白名单路径

// 定义检查白名单的函数
const isInWhiteList = (path) => whiteList.includes(path)

// 定义路由守卫
router.beforeEach((to, from, next) => {
  const isAdminPath = to.path.startsWith('/admin')
  const isUserPath = to.path.startsWith('/')

  if (isAdminPath) {
    const adminStore = useAdminStore()
    const token = adminStore.adminInfo?.token
    if (token) {
      // 已登录管理员用户尝试访问登录页面，重定向到管理员首页
      if (to.path === '/admin/login') return next('/admin')
      return next() // 其他路径放行
    } else {
      // 未登录管理员用户，白名单放行，否则重定向
      return isInWhiteList(to.path) ? next() : next('/admin/login')
    }
  }

  if (isUserPath) {
    const userStore = useUserStore()
    const token = userStore.userInfo?.token
    if (token) {
      // 已登录用户尝试访问用户登录页面，重定向到用户首页
      if (to.path === '/login') return next('/')
      return next() // 其他路径放行
    } else {
      // 未登录用户，白名单放行，否则重定向
      return isInWhiteList(to.path) ? next() : next('/login')
    }
  }

  // 其他路径默认放行
  next()
})
