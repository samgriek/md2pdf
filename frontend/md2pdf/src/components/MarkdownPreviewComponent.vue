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

<style scoped>
blockquote {
  padding: 10px 20px;
  margin: 0 0 20px;
  font-size: 17.5px;
  border-left: 5px solid #eeeeee;
}
code {
  border: 2px;
  border-color: black;
  background-color: black;
  font-size: 2rem;

}

</style>
