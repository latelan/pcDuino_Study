# 移植minicom到pcDuino8 Uno

手上有块nodeMCU，看文章说最好在Linux环境下开发，推荐使用vmware安装ubuntu系统，然后转个minicom就可以。鉴于我的Windows系统已经有两虚拟机跑着，再开个会卡，毕竟配置不高阿。刚好手上有块pcDuino8 Uno，装的就是ubuntu14.04系统。想着就拿这个板子当开发环境吧，apt-get install minicom的时候才发现源里没有，那就只好自己编译。

## 源码
minicom-2.7.tar.gz
ncurses-5.9.tar.gz

## 两种方法
- 直接编译
- 交叉编译
这里选择交叉编译，最后发现在pcDuino8上直接编译更方便，汗~

## 交叉编译
宿主系统：ubuntu14.04.3 32位

### 1.安装交叉编译工具
这个工具最好和目标环境相适应，查看下pcDuino8 Uno上的gcc版本

![](/images/pcduino8-gcc-version.png)

可以看到gcc版本是4.8.2, Target: arm-linux-gnueabihf,在宿主机上安装交叉编译工具

```bash
$sudo apt-get install gcc-arm-linux-gnueabihf
```
测试该工具编译的可执行文件是否能在目标机上运行
```
$vim hello.c
$include <stdio.h>
int main()
{
	printf("Hello pcDuino\n");
	return 0;
}

$arm-linux-gnueabihf-gcc hello.c -L/usr/arm-linux-gnueabihf/lib
```
-L指定使用arm-linux-gnueabihf的库
将生成的文件拷贝到目标机，注意增加可执行权限，看是否正常运行。

![](/images/hello-output.png)

可以看到输出说明编译工具选择正确，接着下一步。

### 2.编译ncurses
安装minicom需要ncurses的支持，所以先编译ncurses。
解压ncurses-5.9.tar.gz，进入ncurses-5.9目录，执行configure

```bash
$./configure CC=arm-linux-gnueabihf-gcc --prefix=/home/svn/work/ncurses-5.9 --host=arm-linux-gnueabihf CPPFLAGS=-I/usr/arm-linux-gnueabihf/include LDFLAGS=-L/usr/arm-linux-gnueabihf/lib --without-cxx-binding --without-manpages --disable-db-install
```
CC指定编译器，--prefix指定编译输出的地方，--host指定目标运行环境，CPPFLAGS和LDFLAGS指定使用的头文件和库，--without-cxx-binding表示不需要c++的ncurses库，--without-manpages表示不需要man帮助手册，加上--disable-db-install简化交叉编译需要的包。(有些选项的意思详情可在[官方网站][1]看到)
接着make && make install

```bash
$make $$ make install
```
编译好所需要的ncurses库，接下来编译minicom

### 3.编译minicom
解压minicom-2.7.tar.gz，进入minicom-2.7目录，执行configure

```bash
./configure CC=arm-linux-gnueabihf-gcc --prefix=/home/svn/work/minicom-2.7 --host=arm-linux-gnueabihf CPPFLAGS=-I/home/svn/work/ncurses-5.9/include LDFLAGS=-L/home/svn/work/ncurses-5.9/lib
```
这里CPPFLAGS和LDFLAGS指定上一步编译好的ncurses库目录
接着make && make install

```bash
$make && make install
```
### 4.安装minicom
把/ncurses-5.9/share/terminfo拷到pcDuino8 Uno的/usr/share/下。
把编译好的minicom打包拷到板子上解压,接上nodeMCU测试下。

```bash
$cd ./minicom-2.7/bin/
$sudo ./minicom -D /dev/ttyUSB0
```
看到这个画面说明成功了。

![](/images/minicom-2.7.png)

### 最后
其实最后发现，在pcDuino8 Uno上可以编译这两个，这样更方便点。

[1]:http://invisible-island.net/ncurses/NEWS.html
