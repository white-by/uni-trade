// 订单相关api
import httpInstance from '@/utils/https'

/**
 * 获取“我买到的”订单列表
 * @param {当前登录用户id} userId 
 * @param {表格页码} page 
 * @param {每页最大信息条数 默认为5条} pageSize 
 * @returns 
 */
export function getPurchasedDataAPI(page, pageSize){
    return httpInstance({
        url: '/orders/purchased',
        params : {
            page,
            pageSize
        },
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

/**
 * 获取“我卖出的”订单列表
 * @param {当前登录用户id} userId 
 * @param {表格页码} page 
 * @param {每页最大信息条数 默认为5条} pageSize 
 * @returns 
 */
export const getSelledDataAPI = (page, pageSize) => {
    return httpInstance({
        url: '/orders/selled',
        params : {
            page,
            pageSize
        },
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}