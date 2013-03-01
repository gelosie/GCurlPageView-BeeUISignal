//
//  GCurlPageView.m
//  GCurlPageView
//
//  Created by gelosie.wang@gmail.com on 12-6-11.
//  Copyright (c) 2012年 gelosie.wang@gmail.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GCurlPageView.h"
#import "NSObject+BeeProperty.h"

@interface GCurlPageView(PrivateGCurlPageView)
- (void) loadPrevView;
- (void) loadNextView;

- (void) swiped:(UISwipeGestureRecognizer *)recognizer;
- (void) tapped:(UITapGestureRecognizer *) recognizer;
- (void) exchangeView;
@end

@implementation GCurlPageView

@synthesize dataSource;
@synthesize disabled;

DEF_SIGNAL( VIEW_WILL_CURL)
DEF_SIGNAL( VIEW_DID_CURL)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:tapRecognizer];
        [self addGestureRecognizer:leftSwipeRecognizer];
        [self addGestureRecognizer:rightSwipeRecognizer];
        
        animating = NO;
    }
    return self;
}

-(void) reloadData
{
    if (currentView != nil) {
        [currentView removeFromSuperview];
        currentView = nil;
    }
    if (prevView != nil) {
        [prevView removeFromSuperview];
        prevView = nil;
    }
    if (nextView != nil) {
        [nextView removeFromSuperview];
        nextView = nil;
    }
    
    currentView = [dataSource currentViewInCurlView:self];
    currentView.frame = self.bounds;
    [self addSubview:currentView];
    [self loadNextView];
    [self loadPrevView];
}

- (void) loadPrevView
{
    if (prevView != nil) {
        [prevView removeFromSuperview];
        prevView = nil;
    }
    prevView = [dataSource prevView:currentView inCurlView:self];
    if (prevView != nil) {
        prevView.frame = self.bounds;
        
        prevView.alpha = 0.0;
        [self addSubview:prevView];
        [self sendSubviewToBack:prevView];
        prevView.alpha = 1.0;
        
    }
    
}

- (void) loadNextView
{
    if (nextView != nil) {
        [nextView removeFromSuperview];
        nextView = nil;
    }
    nextView = [dataSource nextView:currentView inCurlView:self];
    if (nextView != nil) {
        nextView.frame = self.bounds;
        
        nextView.alpha = 0.0;
        [self addSubview:nextView];
        [self sendSubviewToBack:nextView];
        nextView.alpha = 1.0;
        
    }
    
}

- (void) tapped:(UITapGestureRecognizer *) recognizer
{
    if (animating || self.disabled ) {
		return;
	}
    
	if (recognizer.state == UIGestureRecognizerStateRecognized) {
		if ([recognizer locationInView:self].x < (self.bounds.size.width - self.bounds.origin.x) / 2) {
            direction = GCurlPageViewDirectionRight;
            if (prevView == nil) {
                return;
            }
		} else {
            direction = GCurlPageViewDirectionLeft;
            if (nextView == nil) {
                return;
            }
		}
	}
    animating = YES;
    [self exchangeView];
}


-(void)swiped:(UISwipeGestureRecognizer *)recognizer{
    
    if (animating || self.disabled) {
		return;
	}
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        direction = GCurlPageViewDirectionLeft;
        if (nextView == nil) {
            return;
        }
    }else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        direction = GCurlPageViewDirectionRight;
        if (prevView == nil) {
            return;
        }
    }
    animating = YES;
    [self exchangeView];
}

- (void) exchangeView
{   

    [UIView animateWithDuration:0.5f animations:^{
        
        [self sendUISignal:GCurlPageView.VIEW_WILL_CURL withObject:self];
        if (direction == GCurlPageViewDirectionLeft) {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES];
            [self bringSubviewToFront:nextView];
        }else{
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
            [self bringSubviewToFront:prevView];
        }
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        if (direction == GCurlPageViewDirectionLeft) {
            UIView *temp = currentView;
            currentView = nextView;
            nextView = nil;
            [self loadNextView];
            [prevView removeFromSuperview];
            prevView = temp;
        }else{
            UIView *temp = currentView;
            currentView = prevView;
            prevView = nil;
            [self loadPrevView];
            [nextView removeFromSuperview];
            nextView = temp;
        }
        animating = NO;
        
        [self sendUISignal:GCurlPageView.VIEW_DID_CURL withObject:self];
        self.userInteractionEnabled = YES;
    }];
}


@end
