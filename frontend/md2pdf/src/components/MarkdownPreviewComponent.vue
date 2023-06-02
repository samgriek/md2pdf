<template>
  <div v-html="renderedMarkdown" class="border p-2"></div>
</template>
  
<script setup lang="ts">
import { ref, watchEffect } from 'vue';
import { marked } from 'marked';

const props = defineProps({
  markdown: String,
});

let renderedMarkdown = ref('');

watchEffect(() => {
  if (props.markdown) {
    renderedMarkdown.value = marked(props.markdown);
  }
});
</script>
  