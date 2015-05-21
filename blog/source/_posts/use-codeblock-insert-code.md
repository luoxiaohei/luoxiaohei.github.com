title: 使用codeblock插入代码
date: 2014-04-05 17:13:45
categories:
tags: [Markdown, Hexo]
description:
---

在测试在博文中插入代码时发现，使用缩进方式插入代码，即使在Hexo的配置文件中将line_number设置为true，代码框上也不会显示行号。
如下边这段代码直接使用缩进方式插入：

    int main(void) {
        return 0;
    }

对于如我这般的强迫症患者，想要显示行号时却发现没有行号，自然是百般的不自在，后经过搜索后发现，Markdown还支持显示声明Codeblock的方式插入代码。
<!-- more -->
其语法如下：

    {% raw %}{% codeblock [title] [lang:language] [url] [link text] %}{% endraw %}
    {% raw %}code snippet{% endraw %}
    {% raw %}{% endcodeblock %}{% endraw %}

关于Codeblock在Markdown中使用可以参考[这里](http://hexo.io/docs/tag-plugins.html#Code_Block)。
使用codeblock插入的代码，在Hexo中可正常显示行号，并且可以选择编程语言，增加代码标题，链接等。
如下边这段代码使用codeblock方式插入：

{% codeblock %}
int main(void) {
    return 0;
}
{% endcodeblock %}

** 参考文献： **
* [hexo的代码高亮](http://popozhu.github.io/2013/06/15/hexo%E4%BB%A3%E7%A0%81%E9%AB%98%E4%BA%AE/)
