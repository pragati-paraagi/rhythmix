import os
import uuid
import cloudinary
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session
from database import get_db
from sqlalchemy.orm import joinedload
import cloudinary.uploader
from middleware.auth_middleware import verify_auth_middleware
from models.favorite import Favorite
from models.song import Song
from dotenv import load_dotenv
from pydantic_schemas.favorite_song import FavoriteSong
router = APIRouter()

load_dotenv()

# Access Cloudinary credentials from environment variables
cloudinary.config( 
    cloud_name=os.getenv("CLOUDINARY_CLOUD_NAME"), 
    api_key=os.getenv("CLOUDINARY_API_KEY"), 
    api_secret=os.getenv("CLOUDINARY_API_SECRET"), 
    secure=True
)
@router.post('/upload', status_code=201)
def upload(song: UploadFile = File(...), 
           thumbnail : UploadFile = File(...),
           artist: str = Form(...),
           song_name : str = Form(...), 
           hex_code:str = Form(...), 
           db:Session=Depends(get_db), auth_dict = Depends(verify_auth_middleware)):
    song_id = str(uuid.uuid4())
    song_res=cloudinary.uploader.upload(song.file, resource_type='auto', folder=f'songs/{song_id}')
    thumbnail_res=cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f'songs/{song_id}')
    
    
    new_song = Song(
        id=song_id,
        artist=artist,
        song_name=song_name,
        hex_color=hex_code,
        song_url=song_res['url'],
        thumbnail_url=thumbnail_res['url']
    )

    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return {"message": "Song uploaded successfully", "song_id": new_song.id}

@router.get('/list')
def list_song(db:Session=Depends(get_db), auth_details = Depends(verify_auth_middleware)):
     songs = db.query(Song).all()
     return songs

@router.post('/favorite')
def favorite_song(song: FavoriteSong, 
                  db: Session=Depends(get_db), 
                  auth_details=Depends(verify_auth_middleware)):
    # song is already favorited by the user
    user_id = auth_details['uid']

    fav_song = db.query(Favorite).filter(Favorite.song_id == song.song_id, Favorite.user_id == user_id).first()

    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message': False}
    else:
        new_fav = Favorite(id=str(uuid.uuid4()), song_id=song.song_id, user_id=user_id)
        db.add(new_fav)
        db.commit()
        return {'message': True}

@router.get('/list/favorites')
def list_fav_songs(db: Session=Depends(get_db), 
               auth_details=Depends(verify_auth_middleware)):
    user_id = auth_details['uid']
    fav_songs = db.query(Favorite).filter(Favorite.user_id == user_id).options(
        joinedload(Favorite.song),
        joinedload(Favorite.user)
    ).all()
    
    return fav_songs
    