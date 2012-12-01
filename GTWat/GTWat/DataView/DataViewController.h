//
//  DataViewController.h
//  GTWat
//
//  Created by Kevin Hampton on 10/28/12.
//  Copyright (c) 2012 404 Team Not Found. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController <UIAlertViewDelegate> {
  IBOutlet UINavigationBar* navBar;
}

-(IBAction)done:(id)sender;

@end
