// store/category.js
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useCategoryStore = defineStore('category', () => {
  const categoryID = ref(0) // 默认分类 ID 为 0，表示全部

  const setCategoryID = (id) => {
    categoryID.value = id
  }

  return {
    categoryID,
    setCategoryID
  }
})
