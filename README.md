
![Logo](https://avatars3.githubusercontent.com/u/13508076?v=3&s=460)

# QSessionDownloader

===
- A simple encapsulation of NSURLSession files to download.

GitHub：[QianChia](https://github.com/QianChia) ｜ Blog：[QianChia(Chinese)](http://www.cnblogs.com/QianChia)

---

## Installation

### From CocoaPods

- `pod 'QSessionDownloader'`

### Manually
- Drag all source files under floder `QSessionDownloader` to your project.
- Import the main header file：`#import "QSessionDownloader.h"`

---

## Examples

- Start Download

	```objc
	
    	[[QSessionDownloader defaultDownloader] q_downloadWithURL:url progress:^(float progress) {
	        
	        dispatch_async(dispatch_get_main_queue(), ^{
	            [button q_setButtonWithProgress:progress lineWidth:10 lineColor:nil backgroundColor:[UIColor yellowColor]];
	        });
	        
	    } successed:^(NSString *targetPath) {
	        
	        NSLog(@"successed：%@", targetPath);
	        
	    } failed:^(NSError *error) {
	        
	        NSLog(@"failed：%@", error);
	    }];
    
	```
- Pause Download

	```objc
	
    	[[QSessionDownloader defaultDownloader] q_pauseWithURL:url];
    
	``` 
- Cancel Download

	```objc
		
		[[QSessionDownloader defaultDownloader] q_cancelWithURL:url];

	```
   