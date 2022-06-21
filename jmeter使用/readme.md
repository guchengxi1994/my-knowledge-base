## Jmeter接口测试

文档版本 0.0.1

### 1.写一个服务器demo

> 技术栈： fastapi,peewee,mysql

* 创建一个简单的数据库

  ```sql
  /*
   Navicat Premium Data Transfer
  
   Source Server         : local
   Source Server Type    : MySQL
   Source Server Version : 80023
   Source Host           : localhost:3306
   Source Schema         : jmeter
  
   Target Server Type    : MySQL
   Target Server Version : 80023
   File Encoding         : 65001
  
   Date: 21/06/2022 15:56:00
  */
  
  SET NAMES utf8mb4;
  SET FOREIGN_KEY_CHECKS = 0;
  
  -- ----------------------------
  -- Table structure for hobby
  -- ----------------------------
  DROP TABLE IF EXISTS `hobby`;
  CREATE TABLE `hobby`  (
    `hobby_id` int NOT NULL AUTO_INCREMENT,
    `hobby_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `user_id` int NULL DEFAULT NULL,
    PRIMARY KEY (`hobby_id`) USING BTREE
  ) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;
  
  -- ----------------------------
  -- Table structure for person
  -- ----------------------------
  DROP TABLE IF EXISTS `person`;
  CREATE TABLE `person`  (
    `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `age` int NULL DEFAULT NULL,
    `user_id` int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`user_id`) USING BTREE
  ) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;
  
  SET FOREIGN_KEY_CHECKS = 1;
  
  ```

  

  一共两个实体，person和hobby，一对多关系，然后用 peewee 工具同步一下数据库

  ```
  python -m pwiz -e mysql -u root -H localhost -p 3306  --password  Jmeter > model.py
  ```

  得到model.py文件，里面会用python定义好实体类。

  ```python
  from peewee import *
  
  database = MySQLDatabase('Jmeter', **{'charset': 'utf8', 'sql_mode': 'PIPES_AS_CONCAT', 'use_unicode': True, 'host': 'localhost', 'port': 3306, 'user': 'root', 'password': '******'})
  
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
  ```

* 编写后台代码

  ```python
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
  ```

  然后uvicorn部署一下

  ```
  uvicorn.exe  app:app --reload --port 65423 --host 0.0.0.0
  ```

### 2. Jmeter测试

#### 2.1 Jmeter简介

```
	Apache JMeter 是 Apache 组织基于 Java 开发的压力测试工具，用于对软件做压力测试。
	JMeter 最初被设计用于 Web 应用测试，但后来扩展到了其他测试领域，可用于测试静态和动态资源，如静态文件、Java 小服务程序、CGI 脚本、Java 对象、数据库和 FTP 服务器等等。JMeter 可对服务器、网络或对象模拟巨大的负载，在不同压力类别下测试它们的强度和分析整体性能。另外，JMeter 能够对应用程序做功能/回归测试，通过创建带有断言的脚本来验证程序是否返回了期望结果。为了最大限度的灵活性，JMeter 允许使用正则表达式创建断言。
JMeter的作用
	1.能够对HTTP和FTP服务器进行压力和性能测试， 也可以对任何数据库进行同样的测试（通过JDBC）。
	2.完全的可移植性和100% 纯java。
	3.完全 Swing 和轻量组件支持（预编译的JAR使用 javax.swing.*)包。
	4.完全多线程 框架允许通过多个线程并发取样和 通过单独的线程组对不同的功能同时取样。
	5.精心的GUI设计允许快速操作和更精确的计时。
	6.缓存和离线分析/回放测试结果。
JMeter的高可扩展性
	1.可链接的取样器允许无限制的测试能力。
	2.各种负载统计表和可链接的计时器可供选择。
	3.数据分析和可视化插件提供了很好的可扩展性以及个性化。
	4.具有提供动态输入到测试的功能（包括Javascript）。
	5.支持脚本编程的取样器（在1.9.2及以上版本支持BeanShell）。
	在设计阶段，JMeter能够充当HTTP PROXY（代理）来记录IE/NETSCAPE的HTTP请求，也可以记录apache等WebServer的log文件来重现HTTP流量。当这些HTTP客户端请求被记录以后，测试运行时可以方便的设置重复次数和并发度（线程数）来产生巨大的流量。JMeter还提供可视化组件以及报表工具把量服务器在不同压力下的性能展现出来。
相比其他HTTP测试工具,JMeter最主要的特点在于扩展性强。JMeter能够自动扫描其lib/ext子目录下.jar文件中的插件，并且将其装载到内存，让用户通过不同的菜单调用。 (摘自百度2022.6.21)
```

#### 2.2 Jmeter安装

* 下载

  地址：http://jmeter.apache.org/

* 配置环境变量

   jmeter是在jdk环境下运行，首先安装jdk(版本1.8以上，安装的时候把jdk和jre都装上)，配置Java环境变量

#### 2.3 运行

​		Jmeter支持全桌面平台，下载Jmeter完成之后，解压，运行对应的文件。windows是`*/bin/jmeter.bat`,其它平台是`*/bin/jmeter.sh`，windows 下直接双击就可以打开界面，其它平台可能需要指令启动。

![image-20220621171209746](./images/image-20220621171209746.png)

<center>Jmeter主界面</center>
