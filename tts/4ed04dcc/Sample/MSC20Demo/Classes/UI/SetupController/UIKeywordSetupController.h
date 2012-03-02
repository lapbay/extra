//
//  UIKeywordSetupController.h
//  MSC20Demo
//
//  Created by yangchen on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDemoBaseController.h"
#import "iFlyISR/IFlyRecognizeControl.h"


#define H_VAD_LABEL_FRAME		CGRectMake(20, 60, 130, 40)
#define H_VAD_SWITCH_FRAME		CGRectMake(170, 65, 100, 40)

#define TITLE @"识别设置"

@interface UIKeywordSetupController : UIDemoBaseController 
{
	// UI
	UISwitch					*_vadSwitch;
	
	// 中间变量
	IFlyRecognizeControl		*_iFlyRecognizeControl;
}

- (id)initWithRecognize:(IFlyRecognizeControl *)iFlyRecognizeControl;

@end
