import request from '@/utils/https'

// 登录
export const loginApi = ({ mail, password }) => {
  return request({
    url: '/admin/login',
    method: 'POST',
    data: {
      mail,
      password
    }
  })
}
