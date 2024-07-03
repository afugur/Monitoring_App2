// src/app/signalr.service.ts
import { Injectable } from '@angular/core';
import * as signalR from '@microsoft/signalr';

@Injectable({
  providedIn: 'root'
})
export class SignalrService {
  private hubConnection: signalR.HubConnection;

  public dataReceived: any = [];

  constructor() {
    this.hubConnection = new signalR.HubConnectionBuilder()
      .withUrl('http://localhost:5033/myHub')
      .build();
    
    this.hubConnection.on('ReceiveMessage', (data) => {
      console.log('Data received: ', data);
      this.dataReceived = data;
    });

    this.startConnection();
  }

  public startConnection = () => {
    if (this.hubConnection.state === signalR.HubConnectionState.Disconnected) {
      this.hubConnection
        .start()
        .then(() => console.log('SignalR connection started'))
        .catch(err => console.error('Error while starting SignalR connection: ', err));
    }
  }

  public get connection() {
    return this.hubConnection;
  }
}
