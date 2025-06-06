<template>
  <div class="login-wrapper">
    <el-card class="login-card">
      <h2 slot="header" class="login-header">用户登录</h2>

      <el-form :model="form" :rules="rules" ref="formRef" label-position="top">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" />
        </el-form-item>

        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" show-password placeholder="请输入密码" />
        </el-form-item>

        <el-button type="primary" @click="onSubmit" class="submit-btn" round>登 录</el-button>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'Login',
  data() {
    return {
      form: {
        username: '',
        password: ''
      },
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ]
      }
    };
  },
  methods: {
    onSubmit() {
      // 模拟登录逻辑，可替换为真实请求
      if (this.form.username && this.form.password) {
        alert(`欢迎回来, ${this.form.username}`);
      }
    }
  }
};
</script>

<style scoped>
.login-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(to right, #f8f9fa, #e9ecef);
}

.login-card {
  width: 400px;
  padding: 20px;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
  border-radius: 10px;
  background-color: white;
}

.login-header {
  margin: 0;
  font-size: 24px;
  text-align: center;
  color: #333;
}

.submit-btn {
  width: 100%;
  margin-top: 20px;
}
</style>