//
//  ModeSegmentedPicker.h
//  appstore
//
//  Created by Jul on 19.03.2025.
//

#import <UIKit/UIKit.h>

@protocol ModeSegmentedPickerDelegate <NSObject>

- (void)modeSegmentedPickerDidSelectMode:(BOOL)isPhotoMode;

@end

@interface ModeSegmentedPicker : UIView

@property (nonatomic, weak) id<ModeSegmentedPickerDelegate> delegate;
@property (nonatomic, assign) BOOL isPhotoMode;

@end
