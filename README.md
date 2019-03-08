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
```

### 动态数组(vector)
实现高效的遍历和修改，但是新增和删除都不是线性时间复杂度。基本上就是lua table的数组，但是lua的table我们会一不小心就搞成不连续的。比如:
```lua
  local t = {2,4}
  t[4] = 9
  
  print(#t) -- 2
```
#### 方法：
  * add --尾添加(高效的操作)
  * insert --插入(会有内存整理)
  * addRange --尾添加一个表,
  * removeAt
  * remove
  * removeAll
  * contains
  * indexOf
  * sort
  
#### eg.
```lua
  local vector = require("vector")
  local v = vector.create()

  v.add(4)
  v.add(5)
  v.add(6)
  v.add(7)
  
  for i,v in ipairs(v) do
	  print(i,v)
  end
  ---1	4
  ---2	5
  ---3	6
  ---4	7

  print(v)
  ---4,5,6,7
  
  v[4] = 9  --修改值

  print(v)
  ---4,5,6,9

  v[7] = 9
  ---lua: .\vector.lua:101: outrange of vector
  ---stack traceback:
  ---    [C]: in function 'assert'
```

### 双向链表(list)
弥补动态数组增删的不足，提供增删效率，但是遍历和修改效率比较低

#### 方法：
  * addFirst --头添加
  * addLast --尾添加
  * addBefore --node前添加
  * addAfter  --node后添加
  * removeNode --删除node
  * remove --根据值移除
  * find --查找node
#### eg.
```lua
  local vector = require("list")
  local v = list.create()

  v.addFirst(1)
  v.addLast(2)
  print(v)
  ---1,2

  local node = v.find(1)
  node.value = 9
  print(v)
  ---9,2
  
  v.removeNode(node)
  print(v)
  ---2
  
  v.addLast(10)
  v.addLast(20)
  v.addLast(30)
  print(v)
  ---2,10,20,30
  
  for _,i,v in ipairs(v) do --第一个参数是node, i: index, v: value
    print(i,v)
  end
  ---1	2
  ---2	10
  ---3	20
  ---4	30
```
### 栈(stack)
FILO先进后出, 对修改关闭，关闭遍历，只能通过方法修改数据
#### 方法：
  * push  --添加
  * pop   --移除
  * peek  --返回栈顶数据
  * clear --清空
#### eg.
```lua
  local stack = require("stack")
  local v = stack.create()

  v.push(1)
  v.push(2)
  v.push(5)
  
  print(v)
  ---5,2,1
  print(v.len)
  ---3
  v.pop()
  print(v)
  ---2,1
  v.clear()
  print(v.len)
  ---0
```
### 队列(queue)
FIFO,先进先出，因为是队首删除所以不能使用table.remove
#### 方法：
  * enqueue  --添加
  * dequeue   --移除
  * peek  --返回栈顶数据
  * clear --清空
#### eg.
```lua
	local queue = require("queue")
	-- lua table
	local cnt = 10000 * 1

	local t = {}
	for i=1,cnt do
	t[i] = i
	end

	local time = os.clock()
	while #t > 0 do
	-- table.remove(t)
		table.remove(t, 1)
	end
	print(os.clock() - time)
	---1.037s

	local v = queue.create()

	for i=1,cnt do
		v.enqueue(i)
	end


	local time1 = os.clock()
	while v.len > 10 do
		v.dequeue()
	end
	print(os.clock() - time1)
	---0.005s
```
1w条数据，lua table直接删除表头的耗时1.037s，queue耗时0.005s,而且queue整理内存的步长可以调整，耗时可以进步一提高.
