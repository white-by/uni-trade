import request from '@/utils/https'
import { useUserStore } from '@/store/userStore'

/**
 * 获取商品详情
 * @param {商品ID} id
 * @returns
 */
export const getDetail = (id) => {
     const userStore = useUserStore() 
  return request({
    url: '/detail',
    params: {
      id
    },
     headers: {
             Authorization: `${userStore.userInfo.token}`
        }
  })
}
