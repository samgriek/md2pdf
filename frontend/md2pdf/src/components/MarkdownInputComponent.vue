<!-- <template>
    <div class="card">
        <div class="card-body">
            <div class="mb-3">
                <label for="markdownInput" class="form-label">Markdown Input</label>
                <textarea class="form-control" id="markdownInput" rows="10" v-model="markdownText"></textarea>
            </div>
            <div>
                <div>
                    <button class="btn btn-primary" @click="convert">Convert to PDF</button>
                </div>
                <div>
                    <button class="btn btn-primary" @click="toggleView">Toggle View</button>
                </div>
            </div>
        </div>
    </div>
</template>
  
<script setup lang="ts">
import { ref } from 'vue';

const markdownText = ref('');

const emit = defineEmits(['convert', 'toggleView', 'updateMarkdown']);

const convert = () => {
    emit('convert', markdownText.value);
};

const toggleView = () => {
    emit('toggleView');
    emit('updateMarkdown', markdownText.value);
};

</script> -->


<template>
  <div class="card">
    <div class="card-body">
      <ul class="nav nav-tabs" id="myTab" role="tablist">
        <li class="nav-item rounded-top" role="presentation">
          <button class="nav-link active" id="raw-tab" data-bs-toggle="tab" data-bs-target="#raw" type="button" role="tab"
            aria-controls="raw" aria-selected="true">Raw</button>
        </li>
        <li class="nav-item rounded-top" role="presentation">
          <button class="nav-link" id="preview-tab" data-bs-toggle="tab" data-bs-target="#preview" type="button"
            role="tab" aria-controls="preview" aria-selected="false">Preview</button>
        </li>
      </ul>
      <div class="tab-content" id="myTabContent">
        <div class="tab-pane fade show active" id="raw" role="tabpanel" aria-labelledby="raw-tab">
          <textarea class="form-control" rows="10" v-model="markdownText" style="height: 500px;"></textarea>
        </div>
        <div class="tab-pane fade" id="preview" role="tabpanel" aria-labelledby="preview-tab">
          <div v-html="renderedMarkdown" class="border p-2" style="height: 500px; overflow-y: auto;"></div>
        </div>
      </div>
      <button class="btn btn-primary mt-3" @click="convert">Convert to PDF</button>
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
});

const emit = defineEmits(['convert']);

const convert = () => {
  emit('convert', markdownText.value);
};
</script>
