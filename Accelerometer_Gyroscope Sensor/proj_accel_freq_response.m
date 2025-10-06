clear all

%% Defining arduino and mpu5060 sensor
a = arduino('COM5', 'Uno', 'Libraries', 'I2C');
imu = mpu6050(a);

%% Accelerometer Graph
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Response');
f_val = animatedline('Color', 'r');
axis tight;

%% Real-time Data Acquisition
Fs = 100; % Sampling frequency (Hz) --> 
stop_time = 60;  % duration of data acquisition (seconds)
count = 1; % counter starts at 1
data_length = Fs * stop_time; % length of acquired data
data = zeros(data_length, 3); % array to store accelerometer data

tic; % starts a timer using the tic function

while (toc <= stop_time)
    accel = readAcceleration(imu);
    data(count, :) = accel'; % Store acceleration data
    
    % Calculate frequency spectrum
    freq = (0:data_length-1) * Fs / data_length;
    spectrum = abs(fftshift(fft(data(:, 1)))); % fftshift = shifts zero-frequency component to the center of the spectrum
    
    % Plot frequency spectrum
    f_val.clearpoints(); % clears the data points stored so updated values can be displayed
    addpoints(f_val, freq, spectrum); % adds new data points
    drawnow limitrate; % redraws the plot and limits the rate at which the figure is redrawn to avoid excessive updates
    count = count + 1;
end

