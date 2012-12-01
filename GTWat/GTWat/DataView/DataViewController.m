//
//  DataViewController.m
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

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
  navBar.topItem.title = @"Llamas!";
}


-(IBAction)done:(id)sender {
    UIAlertView *shareAlert = [[UIAlertView alloc] initWithTitle:@"Share Your Post"
                                                      message:@"Would you like to share this post on your Social Network?"
                                                     delegate:self
                                            cancelButtonTitle:@"No Thanks."
                                            otherButtonTitles:@"Yes, Please!", nil];
    [shareAlert show];
    [shareAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Yes, Please!"]){
        NSString *textToShare = @"test!"; //Change what we share here.
        NSArray *activityItems = @[textToShare];
        UIActivityViewController *activityVC =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                          applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
