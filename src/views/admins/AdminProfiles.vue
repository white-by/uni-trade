<template>
  <div class="content">
    <h1>个人信息</h1>
    <el-form :model="admin" label-width="100px" class="form" style="max-width: 600px">
      <!-- 管理员ID -->
      <el-form-item label="管理员ID">
        <el-input v-model="admin.adminID" disabled />
      </el-form-item>

      <!-- 姓名/昵称 -->
      <el-form-item label="昵称">
        <el-input v-model="admin.adminName" />
      </el-form-item>

      <!-- 密码 -->
      <el-form-item label="密码">
        <el-input v-model="pswText.value" :type="addPassFlag ? 'text' : 'password'">
          <template #suffix>
            <span @click="addPassFlag = !addPassFlag">
              <el-icon v-if="addPassFlag"><View /></el-icon>
              <el-icon v-else><Hide /></el-icon>
            </span>
          </template>
        </el-input>
      </el-form-item>

      <!-- 性别 -->
      <el-form-item label="性别">
        <el-select v-model="admin.gender" size="large">
          <el-option label="女" :value="0" />
          <el-option label="男" :value="1" />
        </el-select>
      </el-form-item>

      <!-- 年龄 -->
      <el-form-item label="年龄">
        <el-input v-model="admin.age" type="number" min="0" />
      </el-form-item>

      <!-- 邮箱 -->
      <el-form-item label="邮箱">
        <el-input v-model="admin.mail" disabled />
      </el-form-item>

      <!-- 电话 -->
      <el-form-item label="电话">
        <el-input v-model="admin.tel" />
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="onSubmit" class="submit-button">保存</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { View, Hide } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useAdminStore } from '@/store/adminStore'
import useASE from '@/hooks/useASE'

const adminStore = useAdminStore()
const admin = adminStore.adminInfo.data

const addPassFlag = ref(false)

const { decrypt } = useASE()
const pswText = ref('')
onMounted(() => {
  console.log('获得的', admin.password)

  pswText.value = ref(decrypt(admin.password))
  console.log('解密的', pswText.value)
})

function onSubmit() {
  console.log('更改信息:', admin.value)
  ElMessage({
    type: 'success',
    message: '修改成功'
  })
}
</script>

<style scoped lang="scss">
.content {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2rem;
  max-width: 800px; // Sets a max-width for the container
  margin: 2rem auto; // Centers the container and adds vertical spacing
  border-radius: 8px;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
  background-color: #fff;
  margin-top: 80px;
}

h1 {
  font-size: 1.8rem;
  margin-bottom: 1rem;
  font-weight: bold;
  text-align: center;
  margin-bottom: 40px;
  font-size: 25px;
  color: dimgray;
}

.form {
  width: 100%;
}

.el-form-item {
  margin-bottom: 1.5rem;
}

.el-input {
  flex-grow: 1;
  height: 40px;
}

.submit-button {
  font-weight: 600;
  text-align: center;
  margin-top: 20px;
  margin-left: auto;
  margin-right: 55%;
}
</style>
