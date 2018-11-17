//
//  BP_MacroHeader.h
//  BaseProject
//
//  Created by 意一yiyi on 2018/11/5.
//  Copyright © 2018 意一yiyi. All rights reserved.
//

#ifndef BP_MacroHeader_h
#define BP_MacroHeader_h

//-----------IP地址或域名-----------//
#define Domain_Name @""


//-----------三方AppKey和Secret-----------//
#define UM_App_Key @""
#define Weibo_App_Key @""
#define Weibo_App_Secret @""
#define Weibo_Redirect_URL @""
#define Wechat_App_Key @""
#define Wechat_App_Secret @""
#define QQ_App_Key @""
#define QQ_App_Secret @""
#define QQ_Redirect_URL @""
#define JPush_App_Key @""
#define JPush_App_Secret @""


//-----------常用颜色-----------//
#define Theme_Color Color_With_RGB(99, 156, 210, 1)// 主题色
#define Second_Theme_Color Color_With_RGB(240, 179, 62, 1)// 第二主题色

#define Default_VC_Background_Color Color_With_RGB(234, 234, 234, 1)// 默认页面背景色

#define Default_Navigation_Bar_Tint_Color Theme_Color// 默认导航栏颜色
#define Default_Navigation_Bar_Title_Color [UIColor whiteColor]// 默认导航栏中间字体颜色
#define Default_Navigation_Bar_Bar_Button_Item_Color [UIColor whiteColor]// 默认导航栏BarButtonItem颜色

#define Default_Tab_Bar_Tint_Color [UIColor whiteColor]// 默认TabBar颜色
#define Default_Tab_Bar_Selected_Item_Tint_Color Theme_Color// 默认TabBar选中时颜色
#define Default_Tab_Bar_Unselected_Item_Tint_Color Color_With_RGB(150, 150, 150, 1)// 默认TabBar未选中时颜色


//-----------字体大小和颜色-----------//
#define First_Level_Font_Size 16.0
#define Second_Level_Font_Size 14.0
#define Third_Level_Font_Size 12.0

#define First_Level_Text_Color Color_With_Hex(0x333333, 1)
#define Second_Level_Text_Color Color_With_Hex(0x666666, 1)
#define Third_Level_Text_Color Color_With_Hex(0x999999, 1)





//-----------系统版本-----------//
#define System_Version [[UIDevice currentDevice].systemVersion floatValue]


//-----------机型-----------//
#define Device_Is_iPhone5 CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568))
#define Device_Is_iPhone6 CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 667))
#define Device_Is_iPhone6Plus CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736))
#define Device_Is_iPhoneX CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812))


//-----------常用屏幕参数-----------//
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Status_Bar_Height (Device_Is_iPhoneX ? 44.0 : 20.0)
#define Navigation_Bar_Height (Status_Bar_Height + 44.0)
#define Tab_Bar_Height (Device_Is_iPhoneX ? 83.0 : 49.0)


//-----------颜色-----------//
#define Color_With_Hex(hex, α) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:α]
#define Color_With_RGB(r, g, b, α) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:α]


//-----------其它常用宏-----------//
#define Key_Window [UIApplication sharedApplication].keyWindow
#define NS_User_Defaults [NSUserDefaults standardUserDefaults]
#define NS_Notification_Center [NSNotificationCenter defaultCenter]


//-----------判断字符串是否为空-----------//
// 注意：之所以不通过给NSString添加分类的方法来判断，而采用此处的宏，是因为如果服务端返回的万一不是一个string类型，比如（string == nil）或者（string == NULL），它根本就不是一个NSString类，所以不会走NSString分类的方法，会判断失败。
#define String_Is_Empty(string) ([string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"] || [string isEqualToString:@"NULL"] || string == NULL || [string isKindOfClass:[NSNull class]] || string == nil || ((NSString *)string).length == 0)

#endif /* BP_MacroHeader_h */
