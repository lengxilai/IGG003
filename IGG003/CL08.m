//
//  CL08.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "CL08.h"
#import "AppDelegate.h"

static NSUInteger kNumberOfPages = 3;

@implementation CL08

- (id) init
{
	[super init];
    
    // 背景图片
    IGSprite *bak = [IGSprite spriteWithFile:@"sl01.png"];
    bak.position = ccp(kWindowW/2,kWindowH/2);
    [self addChild:bak];
    
    // 标题提示字
    CCLabelBMFont *title= [CCLabelBMFont labelWithString:@"About" fntFile:@"bitmapFont2.fnt"];
    title.position = ccp(kWindowW/2, 460);
    [self addChild:title];
    
    
    // 现在评价
    CCLabelBMFont *comments= [CCLabelBMFont labelWithString:@"Make comments now" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi0 = [CCMenuItemLabel itemWithLabel:comments target:self selector:@selector(go2CommentApp)];
    
    // 联系我们
    CCLabelBMFont *contact = [CCLabelBMFont labelWithString:@"Contact us" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi1 = [CCMenuItemLabel itemWithLabel:contact target:self selector:@selector(launchMailAppOnDeviceToOur)];
    
    // 关注我们
    CCLabelBMFont *care = [CCLabelBMFont labelWithString:@"Care about us" fntFile:@"bitmapFont.fnt"];
    CCMenuItemLabel *mi2 = [CCMenuItemLabel itemWithLabel:care target:self selector:@selector(go2OurWebSite)];
    
    CCMenu* about =[CCMenu menuWithItems:mi0,mi1,mi2,nil];
    
    about.position=ccp(kWindowW/2, 370);
    [about alignItemsVerticallyWithPadding:0];
    [self addChild:about];
    
    // 提示字
    CCLabelBMFont *other= [CCLabelBMFont labelWithString:@"Other applications" fntFile:@"bitmapFont2.fnt"];
    other.position = ccp(130, 280);
    [self addChild:other];
    
    //添加一个返回游戏按钮；
    CCSprite* menuNormal=[CCSprite spriteWithSpriteFrameName:@"btn7-1.png"];
    CCSprite* menuSecelt=[CCSprite spriteWithSpriteFrameName:@"btn7-2.png"];
    
    CCMenuItemSprite* menuSprite=[CCMenuItemSprite itemFromNormalSprite:menuNormal selectedSprite:menuSecelt target:self selector:@selector(gobackMenu)];
    CCMenu* menu=[CCMenu menuWithItems:menuSprite,nil];
    menu.position=ccp(kWindowW/2, 100);
    [self addChild:menu];
    
	// 其他应用显示区域
    CCMenuItemImage *app0 = [CCMenuItemImage itemFromNormalImage:@"pomodoro.png" selectedImage:@"pomodoro.png" target:self selector:@selector(go2DownLoadApp:)];
    app0.tag = AppID_Pomodoro;
    
    CCMenuItemImage *app1 = [CCMenuItemImage itemFromNormalImage:@"tripcheckericon.png" selectedImage:@"tripcheckericon.png" target:self selector:@selector(go2DownLoadApp:)];
    app1.tag = AppID_TripChecker;
    
    // 标题提示字
    [CCMenuItemFont setFontSize:20];
    CCMenuItemFont *pomodoro = [CCMenuItemFont itemFromString:@"Pomodoro" target:self selector:@selector(go2DownLoadApp:)];
    pomodoro.tag = AppID_Pomodoro;
    
    CCMenuItemFont *tripChecker = [CCMenuItemFont itemFromString:@"Trip Check" target:self selector:@selector(go2DownLoadApp:)];
    tripChecker.tag = AppID_TripChecker;
    
    CCMenu* apps=[CCMenu menuWithItems:app0,app1,pomodoro,tripChecker,nil];
    [apps alignItemsInColumns:[NSNumber numberWithInt:2],[NSNumber numberWithInt:2],nil];
     apps.position=ccp(kWindowW/2, 200);
    [self addChild:apps];
	return self;
}

// 返回菜单页面
-(void)gobackMenu
{
    [[CCDirector sharedDirector] replaceScene:[S00 scene:NO]];
}
- (void) dealloc
{
	[super dealloc];
}

// 去评论页面
-(void)go2CommentApp{
    NSString *str = [NSString stringWithFormat: 
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", AppID_FruitBoBo];  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

// 去我们的网站
-(void)go2OurWebSite{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.iguor.com"]];
}

// 发送邮件
-(void)launchMailAppOnDeviceToOur
{	
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=%@",@"igurhelp@163.com",@""];
	NSString *body = [NSString stringWithFormat:@"&body=%@",@""];
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// 下载应用
-(void)go2DownLoadApp:(id) sender{
    NSString *str = [NSString stringWithFormat: 
                     @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d", 
                     [sender tag]];  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
