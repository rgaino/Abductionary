//
//  StarSprite.h
//  Abductionary
//
//  Created by Rafael Gaino on 9/21/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "cocos2d.h"

@interface StarSprite : CCSprite
{

}

+ (id) starSprite;
-(void) setupStar;
+(NSString*) getRandomStar;

@end
