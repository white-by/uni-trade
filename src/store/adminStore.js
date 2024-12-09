import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useAdminStore = defineStore(
  'admin',
  () => {
    const adminInfo = ref({})
    const clearAdminInfo = () => {
      adminInfo.value = {}
    }

    return {
      adminInfo,
      clearAdminInfo
    }
  },
  {
    persist: true
  }
)
