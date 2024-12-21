/**
 * cartStore.js
 * 购物选中的商品信息
 */

import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useCartStore = defineStore('cart', () => {
  // 当前选中的商品信息
  const selectedProduct = ref(null)

  // 设置当前选中的商品
  const setSelectedProduct = (product) => {
    selectedProduct.value = product
  }

  // 清空当前选中的商品
  const clearSelectedProduct = () => {
    selectedProduct.value = null
  }

  return {
    selectedProduct,
    setSelectedProduct,
    clearSelectedProduct
  }
})
