//
//  PhotoPreviewViewController.h
//  appstore
//
//  Created by Jul on 19.03.2025.
//


#import <UIKit/UIKit.h>

@protocol PhotoPreviewViewControllerDelegate <NSObject>

- (void)photoPreviewViewControllerDidUsePhoto:(UIImage *)photo;

@end

@interface PhotoPreviewViewController : UIViewController

@property (nonatomic, weak) id<PhotoPreviewViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *photo;

@end





