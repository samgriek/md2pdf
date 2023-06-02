from fastapi import APIRouter, Response, status


router = APIRouter()


@router.get("/health")
async def health(
    response: Response,
    # db = Depends(get_db)
):
    # db.execute("select 1")
    response.status_code = status.HTTP_200_OK

@router.get("/")
async def health_ecs(
    response: Response,
    # db = Depends(get_db)
):
    # db.execute("select 1")
    response.status_code = status.HTTP_200_OK
