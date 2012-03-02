//
//  UISynthesizerSetupController.h
//  MSC20Demo
//
//  Created by yangchen on 11-3-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDemoBaseController.h"
#import "iFlyTTS/IFlySynthesizerControl.h"

// 显示合成界面


#define H_SYNTHESIZER_UI_LABEL_FRAME		CGRectMake(20, 20, 130, 20)
#define H_SYNTHESIZER_UI_SWITCH_FRAME		CGRectMake(170, 25, 100, 20)

// 背景音
#define H_BG_VOICE_LABEL_FRAME				CGRectMake(20, 65, 130, 40)
#define H_BG_VOICE_SWITCH_FRAME				CGRectMake(170, 65, 100, 40)

// 发音人
#define H_PERSON_VOICE_LABEL_FRAME			CGRectMake(20, 110, 130, 40)
#define H_PERSON_VOICE_SEG_FRAME			CGRectMake(170, 115, 90, 30)

// 调整语速
#define H_SPEED_VOICE_LABEL_FRAME			CGRectMake(20, 160, 100, 40)
#define H_SPEED_VOICE_SLI_FRAME				CGRectMake(140, 165, 150, 15) 

// 调整音量
#define H_VOLUME_VOICE_LABEL_FRAME			CGRectMake(20, 200, 100, 40)
#define H_VOLUME_VOICE_SLI_FRAME			CGRectMake(140, 205, 150, 15) 


#define H_UI_LABEL_FRAME		CGRectMake(20, 10, 150, 20)
#define H_UI_CONTEXT_FRAME		CGRectMake(170, 10, 100, 30)

#define TITLE @"合成设置"

@interface UISynthesizerSetupController : UIDemoBaseController 
{
	IFlySynthesizerControl		*_iFlySynthesizerControl;
	UILabel						*_titleLabel;

	// 0
	UILabel						*_synthesizerUILabel;
	UISwitch					*_synthesizerUISwitch;
	
	// 1
	UILabel						*_bgVoiceLabel;
	UISwitch					*_bgVoiceSwitch;

	// 2
	UILabel						*_personVoiceLabel;
	UISegmentedControl			*_personVoiceSegment;
	
	// 3
	UILabel						*_speedVoiceLabel;
	UISlider					*_speedVoiceSlider;
	
	// 4
	UILabel						*_volumeVoiceLabel;
	UISlider					*_volumeVoiceSlider;
}

- (id)initWithSynthesizer:(IFlySynthesizerControl *)iFlySynthesizerControl;

@end
