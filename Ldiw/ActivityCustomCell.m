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
#define kDarkBackgroundColor [UIColor colorWithRed:0.153 green:0.141 blue:0.125 alpha:1] /*#272420*/
@interface ActivityCustomCell ()


@end

@implementation ActivityCustomCell
@synthesize cellNameTitleLabel, cellSubtitleLabel, cellTitleLabel;



-(id)initWithCoder:(NSCoder *)aDecoder {
  self=[super initWithCoder:aDecoder];
  if (self) {
    [self makeDesign];
  }
  return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self makeDesign];
  }
  

  return self;
}

- (void)makeDesign
{
  UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 130)];
  bgView.backgroundColor=[UIColor blackColor];
  [bgView.layer setCornerRadius:kbgCornerRadius];
  [bgView setClipsToBounds:YES];
  [self addSubview:bgView];
  UIImage *pointMaker=[UIImage imageNamed:@"pointmarker_feed"];
  UIImage *userIcon= [UIImage imageNamed:@"pointmarker_feed"];
  CGRect firstrect=CGRectMake(5, 5, pointMaker.size.width, pointMaker.size.height);
  CGRect secondrect=CGRectOffset(firstrect, pointMaker.size.width+ 2, 0);
  UIImageView *firstImageView=[[UIImageView alloc] initWithFrame:firstrect];
  UIImageView *secondImageView=[[UIImageView alloc] initWithFrame:secondrect];
  firstImageView.image=userIcon;
  secondImageView.image=pointMaker;
  
  CGRect subtitlelabelrect=CGRectOffset(firstrect, 0, pointMaker.size.height +6);
  cellSubtitleLabel=[[UILabel alloc] initWithFrame:subtitlelabelrect];
  cellSubtitleLabel.text=@"Subtitle";
  [DesignHelper setActivityViewSubtitle:cellSubtitleLabel];

  CGRect namelabelrect=CGRectOffset(secondrect, secondrect.size.width + 4, 0);
  cellNameTitleLabel=[[UILabel alloc] initWithFrame:namelabelrect];
  [DesignHelper setActivityViewNametitle:cellNameTitleLabel];

  CGRect titlelabelrect=CGRectOffset(namelabelrect, 0 ,14);
  cellTitleLabel= [[UILabel alloc] initWithFrame:titlelabelrect];
  [DesignHelper setActivityViewActiontitle:cellTitleLabel];
  
  
  [bgView addSubview:firstImageView];
  [bgView addSubview:secondImageView];
  [bgView addSubview:cellSubtitleLabel];
  [bgView addSubview:cellNameTitleLabel];
  [bgView addSubview:cellTitleLabel];
  NSLog(@"korgus %@",NSStringFromCGRect(cellSubtitleLabel.frame));
  _height = 5 + firstImageView.bounds.size.height + 6 + self.cellSubtitleLabel.bounds.size.height + 5;
  bgView.frame = CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.size.width, _height);
  
                  
  }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
