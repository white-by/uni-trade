import { defineStore } from 'pinia'
import { loginApi } from '@/api/admin'
import { ref } from 'vue'
import useASE from '@/hooks/useASE'
const { decrypt } = useASE()

export const useAdminStore = defineStore(
  'admin',
  () => {
    const adminInfo = ref({})

    const getAdminInfo = async ({ mail, password }) => {
      const res = await loginApi({ mail, password })
      console.log('登录数据psw：', res.data.data.password)
      res.data.data.password = decrypt(res.data.data.password)
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
