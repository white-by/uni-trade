import httpInstance from '@/utils/https'

//获取地址列表
export function getAddressListAPI() {
    return httpInstance({
        url: '/address',
        method: 'get', 
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    });
}

// 添加新地址
export function addAddressAPI(data) {
    return httpInstance({
        url: '/address',
        method: 'post',
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`,
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
export function updateAddressAPI(id, updatedData) {
    return httpInstance({
        url: `/address/${id}`,  
        method: 'put',
        data: updatedData,  
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    });
}