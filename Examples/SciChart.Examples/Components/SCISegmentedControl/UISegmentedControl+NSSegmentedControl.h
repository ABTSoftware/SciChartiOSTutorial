//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UISegmentedControl+NSSegmentedControl.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <TargetConditionals.h>

#if TARGET_OS_IOS

#import <UIKit/UISegmentedControl.h>

@interface UISegmentedControl (NSSegmentedControl)

@property NSInteger selectedSegment;

- (void)addTarget:(id)target valueChangeAction:(SEL)action;

@end

#endif
