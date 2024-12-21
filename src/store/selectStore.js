/**
 * selectStore.js
 * 筛选后选中的商品信息
 */

import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useSelectStore = defineStore('select', () => {
  const selectData = ref([])

  return {
    selectData
  }
})
