//
//  LoginViewController.h
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//
@protocol LoginDelegate <NSObject>
- (void)loginSuccessful;

@optional
- (void)loginFailed;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, weak) id <LoginDelegate> delegate;

- (void)loginFailed;

@end
