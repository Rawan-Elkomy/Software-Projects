%% Setup
clear all
hold all

%% Defining arduino and mpu5060 sensor
a = arduino('COM5', 'Uno', 'Libraries', 'I2C');
imu = mpu6050(a);

%% Gyroscope Graph
xlabel('Count');
ylabel('Angular Velocity (rad/s)');
title('Gyroscope Values');
x_val = animatedline('Color', 'c');
y_val = animatedline('Color', 'm');
z_val = animatedline('Color', 'y');
axis tight;
legend('Gyroscope X', 'Gyroscope Y', 'Gyroscope Z');

%% Timer  
stop_time = 60;  % plots the graph for 60 seconds
count = 1; % counter starts at 1
tic; % starts a timer using the tic function

%% Real-time Data Acquisition
while(toc <= stop_time)
    [gyro] = readAngularVelocity(imu); % Read gyroscope data
    addpoints(x_val, count, gyro(:, 1));
    addpoints(y_val, count, gyro(:, 2));
    addpoints(z_val, count, gyro(:, 3));
    count = count + 1;
    drawnow limitrate; % updates the plot 
end
