from fastapi import HTTPException, Header
import jwt


def verify_auth_middleware(x_auth_token= Header()):
    try:
        if not x_auth_token:
           raise HTTPException(status_code=401, detail="No auth token, access denied!")
    
        verified_token = jwt.decode(x_auth_token, 'password_key', algorithms='HS256')

        if not verified_token:
           raise HTTPException(status_code=401, detail="Invalid token, access denied!")
    
        uid = verified_token.get('id')
        return {'uid' : uid, 'token': x_auth_token}
    
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid token, access denied!")