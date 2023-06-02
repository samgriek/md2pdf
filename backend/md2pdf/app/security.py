from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer
from fastapi import Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.orm import Session
from datetime import datetime, timedelta

from jose import JWTError, jwt

from app.settings import security_settings, app_settings
from app.database.models import User
from app.database.queries import get_user
from typing import Dict, Any, List
import re

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

SECRET_KEY = security_settings.secret_key
ALGORITHM = security_settings.algorithm
ACCESS_TOKEN_EXPIRE_MINUTES = security_settings.token_expiration_minutes
ENVIRONMENT = app_settings.environment
VERSION_REGEX = re.compile(r'\/(v\d+)(\/.*)')


class TokenData(BaseModel):
    user_id: str
    username: str
    email: str
    expire: int
    roles: List[str]
    tenants: List[str]


class Token(BaseModel):
    access_token: str
    token_type: str


def get_crypt_context():
    return pwd_context


def get_auth_scheme():
    return oauth2_scheme


def is_expired(expire_timestamp: float):
    
    if datetime.utcnow().timestamp() > expire_timestamp:
        return True
    
    return False


def authenticate_user(username: str, password: str, db: Session) -> User:
    user = get_user(db=db, username=username)
    
    if not user or not pwd_context.verify(password, user.hashed_password):
        return None
    
    return user


def create_access_token(data: Dict[str, Any]):
    
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire.timestamp()})
    to_encode.update({"env": ENVIRONMENT})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(
    token: str = Depends(oauth2_scheme),
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    expiration_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Token expired",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("user_id")
        username: str = payload.get("sub")
        email: str = payload.get("email")
        expire = payload.get("exp")
        roles = payload.get("roles")
        tenants = payload.get("tenants")
        
        if not username or not email:
            raise credentials_exception
        if is_expired(expire):
            raise expiration_exception
        
    except JWTError:
        raise credentials_exception
    
    token_data = TokenData(
        user_id=user_id,
        username=username,
        email=email,
        expire=expire,
        roles=roles,
        tenants=tenants,
    )
    
    return token_data
