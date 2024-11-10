// src/stores/userStore.js
import { defineStore } from 'pinia'
import { getUsersListApi } from '@/api/usersInfo'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const usersList = ref([])
  const userList = ref([
    {
      userID: 1,
      userName: 'tav',
      mail: 'tav@123.com',
      tel: '1234567890',
      gender: 0,
      school: 'school1',
      userStatus: 0,
      avatarUrl: 'https://via.placeholder.com/200'
    },
    {
      userID: 2,
      userName: 'urge',
      mail: 'urge@123.com',
      tel: '0987654321',
      gender: 0,
      school: 'school2',
      userStatus: 1,
      avatarUrl: 'https://via.placeholder.com/200'
    }
  ])

  const getUsersList = async () => {
    const res = await getUsersListApi()
    // 检查 res.data.data 是否为数组
    usersList.value = Array.isArray(res.data.data)
      ? res.data.data.map((user) => {
          console.log(user) // 查看每个用户对象的结构
          return {
            avatarUrl: user.picture || 'https://via.placeholder.com/200',
            gender: user.gender,
            mail: user.mail,
            school: user.schoolName,
            tel: user.tel,
            userID: user.userID,
            userName: user.userName,
            userStatus: user.status
          }
        })
      : []

    console.log('获得usersList', usersList.value)
  }

  return {
    userList,
    usersList,
    getUsersList
  }
})
