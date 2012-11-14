//
//  RUIButton.m
//  RemoteUserInterface
//
//  Created by Simon Booth on 11/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSButton.h"
#import "UIViewController+WFSSchematising.h"

@implementation WFSButton

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
        
        if (([self titleForState:UIControlStateNormal].length == 0) && (self.accessibilityLabel.length == 0))
        {
            if (outError) *outError = WFSError(@"Buttons must have a title or an accessibilityLabel");
            return nil;
        }
        
        [self addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [NSString class], @"title" ],
            @[ [UIImage class], @"image" ]
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"title" : [NSString class],
            @"image" : [UIImage class],
            @"actionName" : [NSString class]
            
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([name isEqualToString:@"title"])
    {
        [self setTitle:value forState:UIControlStateNormal];
        return YES;
    }
    else if ([name isEqualToString:@"image"])
    {
        [self setImage:value forState:UIControlStateNormal];
        return YES;
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