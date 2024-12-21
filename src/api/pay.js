import httpInstance from '@/utils/https'
import { useUserStore } from '@/store/userStore'

// 创建订单
export const createOrderAPI = (Data) => {
  const userStore = useUserStore()
  return httpInstance({
    url: '/createOrder',
    method: 'POST',
    data: Data,
    headers: {
      Authorization: `${userStore.userInfo.token}`
    }
  })
}

// 获取订单列表
export const getOrderApi = (id) => {
  const userStore = useUserStore()
  return httpInstance({
    url: `/order/${id}`,
    headers: {
      Authorization: `${userStore.userInfo.token}`
    }
  })
}

// 获取订单列表
export const paySuccess = (data) => {
  const userStore = useUserStore()
  return httpInstance({
    url: '/alipay/success',
    method: 'POST',
    data,
    headers: {
      Authorization: `${userStore.userInfo.token}`
    }
  })
}

// export const alipayNotify = () => {
//   const userStore = useUserStore()
//   return httpInstance({
//     url: '/alipay/notify',
//     method: 'POST',
//     headers: {
//       Authorization: `${userStore.userInfo.token}`
//     }
//   })
// }
