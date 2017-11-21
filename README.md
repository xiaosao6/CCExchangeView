
# CCExchangeView
A simple subclass of UIView contains two labels and an UIImageView in horizental direction, You can use for exchange two label with animation, typically Address.

一个简单的切换View,包含左右两个UILabel和中间图片，方便实现地址的左右切换效果

---
# CCExchangeView
-------------


### 示例:  
```swift
let exview = CCExchangeView.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 100))
exview.exchangeImgv.image = #imageLiteral(resourceName: "exchange-icon")
exview.labelTextFont = UIFont.systemFont(ofSize: 19)
exview.labelTextColor = UIColor.blue
self.view.addSubview(exview)
        
exview.fromText = "北京市"
exview.toText   = "广西自治区"
```

### 特性
- 可配置项:左右边距、Label字体/文字颜色、图片内容/尺寸

- 手写autoLayout, 未依赖Snapkit

### 原理说明
进行动画时，使用两个临时的Label代替原本的label进行位移动画，结束后移除并显示出原本的label;
解决了设置约束并执行完动画后，处理新的约束产生的显示问题

### 使用方法
直接下载工程，拷贝CCExchangeView.swift文件，即可使用

### 注意事项
需要自己提供中间图片以供旋转动画显示


## License
none


