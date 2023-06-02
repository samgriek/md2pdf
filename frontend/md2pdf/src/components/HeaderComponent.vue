<template>
  <nav class="navbar">
    <div class="container-fluid">
      <h1 class="navbar-brand text-dark" href="#">Markdown to PDF Converter</h1>
      <ul class="nav" id="myTab" role="tablist">
        <li class="nav-item" role="presentation">
          <button class="nav-link active" id="raw-tab" data-bs-toggle="tab" data-bs-target="#raw" type="button" role="tab"
            aria-controls="raw" aria-selected="true">Raw</button>
        </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link" id="preview-tab" data-bs-toggle="tab" data-bs-target="#preview" type="button" role="tab"
            aria-controls="preview" aria-selected="false">Preview</button>
        </li>
        <li class="nav-item" role="presentation">
          <button class="nav-link" @click="convert">Convert to PDF</button>
        </li>
      </ul>
      <a class="btn btn-success" href="https://www.buymeacoffee.com/sgriek" target="_blank">Buy Me a Coffee</a>
    </div>
  </nav>
</template>

<script setup lang="ts">

const emit = defineEmits(['convert']);

const convert = () => {
  emit('convert');
};
</script>
