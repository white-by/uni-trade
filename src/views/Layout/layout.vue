<script setup>
import LayoutNav from './conponents/LayoutNav.vue';
import LayoutHeader from './conponents/LayoutHeader.vue';
import LayoutFooter from './conponents/LayoutFooter.vue';
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