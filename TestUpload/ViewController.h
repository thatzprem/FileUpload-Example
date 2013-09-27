//
//  ViewController.h
//  TestUpload
//
//  Created by Prem kumar on 12/06/13.
//  Copyright (c) 2013 Prem. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASINetworkQueue;

@interface ViewController : UIViewController{
    
    ASINetworkQueue *formUploadQueue;
    ASINetworkQueue *imageUploadQueue;
    ASINetworkQueue *videoUploadQueue;


}


@property (weak, nonatomic) IBOutlet UIProgressView *formUploadProgress;

@property (weak, nonatomic) IBOutlet UIProgressView *imageUploadProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *videoUploadProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *generalProgress;
@property (weak, nonatomic) IBOutlet UILabel *updateInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskCountLabel;

@end
