# from sqlalchemy import Column, DateTime, Enum, Integer, String, Text
# from sqlalchemy.dialects.postgresql import UUID
# from sqlalchemy.ext.declarative import declarative_base
# from sqlalchemy.sql import func, text

# Base = declarative_base()

# class SqlAlchemyToolsMixin:
#     def to_dict(model_instance):
#         return {key: value for key, value in model_instance.__dict__.items() if not key.startswith('_')}
    

# class VideoContent(Base, SqlAlchemyToolsMixin):
#     __tablename__ = 'video_content'

#     video_id = Column(UUID(as_uuid=True), primary_key=True, server_default=text("(gen_random_uuid())"))
#     file_name = Column(String, nullable=False)
#     s3_bucket = Column(String, nullable=False)
#     uploaded_at = Column(DateTime, server_default=func.now())
#     updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
#     size_mb = Column(Integer, nullable=True)
#     status = Column(Enum('DRAFT', 'PUBLISHED', 'UNPUBLISHED', name='status'), nullable=False, default="DRAFT")
#     mime_type = Column(String, nullable=False)
#     description = Column(Text, nullable=True)
