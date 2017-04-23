# 如何在Win10上使用USB数据线连接pcDuino8 Uno

在Win7上用USB数据线让pcDuino8连接Internet[在这里][1], 在Win10上却选择不了相应驱动，需要做一定工作才可以配置到我们想要的驱动。

## 硬件
- pcDuino8 Uno (预装Ubuntu 14.04)
- USB micro USB数据线
- 一台PC (Win10)

## 步骤

### 1. 连接PC与pcDuino8 Uno
找到USB OTG接口，用USB数据线一端接OTG，另一端接PC机。

### 2. 修改驱动
这时我们会发现在设备管理器里pcDuino8 Uno没有被识别成一个Android设备，而是识别成了串口。我们要把默认驱动移除，然后换成我们想要的。
进入```C:\Windows\System32\drivers```目录，将usbser.sys文件重命名为usbser.sys.bak，可能会遇到文件访问被拒绝的提示，需要TrustedInstaller提供的权限才能更改之类的。请参考[这里][2]。然后进去```C:\Windows\System32\DriverStore\FileRepository```目录，将usbser.inf...的文件剪切到桌面。

### 3. 安装新驱动
在设备管理器中卸载原来的驱动，然后重新为其安装我们想要的驱动，选择从列表安装，设备类型选择网络适配器，厂商选择Mirosoft，型号选择Remote NDIS based Internet Sharing Device。
再次连接pcDuino8成功，最后别忘了还原之前对默认驱动的修改。


[1]:https://github.com/latelan/pcDuino_Study/blob/master/post/2015-12-23-how-to-conent-internet-with-otg.md
[2]:http://jingyan.baidu.com/article/5bbb5a1b5d293413eba179ea.html
