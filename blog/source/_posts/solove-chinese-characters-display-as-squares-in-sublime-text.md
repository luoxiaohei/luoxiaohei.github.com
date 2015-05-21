title: 解决Sublime Text中文字符显示为方块
date: 2014-04-08 22:38:31
categories: 问题记录
tags:
description:
---
在笔记本上使用Sublime Text 3，发现其标签页及命令行中的中文均显示为方块。

本文记录了该问题的成因及解决方案。
<!-- more -->
##问题现象
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/solove-chinese-characters-display-as-squares-in-sublime-text/squares.jpg)

##问题成因
开始以为是编码问题导致的中文乱码，但是已经安装了ConvertToUTF8插件，而且编辑框内中文并未乱码，只有标签页和命令行乱码。
后经过搜索，发现有人提到如果修改了系统的显示缩放级别，将字体改的太大，则可能造成ST3版本的标签页放不下，进而显示成方块。
因为我的电脑是1920*1080的分辨率，系统默认将缩放级别调整为了125%。
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/solove-chinese-characters-display-as-squares-in-sublime-text/125%25.jpg)

##解决方案
将缩放级别更改为100%后，在ST3中标签页及命令行已经可以正常显示中文了。
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/solove-chinese-characters-display-as-squares-in-sublime-text/100%25.jpg)

##成果展示
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/solove-chinese-characters-display-as-squares-in-sublime-text/normal.jpg)
