//
//  UpdateDataViewController.m
//  TestDemo
//
//  Created by Piyush Kaklotar on 17/07/19.
//  Copyright © 2019 Piyush Kaklotar. All rights reserved.
//

#import "UpdateDataViewController.h"
#import "UIImageView+WebCache.h"
#import "TDWebServiceManager.h"

@interface UpdateDataViewController () {
    IBOutlet UIImageView *imgView;
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtJob;
}

@end

@implementation UpdateDataViewController
#pragma mark - General Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    txtName.text = [NSString stringWithFormat:@"%@ %@", [_dicSelectedUser valueForKey:@"first_name"], [_dicSelectedUser valueForKey:@"last_name"]];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[_dicSelectedUser valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"imgCellBG.png"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (self->imgView.frame.size.height != self->imgView.image.size.height)
                               {
                                   [self->imgView setImage:image];
                                   self->imgView.layer.cornerRadius = self->imgView.frame.size.height / 2.0;
                                   self->imgView.layer.borderColor = [UIColor grayColor].CGColor;
                                   self->imgView.layer.borderWidth = 5.0;
                               }
                           }];
    
}
#pragma mark - UIButton Methods
- (IBAction)btnUpdate_Pressed:(id)sender {
    [self.view endEditing:YES];
    NSString *strMessage;
    if ([txtName.text length] == 0) {
        strMessage = @"Please enter Full name";
    }

    else if ([txtJob.text length] == 0) {
        strMessage = @"Please enter Job title";
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
#pragma mark - WebService Call Method
- (void)callWebService {
    NSDictionary *paramDict = @{kNameTitle : txtName.text, kJobTitle : txtJob.text};
    [[TDWebServiceManager sharedManager] createPutRequestWithParameters:paramDict withRequestPath:UPDATE_USER withCompletionBlock:^(id responseObject, TDError *error) {
        if (!error) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Opps!" message:@"Updated Successfully" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *btnOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:btnOK];
            [self presentViewController:ac animated:YES completion:nil];
        }
        else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Opps!" message:@"Oops!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *btnOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:btnOK];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
    }];
    
}
@end
