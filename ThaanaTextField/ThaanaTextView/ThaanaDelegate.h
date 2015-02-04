//
//  ThaanaDelegate.h
//  ThaanaTextField
//
//  Created by Mohamed Jinah Adam on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface ThaanaDelegate : NSObject <UITextViewDelegate> 
//factory method that returns a thaanaDelegate Object. 
+(ThaanaDelegate *) thaanaDelegate;


@end
