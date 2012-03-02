//
//  RootViewController.h
//  SinaWeiBoSDKDemo
//
//  Created by Wu WenYong on 11-5-30.
//  Copyright 2011 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeywordController.h"
#import "UIRecognizeController.h"
#import "UISynthesizerController.h"
#import "WBConnect.h"

#define RECOGNIZE_TITLE @"语音识别技术，是将声音转换为文字，让机器能够听懂您的声音。它包括听写技术和关键字识别技术，\
前者可以翻译出您说的日常用语、热词、视频和地点信息等，而后者能够针对性的识别您指定的关键词集。"

#define SYNTHESIZER_TITLE @"语音合成技术，是将文字转换为声音，让机器能够把文字读给您听。"

#define BUTTON_TITLE1  @"立即体验语音听写"
#define BUTTON_TITLE2 @"立即体验命令词识别"
#define BUTTON_TITLE3 @"立即体验语音合成"

#define SECTION_TITLE1 @"语音识别"
#define SECTION_TITLE2 @"语音合成"

#define TITLE @"Feed to Voice"

@interface RootViewController : UIViewController <WBSessionDelegate,WBSendViewDelegate,WBRequestDelegate>{
	WeiBo* weibo;
	
	UIButton* buttonSend;
	UIButton* buttonLogout;
	UIButton* buttonGetFeed;
                                               
    //UIKeywordController			*_keywordController;
    //UIRecognizeController		*_recognizeController;
    UISynthesizerController		*_synthesizerController;
                                               
    NSArray *_tableArray;
                                              
}

@property (nonatomic,assign,readonly) WeiBo* weibo;

@end

