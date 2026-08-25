#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface TrollPadOSListController : PSListController
@end

@implementation TrollPadOSListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

@end
