import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useSelectStore = defineStore('select', () => {
  const selectData = ref([])
  return {
    selectData
  }
})