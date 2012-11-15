//
//  WFSBarButtonItem.m
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSBarButtonItem.h"
#import "WFSSchema+WFSGroupedParameters.h"
#import "UIViewController+WFSSchematising.h"

@implementation WFSBarButtonItem

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    if (!groupedParameters) return nil;
    
    NSString *title = groupedParameters[@"title"];
    UIImage *image = groupedParameters[@"image"];
    NSNumber *systemItem = groupedParameters[@"systemItem"];
     
    if ((image && title) || (image && systemItem) || (title && systemItem))
    {
        if (outError) *outError = WFSError(@"Bar button items must only have one of: title, image, systemItem.");
        return nil;
    }
    
    NSString *accessibilityLabel = groupedParameters[@"accessibilityLabel"];
    
    if (image && !accessibilityLabel)
    {
        if (outError) *outError = WFSError(@"Bar button image items must have an accessibility label");
        return nil;
    }
    
    NSNumber *styleValue = groupedParameters[@"style"];
    if (!styleValue) styleValue = @(UIBarButtonItemStyleBordered);
    UIBarButtonItemStyle style = [styleValue integerValue];
    
    if ([image isKindOfClass:[UIImage class]])
    {
        self = [super initWithImage:image style:style target:self action:@selector(tapped:)];
    }
    else if ([title isKindOfClass:[NSString class]])
    {
        self = [super initWithTitle:title style:style target:self action:@selector(tapped:)];
    }
    else if ([systemItem isKindOfClass:[NSNumber class]])
    {
        self = [super initWithBarButtonSystemItem:[systemItem integerValue] target:self action:@selector(tapped:)];
    }
    else
    {
        if (outError) *outError = WFSError(@"Could not find appropriate initialiser for bar button item.");
        return nil;
    }
    
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
        
        if (self.accessibilityLabel)
        {
            UIView *view = [self valueForKey:@"view"];
            view.accessibilityLabel = self.accessibilityLabel;
            view.accessibilityHint = self.accessibilityHint;
        }
        
    }
    return self;
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [NSString class], @"title" ],
            @[ [UIImage class], @"image"]

    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"image" : [UIImage class],
            @"title" : [NSString class],
            @"style" : @[ [NSString class], [NSNumber class] ],
            @"systemItem" : @[ [NSString class], [NSNumber class] ],
            @"accessibilityLabel" : [NSString class],
            @"accessibilityHint" : [NSString class],
            @"actionName" : [NSString class]
    
    }];
}

+ (NSDictionary *)enumeratedSchemaParameters
{
    return [[super enumeratedSchemaParameters] dictionaryByAddingEntriesFromDictionary:@{
            
            @"style" : @{
            
                    @"plain"    : @(UIBarButtonItemStylePlain),
                    @"bordered" : @(UIBarButtonItemStyleBordered),
                    @"done"     : @(UIBarButtonItemStyleDone)
            
            },
            
            @"systemItem" : @{
            
                    @"done"          : @(UIBarButtonSystemItemDone),
                    @"cancel"        : @(UIBarButtonSystemItemCancel),
                    @"edit"          : @(UIBarButtonSystemItemEdit),
                    @"save"          : @(UIBarButtonSystemItemSave),
                    @"add"           : @(UIBarButtonSystemItemAdd),
                    @"flexibleSpace" : @(UIBarButtonSystemItemFlexibleSpace),
                    @"fixedSpace"    : @(UIBarButtonSystemItemFixedSpace),
                    @"compose"       : @(UIBarButtonSystemItemCompose),
                    @"reply"         : @(UIBarButtonSystemItemReply),
                    @"action"        : @(UIBarButtonSystemItemAction),
                    @"organize"      : @(UIBarButtonSystemItemOrganize),
                    @"bookmarks"     : @(UIBarButtonSystemItemBookmarks),
                    @"search"        : @(UIBarButtonSystemItemSearch),
                    @"refresh"       : @(UIBarButtonSystemItemRefresh),
                    @"stop"          : @(UIBarButtonSystemItemStop),
                    @"camera"        : @(UIBarButtonSystemItemCamera),
                    @"trash"         : @(UIBarButtonSystemItemTrash),
                    @"play"          : @(UIBarButtonSystemItemPlay),
                    @"pause"         : @(UIBarButtonSystemItemPause),
                    @"rewind"        : @(UIBarButtonSystemItemRewind),
                    @"fastForward"   : @(UIBarButtonSystemItemFastForward),
                    @"undo"          : @(UIBarButtonSystemItemUndo),
                    @"redo"          : @(UIBarButtonSystemItemRedo),
                    @"pageCurl"      : @(UIBarButtonSystemItemPageCurl)
            
            }
            
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([@[ @"image", @"title", @"style" ] containsObject:name])
    {
        // we had to deal with these in advance
        return YES;
    }
    else if ([name isEqualToString:@"action"])
    {
        return [super setSchemaParameterWithName:@"tapAction" value:value context:context error:outError];
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

- (void)tapped:(id)sender
{
    WFSMutableContext *context = [self.workflowContext mutableCopy];
    context.actionSender = sender;
    WFSMessage *message = [WFSMessage actionMessageWithName:self.actionName context:context];
    [context sendWorkflowMessage:message];
}

@end