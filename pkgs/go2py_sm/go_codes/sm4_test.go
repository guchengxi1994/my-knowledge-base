/*
 * @Descripttion:
 * @version:
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-23 09:21:18
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-23 09:36:59
 */

package main

import (
	"encoding/hex"
	"fmt"
	"testing"

	"github.com/tjfoc/gmsm/sm4"
)

// [223 145 231 199 107 190 179 96 121 203 250 90 56 117 245 81]
func TestSM4(t *testing.T) {
	s := "df91e7c76bbeb36079cbfa5a3875f551"
	key := "qwertyasdfgh1234"
	tmpPlainText, _ := hex.DecodeString(string(s))
	fmt.Printf("tmpPlainText: %v\n", tmpPlainText)
	val, err := sm4.Sm4Cbc([]byte(key), tmpPlainText, false)
	if err != nil {
		fmt.Printf("\"error\": %v\n", "error")
	}
	fmt.Printf("val: %v\n", string(val))

}
