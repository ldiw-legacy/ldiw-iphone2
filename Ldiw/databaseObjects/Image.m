#import "Image.h"
#import "Database.h"

@implementation Image

+ (Image *)newImageWithLocalUrl:(NSString*)localURL {
  Image *img = [Image insertInManagedObjectContext:[[Database sharedInstance] managedObjectContext]];
  img.localURL = localURL;
  return img;
}

@end
