//
//  AppDelegate.m
//  Auto Exceptions Helper
//
//  Created by Tail Red on 1/24/15.
//  Copyright (c) 2015 Atelier Shiori. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
@synthesize fsdialog;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
-(void)windowWillClose:(NSNotification *)notification{
    //Temrminate Application
    [[NSApplication sharedApplication] terminate:nil];
    
}
-(IBAction)recognizefile:(id)sender{
    //Obtain Detected Title from Media File
    NSOpenPanel * op = [NSOpenPanel openPanel];
    [op setAllowedFileTypes:[NSArray arrayWithObjects:@"mkv", @"mp4", @"avi", @"ogm", nil]];
    [op setMessage:@"Please select a media file."];
    [op beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelCancelButton) {
            return;
        }
        //Close Open Window
        [op orderOut:nil];
        NSDictionary * d = [[anitomy_bridge alloc] tokenize:[[[op URL] path] lastPathComponent]];
        [detectedfilefield setStringValue:(NSString *)[d objectForKey:@"title"]];
        [grouptextfield setStringValue:(NSString *)[d objectForKey:@"group"]];
    }];
}
-(IBAction)recognizefromStream:(id)sender{
    // Create Dictionary
    NSDictionary * d;
    //Set detectream Task and Run it
    NSTask *task;
    task = [[NSTask alloc] init];
    NSBundle *myBundle = [NSBundle mainBundle];
    [task setLaunchPath:[myBundle pathForResource:@"detectstream" ofType:@""]];
    
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    // Reads Output
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    // Launch Task
    [task launch];
    
    // Parse Data from JSON and return dictionary
    NSData *data;
    data = [file readDataToEndOfFile];
    
    
    NSError* error;
    
    d = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    // Populate Fields
    if ([d objectForKey:@"result"]  == [NSNull null]){ // Check to see if anything is playing on stream
        return;
    }
    else{
        NSArray * c = [d objectForKey:@"result"];
        NSDictionary * detected = [c objectAtIndex:0];
        [detectedfilefield setStringValue:(NSString *)[detected objectForKey:@"title"]];
        [grouptextfield setStringValue:(NSString *)[detected objectForKey:@"site"]];
    }

}
-(IBAction)findTitle:(id)sender{
    // Show Find Title Dialog
    fsdialog = [FixSearchDialog new];
    [fsdialog setCorrection:false];
    [fsdialog setSearchField:[detectedfilefield stringValue]];
    [NSApp beginSheet:[fsdialog window]
    modalForWindow:[self window] modalDelegate:self
    didEndSelector:@selector(findDidEnd:returnCode:contextInfo:)
    contextInfo:(void *)nil];
}
-(void)findDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == 1){
        // Fill in the values
        [correcttitlefield setStringValue:[fsdialog getSelectedTitle]];
        [episodethresholdfield setStringValue:[NSString stringWithFormat:@"%@",[fsdialog getSelectedTotalEpisodes]]];
    }
    else{
    }
    fsdialog = nil;
}
-(IBAction)savetoJSON:(id)sender{
    if (grouptextfield.stringValue.length == 0 || detectedfilefield.stringValue.length == 0 || correcttitlefield.stringValue.length == 0 || episodethresholdfield.stringValue.length == 0 || epioffsetfield.stringValue.length == 0) {
        //Fields are missing data
        // Set Up Prompt Message Window
        NSAlert * alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"One or more fields are missing data"];
        [alert setInformativeText:@"All the fields needs to be filled before you can export the exceptions data."];
        // Set Message type to Warning
        [alert setAlertStyle:1];
        // Show as Sheet on Window
        [alert beginSheetModalForWindow:[self window]
                          modalDelegate:self
                         didEndSelector:nil
                            contextInfo:NULL];
    }
    else{
        // Save the json file containing titles
        NSSavePanel * sp = [NSSavePanel savePanel];
        [sp setAllowedFileTypes:[NSArray arrayWithObjects:@"json", @"JSON file", nil]];
        [sp setNameFieldStringValue:[NSString stringWithFormat:@"%@ - %@ Exceptions Submission.json", grouptextfield.stringValue, correcttitlefield.stringValue]];
        [sp beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result){
            if (result == NSFileHandlingPanelCancelButton) {
                return;
            }
            NSURL *url = [sp URL];
            //Create JSON string from array controller
            NSError *error;
            NSDictionary * jsonOutput = [[NSDictionary alloc] initWithObjectsAndKeys:detectedfilefield.stringValue,@"detectedtitle", correcttitlefield.stringValue, @"correcttitle", grouptextfield.stringValue, @"group", [NSNumber numberWithInt:episodethresholdfield.stringValue.intValue], @"threshold", [NSNumber numberWithInt:epioffsetfield.stringValue.intValue], @"offset", nil];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonOutput
                                                           options:0
                                                             error:&error];
            if (!jsonData) {
                return;
            } else {
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            
            
                //write JSON to file
                BOOL wresult = [JSONString writeToURL:url
                                       atomically:YES
                                         encoding:NSASCIIStringEncoding
                                            error:NULL];
                if (! wresult) {
                    NSLog(@"Export Failed");
                }
            }
        }];
    }
}
-(IBAction)clearFields:(id)sender{
    // Clears all fields
    [detectedfilefield setStringValue:@""];
    [grouptextfield setStringValue:@""];
    [correcttitlefield setStringValue:@""];
    [epioffsetfield setStringValue:@""];
    [episodethresholdfield setStringValue:@""];
}

@end
