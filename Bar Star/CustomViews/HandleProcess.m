//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "HandleProcess.h"
#import <QuartzCore/QuartzCore.h>
#import "BarAppDelegate.h"
#import "BarUtility.h"
@interface CornView : UIView
{
	
}
-(void)roundRectViewCornerRadius:(float)radius;
@end

@implementation CornView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if(self != nil)
	{
		[self roundRectViewCornerRadius:10];
	}
	return self;
}

-(void)roundRectViewCornerRadius:(float)radius
{
	self.layer.cornerRadius = radius;
	self.clipsToBounds = YES;
}
@end


@implementation HandleProcess
@synthesize ParentView = _parentView;
@synthesize act = _act;
@synthesize tView= _tView;

+(HandleProcess*)HandleProcess:(UIView*)parentView{
	HandleProcess * tmpActive = [[HandleProcess alloc] initWithParentView:parentView];
	return [tmpActive autorelease];
}

-(id)initWithParentView:(UIView*)parentView{
	if (self = [super init]){
		self.ParentView = parentView;
     
        
		_tView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.f,[BarUtility SCREEN_HEIGHT])];
		[self.tView setBackgroundColor:[UIColor clearColor]];
		
		_act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.f, 25.f)];
		[self.act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
		
		CornView * mTv =[[CornView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.f, 60.f)];
		[mTv setBackgroundColor:[UIColor colorWithRed:0.0 green:0 blue:0.0 alpha:0.6]];
//        [mTv setBackgroundColor:[UIColor darkGrayColor]];
		[mTv addSubview:self.act];
		[self.act setCenter:mTv.center];
		
		[self.tView addSubview:mTv];
		[mTv setCenter:CGPointMake(160.f, 210.f)];
		[mTv release];
	}
	return self;
}

-(void)dealloc {
	[_tView release];
	[_act release];
	[super dealloc];
}

-(void)ShowProcessView {
	if (self.ParentView==nil) {
		return;		
	}
	
	if ([self.tView superview] !=nil) {
		return;
	}
	[self.tView setHidden:NO];
	[self.ParentView addSubview:self.tView];
	[self.ParentView bringSubviewToFront:self.tView];
	[self.act startAnimating];
}

-(void)HideProcessView
{
	if ([self.tView superview] ==nil) {
		return;
	}
	[self.act stopAnimating];
	[self.tView setHidden:YES];
	[self.tView removeFromSuperview];
}
@end








