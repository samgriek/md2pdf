<template>
    <div class="card">
        <div class="card-body">
            <h5 class="card-title">PDF Output</h5>
            <div v-if="pdf">
                <iframe :src="pdf" style="width: 100%; height: 556px;"></iframe>
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