// 注册和重置密码的api

import httpInstance from '@/utils/https'

/**
 * 发送验证码
 * @param mail
 * @returns
 */
export const getCode = (mail) => {
  return httpInstance({
    url: '/code',
    params: {
      mail
    }
  })
}

/**
 * 注册
 * @param form
 * @returns
 */
export const register = (form) => {
  return httpInstance({
    url: '/register',
    method: 'POST',
    data: form
  })
}

/**
 * 重置密码
 * @param form
 * @returns
 */
export const resetPsw = (form) => {
  return httpInstance({
    url: '/resetPsw',
    method: 'POST',
    data: form
  })
}
