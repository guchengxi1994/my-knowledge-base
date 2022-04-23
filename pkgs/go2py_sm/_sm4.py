'''
Descripttion: 
version: 
Author: xiaoshuyui
email: guchengxi1994@qq.com
Date: 2022-04-23 08:17:29
LastEditors: xiaoshuyui
LastEditTime: 2022-04-23 09:14:48
'''
import ctypes
import os
from ctypes import c_char_p, cdll

from _base import Base


class SM4(Base):
    def encode(self, s):
        self.lib.CBCEncode.restype = ctypes.c_uint64
        _key = c_char_p(bytes(self.key, "utf-8"))
        _s = c_char_p(bytes(s, "utf-8"))
        res = self.lib.CBCEncode(_key, _s)
        return ctypes.string_at(res)

    def decode(self, s):
        self.lib.CBCDecode.restype = ctypes.c_uint64
        _key = c_char_p(bytes(self.key, "utf-8"))
        _s = c_char_p(s)
        res = self.lib.CBCDecode(_key, _s)
        return ctypes.string_at(res)

    def __init__(self,
                 key: str,
                 sm4Type: str = "cbc",
                 libPath: str = "go_codes/sm4.dll") -> None:
        assert len(key) == 16, "key error"
        if not os.path.exists(libPath):
            raise Exception("lib file not found")

        self.lib = cdll.LoadLibrary(libPath)
        self.key = key
        self.sm4Type = sm4Type