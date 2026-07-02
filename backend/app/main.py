from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.middleware.audit import AuditMiddleware

from app.config import settings
from app.database import init_db, close_db
from app.auth.router import router as auth_router
from app.routers.companies import router as companies_router
from app.routers.departments import router as departments_router
from app.routers.profiles import router as profiles_router
from app.routers.collaborators import router as collaborators_router
from app.routers.invitations import router as invitations_router
from app.routers.notifications import router as notifications_router
from app.routers.culture import router as culture_router
from app.routers.goals import router as goals_router
from app.routers.evaluations import router as evaluations_router
from app.routers.career import router as career_router
from app.routers.pdi import router as pdi_router
from app.routers.learning import router as learning_router
from app.routers.workshops import router as workshops_router
from app.routers.communications import router as communications_router
from app.routers.onboarding import router as onboarding_router
from app.routers.surveys import router as surveys_router
from app.routers.absences import router as absences_router
from app.routers.benefits import router as benefits_router
from app.routers.salary import router as salary_router
from app.routers.reports import router as reports_router
from app.routers.calendar import router as calendar_router
from app.routers.logs import router as logs_router
from app.routers.custom_tests import router as custom_tests_router
from app.routers.feedbacks import router as feedbacks_router
from app.routers.documents import router as documents_router
from app.routers.timeclock import router as timeclock_router
from app.routers.bingo import router as bingo_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_db()
    yield
    await close_db()


app = FastAPI(
    title="TalentHS API",
    description="API do sistema de RH e desenvolvimento pessoal TalentHS",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(AuditMiddleware)
_frontend_origin = settings.FRONTEND_URL.rstrip("/")
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        _frontend_origin,
        "https://talenths.healthsafetytech.com",
        "http://localhost:8080",
        "http://localhost:5173",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router)
app.include_router(companies_router)
app.include_router(departments_router)
app.include_router(profiles_router)
app.include_router(collaborators_router)
app.include_router(invitations_router)
app.include_router(notifications_router)
app.include_router(culture_router)
app.include_router(goals_router)
app.include_router(evaluations_router)
app.include_router(career_router)
app.include_router(pdi_router)
app.include_router(learning_router)
app.include_router(workshops_router)
app.include_router(communications_router)
app.include_router(onboarding_router)
app.include_router(surveys_router)
app.include_router(absences_router)
app.include_router(benefits_router)
app.include_router(salary_router)
app.include_router(reports_router)
app.include_router(calendar_router)
app.include_router(logs_router)
app.include_router(custom_tests_router)
app.include_router(feedbacks_router)
app.include_router(documents_router)
app.include_router(timeclock_router)
app.include_router(bingo_router)


@app.get("/health")
async def health():
    return {"status": "ok", "version": "1.0.0"}
