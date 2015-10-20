//
//  PreferencesViewController.m
//  Journal
//
//  Created by Peter Hosey on 2015-10-20.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import "PreferencesViewController.h"

#import "PreferenceKeys.h"

@interface PreferencesViewController ()

@property (weak) IBOutlet NSComboBox *characterLimitPopUp;

- (IBAction)takeCharacterLimit:(id)sender;

@end

@implementation PreferencesViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	NSComboBox *limitPopUp = self.characterLimitPopUp;
	limitPopUp.objectValue = [[NSUserDefaults standardUserDefaults]
		objectForKey:JournalPrefCharacterLimit];
}

- (IBAction)takeCharacterLimit:(id)sender {
	NSComboBox *const __nullable comboBox = (NSComboBox *)sender;
	NSString *const __nullable valueBoxed = comboBox.objectValue;
	NSInteger integerValue = valueBoxed.integerValue;
	NSUserDefaults *const __nonnull defaults = [NSUserDefaults standardUserDefaults];
	if (integerValue <= 0) {
		integerValue = [defaults integerForKey:JournalPrefCharacterLimit];
		if (integerValue <= 0) {
			integerValue = JournalPrefCharacterLimitDefaultValue;
		}
	}
	[defaults setInteger:integerValue forKey:JournalPrefCharacterLimit];
	comboBox.objectValue = @(integerValue);
}

@end
