# iOS关于各种本地音频的读取问题(内附Demo)

##我们⾃己的APP对于以下几种情况的⾳音频资源获取情况: 
####1.第三方的⾳音频播放器下载的音频资源。
####2.Apple Music 下载的⾳频资源。 
####3.通过数据线考入的音频资源。


##结论
####1、第三⽅方的⾳音频播放器下载的⾳音频资源: 存放在第三⽅方应⽤用的沙盒⺫⽬目录中由于跨沙盒 限制,⽆无法访问资源。
####2、Apple Music 下载的⾳音频资源: 存放在设备的iPod Library资源库中,可扫描到相关资源, 包括除当前MediaItem的NSURL的所有属性,可进⾏行播放,但由于Apple的版权加密, ⽆无法对⾳音频资源进⾏行操作.
####3、通过数据线考⼊入的⾳音频资源: 存放在设备的iPod Library资源库中,可扫描到相关资源,包 括当前MediaItem的NSURL的所有属性,可进⾏行播放,可对⾳音频资源⽂文件进⾏行操作,获 取到我们⾃自⼰己的APP中。(Demo:GetAudioFromiPod)


##Demo效果图:
![image](https://github.com/LhyPro/iOS-GetAudioFromiPod/blob/master/iOS%E5%85%B3%E4%BA%8E%E5%90%84%E7%A7%8D%E6%9C%AC%E5%9C%B0%E9%9F%B3%E9%A2%91%E7%9A%84%E8%AF%BB%E5%8F%96%E9%97%AE%E9%A2%98/GetAudioFromiPod.gif)
