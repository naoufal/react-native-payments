#import <UIKit/UIKit.h>
#import "BTSpecDependencies.h"
#import "BTUICardExpirationValidator.h"

SpecBegin(BTUICardExpirationValidator)

describe(@"month:year:validForDate:", ^{
    context(@"validating month and year relative to given validation date", ^{
        __block NSDate *today;

        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            components.day = 2;
            components.month = 5;
            components.year = 2014;
            today = components.date;
        });

        it(@"returns false when the month year are before the provided date ", ^{
            BOOL monthYearBeforeTodayValid = [BTUICardExpirationValidator month:4 year:14 validForDate:today];
            expect(monthYearBeforeTodayValid).to.beFalsy();
        });

        it(@"returns true when the month year are the same as the provided date ", ^{
            BOOL monthYearSameAsTodayValid = [BTUICardExpirationValidator month:5 year:14 validForDate:today];
            expect(monthYearSameAsTodayValid).to.beTruthy();
        });

        it(@"returns true when the month year are after the provided date ", ^{
            BOOL monthYearAfterTodayValid = [BTUICardExpirationValidator month:8 year:14 validForDate:today];
            expect(monthYearAfterTodayValid).to.beTruthy();
        });

        describe(@"Year in YYYY", ^{
            it(@"returns true when the month year are after the provided date", ^{
                BOOL monthYearValid = [BTUICardExpirationValidator month:8 year:2014 validForDate:today];
                expect(monthYearValid).to.beTruthy();
            });

            it(@"returns false when the month year are before the provided date", ^{
                BOOL monthYearValid = [BTUICardExpirationValidator month:4 year:2014 validForDate:today];
                expect(monthYearValid).to.beFalsy();
            });
        });
    });

    context(@"validating dates at the end of the year", ^{
        __block NSDate *endOfYearToday;
        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            components.day = 1;
            components.month = 12;
            components.year = 2014;
            endOfYearToday = components.date;
        });

        it(@"returns true when the month/year are the same as the provided date", ^{
            BOOL monthYearValid = [BTUICardExpirationValidator month:12 year:2014 validForDate:endOfYearToday];
            expect(monthYearValid).to.beTruthy();
        });
    });

    context(@"validating dates far in the future", ^{
        __block NSDate *today;

        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            components.day = 2;
            components.month = 5;
            components.year = 2014;
            today = components.date;
        });

        it(@"returns true when the month year are before but near the far future date", ^{
            BOOL monthYearValid = [BTUICardExpirationValidator month:4 year:14 + kBTUICardExpirationValidatorFarFutureYears validForDate:today];
            expect(monthYearValid).to.beTruthy();
        });

        it(@"returns false when the month year are not before the far future date", ^{
            BOOL monthYearValid = [BTUICardExpirationValidator month:5 year:14 + kBTUICardExpirationValidatorFarFutureYears validForDate:today];
            expect(monthYearValid).to.beFalsy();
        });
    });

    context(@"month and year formats", ^{
        __block NSDate *today;

        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            components.day = 2;
            components.month = 2;
            components.year = 2014;
            today = components.date;
        });

        it(@"accepts 2 digit years", ^{
            BOOL monthYearValid = [BTUICardExpirationValidator month:4 year:14 validForDate:today];
            expect(monthYearValid).to.beTruthy();
        });

        it(@"accepts 4 digit years", ^{
            BOOL monthYearValid = [BTUICardExpirationValidator month:4 year:2014 validForDate:today];
            expect(monthYearValid).to.beTruthy();
        });
    });
});

SpecEnd
