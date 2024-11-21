import httpInstance from '@/utils/https'

/**
 * 获取用户列表
 * @param params
 * @returns
 */
export const getUsersListApi = (params) => {
  return httpInstance({
    url: '/admin/usersInfo',
    params
  })
}
/**
 * 新增用户
 * @param userData
 * @returns
 */
export const addUserApi = (userData) => {
  return httpInstance({
    url: '/admin/usersInfo',
    method: 'POST',
    data: userData
  })
}
/**
 * 编辑用户
 * @param userData
 * @returns
 */
export const editUserApi = (userData) => {
  return httpInstance({
    url: `/admin/usersInfo/${userData.userID}`,
    method: 'PUT',
    data: userData
  })
}

// 删除用户
export const deleteUserApi = (userID) => {
  return httpInstance({
    url: `/admin/usersInfo/${userID}`,
    method: 'DELETE'
  })
}
