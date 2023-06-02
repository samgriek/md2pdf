import os

from app.constants import MIME_TYPES, SUPPORTED_EXTENSIONS
from fastapi import HTTPException


def get_supported_content_type(extension: str):
    if extension.lower() not in SUPPORTED_EXTENSIONS:
        raise HTTPException(status_code=422, detail="Unsupported file type")

    content_type = MIME_TYPES.get(extension.lower(), "application/octet-stream")
    
    return content_type
