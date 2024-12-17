import httpInstance from '@/utils/https'
import { useUserStore } from '@/store/userStore'

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

export const getOrderApi = (id) => {
  const userStore = useUserStore()
  return httpInstance({
    url: `/order/${id}`,
    headers: {
      Authorization: `${userStore.userInfo.token}`
    }
  })
}

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
