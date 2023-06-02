# from app.database.connection import SessionLocal
# from alembic.command import upgrade
# from alembic.config import Config

def init():
    
    # this api doesn't have any db at the moment
    # alembic_cfg = Config("alembic.ini")
    # upgrade(alembic_cfg, "head")
        
    # with SessionLocal() as db:
    #     db.execute("select 1")
    print("init complete")
