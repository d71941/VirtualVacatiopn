//
//  PhotoScrollViewController.m
//  TopPlaces
//
//  Created by admin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoScrollViewController.h"
#import "PhotoTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrImageCache.h"

@interface PhotoScrollViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation PhotoScrollViewController

@synthesize scrollView = _scrollView;
@synthesize image = _image;
@synthesize imageView = _imageView;
@synthesize spinner = _spinner;
@synthesize photo = _photo;


- (UIActivityIndicatorView *)spinner
{
    if(!_spinner)
    {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _spinner;
}

- (void)loadView
{
    [super loadView];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.autoresizesSubviews = NO;
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.imageView = [[UIImageView alloc] init];
    
    [self.scrollView addSubview:self.imageView];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.spinner];
}

- (void)setPhoto:(NSDictionary *)photo
{
    if(_photo != photo)
    {
        _photo = photo;
        [self showSpinner:YES];
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
        dispatch_async(downloadQueue, ^{
            FlickrImageCache *imageCache= [[FlickrImageCache alloc] init];
            UIImage *image = [imageCache getImageFromCacheWithIdentifier:[[photo valueForKey:FLICKR_PHOTO_ID] stringByAppendingString:@".large"]];
            if(!image)
            {
                NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                [imageCache addImageToCache:image withIdentifier:[[photo valueForKey:FLICKR_PHOTO_ID] stringByAppendingString:@".large"]];
            }
            if(self.photo == photo)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.title = [[PhotoTableViewController getDataForPhoto:photo] objectForKey:@"title"];
                    [self showSpinner:NO];
                    self.image = image;
                    [self resizeImage];
                });
            }
        });
        dispatch_release(downloadQueue);
    }
}

-(void)showSpinner:(BOOL) isShow
{
    if (isShow)
    {
        [self.spinner startAnimating];
    }
    else
    {
        [self.spinner stopAnimating];
    }
}

- (void)resizeImage
{
    if(self.image && self.scrollView && self.imageView)
    {
        self.imageView.image = self.image;
        
        if (self.image.size.width/self.image.size.height > self.scrollView.frame.size.width/self.scrollView.frame.size.height)
        {
            self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.height*self.image.size.width/self.image.size.height, self.scrollView.frame.size.height);
        }
        else
        {
            self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.width*self.image.size.height/self.image.size.width);
        }
        
        self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.frame = self.view.bounds;
    self.spinner.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    //[self showSpinner:(self.photo && !self.image)];
    [self resizeImage];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.scrollView = nil;
    self.imageView = nil;
    self.spinner = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
