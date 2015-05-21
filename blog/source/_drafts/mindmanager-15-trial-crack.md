title: MindManager 15 试用限制破解
date: 2015-01-20 23:00:32
categories: 软件破解
tags: [Crack]
description: 软件：Mindjet MindManager 15 版本：15.0.160 破解目的：解除试用限制 破解方式：文件Patch
---
最近想要学习绘制思维导图，便对相关软件进行了解，发现在该类软件中，MindManager无疑是专业且优秀的。碍于其昂贵的售价（1500￥/年），作为一名IT狗表示暂时无法承受，于是便对其试用版进行了简单的分析，进而有了本文。

第一次安装时有一个很有趣的事情，我在安装前将系统时间调到了2099年，并在安装完成后调回正常日期，于是打开程序时可以看到这样的画面。

![](http://7xicmh.com1.z0.glb.clouddn.com/blog/mindmanager-15-trial-crack/Trial.jpg)

仅仅是在安装前修改一下系统日期，便如此顺利的获得了80多年的试用期，这着实让我措手不及，尽管我如此自信自己可以健康和愉快的用完这漫长的试用授权。

通过上边的描述，我猜测该软件将试用过期时间写在本地，并且试用验证也是在本地完成的，于是便在虚拟机里重新安装了一次，并且这次在安装前后进行了快照比较，抓取了软件启动时的数据包，更加确认试用验证是在本地完成的。其中过程不再细表，因为我错误的估计了该软件的复杂度，对如此规模的软件使用快照对比的方式寻找关键点无疑是反人类的做法，面对海量的数据，我看了几眼之后便放弃了。

在行为监控无功而返之后我打算从上边截图中的Nag窗口入手，通过OD找到窗口创建的时机，并顺藤摸瓜找到验证试用身份的关键点，这里因为自己的调试水平太水，再一次以失败告终。

最后无奈只好祭出神器IDA开始静态分析（这里对放出IDA Pro 6.6完整版的同学表示诚挚感谢，你无私的行为对构建中国特色的社会主义和谐社会产生了巨大影响和帮助，并对被泄露的大土豪表示沉痛哀悼。）

神器一出果真不同凡响，很快就在导入表里发现了重要线索，因为该软件的导入函数都是明文的，在我使用Trial作为关键字进行搜索的时候很快就搜索到了一些有意思的函数，比如

{% codeblock %}
00D28920  ?GetRemainingTrialDays@CmjApplicationOptions@@QAEHXZ MmApplicationFramework
{% endcodeblock %}

这个函数看名字很像是用来获取剩余试用天数的函数，并且该函数是在MmApplicationFramework模块导出的，于是再开一个IDA载入MmApplicationFramework模块，看到该函数的实现如下
{% codeblock %}
int __thiscall CmjApplicationOptions::GetRemainingTrialDays(CmjApplicationOptions *__hidden this)
    push    ebp
    mov     ebp, esp
    sub     esp, 0D4h
    mov     [ebp+var_C4], ecx
    push    0               ; Time
    call    ds:_time64
    add     esp, 4
    mov     [ebp+var_8C], eax
    mov     [ebp+var_88], edx
    fldz
    fstp    [ebp+var_28]
    mov     [ebp+var_20], 0
    lea     eax, [ebp+var_8C]
    push    eax
    lea     ecx, [ebp+var_28]
    call    sub_100389A0
    lea     ecx, [ebp+var_28]
    push    ecx
    lea     edx, [ebp+var_C]
    push    edx
    call    ds:?RemoveTimeFromDate@CmjDateUtilities@@SA?AVCOleDateTime@ATL@@ABV23@@Z
            ; CmjDateUtilities::RemoveTimeFromDate(ATL::COleDateTime const &)
    add     esp, 8
    lea     eax, [ebp+var_30]
    push    eax
    call    ?GetAppOptions@CmjApplicationOptions@@SAPAV1@XZ
            ; CmjApplicationOptions::GetAppOptions(void)
    mov     ecx, eax
    call    ?GetExpiryDate@CmjApplicationOptions@@QAE?AVCTime@ATL@@XZ
            ; CmjApplicationOptions::GetExpiryDate(void)
    mov     ecx, [eax+4]
    push    ecx
    mov     edx, [eax]
    push    edx
    lea     eax, [ebp+var_1C]
    push    eax
    call    ds:?CTimeToCOleDateTime@CmjDateUtilities@@SA?AVCOleDateTime@ATL@@VCTime@3@@Z
            ; CmjDateUtilities::CTimeToCOleDateTime(ATL::CTime)
    add     esp, 0Ch
    lea     ecx, [ebp+var_C]
    push    ecx
    lea     edx, [ebp+var_3C]
    push    edx
    lea     ecx, [ebp+var_1C]
    call    sub_10038C90
    mov     [ebp+var_C0], eax
    mov     eax, [ebp+var_C0]
    fldz
    fcomp   qword ptr [eax]
    fnstsw  ax
    test    ah, 41h
    jnz     short loc_1003664D
    fld     ds:dbl_10189658
    fchs
    fstp    [ebp+var_CC]
    jmp     short loc_10036659
; ---------------------------------------------------------------------------

loc_1003664D:                           ; CODE XREF: CmjApplicationOptions::GetRemainingTrialDays(void)+9Bj
    fld     ds:dbl_10189658
    fstp    [ebp+var_CC]

loc_10036659:                           ; CODE XREF: CmjApplicationOptions::GetRemainingTrialDays(void)+ABj
    mov     ecx, [ebp+var_C0]
    fld     qword ptr [ecx]
    fadd    [ebp+var_CC]
    call    __ftol2
    mov     dword ptr [ebp+var_D4], eax
    mov     dword ptr [ebp+var_D4+4], edx
    fild    [ebp+var_D4]
    call    __ftol2_sse
    mov     [ebp+var_10], eax
    mov     eax, [ebp+var_10]
    mov     esp, ebp
    pop     ebp
    retn
{% endcodeblock %}

&emsp;&emsp;可以看到，这个函数最终将试用天数的信息通过eax寄存器返回，于是我在OD里在函数返回时将eax改为0x0FFFFFFF,得到了如下结果

![](http://7xicmh.com1.z0.glb.clouddn.com/blog/mindmanager-15-trial-crack/PatchGetRemainingTrialDays.jpg)

&emsp;&emsp;此时我们已经可以摆脱调整系统日期的方式来获取试用天数了，通过Patch上边的函数我们可以获取任意的试用天数，但显然这无法满足我们最终需求——摆脱试用限制。

&emsp;&emsp;通过分析主程序代码，我们发现了另一个关键函数GetLicensingRemoved，实现代码如下

{% codeblock %}
; bool __thiscall CmjApplicationOptions::GetLicensingRemoved(CmjApplicationOptions *__hidden this)
    push    ebp
    mov     ebp, esp
    push    ecx
    mov     [ebp+var_4], ecx
    mov     eax, [ebp+var_4]
    mov     al, [eax+4E1h]
    mov     esp, ebp
    pop     ebp
    retn
{% endcodeblock %}

&emsp;&emsp;我猜测这个函数就是试用验证的关键函数，通过代码可以知道，最终al返回了一个bool值来表示是否移除授权功能，于是我在OD中将返回值改为1，得到如下结果

![](http://7xicmh.com1.z0.glb.clouddn.com/blog/mindmanager-15-trial-crack/PatchGetLicensingRemoved.jpg)

&emsp;&emsp;可以看到此时Nag弹窗已经不见了，实际上其他与试用期相关的信息以及授权代码入口都不见了，我们已经成功的破解了试用限制。

&emsp;&emsp;也许故事到这里就该结束了，但有经验的同学可以知道这个函数是获取了类对象中某个成员的值，我们在这里进行Patch，并不是在源头解决问题（虽然一样解决了问题），并且这个函数内很难进行一字节Patch，所以我又找到了该对象的初始化函数，从源头解决了这个问题并完成了一字节Patch。