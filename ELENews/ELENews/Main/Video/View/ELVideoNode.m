//
//  ELVideoNode.m
//  ELENews
//
//  Created by EL on 2017/12/14.
//  Copyright © 2017年 ElegantLiar. All rights reserved.
//

#import "ELVideoNode.h"

@implementation ELVideoNode{
    ASNetworkImageNode  *_photoImageNode;
    ASTextNode          *_titleLabel;
    ASImageNode         *_playImageNode;
    ELVideoListBean     *_videoListBean;
}

- (instancetype)initWithVideoListBean:(ELVideoListBean *)videoListBean{
   if (self = [super init]) {
       self.selectionStyle = UITableViewCellSelectionStyleNone;

       _videoListBean = videoListBean;
       
       _photoImageNode = [[ASNetworkImageNode alloc] init];
       _photoImageNode.URL = [NSURL URLWithString:_videoListBean.pic];
       _photoImageNode.style.preferredSize = CGSizeMake(ELScreenW - 20, (ELScreenW - 20) / 16 * 9);
       _photoImageNode.imageModificationBlock = ^UIImage *(UIImage *image) {
           UIImage *modifiedImage;
           CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
           UIGraphicsBeginImageContextWithOptions(image.size, false, [[UIScreen mainScreen] scale]);
           [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4] addClip];
           [image drawInRect:rect];
           modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
           UIGraphicsEndImageContext();
           return modifiedImage;
       };
       [self addSubnode:_photoImageNode];
       
       
       _playImageNode = [[ASImageNode alloc] init];
       _playImageNode.image = [UIImage imageNamed:@"video_play_54x54_"];
       _playImageNode.style.preferredSize = CGSizeMake(54, 54);
       [self addSubnode:_playImageNode];
       
       _titleLabel      = [[ASTextNode alloc] init];
       _titleLabel.attributedText = [_videoListBean titleAttributedStringWithFontSize:15];
       _titleLabel.maximumNumberOfLines = 0;
       _titleLabel.style.width = ASDimensionMake(ELScreenW - 20);
       [self addSubnode:_titleLabel];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    
    ASCenterLayoutSpec *centerSpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:_playImageNode];
    centerSpec.style.preferredSize = CGSizeMake(ELScreenW - 20, (ELScreenW - 20) / 16 * 9);

    ASOverlayLayoutSpec *overSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:centerSpec overlay:_photoImageNode];
    
    ASStackLayoutSpec *verticalStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                               spacing:6
                                                                        justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter
                                                                              children:@[overSpec, _titleLabel]];

    ASInsetLayoutSpec *contentInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:verticalStack];
    
    
    return contentInsetSpec;
}

@end
