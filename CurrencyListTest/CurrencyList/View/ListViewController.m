#import "ListViewController.h"
#import "Currency.h"

@interface ListViewController ()

@property (strong, nonatomic) NSMutableArray<Currency *> *currencies;

@end

@implementation ListViewController

NSString *cellId = @"currencyCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self fetchCurrecies];
}

- (void)fetchCurrecies {
    NSLog(@"fetching currencies");
    NSString *urlString = @"http://phisix-api3.appspot.com/stocks.json";
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"finished fetching currencies");
        
        NSError *err;
        
        NSDictionary *currencyResponseJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if(err) {
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        NSMutableArray<Currency *> *currenciesFromJSON = NSMutableArray.new;
        for(NSDictionary *currency in currencyResponseJson[@"stock"]) {
            Currency *currencyViewModel = Currency.new;
            currencyViewModel.amount = currency[@"amount"];
            currencyViewModel.name = currency[@"name"];
            currencyViewModel.changePercent = currency[@"percent_change"];
            currencyViewModel.symbol = currency[@"symbol"];

            [currenciesFromJSON addObject:currencyViewModel];
        }
        
        self.currencies = currenciesFromJSON;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }] resume];
}

- (void)setupView {
    self.navigationItem.title = @"Currency";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellId];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonTapped)];
}
                                              
- (void)refreshButtonTapped {
    [self fetchCurrecies];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    Currency *currency = self.currencies[indexPath.item];
    
    cell.textLabel.text = currency.name;
    cell.detailTextLabel.text = currency.amount;
    
    return cell;
}

@end
