//
//  PhotoAppViewController.h


#import <UIKit/UIKit.h>
#import "Task.h"


@protocol PhotoDelegate;


@interface PhotoAppViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIImageView * imageView;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
	UIButton * saveBtn;
	UIButton * cancelBtn;
	id<PhotoDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * saveBtn;
@property (nonatomic, retain) IBOutlet UIButton * cancelBtn;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
@property (nonatomic, retain) id<PhotoDelegate> delegate;

-(IBAction) getPhoto:(id) sender;
-(IBAction)dismiss:(id) sender;

@end


@protocol PhotoDelegate <NSObject>

@required
- (void) photoAppViewController:(PhotoAppViewController *) photoAppViewController didAddPhoto: (UIImage*) image;
- (UIImage*) getCurrentlySelectedImage;

@end


