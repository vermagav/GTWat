//
//  ViewController.m
//  GTWat
//
//  Created by Gav Verma on 10/23/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "ViewController.h"
#import "DataViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//  
  //DataViewController* dvc = [[DataViewController alloc] init];
  //[dvc.view setBackgroundColor:[UIColor whiteColor]];
//  
  //UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:dvc];
//  [self presentViewController:navController animated:YES completion:nil];

  
  
  [self performSegueWithIdentifier:@"PinSegue" sender:self];
}

@end
