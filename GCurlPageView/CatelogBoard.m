//
//  CatelogBoard.m
//

#import "CatelogBoard.h"
#import "Bee_Debug.h"
#import "Bee_Runtime.h"


#pragma mark -

@implementation CatelogBoard
@synthesize pageView;

- (void)load
{
	[super load];
}

- (void)unload
{	
	[super unload];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];

	if ( [signal isKindOf:BeeUIBoard.SIGNAL] )
	{
		if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
		{
            self.view.backgroundColor = [UIColor whiteColor];
            self.pageView = [[GCurlPageView alloc]initWithFrame:self.view.bounds];
            self.pageView.dataSource = self;
            
            [self.view addSubview:self.pageView];
            [self.pageView reloadData];
		}
		else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
		{
		}
        
        NSLog(@"----------  xxxx curl ");
	}
}
//handleBeeUITabBar
- (void)handleUISignal_GCurlPageView:(BeeUISignal *)signal
{
    if ( [signal is:GCurlPageView.VIEW_WILL_CURL] )
    {
        NSLog(@"----------  will curl ");
    }else if( [signal is:GCurlPageView.VIEW_DID_CURL] ){
        NSLog(@"----------  did curl ");
    }
}


- (UIView *) nextView:(UIView *) currentView inCurlView:(GCurlPageView *) curlPage
{
    NSInteger index = currentView.tag;
    index ++;
    BeeUILabel *lable = [[BeeUILabel alloc]initWithFrame:curlPage.bounds];
    lable.tag = index;
    lable.font = [UIFont systemFontOfSize:64];
    lable.text = [NSString stringWithFormat:@"%d",index];
    lable.textColor = [UIColor redColor];
    lable.backgroundColor = [UIColor whiteColor];
    return lable;
}

- (UIView *) prevView:(UIView *) currentView inCurlView:(GCurlPageView *) curlPage
{
    NSInteger index = currentView.tag;
    index --;
    BeeUILabel *lable = [[BeeUILabel alloc]initWithFrame:curlPage.bounds];
    lable.tag = index;
    lable.font = [UIFont systemFontOfSize:64];
    lable.text = [NSString stringWithFormat:@"%d",index];
    lable.textColor = [UIColor redColor];
    lable.backgroundColor = [UIColor whiteColor];
    return lable;
}

- (UIView *) currentViewInCurlView:(GCurlPageView *) curlPage
{
    BeeUILabel *lable = [[BeeUILabel alloc]initWithFrame:self.view.bounds];
    lable.tag = 100;
    lable.font = [UIFont systemFontOfSize:64];
    lable.textColor = [UIColor redColor];
    lable.text = @"100";
    lable.backgroundColor = [UIColor whiteColor];
    
    return lable;
}
@end
