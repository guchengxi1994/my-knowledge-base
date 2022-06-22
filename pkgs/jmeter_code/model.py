from peewee import *

database = MySQLDatabase('jmeter', **{'charset': 'utf8', 'sql_mode': 'PIPES_AS_CONCAT', 'use_unicode': True, 'host': 'localhost', 'port': 3306, 'user': 'root', 'password': '123456'})

class UnknownField(object):
    def __init__(self, *_, **__): pass

class BaseModel(Model):
    class Meta:
        database = database

class Hobby(BaseModel):
    hobby_id = AutoField()
    hobby_name = CharField(null=True)
    user_id = IntegerField(null=True)

    class Meta:
        table_name = 'hobby'

class Person(BaseModel):
    age = IntegerField(null=True)
    user_id = AutoField()
    user_name = CharField(null=True)

    class Meta:
        table_name = 'person'

