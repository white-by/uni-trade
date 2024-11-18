import httpInstance from "@/utils/https";


// 顶栏个人简介
export const getIntroductionAPI = () => {
    return httpInstance({
        url: '/profiles/introduction',
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

// 已发布
export const getPublishedProductsAPI = () => {
    return httpInstance({
        url: '/profiles/published',
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

// 已完成
export const getFinishedProductsAPI = () => {
    return httpInstance({
        url: '/profiles/finished',
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

// 评价
export const getCommentsAPI = () => {
    return httpInstance({
        url: '/profiles/comment',
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

// 获取个人资料
export const getUserInfoAPI = () => {
    return httpInstance({
        url: '/profiles/info',
        headers: {
            Authorization: `Bearer ${localStorage.getItem('token')}`, 
        }
    })
}

// 修改个人资料
export const editUserInfoAPI = (Data) => {
  return httpInstance({
    url: `/profiles/info/${Data.userID}`,
    method: 'PUT',
    data: Data
  })
}