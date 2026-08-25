#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

#define TPOS_DOMAIN @"com.trollpados"

static PSSpecifier *TPOSGroup(NSString *label, NSString *footer) {
	PSSpecifier *s = [PSSpecifier groupSpecifierWithName:label];
	if (footer) [s setProperty:footer forKey:@"footerText"];
	return s;
}

static PSSpecifier *TPOSSwitch(NSString *label, NSString *key, BOOL def) {
	PSSpecifier *s = [PSSpecifier preferenceSpecifierNamed:label
		target:nil set:nil get:nil detail:nil cell:PSSwitchCell edit:nil];
	[s setProperty:TPOS_DOMAIN forKey:@"defaults"];
	[s setProperty:key forKey:@"key"];
	[s setProperty:@(def) forKey:@"default"];
	return s;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
static PSSpecifier *TPOSSlider(NSString *label, NSString *key, NSInteger def, NSInteger min, NSInteger max) {
	PSSpecifier *s = [PSSpecifier preferenceSpecifierNamed:label
		target:nil set:nil get:nil detail:nil cell:PSSliderCell edit:nil];
	[s setProperty:TPOS_DOMAIN forKey:@"defaults"];
	[s setProperty:key forKey:@"key"];
	[s setProperty:@(def) forKey:@"default"];
	[s setProperty:@(min) forKey:@"min"];
	[s setProperty:@(max) forKey:@"max"];
	return s;
}
#pragma clang diagnostic pop

@interface TrollPadOSListController : PSListController
@end

@implementation TrollPadOSListController

- (NSArray *)specifiers {
	NSMutableArray *specs = [NSMutableArray array];

	[specs addObject:TPOSGroup(@"TrollPadOS — iPadOS 18 inspired", @"Lớp tương thích iPadOS cho iPhone jailbreak. Các mục không thể tái tạo an toàn bằng tweak sẽ không được giả lập.")];
	[specs addObject:TPOSSwitch(@"Kích hoạt TrollPadOS", @"TPOSEnable", YES)];

	[specs addObject:TPOSGroup(@"QUẢN LÝ MÀN HÌNH", @"Khi bật Toàn màn hình, cửa sổ co giãn bị tắt để tránh xung đột.")];
	[specs addObject:TPOSSwitch(@"Ứng dụng toàn màn hình", @"TPOSFullscreenAppsOnly", NO)];
	[specs addObject:TPOSSwitch(@"Ứng dụng có cửa sổ", @"TPOSWindowedApps", YES)];
	[specs addObject:TPOSSwitch(@"Quản lý màn hình", @"TPOSDisplayArrangement", NO)];

	[specs addObject:TPOSGroup(@"ĐA NHIỆM & STAGE MANAGER", nil)];
	[specs addObject:TPOSSwitch(@"Stage Manager", @"TPOSStageManager", YES)];
	[specs addObject:TPOSSlider(@"Số ứng dụng trên Stage", @"TPOSMaxAppsOnStage", 4, 1, 8)];
	[specs addObject:TPOSSwitch(@"Ép windowing cho ứng dụng chỉ hỗ trợ dọc", @"TPOSForceMedusaLandscapeOnlyApps", NO)];
	[specs addObject:TPOSSwitch(@"Switcher kiểu iPad", @"TPOSIPadSwitcherAnimation", YES)];
	[specs addObject:TPOSSwitch(@"Ẩn Dock trong Stage Manager", @"TPOSChamoisHideDock", NO)];

	[specs addObject:TPOSGroup(@"HOME SCREEN & DOCK", nil)];
	[specs addObject:TPOSSwitch(@"Home Screen xoay ngang", @"TPOSAllowLandscapeHomeScreen", YES)];
	[specs addObject:TPOSSwitch(@"App Library trong Dock", @"TPOSAppLibraryInDock", YES)];
	[specs addObject:TPOSSwitch(@"Ứng dụng gần đây trong Dock", @"TPOSRecentsInDock", YES)];
	[specs addObject:TPOSSwitch(@"Floating Dock", @"TPOSFloatingDock", YES)];
	[specs addObject:TPOSSwitch(@"Ép giao diện UIKit nhận diện kiểu iPad", @"TPOSGlobalPadTraits", NO)];

	[specs addObject:TPOSGroup(@"BÀN PHÍM & INPUT", nil)];
	[specs addObject:TPOSSwitch(@"Thanh shortcut bàn phím", @"TPOSKeyboardShortcutButtons", YES)];
	[specs addObject:TPOSSwitch(@"Bàn phím nhận diện kiểu iPad", @"TPOSSpoofIdiomKeyboard", YES)];

	[specs addObject:TPOSGroup(@"MÀN HÌNH NGOÀI", nil)];
	[specs addObject:TPOSSwitch(@"External Display / AirPlay", @"TPOSAirPlayExternalDisplay", NO)];
	[specs addObject:TPOSSwitch(@"Stage Manager trên màn hình ngoài", @"TPOSExternalDisplayStageManager", NO)];
	[specs addObject:TPOSSwitch(@"Toàn màn hình trên màn hình ngoài", @"TPOSExternalDisplayFullScreen", NO)];

	[specs addObject:TPOSGroup(@"MEDIA & VIDEO", nil)];
	[specs addObject:TPOSSwitch(@"Picture in Picture", @"TPOSPictureInPicture", NO)];

	[specs addObject:TPOSGroup(@"GHI CHÚ", @"iPadOS 18 còn có Calculator/Math Notes, Smart Script, Photos redesign, Passwords… Các phần phụ thuộc app riêng, entitlement hoặc phần cứng không thể giả lập bằng hook SpringBoard.")];

	_specifiers = specs;
	return _specifiers;
}

@end
