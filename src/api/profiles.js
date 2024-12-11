import httpInstance from "@/utils/https";
import { useUserStore } from '@/store/userStore'

// 顶栏个人简介
export const getIntroductionAPI = (id) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: '/profiles/introduction',
        params: {id},
        headers: {
           Authorization: `${userStore.userInfo.token}`
        }
    })
}

// 已发布
export const getPublishedProductsAPI = (id) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: '/profiles/published',
        params: {id},
        headers: {
           Authorization: `${userStore.userInfo.token}`
        }
    })
}

// 已发布
export const editPublishedProductsAPI = (data) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: '/profiles/published',
        method: 'POST',
        data: data, 
        headers: {
           Authorization: `${userStore.userInfo.token}`
        }
    })
}

// 已完成
export const getFinishedProductsAPI = (id) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: '/profiles/finished',
        params: {id},
        headers: {
            Authorization: `${userStore.userInfo.token}`
        }
    })
}

// 我收到的评价
export const getReceivedCommentsAPI = (id) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: '/profiles/comment/received',
        params: {id},
        headers: {
            Authorization: `${userStore.userInfo.token}`
        }
    })
}

// 我发布的评价
export const getGivenCommentsAPI = (id) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: '/profiles/comment/given',
        params: {id},
        headers: {
            Authorization: `${userStore.userInfo.token}`
        }
    })
}

// 获取个人资料
export const getUserInfoAPI = () => {
    const userStore = useUserStore() 
    return httpInstance({
        url: '/profiles/info',
        headers: {
            Authorization: `${userStore.userInfo.token}`
        }
    })
}

// 修改个人资料
export const editUserInfoAPI = (Data) => {
    const userStore = useUserStore() 
    return httpInstance({
        url: `/profiles/info/${Data.userID}`,
        method: 'PUT',
        data: Data,
        headers: {
            Authorization: `${userStore.userInfo.token}`
        }
    })
}