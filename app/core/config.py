from __future__ import annotations

from functools import lru_cache
from typing import Literal

from pydantic import AliasChoices, Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Environment-driven runtime configuration.

    Phase 2 goal: all runtime config comes from env vars so it maps cleanly to
    CI/CD secrets + Kubernetes Secrets/ConfigMaps later.
    """

    model_config = SettingsConfigDict(
        env_file=None,  # container/runtime should inject env vars
        extra="ignore",
    )

    app_env: Literal["dev", "staging", "prod"] = Field(
        default="dev",
        validation_alias=AliasChoices("APP_ENV"),
    )

    log_level: str = Field(
        default="INFO",
        validation_alias=AliasChoices("LOG_LEVEL"),
    )

    llm_temperature: float = Field(
        default=0.0,
        validation_alias=AliasChoices("LLM_TEMPERATURE"),
    )

    genai_model: str = Field(
        default="gemini-3-flash-preview",
        validation_alias=AliasChoices("GENAI_MODEL", "GEMINI_MODEL"),
    )

    ai_agentic_api_key: str | None = Field(
        default=None,
        validation_alias=AliasChoices("AI_AGENTIC_API_KEY"),
    )


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    return Settings()
