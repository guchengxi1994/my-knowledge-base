[参考链接](http://www.ruanyifeng.com/blog/2015/04/tail-call.html)


## python 斐波那契数列 非尾递归
```python
def fib(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    return fib(n - 2) + fib(n - 1)

fib(35)
```

## python 斐波那契数列 尾递归
```python
def fib(n, a, b):
    if n == 0:
        return a
    elif n == 1:
        return b
    return fib(n-1, b, a+b)

fib(35, 0, 1)
```
