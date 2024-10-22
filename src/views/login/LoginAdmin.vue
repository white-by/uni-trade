<template>
  <div class="login-container">
    <el-form ref="formRef" :model="form" class="login-form" :rules="rules">
      <div class="title-container">
        <h3 class="title">LoginAdmin</h3>
      </div>
      <br />
      <el-form-item prop="username">
        <el-icon size="20" class="svg-container"><Edit /></el-icon>
        <span>请输入用户名</span>
        <el-input v-model="form.username"> </el-input>
      </el-form-item>

      <el-form-item prop="password">
        <el-icon size="20" class="svg-container"><Lock /></el-icon>
        <span>请输入密码</span>
        <el-input v-model="form.password"></el-input>
      </el-form-item>

      <div class="button-container">
        <el-button type="primary" class="login-button" @click="handleLogin">登录</el-button>
      </div>
    </el-form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Edit, Lock } from '@element-plus/icons-vue'
const form = ref({
  username: '',
  password: ''
})

const login = async (formData) => {
  // 这里放置你的登录逻辑
  console.log('Logging in with:', formData)
}

const rules = ref({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 8, message: '长度应为 3 到 8 位', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    {
      min: 6,
      message: '密码至少 6 位',
      trigger: 'blur'
    },
    {
      validator: (rule, value, callback) => {
        const regex = /^[A-Za-z0-9]+$/ // 只允许字母和数字
        if (value && !regex.test(value)) {
          callback(new Error('密码只能由字母和数字组成。'))
        } else {
          callback() // 验证通过
        }
      },
      trigger: 'blur'
    }
  ]
})

const formRef = ref(null)
const handleLogin = () => {
  formRef.value.validate((valid, fields) => {
    // 添加 fields 参数
    if (valid) {
      login(form.value)
      // alert('submit')
      // console.log('submit!')
    } else {
      console.log('error submit!', fields)
      return false
    }
  })
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(255, 255, 255, 0.8);
}

.login-form {
  width: 100%;
  max-width: 400px;
  padding: 40px;
  border-radius: 8px;
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  background-color: rgba(255, 255, 255, 0.2);
}

.el-form-item {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
}

.svg-container {
  margin-right: 10px;
  color: #555;
}

.el-input {
  flex-grow: 1;
  height: 40px;
}

.el-input input {
  background: transparent;
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 5px;
  padding: 12px 15px;
  color: #333;
  height: 100%;
}

.login-button {
  width: 100%;
  height: 40px;
  margin-top: 20px;
  border-radius: 5px;
  background-color: #409eff;
  color: #fff;
}

.button-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.title-container {
  text-align: center;
  margin-bottom: 20px;
}

.title {
  font-size: 28px;
  color: #333;
  font-weight: bold;
}
</style>
