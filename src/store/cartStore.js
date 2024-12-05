import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useCartStore = defineStore('cart', () => {
  const selectedProduct = ref(null) // 当前选中的商品信息

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
    clearSelectedProduct,
  }
})
