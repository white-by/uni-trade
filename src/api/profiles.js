import httpInstance from "@/utils/https";

//应该在header里带一个jtoken
// 顶栏个人简介
export function getIntroductionAPI(){
    return httpInstance({
        url: '/profiles/introduction'
    })
}

//应该在header里带一个jtoken
// 已发布
export function getPublishedProductsAPI(){
    return httpInstance({
        url: '/profiles/published'
    })
}

//应该在header里带一个jtoken
// 已完成
export function getFinishedProductsAPI(){
    return httpInstance({
        url: '/profiles/finished'
    })
}

//应该在header里带一个jtoken
// 评价
export function getCommentsAPI(){
    return httpInstance({
        url: '/profiles/comment'
    })
}