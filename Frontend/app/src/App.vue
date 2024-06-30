<script setup lang="ts">
import axios from 'axios';
import { ref, onMounted } from 'vue';

const isActive = ref(true);
const isLoading = ref(false);
const remainingTime = ref(5); // 初期値は5秒


async function postData(num: number) {
  const url = 'GASのWebアプリURL';
  const queryParams = { num };

  try {
    const response = await axios.post(url, null, { params: queryParams });
    console.log('Response:', response.data);
    return response.data;
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}

// ページのロード時にローカルストレージから状態を読み込む
onMounted(() => {
  const lastClickedTime = localStorage.getItem('lastClickedTime');
  if (lastClickedTime) {
    const timeDiff = Date.now() - parseInt(lastClickedTime, 10);
    if (timeDiff < 5000) {
      isActive.value = false;
      isLoading.value = true;
      remainingTime.value = Math.ceil((5000 - timeDiff) / 1000); // 残り時間を秒で計算
      const interval = setInterval(() => {
        remainingTime.value--;
        if (remainingTime.value <= 0) {
          clearInterval(interval);
          isActive.value = true;
          isLoading.value = false;
        }
      }, 1000);
    }
  }
});

const post = (num: number) => {
  isActive.value = false;
  isLoading.value = true;
  remainingTime.value = 5; // 初期値に戻す
  console.log(num);
  postData(num);
  localStorage.setItem('lastClickedTime', Date.now().toString());
  const interval = setInterval(() => {
    remainingTime.value--;
    if (remainingTime.value <= 0) {
      clearInterval(interval);
      isActive.value = true;
      isLoading.value = false;
    }
  }, 1000);
};
</script>

<template>
  <main>
    <div>
      <h1>Online Block Game</h1>
      <div class="button-wrappers" v-if="isActive">
        <div class="button-wrapper">
          <button @click="post(1)">1</button>
        </div>
        <div class="button-wrapper">
          <button @click="post(2)">2</button>
        </div>
        <div class="button-wrapper">
          <button @click="post(3)">3</button>
        </div>
      </div>
      <div v-if="isLoading" class="loading-screen">
        <div class="loading-animation"></div>
        <p>
          Loading...<br />
          Remaining time: {{ remainingTime }} s
        </p>
      </div>
    </div>
  </main>
</template>

<style scoped>
h1 {
  text-align: center;
}

.button-wrapper {
  width: 300px;
  height: 120px;
  margin: 30px auto;
}

.button-wrapper>button {
  width: 100%;
  height: 100%;
  border-radius: 10px;
  border: none;
}

.button-wrapper>button:hover {
  background-color: rgb(73, 73, 73);
  cursor: pointer;
}

.loading-screen {
  display: flex;
  position: fixed;
  top: 0;
  left: 0;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
  font-size: 2em;
}

.loading-animation {
  width: 50px;
  height: 50px;
  border: 5px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: #fff;
  animation: spin 1s infinite linear;
  margin-bottom: 20px;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
