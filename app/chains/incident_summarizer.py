from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate

from app.core.llm import get_llm

summary_prompt = ChatPromptTemplate.from_messages(
    [
        (
            "system",
            (
                "You are an assistant that summarizes IT incidents for a banking "
                "environment. Extract key details (impact, systems affected, "
                "root cause if known, timeline, and next steps). Respond in concise "
                "business language suitable for a Jira ticket."
            ),
        ),
        (
            "human",
            "Here is the raw incident description:\n\n{incident_text}\n\n"
            "Provide a structured summary in 4-6 bullet points.",
        ),
    ]
)


def summarize_incident(incident_text: str) -> str:
    """Summarize an incident using a simple LangChain chain."""
    chain = summary_prompt | get_llm() | StrOutputParser()
    return chain.invoke({"incident_text": incident_text})
