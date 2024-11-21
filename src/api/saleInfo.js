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

/**
 * 获取商品列表
 * @param params
 * @returns
 */
export const getProductListApi = (params) => {
  return httpInstance({
    url: '/admin/product',
    params
  })
}

/**
 * 删除商品
 * @param productData
 * @returns
 */
export const deleteProductApi = (productID) => {
  return httpInstance({
    url: `/admin/product/${productID}`,
    method: 'DELETE'
  })
}