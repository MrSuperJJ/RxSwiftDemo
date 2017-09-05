简书地址：http://www.jianshu.com/p/5d47f68588a9

前言

 从几年前做Android（2.x版本的年代），到现在做iOS开发，一直以来崇尚的开发原则就是功能第一，代码第二，架构第三。一个需求布置下来，首先想到的就是怎么快速的去完成，而不是怎么样写出优雅的代码，更不会考虑用什么先进的架构。当然，这跟项目本身也有一定的关系，一些大型项目是接前人的班，我能做就是在原来的结构上砌砖修墙，还有一些项目虽然需要重头开始，但是功能单一时间紧凑，所以一直以来基本都是用了入门简单、结构清晰、官方推荐的MVC架构或其变种来进行项目开发。一段时间后对MVVM有了一些认识，便想尝试着做一些开发，但是苦于找不到入门的法宝，直到有一天遇到了RxSwift。

    本文将通过一个Demo来讲解，分别用MVC和MVVM来实现几个简单的功能，通过对比，可以清晰的展现出两类架构的区别。

需求：

在页面中输入用户名和密码，实时显示验证后的用户名和密码的合并内容，点击登录按钮，验证用户名和密码的合法性，然后弹出提示框告知用户登录结果。

功能点：

1.用户名和密码验证：验证用户名的过程简化为返回大写后的用户名，验证密码的过程简化为返回小写后的密码；

2.实时显示合并内容：合并内容的过程简化为用户名和密码的字符串合并；

3.登录验证合法性验证：验证过程简化为用户名和密码字符数量的判定，返回结果用枚举表示。

准备工作：

1.新建一个基于Swift语言的iOS工程（RxSwiftDemo），用CocoaPods引入RxSwift库（RxSwift，RxCocoa）。

2.在ViewController中添加四个控件，用户名输入框（nameTextField），密码输入框（passwordTextField），输出结果文本标签（resultLabel），登录按钮（loginButton）。

功能点代码分析：

View：

    在MVC中，ViewController担任View和Controller双重角色，而在MVVM中，ViewController只担任View的角色，所以两个架构可以共享View。




View
Model:

    Model本应是结构和业务的结合，但是在MVC架构中经常只实现了结构的方面，业务逻辑的实现会放在Controller中实现。举个例子，在ViewController进行网络请求，返回的数据封装成一个Model，然后将Model的实例传递给View去刷新页面，在ViewController中可以一气呵成，但是假如要把网络请求放在Model，那么必然会增加很多额外的代码，所以，也就不管什么架构了。

    其实Model可以完全独立于Controller和View而存在，对于MVC和MVVM来说也可以共享。为了更通用一些，这里采用了协议的方法，在Controller声明一个协议变量，只需要将Model的实例赋值给这个变量即可。


Model
Controller和ViewModel：

MVC和MVVM的差别体现在这里，Controller存在于MVC架构中，Controller可以可以直接访问Model和View，View只能通过Target-Action告知Controller出现用户操作，通过delegate告知Controller如何展示内容，Model只能通过Notification告知Controller数据有变化，这些都是标准的MVC。

想要实现显示验证后的用户名和密码的合并内容，就必须要监听UITextFiled的输入。

在MVC中通过UITextField的delegate方法来实现：




UITextField delegate
登录流程也是通过函数调用来实现：




function
所有的方法都写在ViewController，虽然封装了Model，但是业务逻辑代码仍然存在于ViewController，使得移植性大大降低。加入将来要将用户名和密码的合并替换为其他方式，那么必然要在UITextField的delegate方法中大动干戈。

    普通的MVVM之所以难入门，是在于View和Model的绑定。RxSwift作为一种响应式编程语言，能够完美的解决这一问题。

在ViewModel中实现View和Model的绑定：




ViewModel
ViewController只承担View的任务，即只负责用户名和密码合并后的内容展示，以及登录结果的展示：




ViewController（View）
ViewModel中，用户名和密码的验证方式，合并内容，登录流程可以任意更改，都不会影响ViewController中View的展示，同时ViewModel也不关心Model的数据是什么结构，数据如何获取，它只是View和Model之间的一座桥梁，也可以很快捷的替换View或者Model，方便代码重用。

总结

    MVC架构(Model-View-Controller)的优缺点已经有很多优秀的文章详细的阐述，这里不再赘述。在iOS项目中，ViewController既扮演了View的角色，又扮演了Controller的角色，Model在ViewController中与View直接交互。对于开发者来说，这样的MVC架构的确“逻辑清晰，层次分明，开发快捷”。但是一遇到View层需要复用的时候，一切就变得不那么美好了。明明一模一样的界面，只是改动了数据获取方式，却要花很多时间和精力，不是重新创建个VC把99%的代码复制过去，就是修改原VC的内部逻辑，使之能适配多类数据的获取。一不小心就给自己挖了坑！

    上述这样伤筋动骨的方式笔者遇到过数次。秉承处女座追求完美的精神，在不影响项目进度的前提下，会尽可能的重构，以便在“不久的将来”能用别的项目中。但也只是逻辑层面的重构，比如用Swift重写，用协议代替类或结构体，多写些delelgate或者block等等。但是心中始终有一个疙瘩，就是代码写的太丑了，Swift这么优雅的语言，不应如此狼狈。本着破釜沉舟的决心，笔者翻开了RxSwift的Git，因为江湖上传闻RxSwift可以让Swift变得很优雅，让MVVM变得很简洁。

    学习RxSwift和MVVM是个痛并快乐着的过程，对于数学功底一般且写惯了MVC的笔者来说，这些内容太过深奥难懂，但是一旦摸着一些门道，回头再来看自己写出来的代码，跟用MVC写的一对比，深深地体会到，不虚此行。

    期望本文能对想学习RxSwift和MVVM的开发者有所帮助，笔者只是一块砖，如有错误，还望指出，谢谢！
