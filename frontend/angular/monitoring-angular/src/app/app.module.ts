import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';
import { SignalrService } from 'src/services/signalr.service';
import { LineChartComponent } from './line-chart/line-chart.component';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { DecimalPipe } from '@angular/common';

@NgModule({
  declarations: [
    AppComponent,
    LineChartComponent
  ],
  imports: [
    BrowserModule,
    NgxChartsModule
  ],
  providers: [SignalrService,DecimalPipe],
  bootstrap: [AppComponent]
})
export class AppModule { }
