<script setup>
import {
  ArrowDown,
  Management,
  UserFilled,
  List,
  Histogram,
  User,
  Tickets,
  Memo,
  Notification,
  Box,
  ChatDotSquare,
  Avatar,
  ShoppingBag
} from '@element-plus/icons-vue'
import { ElMessageBox } from 'element-plus'
import { RouterView, useRoute, useRouter } from 'vue-router'
import { ref, watch } from 'vue'
import { useAdminStore } from '@/store/adminStore'

const router = useRouter()
const route = useRoute()
const activeIndex = ref('')

const adminStore = useAdminStore()
const adminName = ref(adminStore.adminInfo.adminName)

const confirmLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    adminStore.clearAdminInfo()
    router.push('/admin/login')
  } catch (error) {
    console.log('取消了登出操作', error)
  }
}

// 实时改名
watch(
  () => adminStore.adminInfo.adminName,
  (newName) => {
    adminName.value = newName
  }
)

// 根据当前路径设置激活的导航项
watch(
  () => route.path,
  (newPath) => {
    if (newPath === '/admin/adminInfo') {
      activeIndex.value = '1-1'
    } else if (newPath === '/admin/usersInfo') {
      activeIndex.value = '1-2'
    } else if (newPath === '/admin/ordersInfo') {
      activeIndex.value = '2-1'
    } else if (newPath === '/admin/afterSale') {
      activeIndex.value = '2-2'
    } else if (newPath === '/admin/productsInfo') {
      activeIndex.value = '2-3'
    } else if (newPath === '/admin/announcementInfo') {
      activeIndex.value = '3-1'
    } else if (newPath === '/admin/categoryInfo') {
      activeIndex.value = '3-2'
    } else if (newPath === '/admin/commentInfo') {
      activeIndex.value = '3-3'
    } else if (newPath === '/admin/profiles') {
      activeIndex.value = '4'
    }
  },
  { immediate: true }
)
</script>

<template>
  <div class="">
    <el-container class="layout-container">
      <el-header class="app-header">
        <div class="header-left">
          <RouterLink to="/admin">
            <el-icon class="header-icon">
              <Management />
            </el-icon>
          </RouterLink>
          <span class="header-title">校园二手交易管理系统</span>
        </div>

        <div class="header-right">
          <el-dropdown placement="bottom" size="large">
            <span class="el-dropdown-link">
              <i class="iconfont icon-user"></i> {{ adminName }}
              <el-icon class="el-icon--right">
                <ArrowDown />
              </el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <router-link to="/admin/profiles"><el-dropdown-item>个人信息</el-dropdown-item></router-link>
                <el-dropdown-item divided>
                  <span @click="confirmLogout">退出登录</span>
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-container>
        <el-aside width="200px">
          <el-scrollbar>
            <el-menu :default-openeds="['1', '2', '3']" :default-active="activeIndex">
              <!-- 账户管理 -->
              <el-sub-menu index="1">
                <template #title>
                  <el-icon><UserFilled /></el-icon>账户管理
                </template>
                <el-menu-item-group>
                  <router-link to="/admin/adminInfo">
                    <el-menu-item index="1-1">
                      <el-icon><User /></el-icon>管理员管理
                    </el-menu-item>
                  </router-link>

                  <router-link to="/admin/usersInfo">
                    <el-menu-item index="1-2">
                      <el-icon><User /></el-icon>用户管理
                    </el-menu-item>
                  </router-link>
                </el-menu-item-group>
              </el-sub-menu>

              <!-- 销售管理 -->
              <el-sub-menu index="2">
                <template #title>
                  <el-icon><List /></el-icon>销售管理
                </template>
                <el-menu-item-group>
                  <router-link to="/admin/ordersInfo">
                    <el-menu-item index="2-1">
                      <el-icon><Tickets /></el-icon>订单管理
                    </el-menu-item>
                  </router-link>

                  <router-link to="/admin/afterSale">
                    <el-menu-item index="2-2">
                      <el-icon><Memo /></el-icon>售后管理
                    </el-menu-item>
                  </router-link>

                  <router-link to="/admin/productsInfo">
                    <el-menu-item index="2-3">
                      <el-icon><ShoppingBag /></el-icon>商品管理
                    </el-menu-item>
                  </router-link>
                </el-menu-item-group>
              </el-sub-menu>

              <!-- 内容管理 -->
              <el-sub-menu index="3">
                <template #title>
                  <el-icon><Histogram /></el-icon>内容管理
                </template>
                <el-menu-item-group>
                  <router-link to="/admin/announcementInfo">
                    <el-menu-item index="3-1">
                      <el-icon><Notification /></el-icon>公告管理
                    </el-menu-item>
                  </router-link>

                  <router-link to="/admin/categoryInfo">
                    <el-menu-item index="3-2">
                      <el-icon><Box /></el-icon>分类管理
                    </el-menu-item>
                  </router-link>

                  <router-link to="/admin/commentInfo">
                    <el-menu-item index="3-3">
                      <el-icon><ChatDotSquare /></el-icon>评论管理
                    </el-menu-item>
                  </router-link>
                </el-menu-item-group>
              </el-sub-menu>

              <!-- 个人账户菜单项 -->
              <router-link to="/admin/profiles">
                <el-menu-item index="4">
                  <el-icon><Avatar /></el-icon>个人信息
                </el-menu-item>
              </router-link>
            </el-menu>
          </el-scrollbar>
        </el-aside>

        <el-main>
          <div>
            <RouterView />
          </div>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<style scoped lang="scss">
.app-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  height: 64px;
  background-color: #333;
  color: #ffffff;
}

.header-left {
  display: flex;
  align-items: center;

  .header-icon {
    font-size: 30px;
    color: #ffffff;
    margin-right: 20px;
    margin-left: 40px;
  }

  .header-title {
    font-size: 20px;
    font-weight: bold;
  }
}

.header-right {
  margin-right: 65px;
  .el-dropdown-link {
    cursor: pointer;
    color: #cdcdcd;
    display: flex;
    align-items: center;
    font-size: 16px;
    outline: none;

    i.iconfont {
      font-size: 20px;
      margin-right: 5px;
    }

    .el-icon--right {
      margin-left: 5px;
    }

    &:hover {
      color: $comColor;
      outline: none;
    }
  }
}

.layout-container .el-menu {
  border-right: none;
}
.el-aside {
  min-height: 93vh;
  background: #ffffff;
}

.el-menu-item.is-active {
  background-color: $comColor;
  color: #fff !important;
}
/* 确保 router-link 的文字也变为白色 */
.el-menu-item.is-active a {
  color: #fff !important;
}
</style>
