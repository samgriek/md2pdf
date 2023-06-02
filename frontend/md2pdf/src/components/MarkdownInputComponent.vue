<template>
  <div class="d-flex flex-column h-100">
    <div class="tab-content d-flex flex-column flex-grow-1 overflow-auto" id="myTabContent">
      <div class="tab-pane fade show active flex-grow-1" id="raw" role="tabpanel" aria-labelledby="raw-tab">
        <textarea class="form-control" v-model="markdownText" style="height: 100%;"></textarea>
      </div>
      <div class="tab-pane fade flex-grow-1" id="preview" role="tabpanel" aria-labelledby="preview-tab">
        <div v-html="renderedMarkdown" class="border p-2 h-100"></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watchEffect } from 'vue';
import { marked } from 'marked';
import Prism from 'prismjs';
import 'prismjs/themes/prism.css';

const markdownText = ref('');
const renderedMarkdown = ref('');

watchEffect(() => {
  renderedMarkdown.value = marked(markdownText.value);
  emit('updateMarkdown', renderedMarkdown.value);
});

const emit = defineEmits(['convert', 'updateMarkdown']);

const convert = () => {
  emit('convert', markdownText.value);
};
</script>
