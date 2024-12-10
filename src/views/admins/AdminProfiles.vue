<template>
  <div class="content">
    <h1>个人信息</h1>
    <el-form :model="tempAdmin" label-width="100px" class="form" style="max-width: 600px" :rules="rules" ref="formRef">
      <!-- 管理员ID -->
      <el-form-item label="管理员ID">
        <el-input v-model="tempAdmin.adminID" disabled />
      </el-form-item>

      <!-- 姓名/昵称 -->
      <el-form-item label="昵称" prop="adminName">
        <el-input v-model="tempAdmin.adminName" />
      </el-form-item>

      <!-- 密码 -->
      <el-form-item label="密码" prop="password">
        <el-input v-model="tempAdmin.password" :type="addPassFlag ? 'text' : 'password'">
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
        <el-select v-model="tempAdmin.gender" size="large">
          <el-option label="女" :value="0" />
          <el-option label="男" :value="1" />
        </el-select>
      </el-form-item>

      <!-- 年龄 -->
      <el-form-item label="年龄" prop="age">
        <el-input v-model="tempAdmin.age" type="number" min="0" />
      </el-form-item>

      <!-- 邮箱 -->
      <el-form-item label="邮箱">
        <el-input v-model="tempAdmin.mail" disabled />
      </el-form-item>

      <!-- 电话 -->
      <el-form-item label="电话" prop="tel">
        <el-input v-model="tempAdmin.tel" />
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="throttledOnSubmit" class="submit-button">保存</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>
import { ref, reactive, watchEffect } from 'vue'
import { View, Hide } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { useAdminStore } from '@/store/adminStore'
import { editAdminApi } from '@/api/adminInfo'
import useThrottle from '@/hooks/useThrottle'
import useASE from '@/hooks/useASE'

const { throttled } = useThrottle() // 节流
const { encrypt, decrypt } = useASE()

const adminStore = useAdminStore()
// 创建一个临时变量来存储修改后的数据
const tempAdmin = reactive({ ...adminStore.adminInfo })

// 创建原始数据备份
const originalAdmin = reactive({ ...adminStore.adminInfo })

const addPassFlag = ref(false)

const formRef = ref(null)

// 解密密码字段，渲染时显示明文密码
watchEffect(() => {
  if (adminStore.adminInfo.password) {
    tempAdmin.password = decrypt(adminStore.adminInfo.password)
    originalAdmin.password = decrypt(adminStore.adminInfo.password) // 同步解密到备份
  }
})

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
      // 提交之前对密码进行加密
      tempAdmin.password = encrypt(tempAdmin.password)
      // 显式将 age 转换为数字
      tempAdmin.age = Number(tempAdmin.age)

      const res = await editAdminApi(tempAdmin)
      if (res.data.code === 1) {
        // 成功更新后台数据后，弹出提示
        ElMessage.success('管理员信息已更新')
        // 更新 Pinia 中的数据
        adminStore.adminInfo = { ...tempAdmin }

        Object.assign(originalAdmin, tempAdmin) // 更新备份数据
      } else {
        // 提交失败
        ElMessage.error('管理员昵称已存在')

        Object.assign(tempAdmin, originalAdmin) // 回滚所有数据
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
