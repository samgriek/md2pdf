<template>
    <div class="d-flex flex-column vh-100">
      <header-component @convert="convertMarkdownText"></header-component>
  
      <div class="d-flex flex-grow-1 overflow-auto">
        <div class="w-50 overflow-auto">
          <markdown-input-component @updateMarkdown="updateMarkdown"></markdown-input-component>
        </div>
  
        <div class="w-50 overflow-auto">
          <pdf-output-component :pdf="pdf"></pdf-output-component>
        </div>
      </div>
    </div>
</template>

<script setup lang="ts">
import { ref, defineComponent } from 'vue';
import HeaderComponent from '../components/HeaderComponent.vue';
import MarkdownInputComponent from '../components/MarkdownInputComponent.vue';
import PdfOutputComponent from '../components/PdfOutputComponent.vue';
import { convertMarkdown } from '../api';

const pdf = ref<string>('');
const markdown = ref('');

const updateMarkdown = (newMarkdown: string) => {
    markdown.value = newMarkdown;
};

const convertMarkdownText = async () => {
    const pdfUrl = await convertMarkdown(markdown.value);
    pdf.value = pdfUrl;
};

defineComponent({
    components: {
        HeaderComponent,
        MarkdownInputComponent,
        PdfOutputComponent,
    },
});
</script>

<style>
* {
    border-radius: 0 !important;
}
</style>
