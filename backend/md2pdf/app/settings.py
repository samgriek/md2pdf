from typing import List

from pydantic import BaseSettings, PostgresDsn


class AppSettings(BaseSettings):
    database_uri: PostgresDsn = "postgresql://postgres:password@db:5433/content-db"
    database_pool_size: int = 5
    database_pool_recycle: int = 120  # seconds
    environment = "local"
    sentry_dsn: str = ""
    
class UploadSettings(BaseSettings):
    upload_bucket_name = "contenz-dev-video-upload"
    region = "us-west-2"
    upload_expiration_seconds = 3600


class SecuritySettings(BaseSettings):
    secret_key: str = "2688577752"
    token_expiration_minutes = 1440
    algorithm = "HS256"
    superuser_username = "superuser@arcturus.io"
    superuser_password = "password"
    sandbox_host_postfix = "arcturus.io"
    aws_access_key = "AKIAQQ2GE4IV36E3NZAF"
    aws_secret_key = "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"


class EmailSettings(BaseSettings):
    smtp_server_uri: str = "smtp.office365.com"
    smtp_password = "$5zoiH*S^06HvxBglu"
    smtp_user: str = "support@arcturus.io"
    smtp_port: int = 587


class RoleMapping(BaseSettings):
    arc_core: List[str] = ["Premium Role", "Demo Role"]
    arc_corp: List[str] = ["Arc Corp Owner", "Arc Corp Contributor", "Arc Corp Admin"]
    external_api: List[str] = [
        "External API Role",
        "Delta Lake Reader",
        "Sandbox Data Contributor",
    ]
    all_products: List[str] = ["Org Owner"]
    default: List[str] = ["API Role", "Basic Authentication"]


role_mapping = RoleMapping()
app_settings = AppSettings()
security_settings = SecuritySettings()
email_settings = EmailSettings()
upload_settings = UploadSettings()
