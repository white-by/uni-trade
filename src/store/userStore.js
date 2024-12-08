import { defineStore } from 'pinia'
import { loginApi } from '@/api/user'
import { getUserInfoAPI } from '@/api/profiles'
import { ref } from 'vue'
// import useASE from '@/hooks/useASE'
// const { decrypt } = useASE()

export const useUserStore = defineStore(
  'user',
  () => {
    const userInfo = ref({})
    const getUserInfo = async ({ mail, password }) => {
      const res = await loginApi({ mail, password })
      // res.data.data.password = decrypt(res.data.data.password)
      userInfo.value = res.data.data

      console.log('登录数据：', userInfo.value)
    }

    const clearUserInfo = () => {
      userInfo.value = {}
    }

    const fetchUserInfo = async () => {
      // console.log('pinia原数据：', userInfo.value)
      const res = await getUserInfoAPI()
      // res.data.data.password = decrypt(res.data.data.password)
      userInfo.value = {
        ...userInfo.value, // 保留现有字段
        ...res.data.data // 更新新的字段
      }
      // console.log('pinia更新数据：', userInfo.value)
    }

    return {
      userInfo,
      getUserInfo,
      clearUserInfo,
      fetchUserInfo
    }
  },
  {
    persist: true
  }
)
