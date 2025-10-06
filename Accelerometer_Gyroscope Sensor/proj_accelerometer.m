%% Setup
clear all
hold all

%% Defining arduino and mpu5060 sensor
a = arduino('COM5', 'Uno', 'Libraries', 'I2C');
imu = mpu6050(a);

%% Accelerometer Graph
xlabel('Count');
ylabel('Acceleration (m/s^2)');
title('Acceleration Values');
x_val = animatedline('Color','r');
y_val = animatedline('Color','g');
z_val = animatedline('Color','b');
axis tight;
legend('Acceleration in X-axis','Acceleration in Y-axis','Acceleration in Z-axis');

%% Timer  
stop_time = 60;  % plots the graph for 60 seconds
count = 1; % counter starts at 1
tic; % starts a timer using the tic function

%% Real-time Data Acquisition
while(toc <= stop_time) % tic: reads the elapsed time since the stopwatch timer started by the  tic function. 
    % loop runs until the elapsed time (toc) is equal to the specified stop time
    [accel] = readAcceleration(imu); 
    addpoints(x_val,count,accel(:,1)); % adds the acquired acceleration data to the animated lines for real-time plotting
    addpoints(y_val,count,accel(:,2));
    addpoints(z_val,count,accel(:,3));
    count = count + 1;
    drawnow limitrate; % updates the plot 
end
