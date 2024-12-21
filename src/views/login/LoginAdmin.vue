<template>
  <div class="login-container">
    <el-form ref="formRef" :model="form" class="login-form" :rules="rules">
      <div class="title-container">
        <h3 class="title">LoginAdmin</h3>
      </div>
      <br />
      <el-form-item prop="mail">
        <el-icon size="20" class="svg-container"><Edit /></el-icon>
        <span>请输入邮箱</span>
        <el-input v-model="form.mail"> </el-input>
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
import { useRouter } from 'vue-router'
import { useAdminStore } from '@/store/adminStore'
import useASE from '@/hooks/useASE'
import { loginApi } from '@/api/admin'
import { ElMessage } from 'element-plus'

const adminStore = useAdminStore()

const form = ref({
  mail: '',
  password: ''
})

const router = useRouter()

const rules = ref({
  mail: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: ['blur', 'change'] },
    { min: 5, max: 20, message: '长度应为 5 到 20 位', trigger: 'blur' }
  ],

  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    {
      min: 6,
      max: 16,
      message: '长度应为 6 到 16 位',
      trigger: 'blur'
    },
    {
      validator: (rule, value, callback) => {
        const regex = /^[a-zA-Z0-9_]{6,16}$/
        if (value && !regex.test(value)) {
          callback(new Error('密码只能由字母、数字和下划线组成。'))
        } else {
          callback() // 验证通过
        }
      },
      trigger: 'blur'
    }
  ]
})

const { encrypt } = useASE()

const formRef = ref(null)
// 登录
const handleLogin = () => {
  formRef.value.validate(async (valid) => {
    const password = encrypt(form.value.password)
    // console.log('加密后：', password)
    // 添加 fields 参数
    const { mail } = form.value

    if (valid) {
      const res = await loginApi({ mail, password })
      // console.log('res', res)

      if (res.data.code === 1) {
        ElMessage.success('登录成功')
        adminStore.adminInfo = res.data.data
        router.replace('/admin')
      } else {
        ElMessage.error('邮箱或密码错误')
      }
    } else {
      // console.log('error submit!', fields)
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
  height: 100vh; /* 使容器高度占满整个视口 */
  background-image: url('/src/assets/images/background2.svg');
  background-size: cover;
}

.login-form {
  width: 100%;
  max-width: 400px;
  padding: 40px;
  border-radius: 8px;
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  background-color: rgba(255, 255, 255, 0.5);
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
