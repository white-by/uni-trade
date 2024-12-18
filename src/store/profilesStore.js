import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getPublishedProductsAPI } from '@/api/profiles'
import { getFinishedProductsAPI } from '@/api/profiles'
import { getReceivedCommentsAPI } from '@/api/profiles'
import { getGivenCommentsAPI } from '@/api/profiles'
import { getIntroductionAPI } from '@/api/profiles'

export const useProfilesStore = defineStore('profiles', () => {
    const introduction = ref([])
    const publishedProducts = ref([])
    const finishedProducts = ref([])
    const receivedComments = ref([])
    const givenComments = ref([])

    const getIntroduction = async (id) => {
        const res = await getIntroductionAPI(id)
        // console.log('getIntroductionAPI响应: ', res.data)
        introduction.value = res.data.data
    }
    const getPublishedProducts = async (id) => {
        const res = await getPublishedProductsAPI(id)
        // console.log('getPublishedProductsAPI响应: ', res.data)
        publishedProducts.value = res.data.data
    }
    const getFinishedProducts = async (id) => {
        const res = await getFinishedProductsAPI(id)
        // console.log('getFinishedProductsAPI响应: ', res.data)
        finishedProducts.value = res.data.data
    }
    const getReceivedComments = async (id) => {
        const res = await getReceivedCommentsAPI(id)
        // console.log('getReceivedCommentsAPI: ', res.data)
        receivedComments.value = res.data.data
    }
      const getGivenComments = async (id) => {
        const res = await getGivenCommentsAPI(id)
        // console.log('getGivenCommentsAPI: ', res.data)
        givenComments.value = res.data.data
    }

    return {
        introduction,
        getIntroduction ,
        finishedProducts,
        getFinishedProducts,
        publishedProducts,
        getPublishedProducts,
        receivedComments,
        getReceivedComments,
        givenComments,
        getGivenComments,
    }
})
