import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getPublishedProductsAPI } from '@/api/profiles'
import { getFinishedProductsAPI } from '@/api/profiles'
import { getCommentsAPI } from '@/api/profiles'
import { getIntroductionAPI } from '@/api/profiles'

export const useProfilesStore = defineStore('profiles', () => {
    const introduction = ref([])
    const publishedProducts = ref([])
    const finishedProducts = ref([])
    const comments = ref([])

    const getIntroduction = async () => {
        const res = await getIntroductionAPI()
        console.log('getIntroductionAPI响应: ', res.data)
        introduction.value = res.data.data
    }
    const getPublishedProducts = async () => {
        const res = await getPublishedProductsAPI()
        console.log('getPublishedProductsAPI响应: ', res.data)
        publishedProducts.value = res.data.data
    }
    const getFinishedProducts = async () => {
        const res = await getFinishedProductsAPI()
        console.log('getFinishedProductsAPI响应: ', res.data)
        finishedProducts.value = res.data.data
    }
    const getComments = async () => {
        const res = await getCommentsAPI()
        console.log('getCommentsAPI响应: ', res.data)
        comments.value = res.data.data
    }

    return {
        introduction,
        getIntroduction ,
        finishedProducts,
        getFinishedProducts,
        publishedProducts,
        getPublishedProducts,
        comments,
        getComments
    }
})
