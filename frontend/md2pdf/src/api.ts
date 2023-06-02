export async function convertMarkdown(markdownText: string): Promise<string> {
    // const apiKey = process.env.VUE_APP_API_KEY;
    // if (!apiKey) {
    //     throw new Error('API key is not defined');
    // }

    // const api_url = process.env.VUE_APP_API_URL;
    const api_url = "https://api-md2pdf.griekinc.com"
    if (!api_url) {
        throw new Error('API url is not defined')
    }

    const response = await fetch(api_url + '/convert', {
        method: 'POST',
        body: JSON.stringify({ markdown: markdownText }),
        headers: { 
            'Content-Type': 'application/json',
            // 'x-api-key': apiKey
        },
    });
    const data = await response.blob();
    console.log(`data size: ${data.size}`)
    console.log(data)
    const pdfUrl = URL.createObjectURL(data);
    return pdfUrl;
}

