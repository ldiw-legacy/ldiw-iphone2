//
//  ActivityCustomCell.m
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "WastePointCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DesignHelper.h"
#import "UIImageView+AFNetworkingJSAdditions.h"

#define kbgCornerRadius 8
#define kElementPadding 5
#define kSidePadding 10
#define kContentWitdh 300

@implementation WastePointCell

@synthesize titleLabel, descriptionLabel, locationLabel, height, wastePointImageView, userImageView, bgView, spinner, borderImage;

-(void)awakeFromNib
{
  [super awakeFromNib];
  [self layoutSetup];
}

- (void)layoutSetup
{
  [bgView.layer setCornerRadius:kbgCornerRadius];
  [DesignHelper setActivityViewNametitle:titleLabel];
  [DesignHelper setActivityViewLocationtitle:locationLabel];
  [DesignHelper setActivityViewSubtitle:descriptionLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (void)setImageHidden:(BOOL)hidden {
  [borderImage setHidden:hidden];
  [wastePointImageView setHidden:hidden];
}

- (void)setWastePoint:(WastePoint *)wastePoint {
  NSString *wastpointID = [NSString stringWithFormat:@"%@", wastePoint.id];
  titleLabel.text = wastpointID;
  
  //Description
  descriptionLabel.text = wastePoint.displayDescription;
  
  //Country
  locationLabel.text = [wastePoint country];

  NSURL *imageUrl = [wastePoint imageRemoteUrl];

  if (imageUrl) {
    [self setImageHidden:NO];
    UIImage *placeholder = [UIImage imageNamed:@"Default"];
    __weak UIImageView *blockSelf = wastePointImageView;
    [spinner startAnimating];
    [wastePointImageView setImageWithURL:imageUrl placeholderImage:placeholder fadeIn:YES finished:^(UIImage *image) {
      MSLog(@"Image loaded %@", imageUrl);
      [spinner stopAnimating];
      
      // TODO: Why this is necessary???
      [blockSelf setImage:image];
    }];
  } else {
    [self setImageHidden:YES];
    [wastePointImageView setImage:nil];
  }
}

@end
