//
//  CameraViewManager.m
//  SwiftNativeModule
//
//  Created by Daniel Benet on 24/8/23.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <React/RCTUtils.h>

@interface RCT_EXTERN_REMAP_MODULE(CameraView, CameraViewManager, RCTViewManager)

RCT_EXTERN_METHOD(getCameraPermissionStatus:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject);

@end

