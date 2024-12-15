<script setup>
import { ArrowDown, Search } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useRouter } from 'vue-router'
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useUserStore } from '@/store/userStore'
import useThrottle from '@/hooks/useThrottle.js'
import { useSearchStore } from '@/store/searchStore'
// import { useCategoryStore } from '@/store/sortCategory'

const userStore = useUserStore()
const userName = ref(userStore.userInfo.userName)

const searchStore = useSearchStore()
// const categoryStore = useCategoryStore()
const searchInput = ref('')

const router = useRouter()

const { throttled } = useThrottle()

const toHome = () => {
  searchStore.searchQuery = ''
  searchInput.value = ''
  // categoryStore.categoryID = 0
}

// 搜索功能
const handleSearch = () => {
  const trimmedInput = searchInput.value.trim()
  if (trimmedInput) {
    // 搜索逻辑，例如跳转到搜索结果页
    // console.log('搜索内容：', trimmedInput)
    // router.push({ path: '/search', query: { searchInput: trimmedInput } })
    searchStore.searchQuery = trimmedInput
  } else {
    // 空输入提示
    ElMessage({
      message: '请输入商品名称进行搜索',
      type: 'warning',
      plain: true
    })
  }
}

// 节流处理：限制每秒响应一次
const throttledSearch = throttled(handleSearch, 1000)

// 控制公告弹窗可见性
const dialogTableVisible = ref(false)
// 是否有新公告
const hasNewAnnouncement = ref(false)
// 保存公告列表
const announcements = ref([])

// SSE 实例
let eventSource = null

// 实时改名
watch(
  () => userStore.userInfo.userName,
  (newName) => {
    userName.value = newName
  }
)

// 打开弹窗的方法
const openDialog = () => {
  dialogTableVisible.value = true
  markAsRead() // 打开弹窗时标记为已读
}

// 标记公告为已读
const markAsRead = () => {
  hasNewAnnouncement.value = false
  localStorage.setItem('hasNewAnnouncement', 'false')
}

// 恢复新公告状态
const checkNewAnnouncement = () => {
  const storedAnnouncements = localStorage.getItem('announcements')
  const storedStatus = localStorage.getItem('hasNewAnnouncement')

  if (storedAnnouncements) {
    announcements.value = JSON.parse(storedAnnouncements)
  }

  hasNewAnnouncement.value = storedStatus === 'true'
}

onMounted(() => {
  checkNewAnnouncement() // 页面加载时恢复公告和红点状态

  // 连接到 SSE 服务端
  eventSource = new EventSource('http://127.0.0.1:5001/announcements/sse')

  // 接收新公告
  eventSource.onmessage = (event) => {
    console.log('Received SSE data:', event.data) // 查看原始数据
    try {
      // 提取 data 部分
      const rawData = event.data.trim().slice(1) // 去掉前面的 'data: ' 部分

      // 按空格拆分字符串
      const parts = rawData.split(' ')

      if (parts.length >= 4) {
        // 提取日期
        const dateParts = parts.slice(3).join(' ') // 获取时间部分
        const date = dateParts.split(' ')[0] // 获取日期部分（即第一个部分）

        // 提取所需数据
        const extractedData = {
          id: parts[0], // 第一个值作为 id
          title: parts[1], // 第二个值作为 title
          content: parts[2], // 第三个值作为 content
          date: date
        }

        console.log('Extracted Data:', extractedData)

        // 你可以将数据存储到你的变量中
        announcements.value = [extractedData]
        localStorage.setItem('announcements', JSON.stringify([extractedData])) // 持久化公告数据

        // 如果有新的公告且对话框未打开
        if (!dialogTableVisible.value && extractedData.length > 0) {
          hasNewAnnouncement.value = true
          localStorage.setItem('hasNewAnnouncement', 'true')
        }
      }
    } catch (error) {
      console.log('公告获取失败', error)
    }
  }
})

onUnmounted(() => {
  if (eventSource) {
    eventSource.close()
  }
})

const confirmLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    userStore.clearUserInfo()
    router.push('/login')
  } catch (error) {
    console.log('取消了登出操作', error)
  }
}

const navigateToProfile = () => {
  const userID = userStore.userInfo.userID
  const targetUrl = `/profiles/${userID}/receivedComment`

  router.push(targetUrl).then(() => {
    // 强制刷新页面
    window.location.reload()
  })
}
</script>

<template>
  <nav class="app-topnav">
    <div class="container">
      <ul>
        <h1 class="logo" @click="toHome">
          <RouterLink to="/">校园二手交易站</RouterLink>
        </h1>
        <div class="site-name">校园二手交易站</div>
        <div class="search">
          <el-input
            v-if="$route.path === '/'"
            v-model="searchInput"
            style="width: 440px"
            placeholder="请输入商品名称"
            :prefix-icon="Search"
            @keydown.enter="throttledSearch"
          />
        </div>
        <template v-if="true">
          <!-- 使用el-badge显示小红点 -->
          <li>
            <!-- 公告图标，带红点提示 -->
            <el-badge is-dot :hidden="!hasNewAnnouncement" :offset="[-20, 5]">
              <a href="javascript:;" @click="openDialog">
                <i class="iconfont icon-announcement"></i>
              </a>
            </el-badge>
          </li>

          <li>
            <router-link to="/user/collections"><i class="iconfont icon-shop"></i></router-link>
          </li>
          <li>
            <a href="javascript:;"><i class="iconfont icon-message"></i></a>
          </li>
          <el-divider direction="vertical" />
          <li>
            <el-dropdown placement="bottom" size="large">
              <span class="el-dropdown-link">
                <i class="iconfont icon-user"></i> {{ userName }}
                <el-icon class="el-icon--right">
                  <arrow-down />
                </el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item @click="navigateToProfile">个人中心</el-dropdown-item>
                  <router-link to="/user/order"><el-dropdown-item>我的订单</el-dropdown-item></router-link>
                  <router-link :to="`/profiles/${userStore.userInfo.userID}/published`"
                    ><el-dropdown-item>我的商品</el-dropdown-item></router-link
                  >
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

  <!-- 公告弹窗 -->
  <el-dialog v-model="dialogTableVisible" title="公告栏" width="800px">
    <div class="announcement-board">
      <el-timeline>
        <el-timeline-item v-for="item in announcements" :key="item.id" :timestamp="item.date" placement="top">
          <el-card>
            <h4>{{ item.title }}</h4>
            <br />
            <p>{{ item.content }}</p>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </div>
  </el-dialog>
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

.announcement-board {
  margin: 30px;
}
</style>
