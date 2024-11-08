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
  Avatar
} from '@element-plus/icons-vue'
import { ElMessageBox } from 'element-plus'
import { useRouter } from 'vue-router'
import { RouterView } from 'vue-router'

const router = useRouter()

const confirmLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    router.push('/admin/login')
  } catch (error) {
    console.log('取消了登出操作', error)
  }
}
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
              <i class="iconfont icon-user"></i> 白烟
              <el-icon class="el-icon--right">
                <ArrowDown />
              </el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item>
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
            <el-menu :default-openeds="['1', '2', '3']">
              <!-- 账户管理 -->
              <el-sub-menu index="1">
                <template #title>
                  <el-icon><UserFilled /></el-icon>账户管理
                </template>
                <el-menu-item-group>
                  <el-menu-item index="1-1">
                    <router-link to="/admin/adminInfo">
                      <el-icon><User /></el-icon>管理员管理
                    </router-link>
                  </el-menu-item>
                  <el-menu-item index="1-2">
                    <router-link to="/admin/usersInfo">
                      <el-icon><User /></el-icon>用户管理
                    </router-link>
                  </el-menu-item>
                </el-menu-item-group>
              </el-sub-menu>

              <!-- 销售管理 -->
              <el-sub-menu index="2">
                <template #title>
                  <el-icon><List /></el-icon>销售管理
                </template>
                <el-menu-item-group>
                  <el-menu-item index="2-1">
                    <router-link to="/admin/ordersInfo">
                      <el-icon><Tickets /></el-icon>订单管理
                    </router-link>
                  </el-menu-item>
                  <el-menu-item index="2-2">
                    <router-link to="/admin/afterSale">
                      <el-icon><Memo /></el-icon>售后管理
                    </router-link>
                  </el-menu-item>
                </el-menu-item-group>
              </el-sub-menu>

              <!-- 内容管理 -->
              <el-sub-menu index="3">
                <template #title>
                  <el-icon><Histogram /></el-icon>内容管理
                </template>
                <el-menu-item-group>
                  <el-menu-item index="3-1">
                    <router-link to="/admin/announcementInfo">
                      <el-icon><Notification /></el-icon>公告管理
                    </router-link>
                  </el-menu-item>
                  <el-menu-item index="3-2">
                    <router-link to="/admin/categoryInfo">
                      <el-icon><Box /></el-icon>分类管理
                    </router-link>
                  </el-menu-item>
                  <el-menu-item index="3-3">
                    <router-link to="/admin/commentInfo">
                      <el-icon><ChatDotSquare /></el-icon>评论管理
                    </router-link>
                  </el-menu-item>
                </el-menu-item-group>
              </el-sub-menu>

              <!-- 个人账户菜单项 -->
              <el-menu-item index="4">
                <router-link to="/admin/profiles">
                  <el-icon><Avatar /></el-icon>个人信息
                </router-link>
              </el-menu-item>
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
</style>
