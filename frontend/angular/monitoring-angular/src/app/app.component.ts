import { Component, OnInit } from '@angular/core';
import { SignalrService } from 'src/services/signalr.service';


interface TimeSeriesData {
  time: string;
  value: number;
}

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  public chartData1: any[] = [{ name: 'Data1', series: [] }];
  public chartData2: any[] = [{ name: 'Data2', series: [] }];
  public chartData3: any[] = [{ name: 'Data3', series: [] }];
  public view: [number, number] = [2000, 250];

  public colorScheme1 = { domain: ['#0f0a60'] };
  public colorScheme2 = { domain: ['#fb0a60'] };
  public colorScheme3 = { domain: ['#14ff0d'] };

  constructor(private signalrService: SignalrService) {}

  ngOnInit() {
    this.signalrService.startConnection();
    this.signalrService.connection.on('ReceiveMessage', (data: { data1: TimeSeriesData[], data2: TimeSeriesData[], data3: TimeSeriesData[] }) => {
      this.updateChartData(data);
    });
  }

  private formatTime(time: string): string {
    return new Date(time).toISOString().split('.')[0].replace('T', ' ');

  }

  private updateChartData(data: { data1: TimeSeriesData[], data2: TimeSeriesData[], data3: TimeSeriesData[] }) {
    data.data1.forEach((d: TimeSeriesData) => {
      this.chartData1[0].series.push({ name: this.formatTime(d.time), value: d.value });
    });
    data.data2.forEach((d: TimeSeriesData) => {
      this.chartData2[0].series.push({ name: this.formatTime(d.time), value: d.value });
    });
    data.data3.forEach((d: TimeSeriesData) => {
      this.chartData3[0].series.push({ name: this.formatTime(d.time), value: d.value });
    });

    this.chartData1 = [...this.chartData1];
    this.chartData2 = [...this.chartData2];
    this.chartData3 = [...this.chartData3];
  }

  public downloadCSV(data: any[], filename: string) {
    const csvData = this.convertToCSV(data);
    const blob = new Blob([csvData], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.setAttribute('hidden', '');
    a.setAttribute('href', url);
    a.setAttribute('download', filename);
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }

  private convertToCSV(data: any[]): string {
    const headers = ['Time', 'Value'];
    const rows = data[0].series.map((d: any) => `${d.name},${d.value}`);
    return [headers.join(','), ...rows].join('\n');
  }
}
