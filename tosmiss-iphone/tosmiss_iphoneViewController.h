//
//  tosmiss_iphoneViewController.h
//
//  Created by Justin Van Eaton on 6/20/11.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>    
#import "AsyncSocket.h"
#import "AboutViewController.h"

#define kWebAddress @"http://ec2-184-72-154-79.compute-1.amazonaws.com"

@interface tosmiss_iphoneViewController : UIViewController <UIWebViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate, UITabBarControllerDelegate> {
    
    IBOutlet UITabBar *theTabBar;
    IBOutlet UIWebView *theWebView;
    IBOutlet UIWebView *theOtherOneWebView;
    IBOutlet UIWebView *theRandomWebView;
    
    IBOutlet UIActivityIndicatorView *theSpinner;
    IBOutlet UIActivityIndicatorView *theOtherOneSpinner;
    IBOutlet UIActivityIndicatorView *theRandomSpinner;
    
    
    NSMutableData  *receivedData;
    
}

- (IBAction)cameraButtonAction:(id)sender;
- (IBAction)refreshButtonAction:(id)sender;

-(UIImage*)scaleImageWithImage:(UIImage*)image;
-(void)saveImage:(UIImage *)image;

- (IBAction)refreshButtonAction:(id)sender;

@end
