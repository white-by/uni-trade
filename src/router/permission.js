import { useAdminStore } from '@/store/adminStore' // 确保路径正确
import router from '@/router' // 引入 router 实例

const whiteList = ['/admin/login'] // 定义白名单路径

// 设置全局路由守卫
router.beforeEach((to, from, next) => {
  // 检查目标路径是否以 /admin 开头
  if (to.path.startsWith('/admin')) {
    const adminStore = useAdminStore()
    const token = adminStore.adminInfo?.data?.token // 确保安全获取 token
    if (token) {
      // 如果有 token 且试图访问 /admin/login 页面，重定向到 /admin 首页
      if (to.path === '/admin/login') {
        return next('/admin')
      } else {
        return next() // 放行其他 /admin 下的路径
      }
    } else {
      // 如果没有 token 且在白名单中，放行；否则重定向到 /admin/login
      if (whiteList.includes(to.path)) {
        return next()
      } else {
        return next('/admin/login')
      }
    }
  } else {
    // 如果路径不以 /admin 开头，放行
    next()
  }
})
