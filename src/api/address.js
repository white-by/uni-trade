import httpInstance from '@/utils/https'
import { useUserStore } from '@/store/userStore'

//获取地址列表
export const getAddressListAPI = () => {
    const userStore = useUserStore() 
    console.log("token:",userStore.userInfo.token)
    return httpInstance({
        url: '/address',
        method: 'get', 
        headers: {
            Authorization: `${userStore.userInfo.token}`, 
        }
    });
}

// 添加新地址
export const addAddressAPI = (data) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: '/address',
        method: 'post',
        headers: {
            Authorization: `${userStore.userInfo.token}`, 
        },
        data: {
            name: data.name,
            province: data.province,
            city: data.city,
            area: data.area,
            detailArea: data.detailArea,
            tel: data.tel,
            isDefault: data.isDefault,
        },
    });
}

// 修改地址
export const updateAddressAPI = (id, updatedData) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: `/address/${id}`,  
        method: 'put',
        data: updatedData,  
        headers: {
            Authorization: `${userStore.userInfo.token}`,  
        }
    });
}

// 修改默认地址
export const setDefaultAddressAPI = (data) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: `/address/setDefault/{id}`,  
        method: 'put',
        data: {
            oldDefault: data.oldAddressId,
            newDefault: data.newAddressId
        },  
        headers: {
            Authorization:`${userStore.userInfo.token}`, 
        }
    });
}

// 删除地址
export const deleteAddressAPI = (id) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: `/address/${id}`,  
        method: 'delete',
        headers: {
        Authorization: `${userStore.userInfo.token}`, 
        },
    });
}
