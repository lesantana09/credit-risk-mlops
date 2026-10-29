"""Configuração central, lida de variáveis de ambiente (prefixo ``CREDIT_RISK_``)."""

from functools import lru_cache
from pathlib import Path
from typing import Literal

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Parâmetros de execução compartilhados por pipelines, treino e serving."""

    model_config = SettingsConfigDict(env_prefix="CREDIT_RISK_", env_file=".env", extra="ignore")

    environment: Literal["local", "dev", "prod"] = "local"
    data_dir: Path = Path("data")
    random_seed: int = 42
    aws_region: str = "us-east-1"
    mlflow_tracking_uri: str = "file:./mlruns"

    @property
    def raw_dir(self) -> Path:
        return self.data_dir / "raw"

    @property
    def processed_dir(self) -> Path:
        return self.data_dir / "processed"


@lru_cache
def get_settings() -> Settings:
    """Retorna a instância única de configuração do processo."""
    return Settings()
