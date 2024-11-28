import request from '@/utils/https'

export const loginApi = ({ mail, password }) => {
  return request({
    url: '/login',
    method: 'POST',
    data: {
      mail,
      password
    }
  })
}
