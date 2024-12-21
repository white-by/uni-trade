/**
 * sortCategory.js
 * 商品分类
 */

import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getCategoryAPI } from '@/api/products'

export const useCategoryStore = defineStore('category', () => {
  const categoryID = ref(0) // 默认分类 ID 为 0，表示全部
  const categoryList = ref([])

  // 设置分类 ID
  const setCategoryID = (id) => {
    categoryID.value = id
  }

  // 获取分类
  const getCategory = async () => {
    const res = await getCategoryAPI()
    // console.log('获得分类:', res.data)
    categoryList.value = res.data
  }

  return {
    categoryID,
    setCategoryID,
    categoryList,
    getCategory
  }
})
