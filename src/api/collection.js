import httpInstance from '@/utils/https'

export const getCollectionListAPI  = (page, pageSize) => {
    return httpInstance({
        url: '/collection',
         params : {
            page,
            pageSize
        },
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

