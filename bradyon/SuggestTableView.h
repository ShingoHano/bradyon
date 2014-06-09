//
//  SuggestTableView.h
//  GoogleSuggestSample
//
//  Created by takeuchi on 11/08/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestTableView : UITableView {
	SEL touchSelector;
}

@property (nonatomic, assign) SEL touchSelector;

@end

