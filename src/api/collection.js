import httpInstance from '@/utils/https'
import { useUserStore } from '@/store/userStore'

export const getCollectionListAPI  = (page, pageSize) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: '/collection',
         params : {
            page,
            pageSize
        },
        headers: {
            Authorization: `${userStore.userInfo.token}`
        }
    })
}

