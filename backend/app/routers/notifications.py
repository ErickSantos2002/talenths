from fastapi import APIRouter, Depends, HTTPException, status
import asyncpg

from app.dependencies import get_db, get_current_user_id

router = APIRouter(prefix="/notifications", tags=["notifications"])


@router.get("")
async def list_notifications(
    user_id: str = Depends(get_current_user_id),
    conn: asyncpg.Connection = Depends(get_db),
):
    rows = await conn.fetch(
        "SELECT * FROM public.notifications WHERE user_id = $1 ORDER BY created_at DESC",
        user_id,
    )
    return [dict(r) for r in rows]


@router.patch("/{notification_id}/read")
async def mark_as_read(notification_id: str, conn: asyncpg.Connection = Depends(get_db)):
    row = await conn.fetchrow(
        "UPDATE public.notifications SET read = true WHERE id = $1 RETURNING *",
        notification_id,
    )
    if not row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Notificação não encontrada")
    return dict(row)


@router.delete("/{notification_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_notification(notification_id: str, conn: asyncpg.Connection = Depends(get_db)):
    result = await conn.execute(
        "DELETE FROM public.notifications WHERE id = $1", notification_id
    )
    if result == "DELETE 0":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Notificação não encontrada")
