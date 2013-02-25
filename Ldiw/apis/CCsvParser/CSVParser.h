//
//  CSVParser.h
//  CSVImporter

@interface CSVParser : NSObject
{
	NSString *csvString;
	NSString *separator;
	NSScanner *scanner;
	BOOL hasHeader;
	NSMutableArray *fieldNames;
	NSCharacterSet *endTextCharacterSet;
}

- (id)initWithString:(NSString *)string;
- (id)initWithString:(NSString *)aCSVString separator:(NSString *)aSeparatorString hasHeader:(BOOL)header fieldNames:(NSArray *)names;

- (NSArray *)arrayOfParsedRows;
- (void)parseRows;

- (NSArray *)parseFile;
- (NSMutableArray *)parseHeader;
- (NSDictionary *)parseRecord;
- (NSString *)parseName;
- (NSString *)parseField;
- (NSString *)parseEscaped;
- (NSString *)parseNonEscaped;
- (NSString *)parseDoubleQuote;
- (NSString *)parseSeparator;
- (NSString *)parseLineSeparator;
- (NSString *)parseTwoDoubleQuotes;
- (NSString *)parseTextData;

@end
