import httpInstance from '@/utils/https'

/**
 * 获取所有用户
 * @returns
 */
export function getUsersListApi() {
  return httpInstance({
    url: '/admin/usersInfo'
  })
}
