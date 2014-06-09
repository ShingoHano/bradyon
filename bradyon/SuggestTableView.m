//
//  SuggestTableView.m
//  GoogleSuggestSample
//
//  Created by takeuchi on 11/08/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SuggestTableView.h"

@implementation SuggestTableView

@synthesize touchSelector;

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {

	if ([self.delegate respondsToSelector:touchSelector])
    {
//		[self.delegate performSelector:touchSelector withObject:self];
	}
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {

	[super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesCancelled:touches withEvent:event];
}

@end
