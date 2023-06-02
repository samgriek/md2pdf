# from sqlalchemy.orm import Session
# from app.database.models import VideoContent
# from typing import List

# def insert_video_content(db: Session, video_content: VideoContent) -> VideoContent:
#     db.add(video_content)
#     db.commit()
#     db.refresh(video_content)
#     return video_content


# def get_all_content(db: Session) -> List[VideoContent]: 
#     return db.query(VideoContent).order_by(VideoContent.uploaded_at).all()
