//
//  tosmiss_iphoneViewController.m
//
//  Created by Justin Van Eaton on 6/20/11.
//

#import "tosmiss_iphoneViewController.h"

@implementation tosmiss_iphoneViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    theTabBar.selectedItem = [theTabBar.items objectAtIndex:0];
    
    NSString *url_string = [NSString stringWithFormat:@"%@/mobile/new", kWebAddress];
	
	NSURL *url = [NSURL URLWithString:url_string];
	
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[theWebView loadRequest:requestObj];
    
    
    
    
    url_string = [NSString stringWithFormat:@"%@/mobile/top", kWebAddress];
	
    url = [NSURL URLWithString:url_string];
	
    requestObj = [NSURLRequest requestWithURL:url];
	
	[theOtherOneWebView loadRequest:requestObj];
    
    
    
    url_string = [NSString stringWithFormat:@"%@/mobile/random", kWebAddress];
	
    url = [NSURL URLWithString:url_string];
	
    requestObj = [NSURLRequest requestWithURL:url];
	
	[theRandomWebView loadRequest:requestObj];
    
    
    
    [theSpinner removeFromSuperview];
    [theOtherOneSpinner removeFromSuperview];
    [theRandomSpinner removeFromSuperview];
    
    [theWebView addSubview:theSpinner];
    [theOtherOneWebView addSubview:theOtherOneSpinner];
    [theRandomWebView addSubview:theRandomSpinner];
    
    
    theSpinner.hidesWhenStopped = YES;
    theOtherOneSpinner.hidesWhenStopped = YES;
    theRandomSpinner.hidesWhenStopped = YES;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)about:(id)sender
{
    AboutViewController *controller = [[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil] autorelease];
    
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)cameraButtonAction:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.allowsEditing = YES;
    picker.delegate = self;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	else 
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (IBAction)refreshButtonAction:(id)sender
{
    [theWebView reload];
    [theOtherOneWebView reload];
    [theRandomWebView reload];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
    UIImage *image;
    
    image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!image) {
        [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
	UIImage *newImage = [self scaleImageWithImage:image];
    [self saveImage:newImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
}


-(UIImage*)scaleImageWithImage:(UIImage*)image
{  
	CGSize newSize = CGSizeMake(420, (int)(420.0 * (image.size.height / image.size.width)));
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
	
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	
    // End the context
    UIGraphicsEndImageContext();
	
    // Return the new image.
    return newImage;
}

-(void)saveImage:(UIImage *)image
{	 
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/image?v=%@", kWebAddress, version]]];
	
	[request setHTTPMethod:@"POST"];
	
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
	
	NSString *boundary = @"BroClientUploadWhWiVuHq";
	[request setValue:[NSString stringWithFormat: @"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
	NSString *boundaryString = [NSString stringWithFormat:@"\r\n--%@--\r\n", boundary];
	NSMutableData *postData = [NSMutableData dataWithCapacity:[imageData length] + 1024]; 
	
	[postData appendData:[[NSString stringWithFormat:@"--%@", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSString *header1 = [NSString stringWithFormat: @"\r\nContent-Disposition: form-data; name=\"theimage\"; filename=\"anything.jpg\"\r\n"];
	[postData appendData:[header1 dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSString *header2 = @"Content-Type: application/octet-stream\r\n\r\n";
	[postData appendData:[header2 dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postData appendData:imageData];
	
	[postData appendData:[boundaryString dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPBody: (NSData *)postData];
	
    
    receivedData = [[NSMutableData data] retain];
	
	[NSURLConnection connectionWithRequest:request delegate:self];
    
    
    
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 1) {
        theWebView.hidden = false;
        theOtherOneWebView.hidden = true;
        theRandomWebView.hidden = true;
    }
    else if (item.tag == 2) {
        theWebView.hidden = true;
        theOtherOneWebView.hidden = false;
        theRandomWebView.hidden = true;
    }
    else if (item.tag == 3) {
        theWebView.hidden = true;
        theOtherOneWebView.hidden = true;
        theRandomWebView.hidden = false;
    }
}






- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    //[connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Cannot Send Image" 
                                                     message: @"There was an error connecting to the server, please try again later"
                                                    delegate: nil 
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* string = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    
    if ([string isEqualToString:@"success"])
    {
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self
                                       selector:@selector(refreshButtonAction:) userInfo:nil repeats:NO];
    }
    else if ([string isEqualToString:@"upgrade"])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Upgrade Required" 
                                                         message: @"You must update the software for this feature to work"
                                                        delegate: nil 
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] autorelease];
        
        [alert show];
    }
    else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"A Message About Your Request" 
                                                         message: string
                                                        delegate: nil 
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] autorelease];
        
        [alert show];
    }
    
    [string release];
    
    // release the connection, and the data object
    //[connection release];
    [receivedData release];
}





- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (webView.tag == theWebView.tag) {
        [theSpinner startAnimating];
    }
    else if (webView.tag == theOtherOneWebView.tag) {
        [theOtherOneSpinner startAnimating];
    }
    else if (webView.tag == theRandomWebView.tag) {
        [theRandomSpinner startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.tag == theWebView.tag) {
        [theSpinner stopAnimating];
    }
    else if (webView.tag == theOtherOneWebView.tag) {
        [theOtherOneSpinner stopAnimating];
    }
    else if (webView.tag == theRandomWebView.tag) {
        [theRandomSpinner stopAnimating];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView.tag == theWebView.tag) {
        [theSpinner stopAnimating];
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error Connecting" 
                                                         message: @"There was an error connecting to the server, please try again later"
                                                        delegate: nil 
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] autorelease];
        
        [alert show];
    }
    else if (webView.tag == theOtherOneWebView.tag) {
        [theOtherOneSpinner stopAnimating];
    }
    else if (webView.tag == theRandomWebView.tag) {
        [theRandomSpinner stopAnimating];
    }
    
}




@end
