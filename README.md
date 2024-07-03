# Real-time Monitoring with Angular, SignalR, and Flutter

This project is a real-time monitoring built with Angular for the web frontend, SignalR for real-time data communication, and Flutter for the mobile application. The dashboard displays real-time data updates in charts and allows downloading data in CSV format.

![FlowAnimation](https://github.com/afugur/Monitoring_App2/assets/62245496/c5121d63-b443-4746-aa90-8a9796f6e804)
## Features

- Real-time data updates using SignalR
- Line charts for visualizing data
- Download chart data as CSV
- Angular for the web dashboard
- Flutter for the mobile application with Bloc state management and queue structure

## Prerequisites

- Node.js
- Angular CLI
- .NET SDK (for SignalR backend)
- Flutter SDK

## Installation

### SignalR Backend

1. Clone the repository and navigate to the backend directory:

    ```sh
    git clone <repository-url>
    cd <repository-directory>/backend
    ```

2. Restore the .NET dependencies:

    ```sh
    dotnet restore
    ```

3. Run the SignalR server:

    ```sh
    dotnet run
    ```


### Angular Application

1. Navigate to the Angular directory:

    ```sh
    cd ../angular/monitoring-angular
    ```

2. Install the dependencies:

    ```sh
    npm install
    ```

3. Install additional types:

    ```sh
    npm install --save-dev @types/d3-shape @types/d3-scale @types/d3-selection
    ```

4. Start the Angular application:

    ```sh
    ng serve
    ```

5. Open your browser and navigate to `http://localhost:4200`.

### Flutter Application

1. Navigate to the Flutter directory:

    ```sh
    cd ../flutter/monitoring_flutter
    ```

2. Install the dependencies:

    ```sh
    flutter pub get
    ```

3. Run the Flutter application:

    ```sh
    flutter run
    ```

## Project Structure

### SignalR Backend

The SignalR backend handles real-time communication between the server and clients.

- **MyHub.cs**: Defines the SignalR hub for handling client connections and broadcasting messages.
- **Program.cs**: Configures the SignalR middleware and starts the application.

### Angular Application

The Angular application displays real-time data in charts and allows downloading the data as CSV.

- **SignalrService**: Handles SignalR connection and real-time data updates.
- **LineChartComponent**: Displays real-time data in charts and allows downloading data as CSV.
- **AppComponent**: Manages the state and updates for the charts.

### Flutter Application

The Flutter application uses Bloc state management and a queue structure to manage and display real-time data.

- **PublishDataService**: Handles SignalR connection and data publishing for real-time updates.
- **DataBloc**: Manages the state and events for real-time data using Bloc pattern.
- **AppComponent**: Displays real-time charts and manages user interactions.

#### State Management with Bloc

The Flutter application uses Bloc state management to handle the state of the data streams and queue structure to manage incoming data.

- **DataState**: Defines the state including streaming status and data queues.
- **DataEvent**: Defines events like `StartDataStream`, `PauseDataStream`, and `UpdateData`.
- **DataBloc**: Handles the business logic for managing data streams and state transitions.

#### Queue Structure

The Flutter application uses a queue to store incoming data points and ensures the chart displays the most recent data within a defined limit.

## Conclusion

This project demonstrates a real-time monitoring dashboard with Angular and SignalR for the web, and Flutter for the mobile application. The dashboard provides real-time data updates, visualization in charts, and data download functionality.

