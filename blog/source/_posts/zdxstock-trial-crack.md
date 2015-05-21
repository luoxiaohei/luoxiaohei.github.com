title: ZDX股票自动交易软件破解
date: 2015-03-27 21:43:34
categories: 软件破解
tags: [Crack]
description:
---

今天发现邮箱里有人请求帮忙破解一款用于自动操盘的软件，于是便看了一下，虽然最终成功破解掉了该软件，但并未将其发送给求助者。在我看来，破解更多是为了学习和研究，在经济条件允许的情况下，为软件付费，支持正版是每个人都该做的。

<!--more-->

##初次安装
因为是试用期类的软件，所以按照通常的方式，将系统时间向后调若干年后进行安装，安装后发现试用开始日期仍为今天，并未受系统时间调整而影响，故判断该软件的验证方式可能是服务器验证。
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/zdxstock-trial-crack/trial.jpg)

##程序分析
在安装运行之后，发现该软件在启动时带有关键字“正在检测注册信息”，遂尝试通过关键字在程序中找到验证点，查壳后发现该软件为.Net程序，便祭出.Net神器Reflector来分析。

###去混淆处理
通过Reflector可以发现，该软件的主程序是经过混淆处理的，所有类名、方法名都被修改为无意义字母，以此来增加逆向分析的难度。
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/zdxstock-trial-crack/obfuscated.jpg)

这里可以使用Reflector的Reflexil插件的Obfuscator search功能来搜索和去除混淆，效果如下图。
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/zdxstock-trial-crack/cleaned.jpg)

###寻找关键点
去混淆之后，我们开始尝试搜索关键字“正在检测注册信息”，发现以下方法

``` csharp
public GClass3.GEnum4 method_136(string string_1 = "")
{
    GClass3.GEnum4 enum2;
    if (!GClass3.bool_21)
    {
        this.method_12("<" + Conversions.ToString(GClass3.int_2) + ">正在检测注册信息...");
        if (GClass3.string_34 == "")
        {
            GClass3.string_34 = GClass0.smethod_51();
        }
        GClass1 class2 = new GClass1();
        try
        {
            GClass1.GStruct5 struct2 = new GClass1.GStruct5 {
                bool_0 = GClass3.bool_1,
                string_0 = GClass3.string_1,
                string_1 = GClass3.string_2,
                string_2 = GClass3.string_34,
                string_3 = GClass3.string_35
            };
            GClass1.GStruct6 struct3 = class2.method_0(struct2);
            if (struct3.bool_4)
            {
                GClass3.int_2 = 0;
                if (((struct3.bool_0 == GClass3.bool_1) & (struct3.string_1 == GClass3.string_1)) & (struct3.string_2 == GClass3.string_34))
                {
                    string str = struct3.string_0.Substring(0, 7);
                    switch (str)
                    {
                        case "数据库打开失败":
                            GClass3.decimal_1 = GClass3.decimal_0;
                            GClass3.string_12 = GClass3.string_3;
                            GClass3.smethod_8("注册数据库打开失败", true);
                            return GClass3.GEnum4.const_0;

                        case "数据库操作错误":
                            GClass3.decimal_1 = GClass3.decimal_0;
                            GClass3.string_12 = GClass3.string_3;
                            GClass3.smethod_8("注册数据库操作错误", true);
                            return GClass3.GEnum4.const_0;

                        case "机器码首次存档":
                            GClass3.dateTime_0 = Conversions.ToDate(struct3.string_3);
                            GClass3.decimal_1 = struct3.decimal_0;
                            GClass3.string_12 = struct3.string_4;
                            return GClass3.GEnum4.const_2;

                        case "机器码已经存档":
                            if (struct3.bool_3)
                            {
                                GClass3.dateTime_0 = Conversions.ToDate(struct3.string_3);
                                GClass3.decimal_1 = GClass3.decimal_0;
                                GClass3.string_12 = GClass3.string_3;
                                return GClass3.GEnum4.const_1;
                            }
                            GClass3.dateTime_0 = Conversions.ToDate(struct3.string_3);
                            GClass3.decimal_1 = struct3.decimal_0;
                            GClass3.string_12 = struct3.string_4;
                            return GClass3.GEnum4.const_2;

                        case "注册码已经录入":
                            if (struct3.bool_3)
                            {
                                GClass3.dateTime_0 = Conversions.ToDate(struct3.string_3);
                                GClass3.decimal_1 = GClass3.decimal_0;
                                GClass3.string_12 = GClass3.string_3;
                                return GClass3.GEnum4.const_3;
                            }
                            if (struct3.bool_2)
                            {
                                GClass3.dateTime_0 = Conversions.ToDate(struct3.string_3);
                                GClass3.decimal_1 = struct3.decimal_0;
                                GClass3.string_12 = struct3.string_4;
                                return GClass3.GEnum4.const_4;
                            }
                            GClass3.dateTime_0 = Conversions.ToDate(struct3.string_3);
                            GClass3.decimal_1 = GClass3.decimal_0;
                            GClass3.string_12 = GClass3.string_3;
                            return GClass3.GEnum4.const_5;
                    }
                    if (str != "注册码还未录入")
                    {
                        return enum2;
                    }
                    GClass3.decimal_1 = GClass3.decimal_0;
                    GClass3.string_12 = GClass3.string_3;
                    return GClass3.GEnum4.const_6;
                }
                GClass3.decimal_1 = GClass3.decimal_0;
                GClass3.string_12 = GClass3.string_3;
                GClass3.smethod_8("返回信息不匹配", true);
                return GClass3.GEnum4.const_0;
            }
            GClass3.int_2++;
            if (GClass3.int_2 <= 3)
            {
                Thread.Sleep(0x7d0);
                return this.method_136("");
            }
            GClass3.decimal_1 = GClass3.decimal_0;
            GClass3.string_12 = GClass3.string_3;
            GClass3.smethod_8("注册服务不可用", true);
            enum2 = GClass3.GEnum4.const_0;
        }
        catch (Exception exception1)
        {
            ProjectData.SetProjectError(exception1);
            Exception exception = exception1;
            GClass3.decimal_1 = GClass3.decimal_0;
            GClass3.string_12 = GClass3.string_3;
            GClass3.smethod_8("检测注册信息异常：" + exception.Message, true);
            enum2 = GClass3.GEnum4.const_0;
            ProjectData.ClearProjectError();
        }
        finally
        {
            class2 = null;
        }
    }
    return enum2;
}
```

通过这个方法我们可以发现两个重要信息：
1. 该方法将机器码信息和注册信息发送给`class2.method_0`方法并返回一个结构对象，该对象将用来后续的判断；
2. 该方法返回一个枚举值，该枚举值将决定软件最终运行哪种授权版本。

###分析返回值
我们首先分析上述方法的返回值，通过`method_136`方法的引用关系，我们发现返回值会作为参数传给`smethod_2`这个方法，并且当值为`GEnum4.const_4`时,软件会显示为正式版。

``` csharp
public static void smethod_2(GEnum4 genum4_1)
{
    genum4_0 = genum4_1;
    switch (smethod_1())
    {
        case GEnum4.const_0:
        {
            string str = "［注册失败\x00b7" + string_12 + "］";
            smethod_8(str, true);
            Class1.smethod_3().method_8().Text = string_16 + str;
            Class1.smethod_3().method_8().vmethod_156().Visible = true;
            break;
        }
        case GEnum4.const_1:
        {
            string str3 = "［试用版已过期\x00b7" + string_12 + "］";
            smethod_8(str3, true);
            Class1.smethod_3().method_8().Text = string_16 + str3;
            Class1.smethod_3().method_8().vmethod_156().Visible = true;
            break;
        }
        case GEnum4.const_2:
        {
            string str2 = "［试用版\x00b7无限制］";
            smethod_8(str2, true);
            Class1.smethod_3().method_8().Text = string_16 + str2;
            Class1.smethod_3().method_8().vmethod_156().Visible = true;
            break;
        }
        case GEnum4.const_3:
        {
            string str4 = "［正式版已过期\x00b7" + string_12 + "］";
            smethod_8(str4, true);
            Class1.smethod_3().method_8().Text = string_16 + str4;
            Class1.smethod_3().method_8().vmethod_156().Visible = true;
            break;
        }
        case GEnum4.const_4:
        {
            string str5 = "［正式版\x00b7" + string_12 + "］";
            smethod_8(str5, true);
            Class1.smethod_3().method_8().Text = string_16 + str5;
            Class1.smethod_3().method_8().vmethod_156().Visible = false;
            break;
        }
        case GEnum4.const_5:
        {
            string str6 = "［正式版未注册\x00b7" + string_12 + "］";
            smethod_8(str6, true);
            Class1.smethod_3().method_8().Text = string_16 + str6;
            Class1.smethod_3().method_8().vmethod_156().Visible = true;
            break;
        }
        case GEnum4.const_6:
        {
            string str7 = "［正式版未录入\x00b7" + string_12 + "］";
            smethod_8(str7, true);
            Class1.smethod_3().method_8().Text = string_16 + str7;
            Class1.smethod_3().method_8().vmethod_156().Visible = true;
            break;
        }
    }
}
```

通过上边的分析，有经验的同学会想到直接修改`method_136`方法的返回值，使其常返回`GEnum4.const_4`，这样修改虽然可以使软件显示为正式版，但实际上并未破解掉软件的自动操盘金额限制，所以需要继续向下分析。

###服务器验证
通过分析`class2.method_0`方法，可以知道该方法用于服务器验证，其将注册信息加密后发送给服务端后，解密从服务端返回的信息并填充为一个结构对象，然后返回给调用方法。
同时可以知道注册信息和返回信息的明文都是使用字符'|'进行字段间的分隔的。

``` csharp
public GStruct6 method_0(GStruct5 gstruct5_0)
{
    GStruct6 struct3 = new GStruct6();
    try
    {
        string str2 = "";
        str2 = ((((str2 + gstruct5_0.bool_0.ToString() + "|") + gstruct5_0.string_0 + "|") + gstruct5_0.string_1 + "|") + gstruct5_0.string_2 + "|") + gstruct5_0.string_3;
        string s = "key=" + this.method_1(str2);
        byte[] bytes = Encoding.Default.GetBytes(s);
        string requestUriString = "http://www.zdx8.com/Rgst/RgstRequest.aspx";
        HttpWebRequest request = (HttpWebRequest) WebRequest.Create(requestUriString);
        request.Method = "POST";
        request.ContentType = "text/html; charset=utf-8";
        request.ContentLength = bytes.Length;
        Stream requestStream = request.GetRequestStream();
        requestStream.Write(bytes, 0, bytes.Length);
        requestStream.Close();
        request.Timeout = GClass3.int_5 * 2;
        HttpWebResponse response = (HttpWebResponse) request.GetResponse();
        string str = new StreamReader(response.GetResponseStream(), Encoding.UTF8).ReadLine();
        response.Close();
        string str4 = this.method_2(str);
        try
        {
            string[] strArray = str4.Split(new char[] { '|' });
            struct3.string_0 = strArray[0];
            struct3.bool_0 = Conversions.ToBoolean(strArray[1]);
            struct3.string_1 = strArray[2];
            struct3.bool_1 = Conversions.ToBoolean(strArray[3]);
            struct3.string_2 = strArray[4];
            struct3.bool_2 = Conversions.ToBoolean(strArray[5]);
            struct3.string_3 = strArray[6];
            struct3.bool_3 = Conversions.ToBoolean(strArray[7]);
            struct3.decimal_0 = Conversions.ToDecimal(strArray[8]);
            struct3.string_4 = strArray[9];
            struct3.bool_4 = true;
        }
        catch (Exception exception1)
        {
            ProjectData.SetProjectError(exception1);
            Exception exception = exception1;
            struct3.bool_4 = true;
            ProjectData.ClearProjectError();
        }
    }
    catch (Exception exception3)
    {
        ProjectData.SetProjectError(exception3);
        Exception exception2 = exception3;
        GClass3.smethod_8("注册服务错误：" + exception2.Message.Replace("\r", "").Replace("\n", ""), true);
        if (((WebException) exception2).Status != WebExceptionStatus.Timeout)
        {
            struct3.bool_4 = false;
        }
        ProjectData.ClearProjectError();
    }
    return struct3;
}
```

通过上述分析，我们大概知道了该软件的验证流程
1. 获取用户的注册信息
2. 将注册信息发送给服务器验证
3. 根据返回信息选择相应的软件版本

同时知道了服务器返回的信息包含10个字段，通过更加深入的分析，我们可以构造出一个完整的返回数据包，但是这里我们使用一个更加便捷的方法，直接抓取客户端和服务器的通讯数据包。

###分析数据包
重新运行程序，打开网络分析工具，抓取验证注册信息时客户端与服务端的通讯数据包，可以看到通讯数据包如下

``` text POST
EgzwaHzHSBvwy514aiLfP7BT8AVd67toYdCm54a89H0tIXsklk63HRHjtiRPGBnTHv/VlybkxaYQQN1wjlhrjA==
```
``` text RECV
g8egIVo7wykjOBds0v78BK+qvUxiLB/SwQU5bellpG+aG8Lwb25udRXEwB3T9EfW81esMT+R44MeSIr2glg8jWy1vVByXkISp8t+NoRmjOmCLRQ77lAyH5WrYmQ2XNkcIJKBtb77dks=
```

通过程序内的解密方法，得到明文信息如下
``` text POST
True|亲|123456|0142-3111-1313-7210-1120|请在这里输入注册码
```
``` text RECV
机器码已经存档|True|亲|True|0142-3111-1313-7210-1120|False|2015-03-27 23:07:34|False|10000000|1千万
```

经过分析，我们得到服务端返回信息中各字段的作用如下

    字段4:                未使用
    字段7:                标识激活时间
    字段9、字段10:         标识自动操盘的最大金额
    字段1、字段6、字段8:    验证软件授权
    字段2、字段3、字段5:    验证注册用户信息


##破解程序
###修改验证方法
根据前边的分析我们知道，在保证发送及返回的注册信息匹配的同时，需要保证返回数据中字段1为“注册码已经录入”、字段6的值为True，此时程序将被验证为正式版授权，并且将会使用字段9、10的值作为操盘最大金额。
这里我们直接Patch`class2.method_0`方法,将联网验证部分代码NOP掉，并直接构造一个字符串来填充返回值`struct3`，Patch的工作依然由Reflexil插件来完成，Patch后的代码如下

``` csharp
public GStruct6 method_0(GStruct5 gstruct5_0)
{
    GStruct6 struct3 = new GStruct6();
    try
    {
        string str4 = "注册码已经录入|True|亲|True|0142-3111-1313-7210-1120|True|2015-03-27 21:07:34|False|10000000|1千万";
        try
        {
            string[] strArray = str4.Split(new char[] { '|' });
            struct3.string_0 = strArray[0];
            struct3.bool_0 = Conversions.ToBoolean(strArray[1]);
            struct3.string_1 = strArray[2];
            struct3.bool_1 = Conversions.ToBoolean(strArray[3]);
            struct3.string_2 = strArray[4];
            struct3.bool_2 = Conversions.ToBoolean(strArray[5]);
            struct3.string_3 = strArray[6];
            struct3.bool_3 = Conversions.ToBoolean(strArray[7]);
            struct3.decimal_0 = Conversions.ToDecimal(strArray[8]);
            struct3.string_4 = strArray[9];
            struct3.bool_4 = true;
        }
        catch (Exception exception1)
        {
            ProjectData.SetProjectError(exception1);
            Exception exception = exception1;
            struct3.bool_4 = true;
            ProjectData.ClearProjectError();
        }
    }
    catch (Exception exception3)
    {
        ProjectData.SetProjectError(exception3);
        Exception exception2 = exception3;
        GClass3.smethod_8("注册服务错误：" + exception2.Message.Replace("\r", "").Replace("\n", ""), true);
        if (((WebException) exception2).Status != WebExceptionStatus.Timeout)
        {
            struct3.bool_4 = false;
        }
        ProjectData.ClearProjectError();
    }
    return struct3;
}
```
###验证效果
修改验证方法后，将程序重新保存，再次运行发现该软件已经成功被破解了。
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/zdxstock-trial-crack/cracked.jpg)

##版权修改
虽然完成了软件的破解，但是从图片中我们可以看到，在关于对话框中，软件版本信息的标题仍为试用版；软件主界面的用户信息显示为默认的“亲”，并且该程序的文件属性的描述信息也显示为试用版，现在我们把这些信息修改掉。

###修改文件属性
文件属性中的描述信息可以使用PE资源编辑器(如ResHacker)进行修改，直接将FileDescription字段中的试用版删掉，然后重新编译脚本，将文件保存或另存为即完成了文件属性的修改。

###修改用户信息
通过之前的分析可以知道，注册验证逻辑中需要保证发送和返回的用户信息是一致的，所以需要找到`GClass3.string_1`初始化的地方，将其修改为想要的值，同时修改之前构造的返回字符串，这里我将其修改为"Cracked by LuoXiaohei"。

###修改关于信息
通过分析可以发现，关于对话框中的信息是通过AssemblyInfo定义的，在Reflextor中我并没有发现可以直接修改AssemblyInfo的方法，所以我直接使用了WinHex修改程序文件。
AssemblyInfo中的信息在程序文件中是以UTF-8编码保存的，我们可以通过代码将"智达信股票自动交易软件试用版"编码为UTF-8格式并获取Hex值，这里得到的值是

>E699BAE8BEBEE4BFA1E882A1E7A5A8E887AAE58AA8E4BAA4E69893E8BDAFE4BBB6E8AF95E794A8E78988

利用相同的方法，可以得到"正式版"的UTF-8编码的Hex值，然后利用WinHex将"试用版"修改为"正式版"。

##最终成果
![](http://7xicmh.com1.z0.glb.clouddn.com/blog/zdxstock-trial-crack/final.jpg)