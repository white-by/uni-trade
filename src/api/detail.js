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

// 获取商品列表
export const deleteProduct = (id) => {
  return request({
    url: `/product/delete/${id}`,
    method: 'DELETE'
  })
}

// 更新商品收藏状态
export const updateIsStarred = (id, data) => {
  return request({
    url: `/detail/${id}`,
    method: 'PUT',
    data
  })
}
