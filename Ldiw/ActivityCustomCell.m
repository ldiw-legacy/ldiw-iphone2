//
//  ActivityCustomCell.m
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "ActivityCustomCell.h"
#import <QuartzCore/QuartzCore.h>

#define kbgCornerRadius 8

@interface ActivityCustomCell ()
@property (nonatomic, strong) UIView *bgView;
@end

@implementation ActivityCustomCell
@synthesize cellTitleLabel,bgView;


-(id)initWithCoder:(NSCoder *)aDecoder {
  self=[super initWithCoder:aDecoder];
  if (self) {
    [self setDesign];
  }
  return self;
}


- (void)setDesign
{
  self.bgView=[[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 130)];
  self.bgView.backgroundColor=[UIColor blackColor];
  [self.bgView.layer setCornerRadius:kbgCornerRadius];
  [bgView setClipsToBounds:YES];
  [self addSubview:self.bgView];
  UIImage *pointMaker=[UIImage imageNamed:@"pointmarker_feed"];
  UIImage *userIcon= [UIImage imageNamed:@"pointmarker_feed"];
  CGRect firstrect=CGRectMake(5, 5, pointMaker.size.width, pointMaker.size.height);
  CGRect secondrect=CGRectOffset(firstrect, pointMaker.size.width+ 2, 0);
  UIImageView *firstImageView=[[UIImageView alloc] initWithFrame:firstrect];
  UIImageView *secondImageView=[[UIImageView alloc] initWithFrame:secondrect];
  firstImageView.image=userIcon;
  secondImageView.image=pointMaker;

  [self.bgView addSubview:firstImageView];
  [self.bgView addSubview:secondImageView];

  //self.cellTitleLabel=[[UILabel alloc] initWithFrame:rect];
  //[self addSubview:cellTitleLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
