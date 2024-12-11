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
    
    const adminStore = useAdminStore() 
    const userStore = useUserStore() 

     if (response.data.code == 2){
      // 判断是管理员端还是用户端
      const configUrl = response.config?.url; 
      const isAdmin = configUrl?.startsWith('/admin');

      if (isAdmin) {
        // 管理员端操作：清空管理员信息并跳转到管理员登录页
        adminStore.clearAdminInfo() 
        router.push('/admin/login') 
      } else {
        // 用户端操作：清空用户信息并跳转到用户登录页
        userStore.clearUserInfo() 
        router.push('/login') 
      }
      
      ElMessage.error("登录已过期，请重新登录")
     }
    
    return response
  },
  function (error) {
      ElMessage({
        type: 'error',
        message: error.response.data.msg
      })
    return Promise.reject(error)
  }
)

export default httpInstance
