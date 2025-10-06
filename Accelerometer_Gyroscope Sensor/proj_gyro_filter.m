%% Setup
clear all
hold all

%% Defining arduino and mpu5060 sensor
a = arduino('COM5', 'Uno', 'Libraries', 'I2C');
imu = mpu6050(a);

%% Gyroscope Graph (Unfiltered)
figure;
subplot(2,1,1);
xlabel('Count');
ylabel('Angular Velocity (rad/s)');
title('Gyroscope Values (Unfiltered)');
x_val_unfiltered = animatedline('Color', 'c');
y_val_unfiltered = animatedline('Color', 'm');
z_val_unfiltered = animatedline('Color', 'y');
axis tight;
legend('Gyroscope X', 'Gyroscope Y', 'Gyroscope Z');

%% Gyroscope Graph (Filtered)
subplot(2,1,2);
xlabel('Count');
ylabel('Angular Velocity (rad/s)');
title('Gyroscope Values (Filtered)');
x_val_filtered = animatedline('Color', 'c');
y_val_filtered = animatedline('Color', 'm');
z_val_filtered = animatedline('Color', 'y');
axis tight;
legend('Gyroscope X', 'Gyroscope Y', 'Gyroscope Z');

%% Timer  
stop_time = 60;  % plots the graph for 60 seconds
count = 1; % counter starts at 1
tic; % starts a timer using the tic function

%% Complemeh764untary Filter Parameters
alpha = 0.5; % Complementary filter factor
sampling_rate = 100;  % Hz

%% Initialize orientation
orientation = [0, 0, 0];

%% Real-time Data Acquisition
while(toc <= stop_time)
    [gyro, accel] = readSensorData(imu); % Read gyroscope and accelerometer data
    
    % Unfiltered Data
    addpoints(x_val_unfiltered, count, gyro(:, 1));
    addpoints(y_val_unfiltered, count, gyro(:, 2));
    addpoints(z_val_unfiltered, count, gyro(:, 3));
    
    % Apply complementary filter
    orientation = alpha * (orientation + gyro * 1/sampling_rate) + (1 - alpha) * accel;
    
    % Filtered Data
    addpoints(x_val_filtered, count, orientation(1));
    addpoints(y_val_filtered, count, orientation(2));
    addpoints(z_val_filtered, count, orientation(3));
    
    count = count + 1;
    drawnow limitrate; % updates the plot 
end

%% Function to read data for Gyroscope and Accelerometer
function [gyro, accel] = readSensorData(imu)
    gyro = readAngularVelocity(imu); % Read gyroscope data
    accel = readAcceleration(imu);   % Read accelerometer data
end
