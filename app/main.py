from fastapi import FastAPI, Form, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from db import save_user, init_db

app = FastAPI()
templates = Jinja2Templates(directory="templates")

@app.on_event("startup")
def on_startup():
    init_db()

@app.get("/login", response_class=HTMLResponse)
def login_page(request: Request):
    return templates.TemplateResponse("login.html",
        {"request": request, "message": ""})

@app.post("/login", response_class=HTMLResponse)
def login(request: Request,
          username: str = Form(...),
          password: str = Form(...)):
    save_user(username, password)
    return templates.TemplateResponse("login.html",
        {"request": request, "message": "User saved successfully"})
