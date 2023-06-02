import markdown
from weasyprint import HTML
import sys

def markdown_to_pdf(input_file, output_file):
    with open(input_file, 'r') as f:
        text = f.read()

    html = markdown.markdown(text)

    with open('temp.html', 'w') as f:
        f.write(html)

    HTML('temp.html').write_pdf(output_file)

if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    markdown_to_pdf(input_file, output_file)
