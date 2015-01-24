//
//  AppDelegate.h
//  Auto Exceptions Helper
//
//  Created by Tail Red on 1/24/15.
//  Copyright (c) 2015 Atelier Shiori. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FixSearchDialog.h"
#import <anitomy-osx/anitomy-objc-wrapper.h>
@class FixSearchDialog;
@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>{
       FixSearchDialog *fsdialog;
    //Fields
    IBOutlet NSTextField * grouptextfield;
    IBOutlet  NSTextField * detectedfilefield;
    IBOutlet NSTextField * correcttitlefield;
    IBOutlet NSTextField * epioffsetfield;
    IBOutlet  NSTextField * episodethresholdfield;
}
@property(strong) FixSearchDialog *fsdialog;
@end

