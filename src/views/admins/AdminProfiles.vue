<template>
  <div class="content">
    <h1>个人信息</h1>
    <el-form :model="admin" label-width="100px" class="form" style="max-width: 600px" :rules="rules" ref="formRef">
      <!-- 管理员ID -->
      <el-form-item label="管理员ID">
        <el-input v-model="admin.adminID" disabled />
      </el-form-item>

      <!-- 姓名/昵称 -->
      <el-form-item label="昵称" prop="adminName">
        <el-input v-model="admin.adminName" />
      </el-form-item>

      <!-- 密码 -->
      <el-form-item label="密码" prop="password">
        <el-input v-model="admin.password" :type="addPassFlag ? 'text' : 'password'">
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
      <el-form-item label="年龄" prop="age">
        <el-input v-model="admin.age" type="number" min="0" />
      </el-form-item>

      <!-- 邮箱 -->
      <el-form-item label="邮箱">
        <el-input v-model="admin.mail" disabled />
      </el-form-item>

      <!-- 电话 -->
      <el-form-item label="电话" prop="tel">
        <el-input v-model="admin.tel" />
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="throttledOnSubmit" class="submit-button">保存</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { View, Hide } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useAdminStore } from '@/store/adminStore'
import { editAdminApi } from '@/api/adminInfo'
import useThrottle from '@/hooks/useThrottle'

const { throttled } = useThrottle() // 节流

const adminStore = useAdminStore()
const admin = adminStore.adminInfo.data

const addPassFlag = ref(false)

const formRef = ref(null)

// 表单验证规则
const rules = {
  adminName: [{ required: true, message: '请输入管理员名', trigger: 'blur' }],
  mail: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: ['blur', 'change'] }
  ],
  tel: [
    { required: true, message: '请输入电话', trigger: 'blur' },
    { pattern: /^[0-9]{11}$/, message: '请输入有效的电话号码', trigger: 'blur' }
  ],
  gender: [{ required: true, message: '请选择性别', trigger: 'change' }],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { pattern: /^[a-zA-Z0-9_]{6,16}$/, message: '密码只能包含数字、字母和下划线，长度为6-16位', trigger: 'blur' }
  ],
  age: [
    { required: true, message: '年龄不能为空', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        const age = Number(value) // 将输入转换为数字
        if (isNaN(age) || age < 0) {
          callback(new Error('年龄必须为大于等于 0 的数字'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

// 表单提交
const onSubmit = async () => {
  formRef.value.validate(async (valid) => {
    if (valid) {
      console.log('提交的表单数据:', admin)
      console.log('提交的表单数据id:', admin.adminID)
      const res = await editAdminApi(admin)
      if (res.data.code === 1) {
        // 成功更新后台数据后，弹出提示
        ElMessage.success('管理员信息已更新')
        // 刷新页面
      } else {
        ElMessage.error('更新失败')
      }
    } else {
      console.log('表单校验失败')
      return false
    }
  })
}
// 节流处理：限制每秒响应一次
const throttledOnSubmit = throttled(onSubmit, 1000)
</script>

<style scoped lang="scss">
.content {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2rem;
  max-width: 800px;
  margin: 2rem auto;
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
