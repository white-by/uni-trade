import httpInstance from "@/utils/https";


// 顶栏个人简介
export function getIntroductionAPI(){
    return httpInstance({
        url: '/profiles/introduction',
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

// 已发布
export function getPublishedProductsAPI(){
    return httpInstance({
        url: '/profiles/published',
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

// 已完成
export function getFinishedProductsAPI(){
    return httpInstance({
        url: '/profiles/finished',
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

// 评价
export function getCommentsAPI(){
    return httpInstance({
        url: '/profiles/comment',
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}