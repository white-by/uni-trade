<script setup>
import { ArrowDown, Search } from '@element-plus/icons-vue'
import { ElMessageBox } from 'element-plus'
import { useRouter } from 'vue-router'
import { ref } from 'vue'

let input = ref('')

const router = useRouter()

const confirmLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    router.push('/login')
  } catch (error) {
    console.log('取消了登出操作', error)
  }
}
</script>

<template>
  <nav class="app-topnav">
    <div class="container">
      <ul>
        <h1 class="logo">
          <RouterLink to="/">校园二手交易站</RouterLink>
        </h1>
        <div class="site-name">校园二手交易站</div>
        <div class="search">
          <el-input
            v-if="$route.path === '/'"
            v-model="input"
            style="width: 440px"
            placeholder="请输入商品名称"
            :prefix-icon="Search"
          />
        </div>
        <template v-if="true">
          <li>
            <a href="javascript:;"><i class="iconfont icon-announcement"></i></a>
          </li>
          <li>
            <router-link to="/"><i class="iconfont icon-shop"></i></router-link>
          </li>
          <li>
            <a href="javascript:;"><i class="iconfont icon-message"></i></a>
          </li>
          <el-divider direction="vertical" />
          <li>
            <el-dropdown placement="bottom" size="large">
              <span class="el-dropdown-link">
                <i class="iconfont icon-user"></i> 北风
                <el-icon class="el-icon--right">
                  <arrow-down />
                </el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <router-link to="/profiles"><el-dropdown-item>个人中心</el-dropdown-item></router-link>
                  <router-link to="/user/order"><el-dropdown-item>我的订单</el-dropdown-item></router-link>
                  <el-dropdown-item>我的商品</el-dropdown-item>
                  <router-link to="/user/address"><el-dropdown-item>我的地址</el-dropdown-item></router-link>
                  <router-link to="/user/collections"><el-dropdown-item>我的收藏</el-dropdown-item></router-link>
                  <el-dropdown-item divided>
                    <span @click="confirmLogout">退出登录</span>
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </li>
        </template>

        <template v-else>
          <li><a href="javascript:;">请先登录</a></li>
          <li><a href="javascript:;">帮助中心</a></li>
          <li><a href="javascript:;">关于我们</a></li>
        </template>
      </ul>
    </div>
  </nav>
</template>

<style scoped lang="scss">
.container {
  padding: 0 50px;
  width: 100%;
}

.logo {
  width: 120px;
  position: absolute; // 设置绝对定位
  top: -18px; // 向上移动（根据需要调整值）
  left: 50px; // 确保它贴在最左侧

  a {
    display: block;
    height: 150px;
    width: 50%;
    text-indent: -9999px;
    background: url('@/assets/images/logo.png') no-repeat center 18px / contain;
  }
}

.site-name {
  font-size: 20px;
  color: #ffffff; /* 白色字体 */
  margin-left: 70px; /* 使文字与 logo 保持距离 */
  font-weight: bold;
}

.app-topnav {
  background: #333;
  ul {
    display: flex;
    height: 63px;
    justify-content: flex-end;
    align-items: center;
    padding-right: 20px;
    li {
      a {
        padding: 0 25px;
        color: #cdcdcd;
        line-height: 1.5;
        display: inline-block;

        i {
          font-size: 20px;
          margin-right: 2px;
        }

        &:hover {
          color: $comColor;
        }
      }

      ~ li {
        a {
          border-left: 2px solid #666;
        }
      }
    }
  }
}

.search {
  display: flex;
  justify-content: center;
  flex-grow: 1;
  margin-left: 50px; /* 增加与左边 logo 的间距 */
}

.search-input {
  width: 600px; /* 增加宽度 */
  border-radius: 80px; /* 圆角 */
}

.el-dropdown-link {
  cursor: pointer;
  color: #cdcdcd;
  display: flex;
  align-items: center;
  font-size: 16px; // 用户名字体大小
  outline: none;

  i.iconfont {
    font-size: 20px; // 用户图标大小
    margin-right: 5px; // 调整图标和文本之间的间距
  }

  &:hover {
    color: $comColor;
    outline: none;
  }
}
</style>
