import request from '@/utils/https'

export const getDetail = (id) => {
    return request({
        url: '/detail',
        params:{
            id
        }
    })
}