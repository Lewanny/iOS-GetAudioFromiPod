## iOS 关于设备本地音频的读取问题(内附 Demo)。

### 我们⾃己的 APP 对于以下几种情况的⾳音频资源获取情况：
##### 1、第三方的⾳音频播放器下载的音频资源。
##### 2、Apple Music 下载的⾳频资源。 
##### 3、通过数据线考入的音频资源。


### 结论
##### 1、第三方的音频播放器下载的音频资源：存放在第三⽅应用的沙盒目录中由于跨沙盒限制，无法访问资源。
##### 2、Apple Music 下载的音频资源：存放在设备的 iPod Library 资源库中，可扫描到相关资源，包括除当前 MediaItem 的 NSURL 的所有属性，可进行播放，但由于 Apple 的版权加密，无法对⾳频资源进行操作。
##### 3、通过数据线考入的音频资源：存放在设备的 iPod Library 资源库中，可扫描到相关资源包，括当前 MediaItem 的 NSURL 的所有属性，可进行播放，可对音频资源⽂件进行操作，获取到我们⾃⼰的 APP 中。(Demo：GetAudioFromiPod)


### iOS 如何获取设备内的音乐 Demo 效果图:
![image](https://github.com/LhyPro/iOS-GetAudioFromiPod/blob/master/iOS%E5%85%B3%E4%BA%8E%E5%90%84%E7%A7%8D%E6%9C%AC%E5%9C%B0%E9%9F%B3%E9%A2%91%E7%9A%84%E8%AF%BB%E5%8F%96%E9%97%AE%E9%A2%98/GetAudioFromiPod.gif)
