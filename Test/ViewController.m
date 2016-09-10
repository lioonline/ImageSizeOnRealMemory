//
//  ViewController.m
//  Test
//
//  Created by Lee on 9/9/16.
//  Copyright © 2016 Lee. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIImagePickerController *picker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)click:(id)sender {
    
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    self.picker.delegate = self;
    [self presentViewController:self.picker animated:YES completion:^{
        
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  
    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    PHFetchResult *res =  [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
    PHAsset *ph =  [res objectAtIndex:0];
    [[PHImageManager defaultManager] requestImageDataForAsset:ph options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
         float value = imageData.length/1024.0/1024.0;
         NSLog(@"value : %f",value);
    }];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
