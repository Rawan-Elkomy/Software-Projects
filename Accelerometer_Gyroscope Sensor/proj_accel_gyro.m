%% Setup 
clear all
hold all

%% Defining arduino and mpu5060 sensor
a = arduino('COM5', 'Uno', 'Libraries', 'I2C');
imu = mpu6050(a);

%% Accelerometer and Gyroscope Graph
xlabel('Count');
ylabel('Sensor Values');
title('Sensor Readings for Acceleration and Gyroscope');
x_accel_val = animatedline('Color', 'r'); 
y_accel_val = animatedline('Color', 'g');
z_accel_val = animatedline('Color', 'b');
x_gyro_val = animatedline('Color', 'c');  
y_gyro_val = animatedline('Color', 'm');  
z_gyro_val = animatedline('Color', 'y');  
axis tight;
legend('Acceleration X', 'Acceleration Y', 'Acceleration Z', 'Gyroscope X', 'Gyroscope Y', 'Gyroscope Z');

%% Timer 
stop_time = 60;  % records the values for 60 seconds
count = 1; % counter starts at 1
tic; % starts a timer using the tic function

%% Adjust the sampling rate
sampling_rate = 1000;  %  in Hz
pause_duration = 1 / sampling_rate;

%% Real-time Data Acquisition
while(toc <= stop_time)
    [accel, gyro] = readSensorData(imu);  % New function to read both accelerometer and gyroscope
    addpoints(x_accel_val, count, accel(:,1));
    addpoints(y_accel_val, count, accel(:,2));
    addpoints(z_accel_val, count, accel(:,3));
    addpoints(x_gyro_val, count, gyro(:,1));
    addpoints(y_gyro_val, count, gyro(:,2));
    addpoints(z_gyro_val, count, gyro(:,3));
    count = count + 1;
    drawnow limitrate;
    pause(pause_duration);  % Adjust the pause duration based on the desired sampling rate
end

%% Function to read data for Gyroscope
function [accel, gyro] = readSensorData(imu)
    accel = readAcceleration(imu); % Read accelerometer data
    gyro = readAngularVelocity(imu); % Read gyroscope data
end
