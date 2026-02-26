//
//  PhotoPreviewViewController.mm
//  appstore
//
//  Created by Jul on 19.03.2025.
//

#import "PhotoPreviewViewController.h"

@interface PhotoPreviewViewController ()

@property (nonatomic, strong) UIImageView *photoPreviewView;
@property (nonatomic, strong) UIButton *retakeButton;
@property (nonatomic, strong) UIButton *usePhotoButton;
@property (nonatomic, strong) UIView *toolbarView;

@end

@implementation PhotoPreviewViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupUI];
}

- (void)setupUI {
  self.view.backgroundColor = [UIColor blackColor];
  
  // Photo Preview
  self.photoPreviewView = [[UIImageView alloc] init];
  self.photoPreviewView.contentMode = UIViewContentModeScaleAspectFit;
  self.photoPreviewView.image = self.photo;
  self.photoPreviewView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.photoPreviewView];
  
  // Toolbar (the panel you noticed)
  self.toolbarView = [[UIView alloc] init];
  self.toolbarView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
  self.toolbarView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.toolbarView];
  
  // Retake Button
  self.retakeButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.retakeButton setTitle:NSLocalizedString(@"Retake", "") forState:UIControlStateNormal];
  [self.retakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.retakeButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
  [self.retakeButton addTarget:self action:@selector(retakePhoto) forControlEvents:UIControlEventTouchUpInside];
  self.retakeButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.toolbarView addSubview:self.retakeButton];
  
  // Use Photo Button
  self.usePhotoButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.usePhotoButton setTitle:NSLocalizedString(@"Use Photo", "") forState:UIControlStateNormal];
  [self.usePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.usePhotoButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
  [self.usePhotoButton addTarget:self action:@selector(usePhoto) forControlEvents:UIControlEventTouchUpInside];
  self.usePhotoButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.toolbarView addSubview:self.usePhotoButton];
  
  // Constraints
  [NSLayoutConstraint activateConstraints:@[
    // Photo preview fills the whole view
    [self.photoPreviewView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.photoPreviewView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.photoPreviewView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [self.photoPreviewView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    
    // Toolbar at the bottom
    [self.toolbarView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [self.toolbarView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [self.toolbarView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [self.toolbarView.heightAnchor constraintEqualToConstant:100],
    
    // Buttons in toolbar
    [self.retakeButton.leadingAnchor constraintEqualToAnchor:self.toolbarView.leadingAnchor constant:20],
    [self.retakeButton.centerYAnchor constraintEqualToAnchor:self.toolbarView.centerYAnchor],
    
    [self.usePhotoButton.trailingAnchor constraintEqualToAnchor:self.toolbarView.trailingAnchor constant:-20],
    [self.usePhotoButton.centerYAnchor constraintEqualToAnchor:self.toolbarView.centerYAnchor]
  ]];
}

- (void)retakePhoto {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)usePhoto {
  if ([self.delegate respondsToSelector:@selector(photoPreviewViewControllerDidUsePhoto:)]) {
    [self.delegate photoPreviewViewControllerDidUsePhoto:self.photo];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
