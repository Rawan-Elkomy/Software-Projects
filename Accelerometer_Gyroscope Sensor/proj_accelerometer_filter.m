 %% Setup
clear all
hold all

%% Defining arduino and mpu5060 sensor
a = arduino('COM5', 'Uno', 'Libraries', 'I2C');
imu = mpu6050(a);

%% Unfiltered Accelerometer Graph
subplot(2,1,1);
xlabel('Count');
ylabel('Acceleration (m/s^2)');
title('Raw Acceleration Values');
x_val = animatedline('Color','r');
y_val = animatedline('Color','g');
z_val = animatedline('Color','b');
axis tight;
legend('Acceleration in X-axis','Acceleration in Y-axis','Acceleration in Z-axis');

%% Filtered Accelerometer Graph using Low Pass Filter
subplot(2,1,2);
xlabel('Count');
ylabel('Acceleration (m/s^2)');
title('Low Pass Filtered Acceleration Values');
x_filtered_val = animatedline('Color','r');
y_filtered_val = animatedline('Color','g');
z_filtered_val = animatedline('Color','b');
axis tight;
legend('Filtered Acceleration in X-axis', 'Filtered Acceleration in Y-axis', 'Filtered Acceleration in Z-axis');

%% Timer  
stop_time = 60;  % plots the graph for 60 seconds
count = 1; % counter starts at 1
tic; % starts a timer using the tic function

%% Define Low Pass Filter parameters
cutoff_frequency = 1;  % Hz
sampling_rate = 100;  % Hz
filter_order = 4;

%% Calculate filter coefficient
alpha = 1 / (1 + 2 * pi * cutoff_frequency / sampling_rate);

%% Initialize filtered acceleration values
filtered_accel = zeros(1, 3);

%% Real-time Data Acquisition
while(toc <= stop_time) % tic: reads the elapsed time since the stopwatch timer started by the  tic function. 
    % loop runs until the elapsed time (toc) is equal to the specified stop time
    [accel] = readAcceleration(imu);
    filtered_accel = alpha * filtered_accel + (1 - alpha) * accel; % Calculate filtered acceleration using low pass filter
    
    % Unfiltered Data real-time
    addpoints(x_val, count, accel(:, 1));
    addpoints(y_val, count, accel(:, 2));
    addpoints(z_val, count, accel(:, 3));
    
    % Filtered Data real-time
    addpoints(x_filtered_val, count, filtered_accel(:, 1));
    addpoints(y_filtered_val, count, filtered_accel(:, 2));
    addpoints(z_filtered_val, count, filtered_accel(:, 3));
    
    count = count + 1;
    drawnow limitrate; % updates the plot 
end
