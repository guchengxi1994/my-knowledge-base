/*
 * @Descripttion:
 * @version:
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-23 08:10:58
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-23 09:37:21
 */
package main

import "C" //必须引入C库

import (
	"encoding/hex"
	"fmt"

	"github.com/tjfoc/gmsm/sm4"
)

// test
func encryptSM4(plainText []byte) (string, error) {
	key := "qwertyuiasdfghjk"
	val, err := sm4.Sm4Cbc([]byte(key), plainText, true)

	return fmt.Sprintf("%x", val), err
}

// test
func decryptSM4(plainText []byte) (string, error) {
	key := "qwertyuiasdfghjk"
	tmpPlainText, _ := hex.DecodeString(string(plainText))
	val, err := sm4.Sm4Cbc([]byte(key), tmpPlainText, false)

	return string(val), err
}

func SM4CBCEncode(key, value string) (string, error) {
	val, err := sm4.Sm4Cbc([]byte(key), []byte(value), true)
	return fmt.Sprintf("%x", val), err
}

func SM4CBCDecode(key string, value string) (string, error) {
	tmpPlainText, err := hex.DecodeString(string(value))
	if err != nil {
		return "", err
	}
	val, err := sm4.Sm4Cbc([]byte(key), tmpPlainText, false)
	return string(val), err
}

//export CBCEncode
func CBCEncode(key, value *C.char) *C.char {
	val, err := SM4CBCEncode(C.GoString(key), C.GoString(value))
	if err != nil {
		return C.CString("")
	}
	return C.CString(val)
}

//export CBCDecode
func CBCDecode(key, value *C.char) *C.char {
	val, err := SM4CBCDecode(C.GoString(key), C.GoString(value))
	if err != nil {
		return C.CString("")
	}
	return C.CString(val)
}

// uncomment this line when building
func main() {

}
