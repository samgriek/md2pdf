<template>
<div class="card d-flex flex-column h-100">
    <div class="card-body d-flex flex-column flex-grow-1">
        <div v-if="pdf" class="flex-grow-1">
            <iframe :src="pdf" style="width: 100%; height: 100%;"></iframe>
        </div>
        <div v-else>
            <p>No PDF to display.</p>
        </div>
    </div>
</div>

</template>
  
<script setup lang="ts">
const props = defineProps({
    pdf: String,
});
</script>