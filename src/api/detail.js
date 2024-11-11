import request from '@/utils/https'

/**
 * 获取商品详情
 * @param {商品ID} id
 * @returns
 */
export const getDetail = (id) => {
  return request({
    url: '/detail',
    params: {
      id
    }
  })
}
