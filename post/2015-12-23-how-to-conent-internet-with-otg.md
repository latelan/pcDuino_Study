# 如何让pcDuino8 Uno通过USB数据线连接Internet

pcDuino8 Uno没有自带wifi模块，在公司有线网络需要认证，不是很方便，看到网上说可以使用USB数据线远程桌面登录pcDuino8 Uno，还可以联网，于是做了个实验。

## 硬件
- pcDuino8 Uno (预装Ubuntu 14.04)
- USB micro USB数据线
- 一台PC (Win7)

## 软件
- xshell 

## 步骤

### 1. 按照YaoQ的文章[如何使用USB数据线远程桌面登录pcDuino8 Uno][1]配置好网络
尝试vnc连接，如果ok，进行下一步

### 2. 分享Internet给新网卡
双击打开连接Internet的网卡的状态，选择**属性**，选择**共享**。如图设置，家庭网络连接选择刚刚建的新网卡，确定操作。

![](/images/otg-1.png)
会提示如图内容，选择确定。

![](/images/otg-2.png)

### 3. 设置网卡静态IP地址
之前设置过该IP地址，由于上步操作更新了该IP，需要重设一下。双击最新出现的网卡设备，选择**属性**。设置TCP/IPv4静态IP地址：
![](/images/otg-3.png)

注：pcDuino8 Uno中将IP地址设置成了192.168.100.1，需要将PC设置为同一个网段才可以访问。

### 4. ssh到pcDuino8 Uno配置路由
- 使用xshell连接pcDuino8 Uno，IP地址：**192.168.100.1**。
- 查看当前网络配置，输入ifconfig, 可以看到有个usb0的网卡

![](/images/otg-4.png)
这个时候访问Internet是不行的，需要添加路由规则:
```bash
$ sudo route add default gw 192.168.100.2 dev usb0
```
这个命令是添加默认路由，网关为192.168.100.2，网卡设备使用usb0，重启后要记得添加。因为只是在公司用下，手动添加。

- ping下百度,测试网络
![](/images/otg-5.png)

现在就能访问Internet，是要一根USB数据线就可以连接pcDuino，连接Internet。

## 参考
- [http://cnlearn.linksprite.com/?p=1537#.Vnpqi7crKUk][2]

[1]:https://github.com/YaoQ/pcDuino_Doc/blob/master/zh/post/2015-11-23-how-to-board-config.md
[2]:http://cnlearn.linksprite.com/?p=1537#.Vnpqi7crKUk
