from collections.abc import Callable
from typing import cast

from fastapi import APIRouter
from pydantic import BaseModel
from starlette.concurrency import run_in_threadpool

from app.workflows.incident_workflow import incident_workflow
from app.workflows.state import WorkflowState

router = APIRouter()


class IncidentRequest(BaseModel):
    description: str


class IncidentResponse(BaseModel):
    jira_title: str
    jira_description: str
    incident_summary: str
    logs: list[str]


@router.post("/incident", response_model=IncidentResponse)
async def run_incident(request: IncidentRequest) -> IncidentResponse:
    """Run the incident → Jira workflow (Phase 1: local execution only)."""
    initial_state: WorkflowState = {
        "request_text": request.description,
        "logs": ["Request received by API."],
    }

    invoke = cast(Callable[[WorkflowState], WorkflowState], incident_workflow.invoke)
    final_state = await run_in_threadpool(invoke, initial_state)

    return IncidentResponse(
        jira_title=final_state["jira_title"],
        jira_description=final_state["jira_description"],
        incident_summary=final_state["incident_summary"],
        logs=final_state.get("logs", []),
    )
