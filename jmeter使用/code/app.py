from typing import List
from fastapi import FastAPI
from pydantic import BaseModel
from model import Hobby, Person

app = FastAPI()


class NewUserReq(BaseModel):
    name: str
    age: int = 10
    hobbies: List[str]


class NewUserResponse(BaseModel):
    user_id: int


class ChangeAgeReq(BaseModel):
    user_id: int
    age: int


class UserInfo(BaseModel):
    user_id: int
    user_name: str
    age: int
    hobbies: List[str]


@app.get("/")
async def test():
    return {"message": "hello IO"}


@app.post("/newuser")
async def new_user(u: NewUserReq):
    person = Person()
    person.age = u.age
    person.user_name = u.name
    result = person.save()
    if result == 1:
        print(person.user_id)
        for i in u.hobbies:
            h = Hobby()
            h.user_id = person.user_id
            h.hobby_name = i
            h.save()
        us = NewUserResponse(user_id=person.user_id)
        return {"message": "hello IO", "data": us}
    else:
        return {"message": "error"}


@app.post("/changeage")
async def change_age(c: ChangeAgeReq):
    try:
        p: Person = Person.get(user_id=c.user_id)
        print(p.user_name)
        p.age = c.age
        p.save()
        return {"message": "IO"}
    except:
        return {"message": "error"}


@app.get("/user/{pid}")
async def get_user_by_id(pid):
    try:
        p: Person = Person.get(user_id=pid)
        hres = Hobby.select(Hobby.hobby_name).where(Hobby.user_id == pid)
        hbs = []
        for i in hres:
            hbs.append(i.hobby_name)
        u = UserInfo(user_id=p.user_id,user_name=p.user_name,age=p.age,hobbies=hbs)
        return {"message": "IO","data":u}
    except Exception as e:
        print(e)
        return {"message": "error"}
