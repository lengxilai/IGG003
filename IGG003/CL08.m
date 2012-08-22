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
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(85, 220, 150, 100)];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(110, 320, 100, 10)];
    pageControl.hidden = NO;
    
    
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor clearColor];
    
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self loadScrollViewWithPage:pageControl.currentPage];
    
    [[[CCDirector sharedDirector] openGLView] addSubview:scrollView];
    [[[CCDirector sharedDirector] openGLView] addSubview:pageControl];
    
	//[[CCDirector sharedDirector] openGLView].userInteractionEnabled = NO;
    
	return self;
}

// 返回菜单页面
-(void)gobackMenu
{
    //[m_tableView removeFromSuperview];
    [[CCDirector sharedDirector] replaceScene:[S00 scene:NO]];
}
- (void) dealloc
{
	//[m_tableView release];
    
    [views release];
    [scrollView release];
    [pageControl release];
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

// 应用展示控制
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // replace the placeholder if necessary
    UIView *view = [views objectAtIndex:page];
    if (view == nil)
    {
        view =[self getViewByPageNumber:page];
        [views replaceObjectAtIndex:page withObject:view];
        
    }
    
    // add the controller's view to the scroll view
    if (view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [scrollView addSubview:view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

-(UIView*)getViewByPageNumber:(int)page{
    UIView *view = [[[UIImageView alloc] init] autorelease];
    view.userInteractionEnabled = YES;
    //UIImageView *imageview = [[UIImageView alloc] initWithFrame: CGRectMake(45, 0, 64, 64)];
    UIButton *imagebtn = nil;
    CGRect imagebtnFram = CGRectMake(45, 0, 64, 64);
    UILabel *name = [[[UILabel alloc] initWithFrame:CGRectMake(0, 76, 150, 20)] autorelease];
    name.backgroundColor = [UIColor clearColor];
    name.font = [UIFont systemFontOfSize:16];
    name.textAlignment = UITextAlignmentCenter;
    switch (page) {
        case 0:
            name.text = @"Pomodoro";
            //imageview.image = [UIImage imageNamed:@"pomodoro.png"];
            imagebtn = [self buttonWithImage:@"pomodoro.png" target:self selector:@selector(go2DownLoadApp:) frame:imagebtnFram];
            imagebtn.tag = AppID_Pomodoro;
            break;
        case 1:
            name.text = @"Ten Years Diary";
            //imageview.image = [UIImage imageNamed:@"tenyeardiaryicon.png"];
            imagebtn = [self buttonWithImage:@"tenyeardiaryicon.png" target:self selector:@selector(go2DownLoadApp:) frame:imagebtnFram];
            imagebtn.tag = AppID_TenYearsDiary;
            break;
        case 2:
            name.text = @"Trip Checker";
            imagebtn = [self buttonWithImage:@"tripcheckericon.png" target:self selector:@selector(go2DownLoadApp:) frame:imagebtnFram];
            //imageview.image = [UIImage imageNamed:@"tripcheckericon.png"];
            imagebtn.tag = AppID_TripChecker;
            break;
        default:
            break;
    }
    
    [view addSubview:imagebtn];
    [view addSubview:name];
    
    // 资源释放
    //[imagebtn release];
    //[name release];
    
    return view;
}

// 下载应用
-(void)go2DownLoadApp:(id) sender{
    NSString *str = [NSString stringWithFormat: 
                     @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d", 
                     [sender tag]];  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

// 用图片做一个按钮
- (UIButton *)buttonWithImage:(NSString *)imageName target:(id)target selector:(SEL)inSelector frame:(CGRect)frame{
    UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	if (imageName != nil) {
		UIImage *newImage = [UIImage imageNamed:imageName];
		[button setBackgroundImage:newImage forState:UIControlStateNormal];
	}
    [button addTarget:target action:inSelector forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenDisabled = YES;
    button.adjustsImageWhenHighlighted = YES;
    [button setBackgroundColor:[UIColor clearColor]];   // in case the parent view draws with a custom color or gradient, use a transparent color
    return button;
}

@end
