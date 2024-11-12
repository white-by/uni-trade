import httpInstance from '@/utils/https'

/**
 * 获取用户
 * @param {当前页} pageNum
 * @param {每页行数} pageSize
 * @returns
 */
export const getUsersListApi = (params) => {
  return httpInstance({
    url: '/admin/usersInfo',
    params
  })
}
