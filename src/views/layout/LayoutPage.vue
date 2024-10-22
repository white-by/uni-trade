<script setup>
import LayoutNav from './components/LayoutNav.vue'
import LayoutHeader from './components/LayoutHeader.vue'
import LayoutFooter from './components/LayoutFooter.vue'
</script>

<template>
  <div>
    <LayoutNav />
    <LayoutHeader />
    <!--二级路由出口组件---->
    <RouterView />
    <LayoutFooter />
  </div>
</template>
