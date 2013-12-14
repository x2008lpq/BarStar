//  Created by Newline Analytics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import <Foundation/Foundation.h>

@interface HandleProcess : NSObject {
	id			_parentView;
	UIView*		_tView;
	UIActivityIndicatorView * _act;
}

@property(nonatomic,retain)UIView* tView;
@property(nonatomic,retain)UIActivityIndicatorView * act;
@property(assign)id ParentView;

+(HandleProcess*)HandleProcess:(UIView*)parentView;

-(id)initWithParentView:(UIView*)parentView;

-(void)ShowProcessView;
-(void)HideProcessView;
@end
