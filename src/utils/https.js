//axios基础的封装
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { useAdminStore } from '@/store/adminStore'
import { useUserStore } from '@/store/userStore'
import { config } from '@/config/config'

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
    // 超出 2xx 范围的状态码都会触发该函数。
    // 对响应错误做点什么
    ElMessage({
      type: 'error',
      message: error.response.data.msg
    })
    return Promise.reject(error)
  }
)

export default httpInstance
