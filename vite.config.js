import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    AutoImport({
      resolvers: [ElementPlusResolver()]
    }),
    Components({
      resolvers: [ElementPlusResolver({ importStyle: 'sass' })]
    })
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  css: {
    preprocessorOptions: {
      scss: {
        api: 'modern-compiler', // or 'modern'
        additionalData: `
          @use "@/styles/element/index.scss" as *;
          @use "@/styles/var.scss" as *;
        `
      }
    }
  },
  server: {
    port: 5173, // 本地开发服务器端口
    proxy: {
      '/fanBlog': {
        target: 'http://localhost:8888', // 将 /fanBlog 的请求转发到本地后端，这里应该填后端url?
        changeOrigin: true
      },
      '/api': {
        target: 'https://smms.app', // 将 /api 的请求转发到 sm.ms 的 API
        changeOrigin: true,
        secure: false // 若目标为 HTTPS 且证书无效，可设置为 false
      }
    }
  }
})
