import msal
import httpx
from app.config import settings


class MicrosoftAuthService:
    SCOPES = ["User.Read"]
    GRAPH_ME_URL = "https://graph.microsoft.com/v1.0/me"

    def _get_msal_app(self) -> msal.ConfidentialClientApplication:
        return msal.ConfidentialClientApplication(
            client_id=settings.MS_CLIENT_ID,
            client_credential=settings.MS_CLIENT_SECRET,
            authority=f"https://login.microsoftonline.com/{settings.MS_TENANT_ID}",
        )

    def get_authorization_url(self) -> str:
        return self._get_msal_app().get_authorization_request_url(
            scopes=self.SCOPES,
            redirect_uri=settings.MS_REDIRECT_URI,
            prompt="select_account",
        )

    def exchange_code_for_token(self, code: str) -> dict:
        result = self._get_msal_app().acquire_token_by_authorization_code(
            code=code,
            scopes=self.SCOPES,
            redirect_uri=settings.MS_REDIRECT_URI,
        )
        if "error" in result:
            raise ValueError(result.get("error_description", result.get("error")))
        return result

    def get_user_profile(self, access_token: str) -> dict:
        with httpx.Client(timeout=10) as client:
            resp = client.get(self.GRAPH_ME_URL, headers={"Authorization": f"Bearer {access_token}"})
        if resp.status_code != 200:
            raise ValueError(f"Microsoft Graph erro {resp.status_code}: {resp.text}")
        data = resp.json()
        email = (data.get("mail") or data.get("userPrincipalName") or "").lower().strip()
        return {"name": data.get("displayName"), "email": email}


microsoft_auth_service = MicrosoftAuthService()
