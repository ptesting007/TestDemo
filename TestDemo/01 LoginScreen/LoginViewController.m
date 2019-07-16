//
//  LoginViewController.m
//  TestDemo
//
//  Created by Piyush Kaklotar on 16/07/19.
//  Copyright © 2019 Piyush Kaklotar. All rights reserved.
//

#import "LoginViewController.h"
#import "TDAccountManager.h"
#import <AVKit/AVKit.h>

@interface LoginViewController () <ALFormDelegate> {
    AVQueuePlayer *player;
    AVPlayerViewController *controller;
}
@property (weak, nonatomic) IBOutlet ALForm* alForm;

@end

@implementation LoginViewController
#pragma mark - General Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.alForm.delegate = self;
    
    NSURL *videourl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"mp4"]];
    
    player = [AVQueuePlayer playerWithURL:videourl];
    player.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    controller = [[AVPlayerViewController alloc] init];
    controller.view.frame = CGRectMake(0, 0, width, height);
    controller.player = player;
    controller.showsPlaybackControls = NO;
    controller.allowsPictureInPicturePlayback = NO;
    
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    [self.view bringSubviewToFront:_alForm];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideo) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [player play];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = TRUE;
}
#pragma mark - Video Player Methods
- (void)playVideo {
    NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"mp4"]];
    AVPlayerItem *video = [[AVPlayerItem alloc] initWithURL:videoURL];
    [player insertItem:video afterItem:nil];
    [player play];
}
#pragma mark - ALForm Delegate Methods
- (void)alFormDidBeginEditing {
    [UIView animateWithDuration:0.35 animations:^{
        self.alForm.transform = CGAffineTransformMakeTranslation(self.alForm.transform.tx, -100);
    }];
    
    NSLog(@"ALFormDidBeginEditing");
}
- (void)alFormSubmitButtonTapped {
    [UIView animateWithDuration:0.4 animations:^{
        self.alForm.transform = CGAffineTransformMakeTranslation(self.alForm.transform.tx, 0);
    }];
    [self textFieldValidation];
}
- (void)alFormDidEndEditing {
    NSLog(@"ALFormDidEndEditing");
}
- (void)alFormShouldReturn {
    [UIView animateWithDuration:0.4 animations:^{
        self.alForm.transform = CGAffineTransformMakeTranslation(self.alForm.transform.tx, 0);
    }];
}
#pragma mark - Other Methods
- (void)textFieldValidation {
    NSString *strMessage;
    if ([_alForm.loginField.text length] == 0) {
        strMessage = @"Please enter your email address";
    }
    else if (![self isValidEmail:_alForm.loginField.text]) {
        strMessage = @"Please enter valid email address";
    }
    else if ([_alForm.passwordField.text length] == 0) {
        strMessage = @"Please enter your password";
    }
    
    if ([strMessage length] != 0) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Opps!" message:strMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btnOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:btnOK];
        [self presentViewController:ac animated:YES completion:nil];
    }
    else {
        [self callWebService];
    }
    
}
- (BOOL)isValidEmail:(NSString *)strEmail {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}
#pragma mark - WebService Call Method
- (void)callWebService {
    NSDictionary *paramDict = @{kEmailKey : _alForm.loginField.text, kPasswordKey : _alForm.passwordField.text};
    [[TDAccountManager sharedManager] loginWithParameters:paramDict withCompletionHandler:^(NSDictionary *responseDict, TDError *error) {
        if (!error) {
            NSLog(@"%@", responseDict);
            NSLog(@"%@", error);
            [self->_alForm cleatTextFieldValue];
            [self performSegueWithIdentifier:@"pushListView" sender:self];
        }
        else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Opps!" message:error.messageText preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *btnOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:btnOK];
            [self presentViewController:ac animated:YES completion:nil];
            
        }
    }];
    
}
@end

