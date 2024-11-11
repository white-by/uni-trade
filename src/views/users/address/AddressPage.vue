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
              @change="setDefaultAddress(scope.row.id)"
              style="display: flex; justify-content: center"
              ><p></p
            ></el-radio>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120px">
          <template #default="scope">
            <el-button size="small" type="primary" @click="openEditDialog(scope.row)"
              ><i class="iconfont icon-edit"></i></el-button
            ><el-button size="small" type="danger"><i class="iconfont icon-delete"></i></el-button
          ></template>
        </el-table-column>
      </el-table>
      <el-button type="primary" plain style="width: 100%; margin-top: 30px" @click="openAddDialog()"
        ><i class="iconfont icon-add" style="padding: 5px"></i> 添加地址</el-button
      >
    </el-card>

    <!-- 修改地址对话框 -->
    <el-dialog title="修改地址" v-model="editDialogVisible" width="470px" @close="resetEditForm">
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
      <span class="dialog-footer" style="display: flex; justify-content: center">
        <el-button type="primary" @click="confirmEdit">确认修改</el-button>
      </span>
    </el-dialog>

    <!-- 添加地址对话框 -->
    <el-dialog title="新增地址" v-model="addDialogVisible" width="470px" @close="resetAddForm">
      <el-form-item label="联系地址">
        <AreaComponets
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
      <el-form-item label="联系人" style="width: 286px; margin-left: 14px"
        ><el-input placeholder="请输入联系人姓名"></el-input
      ></el-form-item>
      <el-form-item label="联系电话" style="width: 300px"
        ><el-input placeholder="请输入联系人电话"></el-input
      ></el-form-item>
      <span class="dialog-footer" style="display: flex; justify-content: center">
        <el-button type="primary">新增</el-button>
      </span>
    </el-dialog>
  </div>
  <UserFooter />
</template>

<script setup>
import UserNav from '@/components/UserNav.vue'
import UserFooter from '@/components/UserFooter.vue'
import AreaComponets from '@/components/AreaComponets.vue'
import { ref, onMounted } from 'vue'
import { getAddressListAPI } from '@/api/address'

const addressData = ref([])
const getAddressList = async () => {
  const res = await getAddressListAPI()
  console.log('getAddressListAPI响应', res.data)
  addressData.value = res.data.data
}

onMounted(() => {
  getAddressList()
})

//新增地址组件逻辑
const addDialogVisible = ref(false)
const openAddDialog = () => {
  addDialogVisible.value = true
}

//修改地址组件逻辑
const editDialogVisible = ref(false)
const editForm = ref({
  id: '',
  province: '',
  city: '',
  area: '',
  detailArea: ''
})

const areaComponentRef = ref(null)
const openEditDialog = (row) => {
  editDialogVisible.value = true
  editForm.value = { ...row }
  editForm.value.detailArea = ''
}

const confirmEdit = () => {
  // 更新订单数据中的地址信息
  const order = addressData.value.find((item) => item.id === editForm.value.id)
  if (order) {
    order.province = editForm.value.province
    order.city = editForm.value.city
    order.area = editForm.value.area
    order.detailArea = editForm.value.detailArea
    console.log('更新后的地址信息：', order)
  }
  editDialogVisible.value = false
  resetEditForm()
}

const resetEditForm = () => {
  //重置表单数据
  editForm.value = { id: '', province: '', city: '', area: '', detailAddress: '' }
  if (areaComponentRef.value) {
    areaComponentRef.value.resetAddress()
  }
  console.log('已重置表单数据')
}

const defaultAddressId = ref(addressData.value.find((address) => address.isDefault === 1)?.id || null)

const setDefaultAddress = (id) => {
  addressData.value.forEach((address) => {
    address.isDefault = address.id === id ? 1 : 0
  })
}
</script>
