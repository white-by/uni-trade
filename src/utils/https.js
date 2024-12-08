//axios基础的封装
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { useAdminStore } from '@/store/adminStore'

const httpInstance = axios.create({
  //apifox云端MOCK
  // baseURL: 'http://127.0.0.1:4523/m1/5227100-4893915-default',
  baseURL: 'http://127.0.0.1:5001',
  timeout: 5000
})

//拦截器
// 添加请求拦截器
httpInstance.interceptors.request.use(
  (config) => {
    const adminStore = useAdminStore()
    const token = adminStore.adminInfo.token
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
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
