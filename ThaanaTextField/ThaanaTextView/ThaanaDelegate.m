//
//  ThaanaDelegate.m
//  ThaanaTextField
//
//  Created by Mohamed Jinah Adam on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThaanaDelegate.h"

@interface ThaanaDelegate()

@property (nonatomic,strong)NSMutableArray *lines;

@end

@implementation ThaanaDelegate

#pragma mark -
#pragma mark Overide UITextViewDelegate

- (id)init
{
    self = [super init];
    if (self) {
        self.lines = [[NSMutableArray alloc] initWithCapacity: 10];
        [self.lines addObject: [NSMutableString stringWithCapacity: 255]];
       
    }
    return self;
}


+(ThaanaDelegate *) thaanaDelegate {
       return [[ThaanaDelegate alloc] init];
}

//overiding the UITextViewDelegate Method
-(BOOL) textView:(UITextView*) textView shouldChangeTextInRange:(NSRange) range replacementText:(NSString*) text {
    NSRange rng;
    textView.text = [self reverseText: text
                                       withFont: textView.font
                                 carretPosition: &rng 
                                          Bounds: textView.bounds];
    
    textView.selectedRange = rng;
    [textView scrollRangeToVisible:rng];
    return NO;
}


#pragma mark -
#pragma mark Main Logic

-(NSString*) reverseText:(NSString*) text withFont:(UIFont*) font carretPosition:(NSRange*) cpos Bounds:(CGRect) bounds {
    
    cpos->length = 0;
    cpos->location = 0;
    if( [text length] ) {
        if( ![text isEqualToString: @"\n"] ) {
            [self insertText:text];
        } else {
            [self.lines addObject: [NSMutableString stringWithCapacity: 255]];
        }
    } else {
        //backspace
        //TODO:
        NSRange del_rng;
        del_rng.length = 1;
        del_rng.location = 0;
        if( [(NSMutableString*)[self.lines lastObject] length] ) {
            [(NSMutableString*)[self.lines lastObject] deleteCharactersInRange: del_rng];
        }
        if( ![(NSMutableString*)[self.lines lastObject] length] ) {
            // NSLog(@"%d is the line count", [lines count]);
            if([self.lines count] > 1) [self.lines removeLastObject];
        }
    }
    
    CGSize sz = [(NSString*)[self.lines lastObject] sizeWithFont: font];
    if( sz.width >= bounds.size.width-15 ) {
        NSMutableArray* words = [NSMutableArray arrayWithArray: [(NSString*)[self.lines lastObject] componentsSeparatedByString: @" "]];
        NSString* first_word = words[0];
        [words removeObjectAtIndex: 0];
        [(NSMutableString*)[self.lines lastObject] setString: [words componentsJoinedByString: @" "]];
        [self.lines addObject: [NSMutableString stringWithString: first_word]];
    }
    
    NSMutableString* txt = [NSMutableString stringWithCapacity: 100];
    for(int i=0; i<[self.lines count]; ++i) {
        NSString* line = self.lines[i];
        if( i<([self.lines count]-1) ) {
            [txt appendFormat: @"%@\n", line];
            cpos->location += [line length]+1;
        } else {
            [txt appendFormat: @"%@", line];
        }
    }

    
    return txt;

}

- (void)insertText:(NSString *)text{
    int insertIndex = 0;
    NSRange searchRange = [text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    /*decimalDigitCharacterSet : this set is the set of all characters used to represent the decimal values 0 through 9. These characters include, for example, the decimal digits of the Indic scripts and Arabic. Looks like the the decimal character of faseyha is not recognised. - Tula
     
     */
    if ((searchRange.location != NSNotFound) || [text isEqualToString:@"."]) {
        NSMutableString *lastLine = (NSMutableString*)[self.lines lastObject];
        for (int i = 0; i < [lastLine length]; i++) {
            NSString *character = [[lastLine substringToIndex:i+1] substringFromIndex:i];
            searchRange = [character rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
            
            
            if ((searchRange.location != NSNotFound) || [character isEqualToString:@"."]) {
                insertIndex++;
            }else {
                break;
                
            }
        }
        
    }
    [(NSMutableString*)[self.lines lastObject] insertString: text
                                               atIndex: insertIndex];
}

@end
