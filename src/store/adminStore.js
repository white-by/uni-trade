import { defineStore } from 'pinia'
import { loginApi } from '@/api/admin'
import { ref } from 'vue'

export const useAdminStore = defineStore(
  'admin',
  () => {
    const adminInfo = ref({})

    const getAdminInfo = async ({ mail, password }) => {
      const res = await loginApi({ mail, password })
      adminInfo.value = res.data
      console.log('登录数据：', res.data)
    }

    const clearAdminInfo = () => {
      adminInfo.value = {}
    }

    return {
      adminInfo,
      getAdminInfo,
      clearAdminInfo
    }
  },
  {
    persist: true
  }
)