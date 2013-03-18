//
//  ActivityCustomCell.m
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "ActivityCustomCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DesignHelper.h"

#define kbgCornerRadius 8
@interface ActivityCustomCell ()

@end

@implementation ActivityCustomCell
@synthesize cellNameTitleLabel, cellSubtitleLabel, cellTitleLabel, height, wastePointImageView,userImageView,spinner;



-(id)initWithCoder:(NSCoder *)aDecoder {
  self=[super initWithCoder:aDecoder];
  if (self) {
    [self layoutSetup];
  }
  return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self layoutSetup];
  }
  

  return self;
}

- (void)layoutSetup
{
  UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 130)];
  bgView.backgroundColor = [UIColor blackColor];
  [bgView.layer setCornerRadius:kbgCornerRadius];
  [bgView setClipsToBounds:YES];
  [self addSubview:bgView];
  UIImage *dummy = [UIImage imageNamed:@"pointmarker_feed"];
  CGRect firstrect = CGRectMake(5, 5, dummy.size.width, dummy.size.height);
  CGRect secondrect = CGRectOffset(firstrect, dummy.size.width+ 2, 0);
  self.userImageView = [[UIImageView alloc] initWithFrame:firstrect];
  UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:secondrect];
  self.userImageView.image = dummy;
  
  //secondImageView.image=[UIImage imageNamed:@"pointmarker_feed"];
  
  CGRect subtitlelabelrect = CGRectOffset(firstrect, 0, dummy.size.height +5);
  cellSubtitleLabel=[[UILabel alloc] initWithFrame:subtitlelabelrect];
  cellSubtitleLabel.text = @"Subtitle";
  [cellSubtitleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
  [DesignHelper setActivityViewSubtitle:cellSubtitleLabel];

  CGRect namelabelrect = CGRectOffset(firstrect, firstrect.size.width + 4, 0);
  cellNameTitleLabel = [[UILabel alloc] initWithFrame:namelabelrect];
  [DesignHelper setActivityViewNametitle:cellNameTitleLabel];

  CGRect titlelabelrect=CGRectOffset(namelabelrect, 0 ,15);
  cellTitleLabel = [[UILabel alloc] initWithFrame:titlelabelrect];
  [DesignHelper setActivityViewActiontitle:cellTitleLabel];

  
  CGRect wastepointImageRect = CGRectOffset(subtitlelabelrect, -5, cellSubtitleLabel.bounds.size.height + 5);
  CGRect realwastepointImageRect = CGRectMake(wastepointImageRect.origin.x, wastepointImageRect.origin.y, 300, 100);
  self.wastePointImageView = [[UIImageView alloc] initWithFrame:realwastepointImageRect];


  self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  
  spinner.center = CGPointMake(wastePointImageView.center.x, wastePointImageView.center.y);

  
  [bgView addSubview:userImageView];
  [bgView addSubview:secondImageView];
  [bgView addSubview:cellSubtitleLabel];
  [bgView addSubview:cellNameTitleLabel];
  [bgView addSubview:cellTitleLabel];
  [bgView addSubview:wastePointImageView];
  [bgView addSubview:spinner];
  
  self.height = 5 + userImageView.bounds.size.height + 6 + self.cellSubtitleLabel.bounds.size.height + 5 + wastePointImageView.bounds.size.height;
  
  bgView.frame = CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.size.width, self.height);
  
                  
  }


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
