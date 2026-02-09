from app.workflows.incident_workflow import incident_workflow


def test_incident_workflow_state_and_logs(monkeypatch):
    # Avoid external LLM calls by mocking the summarizer
    from app.chains import incident_summarizer

    fake_summary = (
        "- Impact: degraded latency\n"
        "- Systems: payments-api\n"
        "- Next steps: investigate pool"
    )

    monkeypatch.setattr(
        incident_summarizer,
        "summarize_incident",
        lambda _: fake_summary,
    )

    initial_state = {
        "request_text": "raw incident text",
        "logs": ["Request received by API."],
    }
    final_state = incident_workflow.invoke(initial_state)

    assert final_state["incident_summary"].strip()
    assert final_state["jira_title"].strip()
    assert final_state["jira_description"].strip()

    logs = final_state.get("logs", [])
    assert len(logs) >= 3
    assert "Request received by API." in logs[0]
