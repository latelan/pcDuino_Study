# 如何给pcDuino8 Uno安装内核头文件

手上pcDuino8 Uno使用的ubuntu14.04系统,内核为3.4.39,源里面没有可用的linux-headers。前几天看见YaoQ公开了内核，索性就自己编译安装。

## 硬件
- pcDuino8 Uno
- Ubuntu14.04(X86)

## 内核源码
- https://github.com/pcduino/pcduino8-uno-kernel

## 步骤
### 1.下载源码到pcDuino上，在/usr/src目录下创建linux-headers-3.4.39目录,将生成头文件
```
sudo mkdir /usr/src/linux-headers-3.4.39
sudo cp ./linux-3.4 /usr/src/linux-headers-3.4.39 -r
sudo make O=/home/svn/linux-headers-3.4.39 sun8iw6p1smp_defconfig
sudo make O=/home/svn/linux-headers-3.4.39 modules_prepare
```

### 2.建立build软链
```
cd /lib/modules/3.4.39
sudo ln -s /usr/src/linux-headers-3.4.39 build
```

现在linux-headers基本建立好了，但还需要一个文件Module.symvers, 这个文件需要编译或者重编内核得到

### 3.编译内核获取Module.symvers文件
这步操作在PC上按照readme提示进行。

### 3.1 安装相关工具
```
sudo apt-get install libc6:i386 libstdc++6:i386 libncurses5:i386 zlib1g:i386
sudo apt-get install gcc-arm-linux-gnueabihf
sudo apt-get install libncurses5-dev libncursesw5-dev device-tree-compiler u-boot-tools
```

### 3.2 安装gawk，默认安装的是3.1.7版本，需要3.1.6
```
wget http://ftp.gnu.org/gnu/gawk/gawk-3.1.6.tar.bz2
tar -xvf gawk-3.1.6.tar.bz2
cd gawk-3.1.6
./configure
make
sudo make install
```
### 3.3 编译内核
```
./build.sh config
	Welcome to mkscript setup progress
All available chips:
	0. sun6i
	1. sun8iw6p1
	2. sun9iw1p1
Choice: 1
All available platforms:
	0. android
	1. dragonboard
	2. linux
Choice: 2
not set business, to use default!
LICHEE_BUSINESS=
using kernel 'linux-3.4':
All available boards:
	0. eagle-p1
	1. eagle-p1-secure
	2. eagle-tvd-perf3
	3. pcduino8
	4. pcduino8-linux
Choice: 4
```
在./linux-3.4目录下的Module.symvers文件就是我们想要的，将其拷到pcDuino的/usr/src/linux-headers-3.4.39下。

### 4 测试
编写hello.c
```
#include <linux/init.h>
#include <linux/module.h>

static int pcduino_hello_init(void)
{
	printk("Hello, pcDuino\n");
	return 0;
}

static void pcduino_hello_exit(void)
{
	printk("Bye, pcDuino\n");
}

MODULE_LICENSE("GPL");
MODULE_AUTHOR("latelan");
module_init(pcduino_hello_init);
module_exit(pcduino_hello_exit);
```

编写Makefile
```
KDIR := /lib/modules/3.4.39/build  # Point to Linux Kernel Headers
PWD := $(shell pwd)

obj-m := hello.o

default:
	make -C $(KDIR) M=$(PWD) modules

clean:
	rm -rf *.o .*cmd *.ko *.mod.c .tmp_versions *.symvers *order
```
编译测试
```
make
sudo insmod hello.ko
dmesg | tail -n 1
[ 1957.116615] hello,world.
sudo rmmod hell.ko
dmesg | tail -n 1
[ 1976.438055] goodbye world
```
安装完成
