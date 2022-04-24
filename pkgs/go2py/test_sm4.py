'''
Descripttion: 
version: 
Author: xiaoshuyui
email: guchengxi1994@qq.com
Date: 2022-04-23 09:00:17
LastEditors: xiaoshuyui
LastEditTime: 2022-04-23 09:20:05
'''

from sm import SM4

sm = SM4("qwertyasdfgh1234")

en = sm.encode("I love China")

print(en)

de = sm.decode(en)

print(str(de, encoding="utf-8"))
