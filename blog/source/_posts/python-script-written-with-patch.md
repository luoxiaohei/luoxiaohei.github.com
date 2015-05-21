title: 用Python写Patch脚本
date: 2014-06-19 17:15:35
categories: 软件破解
tags: [Patch, Python]
description:
---

近日对某家族样本虚拟机检测进行分析，应同事要求，写了个Python脚本用于Patch及Load该家族样本。

因之前没有相关经验，在编写过程中遇到一些问题，现将其整理如下。
<!-- more -->

##获取PE文件版本信息
该家族样本需特定参数才能运行，且参数信息保存在版本信息中，故需要对样本的版本信息进行解析，进而得到运行参数。
Python中没有内置PE解析库，无法直接获取PE文件相关信息，经过搜索在[这里](http://stackoverflow.com/questions/580924/python-windows-file-version-attribute)发现两种方式解析文件版本信息。
两种方式均需要安装第三方库，分别是PyWin32及pefile库，因为我有安装PyWin32，所以选择了使用PyWin32的方式进行解析。
解析版本信息源码如下：
{%codeblock lang:python%}
import win32api

#==============================================================================
def getFileProperties(fname):
#==============================================================================
    """
    Read all properties of the given file return them as a dictionary.
    """
    propNames = ('Comments', 'InternalName', 'ProductName',
        'CompanyName', 'LegalCopyright', 'ProductVersion',
        'FileDescription', 'LegalTrademarks', 'PrivateBuild',
        'FileVersion', 'OriginalFilename', 'SpecialBuild')

    props = {'FixedFileInfo': None, 'StringFileInfo': None, 'FileVersion': None}

    try:
        # backslash as parm returns dictionary of numeric info corresponding to VS_FIXEDFILEINFO struc
        fixedInfo = win32api.GetFileVersionInfo(fname, '\\')
        props['FixedFileInfo'] = fixedInfo
        props['FileVersion'] = "%d.%d.%d.%d" % (fixedInfo['FileVersionMS'] / 65536,
                fixedInfo['FileVersionMS'] % 65536, fixedInfo['FileVersionLS'] / 65536,
                fixedInfo['FileVersionLS'] % 65536)

        # \VarFileInfo\Translation returns list of available (language, codepage)
        # pairs that can be used to retreive string info. We are using only the first pair.
        lang, codepage = win32api.GetFileVersionInfo(fname, '\\VarFileInfo\\Translation')[0]

        # any other must be of the form \StringfileInfo\%04X%04X\parm_name, middle
        # two are language/codepage pair returned from above

        strInfo = {}
        for propName in propNames:
            strInfoPath = u'\\StringFileInfo\\%04X%04X\\%s' % (lang, codepage, propName)
            ## print str_info
            strInfo[propName] = win32api.GetFileVersionInfo(fname, strInfoPath)

        props['StringFileInfo'] = strInfo
    except:
        pass

    return props
{% endcodeblock %}

##在Python中查找及修改特征码
对于Patch文件，我的做法很简单，将要求改的代码的二进制数据提取为特征码，然后将修改后的代码作为Patch码，直接替换掉特征码即完成了Patch。但因为没找到直接替换十六进制串的方法，在查找和修改时遇到了问题。
后来发现可以以字符串的方式来完成替换，首先将文件以二进制方式读入，将以字符串形式保存的十六进制串按hex方式解码，完成替换，最后以二进制形式再写入即可。
Patch代码如下：
{%codeblock lang:python%}
#==============================================================================
def patchFile(fin, fout):
#==============================================================================
# patch文件，fin为待patch文件，fout为patch后文件
    fdata = open(fin, 'rb').read()
    feature = '0FFD000083C414E8073C000085C074416858DA47006A04'.decode('hex')
    patched = '0FFD000083C414E8073C000085C0EB416858DA47006A04'.decode('hex')
    pdata = fdata.replace(feature, patched)
    open(fout, 'wb').write(pdata)
{% endcodeblock %}

##创建临时文件并将其创建为子进程
对于Load文件，我的做法是先在临时目录生成一个Patched文件，然后获取到参数后创建一个进程来执行Patched文件，待执行完毕后清理临时文件。
因为创建临时文件后需要创建子进程，在创建进程时不可以有进程占有该文件，所以无法使用tempfile.TemporaryFile()函数和tempfile.NamedTemporaryFile()函数。
我使用的是tempfile.mkstmp()函数创建临时文件,但在写入完成且关闭文件后，仍无法成功创建进程，错误信息为WindowsError 32，该文件被其他进程占用。
搜索后发现除关闭文件外，还需调用os.close()函数，关闭文件描述符，之后可正常创建进程。
Loader部分代码如下：
{%codeblock lang:python%}
#==============================================================================
def loadFile(fin):
#==============================================================================
# load程序，fin为需要load文件
    fd, fout = tempfile.mkstemp(suffix='.exe')
    patchFile(fin, fout)
    args = getCommandLine(fin)
    os.close(fd)
    subprocess.call('%s %s' % (fout, args))
    os.remove(fout)
{% endcodeblock %}
