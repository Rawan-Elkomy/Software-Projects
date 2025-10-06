clear all

%% Defining arduino and mpu5060 sensor
a = arduino('COM5', 'Uno', 'Libraries', 'I2C');
imu = mpu6050(a);

%% Gyroscope Graph
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Response');
f_val = animatedline('Color', 'r');
axis tight;

%% Real-time Data Acquisition
Fs = 100; % Sampling frequency (Hz)
stop_time = 60;  % duration of data acquisition (seconds)
count = 1; % counter starts at 1
data_len = Fs * stop_time; % length of acquired data
data = zeros(data_len, 3); % array to store gyroscope data

tic; % starts a timer using the tic function

while (toc <= stop_time)
    gyro = readAngularVelocity(imu);
    data(count, :) = gyro';
    
    % Calculate frequency spectrum
    freq = (0:data_len-1) * Fs / data_len;
    spectrum = abs(fftshift(fft(data(:, 2))));
    
    % Plot frequency spectrum
    f_val.clearpoints();
    addpoints(f_val, freq, spectrum);
    drawnow limitrate;
    
    count = count + 1;
end
