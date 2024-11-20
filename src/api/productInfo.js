import httpInstance from '@/utils/https'

/**
 * 获取订单列表
 * @param params
 * @returns
 */
export const getOrderListApi = (params) => {
  return httpInstance({
    url: '/admin/order',
    params
  })
}