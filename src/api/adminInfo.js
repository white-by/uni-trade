import httpInstance from '@/utils/https'

/**
 * 获取管理员列表
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
 * 新增管理员
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
 * 编辑管理员
 * @param adminData
 * @returns
 */
export const editAdminApi = (adminData) => {
  return httpInstance({
    url: `/admin/adminInfo/${adminData.adminID}`,
    method: 'PUT',
    data: adminData
  })
}

// 删除管理员
export const deleteAdminApi = (adminID) => {
  return httpInstance({
    url: `/admin/adminInfo/${adminID}`,
    method: 'DELETE'
  })
}
