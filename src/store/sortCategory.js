import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getCategoryAPI } from '@/api/products'

export const useCategoryStore = defineStore('category', () => {
  const categoryID = ref(0) // 默认分类 ID 为 0，表示全部
  const categoryList = ref([])

  const setCategoryID = (id) => {
    categoryID.value = id
  }

  const getCategory = async () => {
    const res = await getCategoryAPI()
    console.log('获得分类:', res.data)
    categoryList.value = res.data
  }

  return {
    categoryID,
    setCategoryID,
    categoryList,
    getCategory
  }
})
