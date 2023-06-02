<template>
    <div class="container bg-dark">
        <header-component></header-component>

        <div class="row">
            <div class="col-md-6">
                <markdown-input-component @convert="convertMarkdown" @toggleView="toggleView"
                    @updateMarkdown="updateMarkdown"></markdown-input-component>

                <!-- <markdown-input-component @convert="convertMarkdown" @toggleView="toggleView"></markdown-input-component> -->
                <markdown-preview-component v-if="showPreview" :markdown="markdown"></markdown-preview-component>
            </div>
            <div class="col-md-6">
                <pdf-output-component :pdf="pdf"></pdf-output-component>
            </div>
        </div>

        <ad-component></ad-component>

        <footer-component></footer-component>
    </div>
</template>
  
<script setup lang="ts">
import { ref, defineComponent } from 'vue';
import HeaderComponent from '../components/HeaderComponent.vue';
import MarkdownInputComponent from '../components/MarkdownInputComponent.vue';
import MarkdownPreviewComponent from '../components/MarkdownPreviewComponent.vue';
import PdfOutputComponent from '../components/PdfOutputComponent.vue';
import AdComponent from '../components/AdComponent.vue';
import FooterComponent from '../components/FooterComponent.vue';

const pdf = ref<string | null>(null);
const markdown = ref('');
const showPreview = ref(false);

const updateMarkdown = (newMarkdown: string) => {
  markdown.value = newMarkdown;
};

const convertMarkdown = async (markdownText: string) => {
    markdown.value = markdownText;
    const response = await fetch('http://localhost:20081/convert', {
        method: 'POST',
        body: JSON.stringify({ markdown: markdownText }),
        headers: { 'Content-Type': 'application/json' },
    });
    const data = await response.blob();

    const pdfUrl = URL.createObjectURL(data);
    console.log(pdfUrl)

    pdf.value = pdfUrl;
};

const toggleView = () => {
    showPreview.value = !showPreview.value;
};

defineComponent({
    components: {
        HeaderComponent,
        MarkdownInputComponent,
        MarkdownPreviewComponent,
        PdfOutputComponent,
        AdComponent,
        FooterComponent,
    },
});
</script>
  