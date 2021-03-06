//
//  FixSearchDialog.h
//  MAL Updater OS X
//
//  Created by 高町なのは on 2014/11/15.
//  Copyright (c) 2014年 Atelier Shiori. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FixSearchDialog : NSWindowController{
    IBOutlet NSArrayController * arraycontroller;
    IBOutlet NSTextField *search;
    IBOutlet NSButton * deleteoncorrection;
    IBOutlet NSTableView *tb;
    NSString * selectedtitle;
    NSString * selectedaniid;
    NSString * selectedtotalepisodes;
    NSString * searchquery;
    bool correction;
}
-(id)init;
-(void)setCorrection:(BOOL)correct;
-(NSString *)getSelectedTitle;
-(NSString *)getSelectedAniID;
-(NSString *)getSelectedTotalEpisodes;
-(bool)getdeleteTitleonCorrection;
-(void)setSearchField:(NSString *)term;
@end
