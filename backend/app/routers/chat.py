from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional
import asyncpg

from app.dependencies import get_db, get_current_user_id
from app.config import settings

router = APIRouter(prefix="/chat", tags=["chat"])


class ConversationCreate(BaseModel):
    title: Optional[str] = None


class MessageCreate(BaseModel):
    content: str


@router.get("/conversations")
async def list_conversations(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    rows = await conn.fetch(
        "SELECT * FROM public.hr_conversations WHERE user_id = $1 ORDER BY created_at DESC",
        user_id,
    )
    return [dict(r) for r in rows]


@router.post("/conversations", status_code=status.HTTP_201_CREATED)
async def create_conversation(
    body: ConversationCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    row = await conn.fetchrow(
        "INSERT INTO public.hr_conversations (user_id, title) VALUES ($1, $2) RETURNING *",
        user_id, body.title,
    )
    return dict(row)


@router.delete("/conversations/{conversation_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_conversation(
    conversation_id: str,
    conn: asyncpg.Connection = Depends(get_db),
):
    result = await conn.execute(
        "DELETE FROM public.hr_conversations WHERE id = $1", conversation_id
    )
    if result == "DELETE 0":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Conversa não encontrada")


@router.get("/conversations/{conversation_id}/messages")
async def list_messages(
    conversation_id: str,
    conn: asyncpg.Connection = Depends(get_db),
):
    rows = await conn.fetch(
        "SELECT * FROM public.hr_messages WHERE conversation_id = $1 ORDER BY created_at",
        conversation_id,
    )
    return [dict(r) for r in rows]


@router.post("/conversations/{conversation_id}/messages", status_code=status.HTTP_201_CREATED)
async def send_message(
    conversation_id: str,
    body: MessageCreate,
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    # Salva mensagem do usuário
    await conn.execute(
        "INSERT INTO public.hr_messages (conversation_id, role, content) VALUES ($1, 'user', $2)",
        conversation_id, body.content,
    )

    # Busca contexto do perfil e resultado do usuário
    profile = await conn.fetchrow(
        "SELECT name FROM public.profiles WHERE user_id = $1", user_id
    )
    result = await conn.fetchrow(
        "SELECT disc_natural, disc_adapted, big_five, ai_analysis FROM public.test_results WHERE user_id = $1 ORDER BY completed_at DESC LIMIT 1",
        user_id,
    )

    history = await conn.fetch(
        "SELECT role, content FROM public.hr_messages WHERE conversation_id = $1 ORDER BY created_at",
        conversation_id,
    )

    ai_reply = await _call_ai(profile, result, history, body.content)

    row = await conn.fetchrow(
        "INSERT INTO public.hr_messages (conversation_id, role, content) VALUES ($1, 'assistant', $2) RETURNING *",
        conversation_id, ai_reply,
    )
    return dict(row)


async def _call_ai(profile, result, history, user_message: str) -> str:
    if not settings.ANTHROPIC_API_KEY:
        return "API de IA não configurada. Defina ANTHROPIC_API_KEY no .env."

    try:
        import anthropic

        context = ""
        if profile:
            context += f"Nome do colaborador: {profile['name']}\n"
        if result:
            context += f"Perfil DISC natural: {result['disc_natural']}\n"
            context += f"Perfil DISC adaptado: {result['disc_adapted']}\n"
            context += f"Big Five / OCEAN: {result['big_five']}\n"

        system_prompt = f"""Você é um assistente especialista em RH e desenvolvimento humano da TalentHS.
Ajude o colaborador a entender seu perfil comportamental e seu desenvolvimento na empresa.
Seja direto, empático e use linguagem acessível em português.

{f'Contexto do colaborador:{chr(10)}{context}' if context else ''}"""

        messages = [
            {"role": r["role"], "content": r["content"]}
            for r in history
            if r["role"] in ("user", "assistant")
        ]

        client = anthropic.Anthropic(api_key=settings.ANTHROPIC_API_KEY)
        response = client.messages.create(
            model="claude-sonnet-4-6",
            max_tokens=1024,
            system=system_prompt,
            messages=messages,
        )
        return response.content[0].text

    except Exception as e:
        return f"Erro ao chamar IA: {str(e)}"
