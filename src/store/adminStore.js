/**
 * adminStore.js
 * 管理员个人信息
 */

import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useAdminStore = defineStore(
  'admin',
  () => {
    const adminInfo = ref({})

    // 清空管理员信息
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
