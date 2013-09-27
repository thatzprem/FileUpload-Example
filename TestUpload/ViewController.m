//
//  ViewController.m
//  TestUpload
//
//  Created by Prem kumar on 12/06/13.
//  Copyright (c) 2013 Prem. All rights reserved.
//

#import "ViewController.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"


#define TEXT_POST_URL  @"http://posttestserver.com/post.php"
#define IMAGE_POST_URL @"http://posttestserver.com/post.php"
#define VIDEO_POST_URL @"http://posttestserver.com/post.php"

@interface ViewController (){
    
    ASIFormDataRequest * request;

}
- (void)formDataUpload;


@end

@implementation ViewController
@synthesize  formUploadProgress,imageUploadProgress,videoUploadProgress,generalProgress,updateInfoLabel,taskCountLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self formDataUploadInBlocks];

    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark FORM DATA upload methods


- (void)formDataUploadInBlocks{
    
    
    NSURL * url = [NSURL URLWithString:TEXT_POST_URL];
    
    // Add Image
    NSString *path = [[NSBundle mainBundle]pathForResource:@"textData" ofType:@"txt"];
    
    // Get Image
    NSData *formData = [[NSData alloc]
                        initWithContentsOfFile:path];
    
    updateInfoLabel.text = @"Uploading form data...";
    taskCountLabel.text = @"1/3";
    __block  ASIFormDataRequest *request1 = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request1 setUploadProgressDelegate:generalProgress];
    [request1 setPostValue:@"ID: 101" forKey:@"form_upload"];
    [request1 setData:formData forKey:@"form_file"];
    [request1 setDelegate:self];
    [request1 setDidFinishSelector:@selector(formUploadDidFinish:)];
    [request1 setDidFailSelector:@selector(formUploadDidFail:)];
    [request1 setTimeOutSeconds:500];
    [request1 setCompletionBlock:^{
        // Use when fetching text data

        NSLog(@"Form upload successful...");
        [self imageDataUpload];
        
    }];
    [request1 setFailedBlock:^{
        NSLog(@"Form upload failed...");
    }];
    [request1 startAsynchronous];
    
    
}
- (void)formDataUpload{
    
    // Initilize Queue
    if (!formUploadQueue) {
		formUploadQueue = [[ASINetworkQueue alloc] init];
	}
    [formUploadQueue setUploadProgressDelegate:formUploadProgress];
    [formUploadQueue setUploadProgressDelegate:generalProgress];
    [formUploadQueue setRequestDidFinishSelector:@selector(formQueueRequestDidFinish:)];
    [formUploadQueue setQueueDidFinishSelector:@selector(formQueueDidFinish:)];
    [formUploadQueue setRequestDidFailSelector:@selector(formQueueRequestDidFail:)];
    [formUploadQueue setShowAccurateProgress:true];
    [formUploadQueue setDelegate:self];
    
    // Initilize Variables
    NSURL * url = [NSURL URLWithString:TEXT_POST_URL];
    
    // Add Image
    NSString *path = [[NSBundle mainBundle]pathForResource:@"textData" ofType:@"txt"];
    
    // Get Image
    NSData *formData = [[NSData alloc]
                         initWithContentsOfFile:path];    
    
    // Return if there is no image
    if(formData != nil){
        
        //Request-1
        [request setTag:101];
        
        request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setPostValue:@"ID: 101" forKey:@"form_upload"];
        [request setData:formData forKey:@"form_file"];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(formUploadDidFinish:)];
        [request setDidFailSelector:@selector(formUploadDidFail:)];
        [request setTimeOutSeconds:500];
        [formUploadQueue addOperation:request];
        
    }
    [formUploadQueue go];
    
}

- (void)formQueueRequestDidFinish:(ASIHTTPRequest *)request{
    NSLog(@"formQueueRequestDidFinish");

}

- (void)formQueueDidFinish:(ASIHTTPRequest *)request{
    NSLog(@"formQueueDidFinish");
    [self imageDataUpload];

}

- (void)formQueueRequestDidFail:(ASIHTTPRequest *)request{
    NSLog(@"formQueueRequestDidFail");

}

- (void)formUploadDidFinish:(ASIHTTPRequest *)request{
    NSLog(@"formUploadDidFinish");

}
- (void)formUploadDidFail:(ASIHTTPRequest *)request{
    NSLog(@"formUploadDidFail");
    
}



#pragma mark IMAGE DATA upload methods

- (void)imageDataUpload{

    updateInfoLabel.text = @"Uploading images...";
    taskCountLabel.text = @"2/3";

    if (!imageUploadQueue) {
		imageUploadQueue = [[ASINetworkQueue alloc] init];
	}
    [imageUploadQueue setUploadProgressDelegate:generalProgress];
    [imageUploadQueue setRequestDidFinishSelector:@selector(imageQueueRequestDidFinish:)];
    [imageUploadQueue setQueueDidFinishSelector:@selector(imageQueueDidFinish:)];
    [imageUploadQueue setShowAccurateProgress:YES];
    [imageUploadQueue setRequestDidFailSelector:@selector(imageQueueRequestDidFail:)];
    [imageUploadQueue setShowAccurateProgress:true];
    [imageUploadQueue setDelegate:self];
    
    // Initilize Variables
    NSURL * url = [NSURL URLWithString:IMAGE_POST_URL];
    
    // Add Image
    NSString *path = [[NSBundle mainBundle]pathForResource:@"image1" ofType:@"jpg"];
    
    // Get Image
    NSData *imageData = [[NSData alloc]
                         initWithContentsOfFile:path];
    
    // Return if there is no image
    if(imageData != nil){
        
        //Request-1
        ASIFormDataRequest * request1;
        [request1 setTag:201];
        
        request1 = [[ASIFormDataRequest alloc] initWithURL:url];
        [request1 setPostValue:@"ID = 201" forKey:@"image_upload"];
        [request1 setFile:path forKey:@"image1_file"];
        [request1 setDelegate:self];
        [request1 setDidFinishSelector:@selector(imageUploadDidFinish:)];
        [request1 setDidFailSelector:@selector(imageUploadDidFail:)];
        [request1 setTimeOutSeconds:500];
        [request1 setShouldStreamPostDataFromDisk:YES];
        [imageUploadQueue addOperation:request1];
        
        //Request-2
        ASIFormDataRequest * request2;
        [request2 setTag:202];
        
        request2 = [[ASIFormDataRequest alloc] initWithURL:url];
        [request2 setPostValue:@"ID = 202" forKey:@"image_upload"];
        [request2 setFile:path forKey:@"image2_file"];
        [request2 setDelegate:self];
        [request2 setDidFinishSelector:@selector(imageUploadDidFinish:)];
        [request2 setDidFailSelector:@selector(imageUploadDidFail:)];
        [request2 setShouldStreamPostDataFromDisk:YES];
        [request2 setTimeOutSeconds:500];
        [imageUploadQueue addOperation:request2];

    }
    [imageUploadQueue go];
}


- (void)imageQueueRequestDidFinish:(ASIHTTPRequest *)request1{
    NSLog(@"imageQueueRequestDidFinish");

}

- (void)imageQueueDidFinish:(ASIHTTPRequest *)request{
    NSLog(@"imageQueueDidFinish");
    [self videoDataUpload];

}

- (void)imageQueueRequestDidFail:(ASIHTTPRequest *)request{
    NSLog(@"imageQueueRequestDidFail");

}

- (void)imageUploadDidFinish:(ASIHTTPRequest *)request{
    NSLog(@"imageUploadDidFinish");
}

- (void)imageUploadDidFail:(ASIHTTPRequest *)request{
    NSLog(@"imageUploadDidFinish");
    
}


#pragma mark VIDEO DATA upload methods

- (void)videoDataUpload{
    
    updateInfoLabel.text = @"Uploading videos...";
    taskCountLabel.text = @"3/3";

    if (!videoUploadQueue) {
		videoUploadQueue = [[ASINetworkQueue alloc] init];
	}
    [videoUploadQueue setUploadProgressDelegate:generalProgress];
    [videoUploadQueue setRequestDidFinishSelector:@selector(videoQueueRequestDidFinish:)];
    [videoUploadQueue setQueueDidFinishSelector:@selector(videoQueueDidFinish:)];
    [videoUploadQueue setRequestDidFailSelector:@selector(videoQueueRequestDidFail:)];
    [videoUploadQueue setShowAccurateProgress:true];
    [videoUploadQueue setDelegate:self];
    
    // Initilize Variables
    NSURL * url = [NSURL URLWithString:VIDEO_POST_URL];
    
    // Add Image
    NSString *path = [[NSBundle mainBundle]pathForResource:@"sample" ofType:@"mov"];
    
    // Get Image
    NSData *imageData = [[NSData alloc]
                         initWithContentsOfFile:path];
    // Return if there is no image
    if(imageData != nil){
        
        //Request-1
        ASIFormDataRequest * request1;
        request1.tag = 301;
        
        request1 = [[ASIFormDataRequest alloc] initWithURL:url];
        [request1 setPostValue:@"EstablishementID = 301" forKey:@"Video Upload"];
        [request1 setFile:path forKey:@"video_file"];
        [request1 setDelegate:self];
        [request1 setDidFinishSelector:@selector(videoUploadDidFinish:)];
        [request1 setDidFailSelector:@selector(videoUploadDidFail:)];
        [request1 setShouldStreamPostDataFromDisk:YES];
        [request1 setTimeOutSeconds:500];
        [videoUploadQueue addOperation:request1];
    }
    [videoUploadQueue go];
}


- (void)videoQueueRequestDidFinish:(ASIHTTPRequest *)request{
    NSLog(@"videoQueueRequestDidFinish");
    
}

- (void)videoQueueDidFinish:(ASIHTTPRequest *)request{
    NSLog(@"videoQueueDidFinish");
    updateInfoLabel.text = @"Upload complete...";

}

- (void)videoQueueRequestDidFail:(ASIHTTPRequest *)request{
    NSLog(@"videoQueueRequestDidFail");
    
}

- (void)videoUploadDidFinish:(ASIHTTPRequest *)request{
    NSLog(@"videoUploadDidFinish");
    
}

- (void)videoUploadDidFail:(ASIHTTPRequest *)request{
    NSLog(@"videoUploadDidFail");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
