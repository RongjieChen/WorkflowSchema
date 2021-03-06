//
//  WFSSchema.m
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSchema.h"
#import "WFSSchema+WFSGroupedParameters.h"
#import "WorkflowSchema.h"
#import <objc/runtime.h>

NSString * const WFSClassDoesNotMatchSchemaTypeException = @"WFSClassDoesNotMatchSchemaTypeException";
NSString * const WFSSchemaInvalidException = @"WFSSchemaInvalidException";
NSString * const WFSSchemaInvalidExceptionSchemaKey = @"schema";

@interface WFSSchema ()

@property (nonatomic, copy, readwrite) NSString *typeName;
@property (nonatomic, strong, readwrite) NSArray *parameters;

@property (nonatomic, strong) NSCache *groupedParametersCache;

@end

@implementation WFSSchema

+ (void)initialize
{
    [self registerClass:[NSObject class] forTypeName:@"object"];
    [self registerClass:[UIView class] forTypeName:@"view"];
    [self registerClass:[UIViewController class] forTypeName:@"viewController"];
    
    [self registerClass:[NSString class] forTypeName:@"string"];
    [self registerClass:[NSNumber class] forTypeName:@"number"];
    [self registerClass:[NSNumber class] forTypeName:@"bool"];
    [self registerClass:[UIImage class] forTypeName:@"image"];
    [self registerClass:[NSDate class] forTypeName:@"date"];
    [self registerClass:[NSNull class] forTypeName:@"null"];
    
    [self registerClass:[WFSMessage class] forTypeName:@"message"];
    
    [self registerClass:[WFSTabBarController class] forTypeName:@"tabs"];
    [self registerClass:[WFSNavigationController class] forTypeName:@"navigation"];
    [self registerClass:[WFSScreenController class] forTypeName:@"screen"];
    [self registerClass:[WFSFormController class] forTypeName:@"form"];
    [self registerClass:[WFSTableController class] forTypeName:@"table"];
    
    [self registerClass:[WFSButton class] forTypeName:@"button"];
    [self registerClass:[WFSContainerView class] forTypeName:@"container"];
    [self registerClass:[WFSDatePicker class] forTypeName:@"datePicker"];
    [self registerClass:[WFSImageView class] forTypeName:@"imageView"];
    [self registerClass:[WFSLabel class] forTypeName:@"label"];
    [self registerClass:[WFSNavigationBar class] forTypeName:@"navigationBar"];
    [self registerClass:[WFSSearchBar class] forTypeName:@"searchBar"];
    [self registerClass:[WFSSegmentedControl class] forTypeName:@"segmentedControl"];
    [self registerClass:[WFSSegment class] forTypeName:@"segment"];
    [self registerClass:[WFSSlider class] forTypeName:@"slider"];
    [self registerClass:[WFSSwitch class] forTypeName:@"switch"];
    [self registerClass:[WFSTableCell class] forTypeName:@"tableCell"];
    [self registerClass:[WFSTextField class] forTypeName:@"textField"];
    [self registerClass:[WFSTextView class] forTypeName:@"textView"];
    [self registerClass:[WFSToolbar class] forTypeName:@"toolbar"];
    
    [self registerClass:[WFSTapGestureRecognizer class] forTypeName:@"tapGesture"];
    [self registerClass:[WFSLongPressGestureRecognizer class] forTypeName:@"longPressGesture"];
    [self registerClass:[WFSSwipeGestureRecognizer class] forTypeName:@"swipeGesture"];
    
    [self registerClass:[WFSConditionalAction class] forTypeName:@"conditionalAction"];
    [self registerClass:[WFSMultipleAction class] forTypeName:@"multipleActions"];
    [self registerClass:[WFSSendMessageAction class] forTypeName:@"sendMessage"];
    [self registerClass:[WFSShowAlertAction class] forTypeName:@"showAlert"];
    [self registerClass:[WFSShowActionSheetAction class] forTypeName:@"showActionSheet"];
    [self registerClass:[WFSLoadSchemaAction class] forTypeName:@"loadSchema"];
    [self registerClass:[WFSPushControllerAction class] forTypeName:@"pushController"];
    [self registerClass:[WFSPresentControllerAction class] forTypeName:@"presentController"];
    [self registerClass:[WFSPopControllerAction class] forTypeName:@"popController"];
    [self registerClass:[WFSDismissControllerAction class] forTypeName:@"dismissController"];
    [self registerClass:[WFSReplaceRootControllerAction class] forTypeName:@"replaceRootController"];
    [self registerClass:[WFSShowViewsAction class] forTypeName:@"showViews"];
    [self registerClass:[WFSHideViewsAction class] forTypeName:@"hideViews"];
    [self registerClass:[WFSUpdateViewsAction class] forTypeName:@"updateViews"];
    [self registerClass:[WFSStoreValueAction class] forTypeName:@"storeValue"];
    [self registerClass:[WFSEndEditingAction class] forTypeName:@"endEditing"];
    
    [self registerClass:[WFSFormAccessoryView class] forTypeName:@"formAccessoryView"];
    [self registerClass:[WFSFormTrigger class] forTypeName:@"trigger"];
    
    [self registerClass:[WFSNegatedCondition class] forTypeName:@"not"];
    [self registerClass:[WFSComparisonCondition class] forTypeName:@"isLessThan"];
    [self registerClass:[WFSComparisonCondition class] forTypeName:@"isLessThanOrEqualTo"];
    [self registerClass:[WFSComparisonCondition class] forTypeName:@"isGreaterThanOrEqualTo"];
    [self registerClass:[WFSComparisonCondition class] forTypeName:@"isGreaterThan"];
    [self registerClass:[WFSEqualityCondition class] forTypeName:@"isEqual"];
    [self registerClass:[WFSMultipleCondition class] forTypeName:@"multipleConditions"];
    [self registerClass:[WFSPresenceCondition class] forTypeName:@"isPresent"];
    [self registerClass:[WFSRegularExpressionCondition class] forTypeName:@"doesMatchRegularExpression"];
    [self registerClass:[WFSTruthinessCondition class] forTypeName:@"isTrue"];
    
    [self registerClass:[WFSActionButtonItem class] forTypeName:@"actionButtonItem"];
    [self registerClass:[WFSCancelButtonItem class] forTypeName:@"cancelButtonItem"];
    [self registerClass:[WFSDestructiveButtonItem class] forTypeName:@"destructiveButtonItem"];
    [self registerClass:[WFSBarButtonItem class] forTypeName:@"barButtonItem"];
    [self registerClass:[WFSTabBarItem class] forTypeName:@"tabBarItem"];
    [self registerClass:[WFSNavigationItem class] forTypeName:@"navigationItem"];
    
    [self registerClass:[WFSTableSection class] forTypeName:@"tableSection"];
}

- (id)initWithTypeName:(NSString *)typeName attributes:(NSDictionary *)attributes parameters:(NSArray *)parameters
{
    self = [super init];
    if (self)
    {
        _typeName = [typeName copy];
        _attributes = attributes;
        _parameters = parameters;
        
        Class schemaClass = [self schemaClass];
        if (!schemaClass) return nil;
    }
    return self;
}

+ (NSMutableDictionary *)registeredClasses
{
    static NSMutableDictionary *registeredTypes = nil;
    if (!registeredTypes)
    {
        registeredTypes = [NSMutableDictionary dictionary];
    }
    
    return registeredTypes;
}

+ (void)registerClass:(Class<WFSSchematising>)schemaClass forTypeName:(NSString *)typeName
{
    [self registeredClasses][typeName] = schemaClass;
}

+ (Class<WFSSchematising>)registeredClassForTypeName:(NSString *)typeName
{
    return [self registeredClasses][typeName];
}

+ (NSArray *)registeredTypeNames
{
    return [[self registeredClasses] allKeys];
}

- (NSLocale *)locale
{
    if (_locale) return _locale;
    
    // We assume that the schema was written by the same people as the app, so their language is the default.
    NSString *localeIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:CFBridgingRelease(kCFBundleDevelopmentRegionKey)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    if (locale) return locale;
    
    return [NSLocale systemLocale];
}

- (NSString *)styleName
{
    return self.attributes[@"class"];
}

- (NSString *)workflowName
{
    return self.attributes[@"name"];
}

- (Class<WFSSchematising>)schemaClass
{
    Class baseClass = [WFSSchema registeredClassForTypeName:self.typeName];
    NSString *className = NSStringFromClass(baseClass);
    
    if (self.styleName)
    {
        className = [NSString stringWithFormat:@"%@.%@", className, self.styleName];
    }
    
    Class subClass = NSClassFromString(className);
    
    if (!subClass)
    {
        subClass = (Class)objc_allocateClassPair(baseClass, [className UTF8String], 0);
        if (subClass)
        {
            objc_registerClassPair(subClass);
        }
    }
    
    return subClass;
}

- (id<WFSSchematising>)createObjectWithContext:(WFSContext *)context error:(NSError **)outError
{
    NSError *error = nil;
    id<WFSSchematising> object = nil;
    
    @try
    {
        Class schemaClass = [self schemaClass];
        
        if (!schemaClass)
        {
            error = WFSError(@"Failed to create class for object");
        }
        else
        {
            object = [[schemaClass alloc] initWithSchema:self context:context error:&error];
            if (object)
            {
                [context.schemaDelegate schema:self didCreateObject:object withContext:context];
            }
            else
            {
                if (!error) error = WFSError(@"Failed to create object");
            }
        }
    }
    @catch (NSException *exception)
    {
        if (!error) error = WFSErrorFromException(exception);
        object = nil;
    }
    
    if (outError) { *outError = error; }
    return object;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ typeName:%@ attributes:%@ parameters:%@", [super description], self.typeName, self.attributes, self.parameters];
}

@end

@implementation WFSMutableSchema

- (id)initWithTypeName:(NSString *)typeName attributes:(NSDictionary *)attributes
{
    return [super initWithTypeName:typeName attributes:attributes parameters:nil];
}

- (void)addParameter:(id)parameter
{
    if (!self.parameters) self.parameters = [NSArray array];
    self.parameters = [self.parameters arrayByAddingObject:parameter];
}

@end
