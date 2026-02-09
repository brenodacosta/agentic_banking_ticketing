from langgraph.graph import END, StateGraph

from app.chains import incident_summarizer
from app.workflows.state import WorkflowState


def _append_log(state: WorkflowState, message: str) -> list[str]:
    logs = list(state.get("logs", []))
    logs.append(message)
    return logs


def summarize_incident_node(state: WorkflowState) -> WorkflowState:
    request_text = state["request_text"]
    summary = incident_summarizer.summarize_incident(request_text)

    return {
        "incident_summary": summary,
        "logs": _append_log(state, "Incident summarized by LLM."),
    }


def draft_jira_node(state: WorkflowState) -> WorkflowState:
    summary = state["incident_summary"]

    first_line = summary.split("\n", 1)[0].lstrip("- ").strip()
    jira_title = "Incident: " + (first_line if first_line else "Production incident")

    jira_description = (
        "Summary (LLM-generated):\n\n"
        f"{summary}\n\n"
        "---\n"
        "This ticket was drafted by the Agentic Banking Ticketing platform (Phase 1)."
    )

    return {
        "jira_title": jira_title,
        "jira_description": jira_description,
        "logs": _append_log(state, "Jira draft generated."),
    }


_graph = StateGraph(WorkflowState)
_graph.add_node("summarize_incident", summarize_incident_node)
_graph.add_node("draft_jira", draft_jira_node)

_graph.set_entry_point("summarize_incident")
_graph.add_edge("summarize_incident", "draft_jira")
_graph.add_edge("draft_jira", END)

incident_workflow = _graph.compile()
