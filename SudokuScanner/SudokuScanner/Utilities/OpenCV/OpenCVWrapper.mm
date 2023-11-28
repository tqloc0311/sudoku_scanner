//
//  OpenCVWrapper.m
//  SudokuScanner
//
//  Created by azibai loc on 28/11/2023.
//

#ifdef __cplusplus
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVWrapper.h"

#pragma clang pop
#endif

//using namespace cv;
//using namespace std;

@implementation OpenCVWarpper
+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}
@end
