import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { DecimalPipe } from '@angular/common';

@Component({
  selector: 'app-line-chart',
  templateUrl: './line-chart.component.html',
  styleUrls: ['./line-chart.component.css']
})
export class LineChartComponent implements OnChanges {
  @Input() public data: any[] = [];
  @Input() public view: [number, number] = [700, 300];
  @Input() public colorScheme: any;
  @Input() public downloadCSV!: (data: any[], filename: string) => void;
  
  public lastDataPoint: { time: string, value: number } | null = null;

  public showXAxis = true;
  public showYAxis = true;
  public gradient = false;
  public showLegend = true;
  public showXAxisLabel = true;
  public xAxisLabel = 'Time';
  public showYAxisLabel = true;
  public yAxisLabel = 'Value';

  constructor(private decimalPipe: DecimalPipe) {}

  ngOnChanges(changes: SimpleChanges) {
    if (changes['data'] && this.data.length > 0 && this.data[0].series.length > 0) {
      const latestPoint = this.data[0].series[this.data[0].series.length - 1];
      this.lastDataPoint = { time: latestPoint.name, value: latestPoint.value };
    }
  }

  get formattedValue(): string {
    if (this.lastDataPoint) {
      return this.decimalPipe.transform(this.lastDataPoint.value, '1.2-2')!;
    }
    return '';
  }

  download() {
    this.downloadCSV(this.data, 'chart-data.csv');
  }

}
