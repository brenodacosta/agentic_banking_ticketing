from langchain_core.language_models.chat_models import BaseChatModel
from langchain_google_genai import ChatGoogleGenerativeAI

from app.core.config import get_settings


def get_llm() -> BaseChatModel:
    """Return a configured Gemini chat model.

    Env vars:
    - `AI_AGENTIC_API_KEY` (required)
    - `GENAI_MODEL` (optional)
    - `LLM_TEMPERATURE` (optional)
    """
    settings = get_settings()

    if not settings.ai_agentic_api_key:
        raise RuntimeError(
            "Missing AI_AGENTIC_API_KEY. Set it in the environment before running."
        )

    return ChatGoogleGenerativeAI(
        model=settings.genai_model,
        temperature=settings.llm_temperature,
        google_api_key=settings.ai_agentic_api_key,
    )
