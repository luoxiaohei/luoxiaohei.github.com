title: 修复Win8.1 x64环境下PcxFirefox打开文件崩溃
date: 2014-05-06 19:19:46
categories: 调试逆向
tags: Windbg
description:
---

最近在使用PcxFirefox浏览器时，发现其x64版本在Win8.1系统中一旦触发文件选择框，如下载/打开文件时，浏览器就会崩溃。

在网上搜索无果后，只好祭出神器Windbg查找原因。在这里对两位帮忙定位问题的同事bianfeng和KeyKernel由衷表示感谢。
<!-- more -->

##问题现象
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/crash.jpg)

##问题定位
###捕获异常
首先使用Windbg重新加载崩溃程序Firefox.exe，然后执行g命令执行程序并触发崩溃，Windbg捕获到如下异常
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/windbg_crash.jpg)
得知错误代码出现在`00007ffa'5bbab9fd`，在当前地址反汇编得到如下代码
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/u-rip.jpg)
###定位异常模块
查看当前出错模块路径如下
{% codeblock %}
0:000> lmf a rip
start             end                 module name
00007ffa`5b9f0000 00007ffa`5ce07000   SHELL32  C:\windows\system32\SHELL32.dll
{% endcodeblock %}
###分析异常代码
使用IDA Pro反汇编该模块后，发现该地址原始反汇编代码如下，与正在执行代码不同
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/ida-code.jpg)
向前遍历发现，模块中代码从`00007ffa'5bbab9f0`处开始被覆写了14字节
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/u-b9f0.jpg)
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/ida-b9f0.jpg)
###确认异常原因
从上图代码可知，该地址为SHGetSpecialFolderPathW函数地址，对比代码可知，该函数被inline hook。
进而可以确认崩溃原因是hook过程中将`00007ffa'5bbab9fd`处一字节覆盖为0，导致cpu解释指令出错，产生异常并引起崩溃。
在Windbg中将其修正为48h后恢复进程执行，文件选择框正常被打开。
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/fix-ok.jpg)
###定位HOOK来源
得知崩溃原因后，下一步开始定位是谁hook了SHGetSpecialFolderPathW函数
首先重新加载运行Firefox.exe，然后执行sxe ld:shell32.dll命令使调试器在加载该模块后中断程序
中断后对`00007ffa'5bbab9f0`处下写入断点，然后继续执行程序，发现程序被中断在如下地址
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/ba-b9f0.jpg)
查看该地址模块路径如下
{% codeblock %}
0:000> lmf a rip
start             end                 module name
00000000`63000000 00000000`6300a000   tmemutil D:\MyTools\Tools\UserSoft\PcxFireFox\tmemutil.dll
{% endcodeblock %}
###分析HOOK代码
使用IDA Pro反汇编该模块后，发现正是该地址上下文代码hook了SHGetSpecialFolderPathW函数
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/ida-hook.jpg)

该段代码是将hook代码写入到SHGetSpecialFolderPathW函数起始处，但因为其使用的跳转方式为
>jmp qword ptr [xxxxxxxx]

对应Opcode为
>ff 25 00 00 00 00 xx xx xx xx xx xx xx xx

共需14字节。
从前文中可知SHGetSpecialFolderPathW函数地址距离之后代码只有13字节，故使用这种跳转方式进行hook，会覆盖掉函数中的代码，进而导致异常，引起崩溃。

##解决方案
因为该问题是由于temeutil模块对SHGetSpecialFolderPathW函数进行hook时使用了错误的跳转方式导致的，故考虑修改其跳转方式。
在64位系统下，除上述跳转方式外，还可使用如下方式进行绝对地址跳转
>mov rax,xxxxxxxx
>jmp rax

对应Opcode为
>48 b8 xx xx xx xx xx xx xx xx
>ff e0

这样仅需覆写12个字节即可完成hook，可以解决掉覆盖正常代码的问题。
因为没有找到可以直接patch64位程序的工具（Windbg/IDA Pro的patch功能均不支持带64位寄存器的指令），固只好在IDA Pro中进行Hex修改，然后通过WinHex保存到文件中。
修正后的代码如下
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/fix-hook.jpg)

需要注意的是，在hook函数内部会首先恢复SHGetSpecialFolderPathW的代码，调用完成后会重新inline hook，故需要对恢复hook的代码进行相同的修改。

###成果展示
完成上述步骤后，用修改后的dll文件替换掉原dll文件，再次测试触发文件选择框时，已可正常打开文件选择框。
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/repair-pcxfirefox-crash-in-win81-x64-environment/is-ok.jpg)

##修正后文件
版本：pcxFirefox-28.0-zhCN-vc2010-x64-sse2-betterpgo-140318
md5：7b6f5ce613e8d8c9e8b91ca4f6b6cc9039b0a6f5
下载：[temeutil.dll](http://pan.baidu.com/s/1fCfsM)
