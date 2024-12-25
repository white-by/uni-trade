<script setup>
import { ArrowDown, Search } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useRouter } from 'vue-router'
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useUserStore } from '@/store/userStore'
import useThrottle from '@/hooks/useThrottle.js'
import { useSearchStore } from '@/store/searchStore'
// import { useSelectStore } from '@/store/selectStore'
// import { useCategoryStore } from '@/store/sortCategory'

const userStore = useUserStore()
const userName = ref(userStore.userInfo.userName)

const searchStore = useSearchStore()
// const selectStore = useSelectStore()
// const categoryStore = useCategoryStore()
const searchInput = ref('')

const router = useRouter()

const { throttled } = useThrottle()

// 返回首页
const toHome = () => {
  searchStore.searchQuery = ''
  searchInput.value = ''
  // selectStore.selectData = ''
  // console.log('categoryID:', categoryStore.categoryID)
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

// 从本地存储加载公告并排序
const loadAnnouncements = () => {
  const storedAnnouncements = localStorage.getItem('announcements')

  // 如果本地没有存储公告数据，则初始化为一个空数组
  if (!storedAnnouncements) {
    announcements.value = []
    localStorage.setItem('announcements', JSON.stringify(announcements.value)) // 初始化本地存储
  } else {
    // 从本地存储中加载公告并进行排序
    announcements.value = JSON.parse(storedAnnouncements)

    // 对存储的公告按时间倒序排序
    announcements.value.sort((a, b) => new Date(b.date) - new Date(a.date))
  }
}

onMounted(() => {
  checkNewAnnouncement() // 页面加载时恢复公告和红点状态
  loadAnnouncements() // 加载本地存储的公告

  // 连接到 SSE 服务端
  eventSource = new EventSource('http://127.0.0.1:5001/announcements/sse')

  // 接收新公告
  eventSource.onmessage = (event) => {
    try {
      // 提取 data 部分
      const rawData = event.data.trim().slice(1) // 去掉前面的 'data: ' 部分
      const parts = rawData.split(' ')

      if (parts.length > 4) {
        // 提取日期时间部分，注意时区信息（+0000 UTC）会去除
        const dateParts = parts.slice(3, 6).join(' ') // 获取 '2024-12-23 13:40:15'

        // 格式化日期和时间
        const [date, time] = dateParts.split(' ') // 拆分成日期和时间部分

        // 合并日期和时间部分，创建一个 Date 对象
        const dateTimeStr = `${date}T${time}Z` // 将字符串转化为 ISO 8601 格式的时间
        const dateObj = new Date(dateTimeStr) // 转化为 Date 对象

        // 加上 8 小时
        // dateObj.setHours(dateObj.getHours() + 8); // 增加 8 小时

        // 格式化日期和时间
        const adjustedDate = dateObj.toLocaleDateString() // 获取 YYYY-MM-DD 格式的日期
        const adjustedTime = dateObj.toLocaleTimeString() // 获取 HH:MM:SS 格式的时间

        const newAnnouncement = {
          id: parts[0], // 公告 ID
          title: parts[1], // 公告标题
          content: parts[2], // 公告内容
          date: `${adjustedDate} ${adjustedTime}` // 完整的日期和时间
        }

        // 检查公告 ID 是否已经存在
        const existingAnnouncements = announcements.value
        const isNew = !existingAnnouncements.some((item) => item.id === newAnnouncement.id)

        if (isNew) {
          // 将新公告添加到最前面
          announcements.value.unshift(newAnnouncement) // 如果是新公告，添加到公告列表的前面

          // 保证公告列表最多只有 3 条
          if (announcements.value.length > 3) {
            announcements.value = announcements.value.slice(0, 3) // 保留前 3 条公告
          }

          // 排序公告列表，确保顺序倒序
          announcements.value.sort((a, b) => new Date(b.date) - new Date(a.date)) // 按时间倒序排序

          // 更新本地存储
          localStorage.setItem('announcements', JSON.stringify(announcements.value)) // 更新本地存储

          // 设置红点显示
          if (!dialogTableVisible.value) {
            hasNewAnnouncement.value = true
            localStorage.setItem('hasNewAnnouncement', 'true') // 更新红点状态
          }
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

// 退出登录
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

// 跳转到个人中心
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
          <!-- <li>
            <a href="javascript:;"><i class="iconfont icon-message"></i></a>
          </li> -->
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
