//
//  FeedItem.m
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

#import "FeedItem.h"

@implementation FeedItem

@synthesize unRead = _unRead;

- (id)init
{
    if (self = [super init])
    {
        _properties = [[NSMutableDictionary alloc] init];
		_unRead = YES;
    }
    return self;
}

- (void)dealloc
{
	[_properties release];
    [super dealloc];
}

- (NSMutableDictionary *)properties
{
    return _properties;
}

- (void)setProperties:(NSDictionary *)newProperties
{
	[_properties release];
	_properties = [[NSMutableDictionary alloc] initWithDictionary:newProperties];
}

- (BOOL)isEqual:(id)anObject
{
	// Ensure it's the same class.
	if ([self class] != [anObject class])
	{
		return NO;
	}
	
	// Compare all the keys from the foreign object.
	NSEnumerator *foreignKeys = [[anObject properties] keyEnumerator];
	NSString *key;
	while (key = [foreignKeys nextObject])
	{
		if (![[[self properties] valueForKey:key] isEqual:[[anObject properties] valueForKey:key]])
		{
			return NO;
		}
	}

	// The two objects seem to be the same.
	return YES;
}

- (id) initWithCoder: (NSCoder *)coder  
{  
    if (self = [super init])  
    {  
        [self setProperties:[coder decodeObjectForKey:@"_properties"]];
		_unRead = [coder decodeBoolForKey:@"unread"];
    }  
    return self;  
}  
- (void) encodeWithCoder: (NSCoder *)coder  
{  
    [coder encodeObject:[self properties] forKey:@"_properties"];
	[coder encodeBool:_unRead forKey:@"unread"];
} 
@end
