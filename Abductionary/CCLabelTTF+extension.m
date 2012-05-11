//
//  CCLabelTTF+extension.m
//  Abductionary
//
//  Created by Rafael Gaino on 5/11/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "CCLabelTTF+extension.h"

@implementation CCLabelTTF (extension)

-(void) shrinkFontSizeToFitWidth:(CGFloat)width 
{
    float fontSize = [self fontSize];
    float fontAdjustmentStep = 0.5f;
    
    NSLog(@"self.width is %.2f", self.contentSize.width);
    while(self.contentSize.width > width)
    {
        NSLog(@"self.width is %.2f", self.contentSize.width);
        fontSize -= fontAdjustmentStep;
        [self setFontSize:fontSize];
        
        if( fontSize < 5) 
        {
            break; 
        }
    }
}

@end
