import httpInstance from '@/utils/https'

/**
 * 获取用户列表
 * @param params
 * @returns
 */
export const getAdminListApi = (params) => {
  return httpInstance({
    url: '/admin/adminInfo',
    params
  })
}

/**
 * 新增用户
 * @param adminData
 * @returns
 */
export const addAdminApi = (adminData) => {
  return httpInstance({
    url: '/admin/adminInfo',
    method: 'POST',
    data: adminData
  })
}
/**
 * 编辑用户
 * @param adminData
 * @returns
 */
export const editAdminApi = (adminData) => {
  return httpInstance({
    url: `/admin/adminInfo/${adminData.userID}`,
    method: 'PUT',
    data: adminData
  })
}

export const deleteAdminApi = (adaminID) => {
  return httpInstance({
    url: `/admin/adminInfo/${adaminID}`,
    method: 'DELETE'
  })
}
