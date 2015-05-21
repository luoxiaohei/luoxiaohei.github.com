title: "反编译64位AutoIt程序"
date: 2015-05-20 20:22:08
categories: 调试逆向
tags: [Autoit, Decompile]
description:
---
[AutoIt](https://www.autoitscript.com/site/autoit/)（读音aw-tow-it）是一个用于Microsoft Windows的免费自动化语言。AutoIt脚本编译后的程序是通过解释器解释执行的，所以很难直接调试和逆向分析。但与其他解释执行的语言相同，AutoIt编译后的程序可以通过反编译工具得到程序源代码。[exe2aut](https://exe2aut.coom/)就是一款专门用来反编译AutoIt程序的工具，但是目前exe2aut工具只支持32位AutoIt程序的反编译，并不支持64位AutoIt程序的反编译，故本文将介绍如何反编译64位的AutoIt程序。

<!-- more -->

##反编译64位AutoIt程序的基本思路

反编译64位AutoIt程序的基本思路是将64位程序转换为32位程序，然后执行32位程序的反编译流程。因为AutoIt程序是解释执行的，所以我们可以通过替换解释器的方式来将64位程序转换为32位程序。

##反编译64位AutoIt程序的完整流程

###获取AutoIt解释器
AutoIt的解释器程序为Aut2Exe目录中的AutoItSC.bin文件（新版中解释器已嵌入到Aut2Exe.exe）
可通过以下链接进行下载v3.3.8.1版本的安装文件并解压获取
[https://www.autoitscript.com/autoit3/files/archive/autoit/autoit-v3.3.8.1.zip](https://www.autoitscript.com/autoit3/files/archive/autoit/autoit-v3.3.8.1.zip)
或直接通过以下连接下载
[http://smvirus.com/blog/2015/05/20/decompiling-compiled-autoit-scripts-64bit/AutoItSC.zip](http://smvirus.com/blog/2015/05/20/decompiling-compiled-autoit-scripts-64bit/AutoItSC.zip)

###提取编译后的脚本

####v3.3.8.1之前版本编译
编译后的AutoIt脚本被保存在程序末尾，可以通过特征码来定位到脚本数据
起始特征码： `A3484BBE986C4AA9994C530A86D6487D`
结束特征码： `A91CCBDD4155332145413036`

####v3.3.8.1之后版本编译
编译后的AutoIt脚本被保存在资源中，可通过PE资源查看器进行提取或通过上述特征码定位提取


###构造32位的AutoIt程序
将脚本数据直接追加到AutoItSC.bin文件末尾（v3.3.8.1版本的程序脚本数据存放在程序末尾）并另存为filename.x86.exe就完成了64位到32位AutoIt程序的转换。

###反编译32位AutoIt程序
使用exe2aut工具反编译转换后的32位程序，此时得到的源码就是64位AutoIt程序的源码。