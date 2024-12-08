// 订单相关api
import httpInstance from '@/utils/https'
import { useUserStore } from '@/store/userStore'

/**
 * 获取“我买到的”订单列表
 * @param {当前登录用户id} userId 
 * @param {表格页码} page 
 * @param {每页最大信息条数 默认为5条} pageSize 
 * @returns 
 */
export function getPurchasedDataAPI(page, pageSize){
    const userStore = useUserStore() 
    return httpInstance({
        url: '/orders/purchased',
        params : {
            page,
            pageSize
        },
        headers: {
             Authorization: `${userStore.userInfo.token}`
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
    const userStore = useUserStore() 
    return httpInstance({
        url: '/orders/selled',
        params : {
            page,
            pageSize
        },
        headers: {
            Authorization: `${userStore.userInfo.token}`
        }
    })
}

// 订单操作
export const operateOrderAPI = (Data) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: `/orders/operate/${Data.id}`,
        method: 'post',
        data: Data,
         headers: {
            Authorization: `${userStore.userInfo.token}`, 
        }
    })
}

// 修改地址
export const editAddressAPI = (Data) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: `/orders/address/${Data.id}`,
        method: 'post',
        data: Data,
         headers: {
            Authorization: `${userStore.userInfo.token}`, 
        }
    })
}