//
//  ModeSegmentedPicker.mm
//  appstore
//
//  Created by Jul on 19.03.2025.
//

#import "ModeSegmentedPicker.h"

@interface ModeSegmentedPicker ()

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIView *highlightView;

@end

@implementation ModeSegmentedPicker

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupUI];
  }
  return self;
}

- (void)setupUI {
  
  // Highlight View
  self.highlightView = [[UIView alloc] init];
  self.highlightView.backgroundColor = [UIColor whiteColor];
  self.highlightView.layer.cornerRadius = 10;
  self.highlightView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:self.highlightView];
  
  // Photo Button
  self.photoButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.photoButton setTitle:NSLocalizedString(@"Photo", "") forState:UIControlStateNormal];
  [self.photoButton addTarget:self action:@selector(photoButtonTapped) forControlEvents:UIControlEventTouchUpInside];
  self.photoButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:self.photoButton];
  
  // Video Button
  self.videoButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.videoButton setTitle:NSLocalizedString(@"Video", "") forState:UIControlStateNormal];
  [self.videoButton addTarget:self action:@selector(videoButtonTapped) forControlEvents:UIControlEventTouchUpInside];
  self.videoButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:self.videoButton];
  
  // Constraints
  [NSLayoutConstraint activateConstraints:@[
    [self.videoButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
    [self.videoButton.topAnchor constraintEqualToAnchor:self.topAnchor],
    [self.videoButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    [self.videoButton.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5],
    
    [self.photoButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
    [self.photoButton.topAnchor constraintEqualToAnchor:self.topAnchor],
    [self.photoButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    [self.photoButton.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5],
    
    [self.highlightView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.8],
    [self.highlightView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5],
    [self.highlightView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
  ]];
  
  // Set initial mode
  [self updateHighlightViewPosition];
}

- (void)setIsPhotoMode:(BOOL)isPhotoMode {
  _isPhotoMode = isPhotoMode;
  [self updateHighlightViewPosition];
}

- (void)updateHighlightViewPosition {
  CGFloat highlightX = self.isPhotoMode ?  self.bounds.size.width / 2 : 0;
  [UIView animateWithDuration:0.3 animations:^{
    self.highlightView.frame = CGRectMake(highlightX, self.highlightView.frame.origin.y, self.highlightView.frame.size.width, self.highlightView.frame.size.height);
  }];
  if (self.isPhotoMode) {
    [self.videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.photoButton setTitleColor:[UIColor systemTealColor] forState:UIControlStateNormal];
  } else {
    [self.videoButton setTitleColor:[UIColor systemTealColor] forState:UIControlStateNormal];
    [self.photoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  }
}

- (void)photoButtonTapped {
  self.isPhotoMode = YES;
  if ([self.delegate respondsToSelector:@selector(modeSegmentedPickerDidSelectMode:)]) {
    [self.delegate modeSegmentedPickerDidSelectMode:YES];
  }
}

- (void)videoButtonTapped {
  self.isPhotoMode = NO;
  if ([self.delegate respondsToSelector:@selector(modeSegmentedPickerDidSelectMode:)]) {
    [self.delegate modeSegmentedPickerDidSelectMode:NO];
  }
}

@end
