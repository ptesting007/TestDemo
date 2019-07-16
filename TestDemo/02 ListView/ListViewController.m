//
//  ListViewController.m
//  TestDemo
//
//  Created by Piyush Kaklotar on 16/07/19.
//  Copyright © 2019 Piyush Kaklotar. All rights reserved.
//

#import "ListViewController.h"
#import "TDConfiguration.h"
#import "UIImageView+WebCache.h"
#import "TDWebServiceManager.h"
#import "ListUserCell.h"
#import "UpdateDataViewController.h"

#define CELL_HEIGHT 140

@interface ListViewController () {
    IBOutlet UICollectionView *collView;
    NSMutableArray *arrUserList;
    int pageCount;
    int totalPage;
    int selectedUser;
}
@end

@implementation ListViewController
#pragma mark - General Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = FALSE;
    self.navigationItem.hidesBackButton = YES;
    pageCount = 1;
    [arrUserList removeAllObjects];
    arrUserList = [[NSMutableArray alloc] init];
    [self callWebService];
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Logout"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(btnLogout_Pressed)];
    self.navigationItem.rightBarButtonItem = flipButton;
    
    
}
#pragma mark - Other Methods
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize {
    
    CGFloat scaleFactor = [UIScreen mainScreen].scale;
    if (image.size.width > targetSize.width || image.size.height > targetSize.height)
        if (!((scaleFactor = (targetSize.width / image.size.width)) > (targetSize.height / image.size.height))) //scale to fit width, or
            scaleFactor = targetSize.height / image.size.height; // scale to fit heigth.
    UIGraphicsBeginImageContext(targetSize);
    CGRect rect = CGRectMake((targetSize.width - image.size.width * scaleFactor) / 2, (targetSize.height - image.size.height * scaleFactor) / 2,
                             image.size.width * scaleFactor, image.size.height * scaleFactor);
    [image drawInRect: rect];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)btnLogout_Pressed {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - WebService Call Method
- (void)callWebService {
    
    [[TDWebServiceManager sharedManager] createGetRequestWithParameters:nil withRequestPath:[LIST_USER stringByReplacingOccurrencesOfString:@"{value}" withString:[NSString stringWithFormat:@"%i", pageCount]] withCompletionBlock:^(id responseObject, TDError *error) {
        if (!error) {
            NSDictionary *responseData = (NSDictionary *)responseObject;
            NSMutableArray *temp = [responseData valueForKey:@"data"];
            [self->arrUserList addObjectsFromArray:temp];
            [self->collView reloadData];
            temp = nil;
            self->totalPage = [[responseData valueForKey:@"total_pages"] intValue];
        }
        else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Opps!" message:@"Oops!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *btnOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:btnOK];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
    }];
    
}
#pragma mark - UICollectionView DataSource & Delegate Methods
- (NSInteger)collectionView:(UICollectionView *)colView numberOfItemsInSection:(NSInteger)section{
    return [arrUserList count];
}
- (ListUserCell *)collectionView:(UICollectionView *)colView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ListUserCell *cell = [colView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.viewForFirstBaselineLayout.layer.borderColor = [UIColor blackColor].CGColor;
    cell.viewForFirstBaselineLayout.layer.borderWidth = 2.0f;
    
    //Image Path
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[[arrUserList objectAtIndex:indexPath.row] valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"imgCellBG.png"]
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          if (cell.imgView.frame.size.height != cell.imgView.image.size.height)
                          {
                              CGFloat scaleFactor = [UIScreen mainScreen].scale;
                              CGSize size = CGSizeMake(cell.imgView.frame.size.width * scaleFactor, cell.imgView.frame.size.height * scaleFactor) ;
                              [cell.imgView setImage:[self scaleImage:image toSize:size]];
                          }
                      }];
    
    cell.lblTitle.text = [NSString stringWithFormat:@"%@ %@", [[arrUserList objectAtIndex:indexPath.row] valueForKey:@"first_name"], [[arrUserList objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
    ListUserCell *tempCell = cell;
    cell = nil;
    return tempCell;
}
- (void)collectionView:(UICollectionView *)colView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedUser = (int)indexPath.row;
    [self performSegueWithIdentifier:@"pushUpdateData" sender:self];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    pageCount ++;
    if (pageCount <= totalPage) {
        [self callWebService];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pushUpdateData"]) {
        UpdateDataViewController *object = (UpdateDataViewController *)[segue destinationViewController];
        object.dicSelectedUser = [arrUserList objectAtIndex:selectedUser];
    }
}

@end
