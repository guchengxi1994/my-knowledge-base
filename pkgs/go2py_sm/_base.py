'''
Descripttion: 
version: 
Author: xiaoshuyui
email: guchengxi1994@qq.com
Date: 2022-04-23 08:18:58
LastEditors: xiaoshuyui
LastEditTime: 2022-04-23 09:08:59
'''

import abc


class Base:
    @abc.abstractmethod
    def encode(self,s: str) -> str:
        ...

    @abc.abstractmethod
    def decode(self,s: bytes) -> str:
        ...
