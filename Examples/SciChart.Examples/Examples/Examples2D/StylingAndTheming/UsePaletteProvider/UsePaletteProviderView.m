//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsePaletteProviderView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UsePaletteProviderView.h"
#import "SCDDataManager.h"
#import "XyCustomPaletteProvider.h"
#import "OhlcCustomPaletteProvider.h"

@interface AnnotationDragListener : NSObject<ISCIAnnotationDragListener>
@end
@implementation AnnotationDragListener
- (void)onDragStarted:(id<ISCIAnnotation>)annotation {
    [self updateAnnotation:annotation];
}
- (void)onDragAnnotation:(id<ISCIAnnotation>)annotation byXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta {
    [self updateAnnotation:annotation];
}
- (void)onDragEnded:(id<ISCIAnnotation>)annotation {
    [self updateAnnotation:annotation];
}
- (void)updateAnnotation:(id<ISCIAnnotation>)annotation {
    annotation.y1 = @(0);
    annotation.y2 = @(1);
}
@end

@implementation UsePaletteProviderView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:150.0 max:165.0];
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    
    SCDPriceSeries *priceData = [SCDDataManager getPriceDataIndu];
    double offset = -1000;

    SCIXyDataSeries *mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIOhlcDataSeries *ohlcDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIOhlcDataSeries *candlestickDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *scatterDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    
    [mountainDataSeries appendValuesX:priceData.indexesAsDouble y:priceData.lowData];
    [lineDataSeries appendValuesX:priceData.indexesAsDouble y:[SCDDataManager offset:priceData.closeData offset:-offset]];
    [columnDataSeries appendValuesX:priceData.indexesAsDouble y:[SCDDataManager offset:priceData.closeData offset:offset * 3]];
    
    [ohlcDataSeries appendValuesX:priceData.indexesAsDouble open:priceData.openData high:priceData.highData low:priceData.lowData close:priceData.closeData];
    [candlestickDataSeries appendValuesX:priceData.indexesAsDouble
                                    open:[SCDDataManager offset:priceData.openData offset:offset]
                                    high:[SCDDataManager offset:priceData.highData offset:offset]
                                     low:[SCDDataManager offset:priceData.lowData offset:offset]
                                   close:[SCDDataManager offset:priceData.closeData offset:offset]];
    [scatterDataSeries appendValuesX:priceData.indexesAsDouble y:[SCDDataManager offset:priceData.closeData offset:offset * 2.5]];

    SCIBoxAnnotation *boxAnnotation = [SCIBoxAnnotation new];
    boxAnnotation.x1 = @(152);
    boxAnnotation.y1 = @(1.0);
    boxAnnotation.x2 = @(158);
    boxAnnotation.y2 = @(0.0);
    boxAnnotation.coordinateMode = SCIAnnotationCoordinateMode_RelativeY;
    boxAnnotation.isEditable = YES;
    boxAnnotation.fillBrush = [[SCILinearGradientBrushStyle alloc] initWithStart:CGPointZero end:CGPointMake(0, 1) startColorCode:0x550000FF endColorCode:0x55FFFF00];                    
    boxAnnotation.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 thickness:1.0];
    boxAnnotation.annotationDragListener = [AnnotationDragListener new];
    
    SCIFastMountainRenderableSeries *mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = mountainDataSeries;
    mountainSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x9787CEEB];
    mountainSeries.strokeStyle  = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF00FF thickness:1.0];
    mountainSeries.zeroLineY = 6000;
    mountainSeries.paletteProvider = [[XyCustomPaletteProvider alloc] initWithColor:SCIColor.redColor annotation:boxAnnotation];

    SCIEllipsePointMarker *ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColor:SCIColor.redColor];
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.orangeColor thickness:2.0];
    ellipsePointMarker.size = CGSizeMake(10, 10);

    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = lineDataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0000FF thickness:1.0];
    lineSeries.pointMarker = ellipsePointMarker;
    lineSeries.paletteProvider = [[XyCustomPaletteProvider alloc] initWithColor:SCIColor.redColor annotation:boxAnnotation];

    SCIFastOhlcRenderableSeries *ohlcSeries = [SCIFastOhlcRenderableSeries new];
    ohlcSeries.dataSeries = ohlcDataSeries;
    ohlcSeries.paletteProvider = [[OhlcCustomPaletteProvider alloc] initWithColor:SCIColor.blueColor annotation:boxAnnotation];

    SCIFastCandlestickRenderableSeries *candlestickSeries = [SCIFastCandlestickRenderableSeries new];
    candlestickSeries.dataSeries = candlestickDataSeries;
    candlestickSeries.paletteProvider = [[OhlcCustomPaletteProvider alloc] initWithColor:SCIColor.greenColor annotation:boxAnnotation];

    SCIFastColumnRenderableSeries *columnSeries = [SCIFastColumnRenderableSeries new];
    columnSeries.dataSeries = columnDataSeries;
    columnSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.blueColor thickness:1];
    columnSeries.zeroLineY = 6000;
    columnSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColor:SCIColor.blueColor];
    columnSeries.paletteProvider = [[XyCustomPaletteProvider alloc] initWithColor:SCIColor.purpleColor annotation:boxAnnotation];

    SCISquarePointMarker *squarePointMarker = [SCISquarePointMarker new];
    squarePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColor:SCIColor.redColor];
    squarePointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.orangeColor thickness:2.0];
    squarePointMarker.size = CGSizeMake(7, 7);

    SCIXyScatterRenderableSeries *scatterSeries = [SCIXyScatterRenderableSeries new];
    scatterSeries.dataSeries = scatterDataSeries;
    scatterSeries.pointMarker = squarePointMarker;
    scatterSeries.paletteProvider = [[XyCustomPaletteProvider alloc] initWithColor:SCIColor.greenColor annotation:boxAnnotation];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries addAll:mountainSeries, lineSeries, ohlcSeries, candlestickSeries, columnSeries, scatterSeries, nil];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        [self.surface.annotations add:boxAnnotation];
        
        [SCIAnimations scaleSeries:mountainSeries withZeroLine:6000 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:lineSeries withZeroLine:12500 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:ohlcSeries withZeroLine:11750 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:candlestickSeries withZeroLine:10750 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:columnSeries withZeroLine:6000 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:scatterSeries withZeroLine:9000 duration:3.0 andEasingFunction:[SCIElasticEase new]];
    }];
}

@end
