###计算图片在内存中的真实大小

---
在计算图片大小时，一般的做法是用使用   __UIImageJPEGRepresentation(image, 1.0)__和 __UIImagePNGRepresentation(image, 1.0)__，仔细观察的开发者应该已经发现，虽然这样也可以计算出图片大小，但是和实际的图片大小有很大的差距，那么这是为什么呢？是什么原因造成的呢？

有问题看文档:

>A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.


> A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.

从文档中可以了解到，返回的其实都不是原图，而是包含了`PNG data`和`JPEG data`。
参考：
[Calling imageWithData:UIImageJPEGRepresentation() multiple times only compresses image the first time](http://stackoverflow.com/questions/17005456/calling-imagewithdatauiimagejpegrepresentation-multiple-times-only-compresses)

正确的方法是通过 `ALAssetsLibrary`去获取图片的URL，具体方法参考上面的[http://stackoverflow.com](http://stackoverflow.com/questions/17005456/calling-imagewithdatauiimagejpegrepresentation-multiple-times-only-compresses)问题答案。

但是 `ALAssetsLibrary`在 iOS 9中已经不推荐使用，代替的方案是 `Photos`,如下
导入

` #import <Photos/Photos.h>`


```
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


```

