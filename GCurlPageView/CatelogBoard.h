//
//  CatelogBoard.h
//

#import "Bee.h"
#import "Bee_UITableBoard.h"
#import "GCurlPageView.h"
#pragma mark -


#pragma mark -

@interface CatelogBoard : BeeUIBoard<GCurlPageViewDataSource>
@property(nonatomic,strong)GCurlPageView *pageView;
@end
