//
//  WFSSearchBar.h
//  WorkflowSchema
//
//  Created by Simon Booth on 15/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"
#import "WFSFormInput.h"

extern NSString * WFSSearchBarTextKey;
extern NSString * WFSSearchBarScopeKey;

@interface WFSSearchBar : UISearchBar <WFSSchematising, WFSFormInput>

@property (nonatomic, strong, readonly) id formValue;
@property (nonatomic, strong) NSArray *validations;
@property (nonatomic, weak) id<WFSFormInputDelegate> formInputDelegate;
@property (nonatomic, strong) NSArray *scopeButtonItems;

@property (nonatomic, copy) id searchMessage;
@property (nonatomic, copy) id cancelMessage;
@property (nonatomic, copy) id bookmarkMessage;
@property (nonatomic, copy) id resultsListMessage;
@property (nonatomic, copy) id textDidChangeMessage;

@end
