from models.base import Base
from fastapi import FastAPI
from routes import song,auth
from routes.auth import router
from database import engine


app = FastAPI()    # instance of class is created

app.include_router(auth.router,prefix='/auth')
app.include_router(song.router,prefix='/song')
     

Base.metadata.create_all(engine)