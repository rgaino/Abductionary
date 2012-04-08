//
//  I18nManager.m
//  Abductionary
//
//  Created by Rafael Gaino on 4/8/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "I18nManager.h"

@implementation I18nManager


static I18nManager* _i18nManager = nil;


+(I18nManager *) getInstance
{
	@synchronized([I18nManager class])
	{
		if (!_i18nManager)
			[[self alloc] init];
        
		return _i18nManager;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([I18nManager class])
	{
		NSAssert(_i18nManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_i18nManager = [super alloc];
		return _i18nManager;
	}
    
	return nil;
}

-(id)init 
{
	self = [super init];
	if (self != nil) {

	}
    
	return self;
}


@end
