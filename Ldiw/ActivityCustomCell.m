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
  //CGRect rect=CGRectMake(20, 20, 100, 30);
  //self.cellTitleLabel=[[UILabel alloc] initWithFrame:rect];
  //[self addSubview:cellTitleLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
