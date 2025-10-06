% Wireless Communication System Planning Tool

clear; clc; close all;

% Constants
fc = 900e6;           % Frequency in Hz
c = 3e8;              % Speed of light in m/s
lambda = c / fc;      % Wavelength in meters
ht = 50;              % Base station height in meters
hr = 1.5;             % Mobile station height in meters
SIR_min = 1:30;       % SIRmin range in dB
GOS_range = 0.01:0.01:0.3; % GOS range (1% to 30%)
A = 100;              % City area in km^2
traffic_per_user = 0.025; % Traffic intensity per user in Erlangs
N_channels = 340;     % Total available channels
path_loss_exp = 4;    % Path loss exponent x
% Inputs
user_density_range = 100:100:2000; % User density in users/km^2

% Functions
d_max = @(Pt, Pmin) sqrt((ht * hr)^2 * Pt / Pmin); % Max cell radius
P_r = @(Pt, d) Pt * (ht^2 * hr^2) ./ d.^4;        % Two-Ray Model
cluster_size = @(SIR_dB) ceil((6 * 10^(SIR_dB / 10))^(1/3)); % Minimum cluster size

%% Task 1: Plot Cluster Size vs. SIRmin
cluster_sizes = arrayfun(cluster_size, SIR_min);
figure;
plot(SIR_min, cluster_sizes, '-o', 'LineWidth', 1.5);
xlabel('SIR_{min} (dB)');
ylabel('Cluster Size');
title('Cluster Size vs. SIR_{min}');
grid on;

%% Task 2: Number of Cells and Traffic Intensity vs. GOS
user_density = 1400; % users/km^2
traffic_intensity_cell = zeros(size(GOS_range));
num_cells = zeros(size(GOS_range));

for i = 1:length(GOS_range)
    Erl_per_cell = N_channels * GOS_range(i);
    num_cells(i) = ceil((user_density * A * traffic_per_user) / Erl_per_cell);
    traffic_intensity_cell(i) = Erl_per_cell;
end

figure;
subplot(2, 1, 1);
plot(GOS_range * 100, num_cells, '-o', 'LineWidth', 1.5);
xlabel('GOS (%)');
ylabel('Number of Cells');
title('Number of Cells vs. GOS');
grid on;

subplot(2, 1, 2);
plot(GOS_range * 100, traffic_intensity_cell, '-o', 'LineWidth', 1.5);
xlabel('GOS (%)');
ylabel('Traffic Intensity per Cell (Erlangs)');
title('Traffic Intensity per Cell vs. GOS');
grid on;

%% Task 3: Number of Cells and Cell Radius vs. User Density
SIR_fixed = 14; % dB
GOS_fixed = 0.02; % 2%
num_cells_density = zeros(size(user_density_range));
cell_radius = zeros(size(user_density_range));

for i = 1:length(user_density_range)
    Erl_per_cell = N_channels * GOS_fixed;
    num_cells_density(i) = ceil((user_density_range(i) * A * traffic_per_user) / Erl_per_cell);
    cell_radius(i) = sqrt(A * 1e6 / num_cells_density(i) / pi); % km to m
end

figure;
subplot(2, 1, 1);
plot(user_density_range, num_cells_density, '-o', 'LineWidth', 1.5);
xlabel('User Density (users/km^2)');
ylabel('Number of Cells');
title('Number of Cells vs. User Density');
grid on;

subplot(2, 1, 2);
plot(user_density_range, cell_radius / 1000, '-o', 'LineWidth', 1.5); % Convert to km
xlabel('User Density (users/km^2)');
ylabel('Cell Radius (km)');
title('Cell Radius vs. User Density');
grid on;

%% Task 4: MS Received Power vs. Distance
Pt = 10; % Transmit power in Watts
d = 1:10:10000; % Distance from BS in meters
Pmin = 10^(-95/10); % Minimum received power (converted to linear scale)

received_power = P_r(Pt, d);
valid_range = received_power > Pmin;

figure;
plot(d(valid_range), 10*log10(received_power(valid_range)), 'LineWidth', 1.5);
xlabel('Distance (m)');
ylabel('Received Power (dBm)');
title('Received Power vs. Distance');
grid on;