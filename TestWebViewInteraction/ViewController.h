//
//  ViewController.h
//  TestWebViewInteraction
//
//  Created by sheldon on 13-9-3.
//  Copyright (c) 2013年 sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIWebViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIWebView *myWebView;
    UIImagePickerController *pickerController;
}
@property (nonatomic,retain) IBOutlet UIWebView *myWebView;
@property (nonatomic,retain)IBOutlet UIImagePickerController *pickerController;

@end
