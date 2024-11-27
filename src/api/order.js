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

// 订单操作
export const operateOrderAPI = (Data) => {
    return httpInstance({
        url: `/orders/operate/${Data.id}`,
        method: 'post',
        data: Data,
         headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

// 订单操作
export const editAddressAPI = (Data) => {
    return httpInstance({
        url: `/orders/address/${Data.tradeID}`,
        method: 'post',
        data: {
            id: Data.tradeID,
            province: Data.province,
            city: Data.city,
            area: Data.area,
            detailArea: Data.detailArea
        },
         headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}