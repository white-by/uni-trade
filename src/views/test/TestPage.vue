<template>
  <UserNav />
  <div class="content">
    <br /><br />
    <el-form :model="userInfo" label-width="40px" class="form" style="max-width: 600px">
      <!-- 可更改头像的部分 -->
      <div class="avatar-container">
        <el-avatar :size="130" :src="userInfo.picture" class="avatar">
          <!-- 点击头像触发上传 -->
          <el-upload
            class="avatar-uploader"
            action="https://jsonplaceholder.typicode.com/posts/"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :before-upload="beforeAvatarUpload"
          >
            <i class="el-icon-edit avatar-uploader-icon"></i>
          </el-upload>
        </el-avatar>
      </div>

      <el-form-item>
        <el-button type="primary" @click="onSubmit" class="submit-button">保存</el-button>
      </el-form-item>
    </el-form>
  </div>
  <UserFooter />
</template>

<script setup>
import UserNav from '@/components/UserNav.vue'
import { ref, onMounted } from 'vue'
import UserFooter from '@/components/UserFooter.vue'
import { ElMessage } from 'element-plus'
import { getUserInfoAPI, editUserInfoAPI } from '@/api/profiles'

// 从接口获取数据
const userInfo = ref({})
const getUserInfo = async () => {
  const res = await getUserInfoAPI()
  userInfo.value = res.data.data
}

// 头像上传成功处理
const handleAvatarSuccess = (response) => {
  // 假设接口返回新头像的 URL
  userInfo.value.picture = response.data.pictureUrl || userInfo.value.picture
  ElMessage.success('头像上传成功')
}

// 上传头像前的校验
const beforeAvatarUpload = (file) => {
  const isJpgOrPng = file.type === 'image/jpeg' || file.type === 'image/png'
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isJpgOrPng) {
    ElMessage.error('上传头像图片只能是 JPG 或 PNG 格式！')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('上传头像图片大小不能超过 2MB！')
    return false
  }
  return true
}

// 提交修改
const onSubmit = async () => {
  const updatedData = {
    picture: userInfo.value.picture
  }
  console.log('更新的数据：', updatedData)
  const res = await editUserInfoAPI(updatedData)
  if (res.data.code === 1) {
    ElMessage({
      type: 'success',
      message: '修改成功'
    })
  } else ElMessage.error('修改失败')
}

onMounted(() => {
  getUserInfo()
})
</script>

<style scoped lang="scss">
.content {
  display: flex;
  flex-direction: column;
  align-items: center; /* 居中 */
  background-image: url('/src/assets/images/background3.svg');
}

.avatar-container {
  display: flex;
  justify-content: center; /* 水平居中 */
  margin-bottom: 10%; /* 调整头像和表单之间的间距 */
  position: relative; /* 方便放置编辑图标 */
}

.avatar-uploader {
  position: absolute;
  bottom: 10;

  cursor: pointer;
}

.avatar-uploader-icon {
  font-size: 54px;
  color: #fff;
  background: rgba(0, 0, 0, 0.6);
  border-radius: 50%;
  padding: 50px;
}

.form {
  margin-top: 5%;
  margin-bottom: 2%;
  width: 30%;
}

.submit-button {
  margin-top: 20px; /* 调整按钮和表单之间的间距 */
  margin-left: auto;
  margin-right: auto; /* 居中按钮 */
  margin-bottom: 3%;
  font-weight: 600;
}
</style>
