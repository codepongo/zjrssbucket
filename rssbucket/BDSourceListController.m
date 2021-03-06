	//
	//  BDSourceListController.m
	//  rssbucket
	//
	// Copyright 2008 Brian Dunagan (brian@bdunagan.com)
	//
	// MIT License
	// Permission is hereby granted, free of charge, to any person
	// obtaining a copy of this software and associated documentation
	// files (the "Software"), to deal in the Software without
	// restriction, including without limitation the rights to use,
	// copy, modify, merge, publish, distribute, sublicense, and/or sell
	// copies of the Software, and to permit persons to whom the
	// Software is furnished to do so, subject to the following
	// conditions:
	//
	// The above copyright notice and this permission notice shall be
	// included in all copies or substantial portions of the Software.
	//
	// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	// OTHER DEALINGS IN THE SOFTWARE.
	//

#import "BDSourceListController.h"
#import "Feed.h"
#import "FeedItem.h"
#import "BDBadgeCell.h"
#import "MainController.h"

@implementation BDSourceListController

- (id)init
{
	self = [super init];
	
	if (self != nil)
	{
		_indicators = [[NSMutableArray alloc] init];
	}
	return self;
}
- (void)awakeFromNib
{
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [[feeds arrangedObjects] count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	return [[[feeds arrangedObjects] objectAtIndex:rowIndex] valueForKeyPath:@"properties.title"];
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	Feed *currentFeed = [[feeds arrangedObjects] objectAtIndex:rowIndex];
	
	if (currentFeed.isFeeding)
	{
		[aCell setIsFeeding:YES];
		
	}
	else
	{
		[aCell setIsFeeding:NO];
	}
	id indicator;
	if ([_indicators count] <= rowIndex) {
		indicator = [[[NSProgressIndicator alloc] init]autorelease];
		[_indicators addObject:indicator];
	}
	else {
		indicator = [_indicators objectAtIndex:rowIndex];
	}
		
	[aCell setIndicator:indicator];
	NSUInteger count =0;
	for (FeedItem* item in [currentFeed feedItems])
	{
		if (item.unRead)
		{
			count++;
		}
	}
	
	[aCell setBadgeCount:count];
	[aCell setIcon:[currentFeed valueForKeyPath:@"properties.icon"]];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
	MainController* ctroller = [NSApp delegate];
	ctroller.shouldChange = NO;
	[feeds setSelectionIndex:[sourceList selectedRow]];
	ctroller.shouldChange = YES;
		//[[NSApp delegate] updateWebView];
}

@end
