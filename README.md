# Rhythmix - Music Streaming App

Rhythmix is a seamless music streaming platform that allows users to upload and enjoy their favorite music tracks. With a user-friendly interface, JWT-based authentication, and advanced features like background playback and song management, Rhythmix brings your music experience to life. This app is powered by **Flutter** for the frontend, **FastAPI** for the backend, and utilizes a variety of technologies including **Cloudinary** for media storage, **PostgreSQL** for user and song management, **Hive** for local storage, and **Riverpod** for state management.

## Features

- **User Authentication**: Secure registration and login using JWT tokens to ensure safe and authorized access.
- **Music Upload**: Users can upload their own music, providing details such as song name, artist, and album art.
- **Favorites**: Users can add songs to their favorites and easily access them later.
- **Background Playback**: Music can be played in the background using the `just_audio_background` package for an uninterrupted listening experience.
- **Cloud Storage**: Songs and thumbnails are uploaded to **Cloudinary** and their URLs are saved in the database.
- **MVVM Architecture**: Follows the **Model-View-ViewModel** design pattern for better maintainability and separation of concerns.
- **State Management**: Efficient state management using **Riverpod** for a reactive UI.
- **Local Storage**: **Hive** is used for fast and secure local storage of user preferences and data.

## Tech Stack

- **Frontend**: Flutter
- **Backend**: FastAPI
- **Authentication**: JWT (JSON Web Tokens)
- **Database**: PostgreSQL
- **Storage**: Cloudinary (for music and thumbnails)
- **State Management**: Riverpod
- **Local Storage**: Hive
- **Music Playback**: just_audio_background

## Prerequisites

Before starting, make sure you have the following installed:

- **Flutter**: For building and running the frontend.
- **FastAPI**: For running the backend.
- **PostgreSQL**: For managing database storage.
- **Cloudinary account**: For storing and retrieving music files and thumbnails.




