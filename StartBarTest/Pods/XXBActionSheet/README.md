# XXBActionSheet
#和UIActionSheet 一样好用
## 目前已经全面支持ios7.0+
支持pod
```c
pod 'XXBActionSheet',:git => 'https://github.com/sixTiger/XXBActionSheet'
```

``` c
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // 1.创建XXBActionSheet对象, 可以随意设置标题个数，第一个为取消按钮的标题，需要设置代理才能监听点击结果
    XXBActionSheet *sheet = [[XXBActionSheet alloc] initWithTitle:@"title" delegate:self cancelButtonTitle:@"cancale" otherButtonTitles:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];
    // 2.显示出来
    [sheet showInView:self.view];
}

// 3.实现代理方法，需要遵守XXBCActionSheetDelegate代理协议
- (void)actionSheet:(XXBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@",@(buttonIndex));
}
```
#iphone的效果图
![image](./image/1.png)<br>
![image](./image/2.png)<br>
![image](./image/3.png)<br>
![image](./image/4.png)<br>
