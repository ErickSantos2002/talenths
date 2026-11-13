from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    DATABASE_URL: str
    JWT_SECRET: str
    JWT_ALGORITHM: str = "HS256"
    JWT_EXPIRE_HOURS: int = 24
    ANTHROPIC_API_KEY: str = ""
    FRONTEND_URL: str = "http://localhost:8080"
    UPLOADS_DIR: str = "/app/uploads"

    # PEM Ed25519 do HS.OS (token do Guardi). Vazio: todo token de agente dá 401.
    HSOS_AGENTE_CHAVE_PUBLICA: str = ""

    MS_CLIENT_ID: str = ""
    MS_TENANT_ID: str = ""
    MS_CLIENT_SECRET: str = ""
    MS_REDIRECT_URI: str = "http://localhost:8000/auth/microsoft/callback"


settings = Settings()
