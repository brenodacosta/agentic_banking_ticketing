import os

import pytest

from app.chains.incident_summarizer import summarize_incident


@pytest.mark.llm
def test_summary_has_bullets_and_minimum_content():
    # This test intentionally calls the real provider.
    # Enable in CI by setting RUN_LLM_TESTS=1 and exporting AI_AGENTIC_API_KEY.
    if os.getenv("RUN_LLM_TESTS") != "1":
        pytest.skip("Set RUN_LLM_TESTS=1 to enable LLM determinism checks")

    if not os.getenv("AI_AGENTIC_API_KEY"):
        pytest.skip("AI_AGENTIC_API_KEY not set")

    text = (
        "After a deploy, customers saw intermittent payment timeouts. "
        "p95 latency rose to 5s. We rolled back. Suspect DB pool exhaustion."
    )

    summary = summarize_incident(text)
    assert isinstance(summary, str)
    assert len(summary) >= 80

    # Determinism-ish guardrails (semantic shape, not exact text)
    lines = [ln.strip() for ln in summary.splitlines() if ln.strip()]
    bullet_lines = [ln for ln in lines if ln.startswith("-") or ln.startswith("•")]
    assert len(bullet_lines) >= 3
