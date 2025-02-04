from sqlalchemy.orm import Session
import logging
import uuid
import bcrypt
from fastapi import Depends, HTTPException, Header
from database import get_db
from middleware import auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
import jwt
from pydantic_schemas.user_login import UserLogin
from sqlalchemy.orm import joinedload
router = APIRouter()

@router.post('/signup', status_code=201)
def signup_user(user: UserCreate, db: Session = Depends(get_db)):
    # Check if the user with the same email already exists
    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(status_code=400, detail="User with same email already exists!")

    try:
        # Hash the password
        hash_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())

        # Create new user entry
        user_db = User(id=str(uuid.uuid4()), email=user.email, password=hash_pw, name=user.name)

        # Add the user to the database
        db.add(user_db)
        db.commit()
        db.refresh(user_db)  # Refresh to get the generated ID

        return {"message": "User has been created successfully!", "user_id": user_db.name}
    
    except Exception as e:
        db.rollback()  # Rollback the transaction in case of error
        logging.error(f"Error creating user: {str(e)}")  # Logs the actual error
        raise HTTPException(status_code=500, detail="Internal Server Error")
    
@router.post('/login')
def login_user(user: UserLogin, db:Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db:
        raise HTTPException(status_code=400, detail="User with this email does not exist")
    
    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)

    if not is_match:
        raise HTTPException(status_code=400, detail="Incorrect password")
    
    
    token = jwt.encode(
            {'id': str(user_db.id)}, 
            'password_key', 
            algorithm='HS256'
        )
    return {'token': token, 'user': user_db}

@router.get('/')
def current_user_data(db: Session=Depends(get_db), user_dict = Depends(auth_middleware.verify_auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).options(
        joinedload(User.favorites)
    ).first()

    if not user:
        raise HTTPException(404, "User not found")
    
    return user
    
    
    
    
    