import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getAddressListAPI } from '@/api/address'

export const useAddressStore = defineStore('address', () => {
    const addressData = ref([])

  // 获取地址列表
    const getAddressList = async () => {
        const res = await getAddressListAPI()
        addressData.value = res.data.data
        console.log("pinia获取地址列表")
    }

    return {
        addressData,
        getAddressList
    }
})

