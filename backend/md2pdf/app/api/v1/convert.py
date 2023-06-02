import io

import markdown
from fastapi import APIRouter, Response
from pydantic import BaseModel
from weasyprint import HTML

router = APIRouter()


class MarkdownData(BaseModel):
    markdown: str


@router.post("/convert")
async def convert(data: MarkdownData):

    html = markdown.markdown(data.markdown)
    pdf = HTML(string=html).write_pdf()
    pdf_stream = io.BytesIO(pdf)
    response = Response(pdf_stream.getvalue(), media_type="application/pdf")

    return response
