//
//  ViewController.m
//  TestWebViewInteraction
//
//  Created by sheldon on 13-9-3.
//  Copyright (c) 2013年 sheldon. All rights reserved.
//

#import "ViewController.h"
#import "ASIFormDataRequest.h"
#import "MMProgressHUD.h"
@interface ViewController ()

@end

@implementation ViewController
{
    UIProgressView *myProgressIndicator;
}
@synthesize myWebView=_myWebView;
@synthesize pickerController=_pickerController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _myWebView.delegate=self;
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.188:4000/users/new"];
    //创建一个请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_myWebView loadRequest:request];
    
    myProgressIndicator= [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:myProgressIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL]absoluteString];
    NSLog(@"requestString:%@",requestString);
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count]>1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"gallery" ] ) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"open"])
        {
            [self openGallery];
        }
        return NO;
    }
    
    return YES;
}
//打开相册
-(void)openGallery{
    //初始化类
    _pickerController = [[UIImagePickerController alloc] init];
    //指定几总图片来源
    //UIImagePickerControllerSourceTypePhotoLibrary：表示显示所有的照片。
    //UIImagePickerControllerSourceTypeCamera：表示从摄像头选取照片。
    //UIImagePickerControllerSourceTypeSavedPhotosAlbum：表示仅仅从相册中选取照片。
    _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //表示用户可编辑图片。
    _pickerController.allowsEditing = YES;
    //代理
    _pickerController.delegate = self;
    [self presentModalViewController: _pickerController animated: YES];
//    [self presentViewController:_pickerController animated:YES ];
}


//3.x  用户选中图片后的回调
- (void)imagePickerController: (UIImagePickerController *)picker
didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    NSLog(@"3.x");
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    [self dismissModalViewControllerAnimated:YES];
    
    [self imageUpload:image];
    
    
}

//2.x  用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"2.x");
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    
    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
    
    //直接调用3.x的处理函数
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

// 用户选择取消
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void) imageUpload:(UIImage *) image
{
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.188:4000/users"]];
    [request addData:UIImagePNGRepresentation(image)  forKey:@"user[avatar]"];
    [request setRequestMethod:@"POST"];
    [request setUploadProgressDelegate:myProgressIndicator];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setStartedBlock:^{
        [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
        [MMProgressHUD showWithTitle:@"上传文件" status:@"请等待..."];
    }];
    [request setFailedBlock:^{
//        NSError *error = [request error];
        [MMProgressHUD dismissWithError:@"试衣MM开了个小差，上传失败了。"];
        
    }];
    [request setCompletionBlock:^{
//        NSString *responseString = [request responseString];
//        [MMProgressHUD dismissWithSuccess:@"上传完成"];
        [MMProgressHUD dismissWithSuccess:@"上传完成" title:nil afterDelay:0.5f];
        // Use when fetching binary data
        //    NSData *responseData = [request responseData];
    }];
    [request startAsynchronous];
    
    
}
    
@end
