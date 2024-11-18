import httpInstance from '@/utils/https'

export function getCollectionListAPI (page, pageSize){
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

