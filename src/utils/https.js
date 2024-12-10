//axios基础的封装
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { useAdminStore } from '@/store/adminStore'
import { config } from '@/config/config'

const httpInstance = axios.create({
  baseURL: config.baseURL,
  timeout: config.timeout
})

//拦截器
// 添加请求拦截器
httpInstance.interceptors.request.use(
  (config) => {
    const adminStore = useAdminStore()
    const token = adminStore.adminInfo.token
    if (token) {
      config.headers.Authorization = `${token}`
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
