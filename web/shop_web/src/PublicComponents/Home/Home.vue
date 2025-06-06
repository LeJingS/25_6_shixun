<template>
  <div class="home-layout">
    <!-- 顶部边框 -->
    <header class="top-bar">
      <h1>我的商城</h1>
    </header>

    <!-- 主要内容区域，并显示 Login 组件 -->
    <main class="content">
      <Login />
    </main>

    <!-- 底部边框 -->
    <footer class="bottom-bar">
      <p>© 2025 商城版权所有</p>
    </footer>
  </div>
</template>

<script>
import Login from '../../Login/Login.vue'; // ✅ 正确导入 Login 组件

export default {
  name: 'Home',
  components: {
    Login // ✅ 注册组件
  }
};
</script>

<style scoped>
.home-layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  width: 100%;
  position: fixed;
  top: 0;
  left: 0;
  z-index: -1000;
}

.content {
  flex: 1;
  padding: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 70px;
}

.top-bar {
  background-color: orange;
  color: white;
  padding: 15px 0;
  text-align: center;
  width: 100%;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 999;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.bottom-bar {
  background-color: #f1f1f1;
  color: #333;
  padding: 10px 20px;
  text-align: center;
  border-top: 1px solid #ddd;
}
</style>