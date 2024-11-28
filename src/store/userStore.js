import { defineStore } from 'pinia'
import { loginApi } from '@/api/user'
import { ref } from 'vue'

export const useUserStore = defineStore(
  'user',
  () => {
    const userInfo = ref({})

    const getUserInfo = async ({ mail, password }) => {
      const res = await loginApi({ mail, password })
      userInfo.value = res.data
      console.log('登录数据：', res.data)
    }

    const clearUserInfo = () => {
      userInfo.value = {}
    }

    return {
      userInfo,
      getUserInfo,
      clearUserInfo
    }
  },
  {
    persist: true
  }
)
