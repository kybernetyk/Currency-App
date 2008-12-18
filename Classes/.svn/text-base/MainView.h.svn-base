//
//  MainView.h
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainView : UIView {
	IBOutlet UITableView *tableView;
	NSMutableArray *calcList;
	
	IBOutlet UITextField *inputField;
	IBOutlet UIBarButtonItem *editButton;
	IBOutlet UIBarButtonItem *updateButton;
	IBOutlet UIPickerView *pickerView;
	IBOutlet UIView *addView;

	IBOutlet UILabel *addViewLabel1;
	IBOutlet UILabel *addViewLabel2;
	IBOutlet UILabel *lastUpdatedLabel;
	
	IBOutlet UIToolbar *editBar;
	IBOutlet UIToolbar *mainBar;
	

	UIImage *cellBackgroundImage; // fuer gerade zellen
	
	
	//BOOL canEdit;
	
	NSMutableArray *currencyList;
	NSDate *lastUpdated;
	

	
}

@property (readwrite, retain) NSDate *lastUpdated;
@property (readwrite, retain) NSMutableArray *calcList;
@property (readwrite, retain) NSMutableArray *currencyList;

- (BOOL) loadCalcList;
- (BOOL) saveCalcList;

- (BOOL) loadCurrencyList;
- (BOOL) saveCurrencyList;

- (void) createDefaultCurrencyList;
- (void) createDefaultCalcList;

- (void) didLoad;

- (IBAction) addCellToTableView: (id) sender;
- (IBAction) addViewReturnSave: (id) sender;
- (IBAction) addViewReturnCancel: (id) sender;

- (IBAction) toggleEdit: (id) sender;

- (IBAction) calc: (id) sender;
- (IBAction) updateExchangeRates: (id) sender;
@end
