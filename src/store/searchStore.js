/**
 * searchStore.js
 * 首页搜索框输入
 */

import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useSearchStore = defineStore('search', () => {
  const searchQuery = ref('')

  return {
    searchQuery
  }
})
