#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    NSMutableString *initialString = [[NSMutableString alloc] initWithString:string];
    NSString *keyPhoneNumber = [[NSMutableString alloc] init];
    NSString *keyCountry = [[NSString alloc] init];
    NSDictionary *resultDict = @{KeyPhoneNumber: @"", KeyCountry: @""};

    NSDictionary *codeDict = @{@"+7": @"RU",
                               @"+77": @"KZ",
                               @"+380": @"UA",
                               @"+373": @"MD",
                               @"+374": @"AM",
                               @"+375": @"BY",
                               @"+992": @"TJ",
                               @"+993": @"TM",
                               @"+994": @"AZ",
                               @"+996": @"KG",
                               @"+998": @"UZ"};
// Check for +
    if ([initialString characterAtIndex:0] != '+') {
        [initialString insertString:@"+" atIndex:0];
    }
//    NSString *firstCaracter = [initialString substringToIndex:1];
//    if (![firstCaracter isEqualToString:@"+"]) {
//        initialString = [@"+" stringByAppendingString:string];
//    }
    NSArray *codeArray = [codeDict allKeys];
    for (NSString *code in codeArray) {
        if (initialString.length >= code.length) {
            NSString *phoneNumberCode = [initialString substringWithRange: NSMakeRange(0, code.length)];
            if ([phoneNumberCode isEqualToString: code]) {
                keyCountry = [codeDict objectForKey:code];
//                if ([keyCountry isEqualToString:@"RU"] && initialString.length > 2) {
//
//                }
                [initialString deleteCharactersInRange:NSMakeRange(0, code.length)];
                if (initialString.length > 0) {
                    keyPhoneNumber = [self convertType:initialString forCode:code andCountry: keyCountry];
                } else {
                    keyPhoneNumber = code;
                }
            }
        }
    }
    if (keyCountry.length<1) {
        keyCountry = @"";
        if (initialString.length > 12) {
            keyPhoneNumber = [initialString substringWithRange: NSMakeRange(0, 13)];
        } else {
            keyPhoneNumber = initialString;
        }
    }

    resultDict = @{KeyPhoneNumber: keyPhoneNumber, KeyCountry: keyCountry};
    return resultDict;
}

- (NSString *)convertType:(NSMutableString *)remainString forCode: (NSString *)code andCountry: (NSString *)country {
    NSMutableString *resultString = [code mutableCopy];
    [resultString appendString:@" "];

    NSString *formatString = @"";

    if ([country isEqualToString: @"RU"] || [country isEqualToString: @"KZ"]) {
        formatString = @"(xxx) xxx-xx-xx";
    } else if ([country isEqualToString: @"MD"] || [country isEqualToString: @"AM"] || [country isEqualToString: @"TM"]) {
        formatString = @"(xx) xxx-xxx";
    } else {
        formatString = @"(xx) xxx-xx-xx";
    }
    for (int i = 0; i < formatString.length; i++) {
        if (remainString.length != 0 && [formatString characterAtIndex:i] != 'x') {
            [resultString appendString: [formatString substringWithRange: NSMakeRange(i, 1)]];
//            [resultString stringByAppendingFormat:@"%c", [formatString characterAtIndex:i]];
        } else if (remainString.length != 0 && [formatString characterAtIndex:i] == 'x') {
//            [resultString stringByAppendingFormat:@"%c", [remainString characterAtIndex:0]];
            [resultString appendString: [remainString substringWithRange: NSMakeRange(0, 1)]];
            [remainString deleteCharactersInRange: NSMakeRange(0, 1)];
        }
    }

    return resultString;
}

@end
