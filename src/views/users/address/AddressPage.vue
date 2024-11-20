<template>
  <UserNav />
  <div style="display: flex; justify-content: center; margin: 50px; min-height: 68vh">
    <el-card>
      <el-row style="margin-bottom: 20px; color: dimgray"><h3>我的地址</h3></el-row>
      <el-table :data="addressData" stripe border>
        <el-table-column label="联系地址" width="380px">
          <el-table-column prop="province" label="省" width="100" />
          <el-table-column prop="city" label="市" width="100" />
          <el-table-column prop="area" label="区" width="100" />
          <el-table-column prop="detailArea" label="详细地址" width="180" />
          /></el-table-column
        >
        <el-table-column prop="name" label="联系人" width="100px"> </el-table-column>
        <el-table-column prop="tel" label="联系电话" width="150px"> </el-table-column>
        <el-table-column label="默认地址" width="100px">
          <template #default="scope">
            <el-radio
              v-model="defaultAddressId"
              :label="scope.row.id"
              @change="handleDefaultAddressChange(scope.row.id)"
              style="display: flex; justify-content: center"
            >
              <p></p>
            </el-radio>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120px">
          <template #default="scope">
            <el-button size="small" type="primary" @click="openEditDialog(scope.row)"
              ><i class="iconfont icon-edit"></i></el-button
            ><el-button size="small" type="danger" @click="handleDelete(scope.row.id)"
              ><i class="iconfont icon-delete"></i></el-button
          ></template>
        </el-table-column>
      </el-table>
      <el-button type="primary" plain style="width: 100%; margin-top: 30px" @click="openAddDialog()"
        ><i class="iconfont icon-add" style="padding: 5px"></i> 添加地址</el-button
      >
    </el-card>

    <!-- 修改地址对话框 -->
    <el-dialog title="修改地址" v-model="editDialogVisible" width="470px" @close="resetEditForm">
      <el-form :model="editForm" :rules="rules" ref="editAddressFormRef" label-width="80px">
        <el-form-item label="新地址">
          <AreaComponets
            ref="areaComponentRef"
            @updateProvince="editForm.province = $event"
            @updateCity="editForm.city = $event"
            @updateArea="editForm.area = $event"
          />
          <el-input
            v-model="editForm.detailArea"
            placeholder="请输入详细地址"
            style="margin-top: 10px; width: 340px"
          ></el-input>
        </el-form-item>
        <el-form-item label="联系人" prop="name" style="width: 420px">
          <el-input v-model="editForm.name" placeholder="请输入联系人姓名"></el-input>
        </el-form-item>
        <el-form-item label="联系电话" prop="tel" style="width: 420px">
          <el-input v-model="editForm.tel" placeholder="请输入联系人电话"></el-input>
        </el-form-item>
        <span class="dialog-footer" style="display: flex; justify-content: center">
          <el-button type="primary" @click="confirmEdit">确认修改</el-button>
        </span>
      </el-form>
    </el-dialog>

    <!-- 添加地址对话框 -->
    <el-dialog title="新增地址" v-model="addDialogVisible" width="470px" @close="resetAddForm">
      <el-form :model="newAddress" :rules="rules" ref="addAddressFormRef" label-width="80px">
        <el-form-item label="联系地址" prop="province">
          <AreaComponets
            ref="_areaComponentRef"
            @updateProvince="newAddress.province = $event"
            @updateCity="newAddress.city = $event"
            @updateArea="newAddress.area = $event"
          />
          <el-input
            v-model="newAddress.detailArea"
            placeholder="请输入详细地址"
            style="margin-top: 10px; width: 340px"
          ></el-input>
        </el-form-item>
        <el-form-item label="联系人" prop="name" style="width: 420px">
          <el-input v-model="newAddress.name" placeholder="请输入联系人姓名"></el-input>
        </el-form-item>
        <el-form-item label="联系电话" prop="tel" style="width: 420px">
          <el-input v-model="newAddress.tel" placeholder="请输入联系人电话"></el-input>
        </el-form-item>
        <span class="dialog-footer" style="display: flex; justify-content: center">
          <el-button type="primary" @click="submitAddressForm">新增</el-button>
        </span>
      </el-form>
    </el-dialog>
  </div>
  <UserFooter />
</template>

<script setup>
import UserNav from '@/components/UserNav.vue'
import UserFooter from '@/components/UserFooter.vue'
import AreaComponets from '@/components/AreaComponets.vue'
import { ref, onMounted, nextTick } from 'vue'
import {
  getAddressListAPI,
  addAddressAPI,
  updateAddressAPI,
  setDefaultAddressAPI,
  deleteAddressAPI
} from '@/api/address'
import { ElMessage, ElMessageBox } from 'element-plus'

//从接口拿地址列表
const addressData = ref([])
const getAddressList = async () => {
  const res = await getAddressListAPI()
  console.log('getAddressListAPI响应', res.data)
  addressData.value = res.data.data
  defaultAddressId.value = addressData.value.find((address) => address.isDefault === 1)?.id || null
}

// 当前默认地址的 ID
const defaultAddressId = ref(addressData.value.find((address) => address.isDefault === 1)?.id || null)
let oldAddressId = defaultAddressId.value
let isThrottling = false // 控制节流状态

// 设置默认地址
const setDefaultAddress = async (newAddressId) => {
  addressData.value.forEach((address) => {
    address.isDefault = address.id === newAddressId ? 1 : 0
  })
  const res = await setDefaultAddressAPI({ oldAddressId, newAddressId })
  if (res.data.code === 1) {
    ElMessage.success('修改成功')
    oldAddressId = newAddressId
  } else {
    ElMessage.error('修改失败')
  }
}

// 处理默认地址改变
const handleDefaultAddressChange = (newAddressId) => {
  if (isThrottling) {
    defaultAddressId.value = oldAddressId
    ElMessage.warning('操作过于频繁，请稍后再试')
    return
  }
  isThrottling = true
  setDefaultAddress(newAddressId)
  setTimeout(() => {
    isThrottling = false
  }, 2000)
}

//新增地址
const addDialogVisible = ref(false)
const openAddDialog = () => {
  addDialogVisible.value = true
  addAddressFormRef.value?.clearValidate()
}
const newAddress = ref({
  name: '',
  province: '',
  city: '',
  area: '',
  detailArea: '',
  tel: '',
  isDefault: 0
})

// 定义验证规则
const rules = {
  province: [{ required: true, message: '请选择省份', trigger: 'change' }],
  city: [{ required: true, message: '请选择城市', trigger: 'change' }],
  area: [{ required: true, message: '请选择区县', trigger: 'change' }],
  detailArea: [{ required: true, message: '请输入详细地址', trigger: 'blur' }],
  name: [{ required: true, message: '请输入联系人姓名', trigger: 'blur' }],
  tel: [{ required: true, message: '请输入联系电话', trigger: 'blur' }]
}

const addAddressFormRef = ref(null)
// 提交表单
const submitAddressForm = () => {
  addAddressFormRef.value.validate(async (valid) => {
    if (valid) {
      const res = await addAddressAPI(newAddress.value)
      if (res.data.code === 1) {
        const newAddressWithID = { ...newAddress.value, id: res.data.data.id }
        addressData.value.push(newAddressWithID)
        addDialogVisible.value = false
        resetAddForm()
        ElMessage.success('添加成功')
      } else {
        ElMessage.error(`新增地址失败: ${res.msg}`)
      }
    } else {
      ElMessage.warning('请填写完整的地址信息')
    }
  })
}

// 添加地址对话框地址组件ref
const _areaComponentRef = ref(null)
const resetAddForm = () => {
  newAddress.value = {
    name: '',
    province: '',
    city: '',
    area: '',
    detailArea: '',
    tel: '',
    isDefault: 0
  }
  if (_areaComponentRef.value) {
    _areaComponentRef.value.resetAddress()
  }
  addAddressFormRef.value?.clearValidate()
}

//修改地址
const editDialogVisible = ref(false)
const editForm = ref({
  id: '',
  name: '',
  province: '',
  city: '',
  area: '',
  detailArea: '',
  tel: '',
  isDefault: 0
})

// 修改地址对话框地址组件ref
const areaComponentRef = ref(null)
const openEditDialog = (row) => {
  editDialogVisible.value = true
  editForm.value = { ...row }
  nextTick(() => {
    if (areaComponentRef.value) {
      areaComponentRef.value.setAddress(editForm.value.province, editForm.value.city, editForm.value.area)
    }
  })
}

const editAddressFormRef = ref(null)
const confirmEdit = async () => {
  editAddressFormRef.value.validate(async (valid) => {
    if (valid) {
      console.log('修改后的地址信息: ', editForm.value)
      const res = await updateAddressAPI(editForm.value.id, editForm.value)
      if (res.data.code === 1) {
        const addressIndex = addressData.value.findIndex((item) => item.id === editForm.value.id)
        if (addressIndex !== -1) {
          addressData.value[addressIndex] = { ...editForm.value }
        }
        editDialogVisible.value = false
        resetEditForm()
        ElMessage.success('修改成功')
      } else {
        console.error('更新地址失败', res.data.msg)
      }
    } else {
      ElMessage.warning('请填写完整的地址信息')
    }
  })
}

const resetEditForm = () => {
  editForm.value = { id: '', province: '', city: '', area: '', detailAddress: '' }
  if (areaComponentRef.value) {
    areaComponentRef.value.resetAddress()
  }
}

// 删除地址
const handleDelete = async (id) => {
  try {
    await ElMessageBox.confirm('确认删除地址？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
  } catch (error) {
    console.log('取消了删除操作', error)
    return
  }
  const res = await deleteAddressAPI(id)
  if (res.data.code === 1) {
    addressData.value = addressData.value.filter((address) => address.id !== id)
    ElMessage.success('删除成功')
  } else {
    ElMessage.error('删除失败')
  }
}

onMounted(() => {
  getAddressList()
})
</script>
