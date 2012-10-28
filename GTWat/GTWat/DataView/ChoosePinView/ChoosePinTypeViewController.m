//
//  ChoosePinTypeViewController.m
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import "ChoosePinTypeViewController.h"

@interface ChoosePinTypeViewController ()

@end

@implementation ChoosePinTypeViewController

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
  
  pinTypes = [[NSArray alloc] initWithObjects:@"Question", @"Alert", @"Event", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)done:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark PickerView DataSource

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [pinTypes count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  NSLog(@"Row: %d", row );
  return [pinTypes objectAtIndex: row];
}

#pragma mark PickerView Delegate

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  NSString* descStr = [NSString stringWithFormat:@"Add description of pin type here for: %@", [pinTypes objectAtIndex:row]];
  
  [description setText:descStr];
}

-(UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
  NSLog(@"Row picked here: %d", row);
  UILabel* txtView = [[UILabel alloc] init];
  [txtView setText:[pinTypes objectAtIndex:row]];
  return txtView;
}

@end
