<template>
  <div class="app-container">
    <Home />
  </div>
</template>

<script>
import Home from './PublicComponents/Home/Home.vue';

export default {
  components: {
    Home
  }
};
</script>

<style scoped>
.app-container {
  position: relative;
  width: 100%;
  height: 100vh;
}
</style>