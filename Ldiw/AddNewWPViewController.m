//
//  AddNewWPViewController.m
//  Ldiw
//
//  Created by Timo Kallaste on 2/25/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "AddNewWPViewController.h"
#import "WastePointViews.h"
#import "Database+Server.h"

@interface AddNewWPViewController ()

@end

@implementation AddNewWPViewController

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  WastePointViews *wpViews = [[WastePointViews alloc] initWithWastePoint:nil];
  [wpViews setUserInteractionEnabled:NO];
  [self.scrollView setContentSize:CGSizeMake(320, wpViews.bounds.size.height)];
  [self.scrollView setCanCancelContentTouches:NO];
  [self.scrollView addSubview:wpViews];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)checkPressed:(UIButton *)selector {
  MSLog(@"checkPressed!");
  [selector setSelected:YES];
}

@end
