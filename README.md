# Lua-ADT
封装的lua数据结构, 元组(tuple)、动态数组(vector)、双向链表(list)、队列(queue)、栈(stack)

### 元组(tuple)
需要用table的动态数组初始化(不支持hashtable),只对外公开遍历，修改关闭。

遍历：
```lua
  local tuple = require("tuple")
  local v = tuple.create({2,3,6})

  for i,v in ipairs(v) do --只支持ipairs遍历,抛弃了pairs(因为原则上我们是数组，不存在key)
    print(i,v)
  end
  ---1	2
  ---2	3
  ---3	6
  
  print(v)  --重写了__tostring,方便快速浏览数据
  ---2,3,6
  
  v[2] = 9  --因为对修改关闭了所以这地方修改会抛出错误
  ---lua: .\tuple.lua:33: >> Dee: Limited access
  ---stack traceback:
  ---[C]: in function 'error'
