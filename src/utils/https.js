//axios基础的封装
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { useAdminStore } from '@/store/adminStore'
import { useUserStore } from '@/store/userStore'
import { config } from '@/config/config'
import router from '@/router'

const httpInstance = axios.create({
  baseURL: config.baseURL,
  timeout: config.timeout
})

// 添加请求拦截器
httpInstance.interceptors.request.use(
  (config) => {
    const adminStore = useAdminStore()
    const userStore = useUserStore()

    // 判断请求路径是否以 '/admin' 开头
    if (config.url && config.url.startsWith('/admin')) {
      // 管理员端，使用管理员token
      const adminToken = adminStore.adminInfo.token
      if (adminToken) {
        config.headers.Authorization = `${adminToken}`
      }
    } else {
      // 用户端，使用用户token
      const userToken = userStore.userInfo.token
      if (userToken) {
        config.headers.Authorization = `${userToken}`
      }
    }

    return config
  },
  (e) => Promise.reject(e)
)

// 添加响应拦截器
httpInstance.interceptors.response.use(
  function (response) {
    // 2xx 范围内的状态码都会触发该函数。
    // 对响应数据做点什么
    return response
  },
  function (error) {
    const adminStore = useAdminStore() // 获取 adminStore 实例
    const userStore = useUserStore() // 获取 userStore 实例

    // 如果 code 为 2，表示 token 过期
    if (error.response.data.code === 2) {
      // 判断是管理员端还是用户端
      const isAdmin = error.config.url.startsWith('/admin')

      if (isAdmin) {
        // 管理员端操作：清空管理员信息并跳转到管理员登录页
        adminStore.clearAdminInfo() // 清空管理员信息
        router.push('/admin/login') // 跳转到管理员登录页
      } else {
        // 用户端操作：清空用户信息并跳转到用户登录页
        console.log("清空用户信息")
        userStore.clearUserInfo() // 清空用户信息
        router.push('/login') // 跳转到用户登录页
      }
      
      ElMessage.error("登录已过期，请重新登录")

    } else {
      ElMessage({
        type: 'error',
        message: error.response.data.msg
      })
    }
    return Promise.reject(error)
  }
)

export default httpInstance
