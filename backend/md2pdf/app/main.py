from app.api.v1 import health, convert
from app.init import init
from fastapi.middleware.cors import CORSMiddleware
from fastapi import status, Request, Response, FastAPI

import time

api_version = "/v1"

app = FastAPI()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)
    print(f"process-time={str(process_time)}")
    return response

app.include_router(health.router, prefix="")
app.include_router(convert.router, prefix="")


@app.options("/{path:path}")
async def handle_options_request(path: str, response: Response):
    response.status_code = status.HTTP_200_OK
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] = "*"
    return response

init()
