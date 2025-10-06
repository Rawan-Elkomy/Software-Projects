
%% Connecting to a phone
clear m
m = mobiledev;
m.AccelerationSensorEnabled = 1; % enables the accelerometer sensor on the mobile device
m.Logging = 1; % enables logging of sensor data

%% Graph
data = zeros(200,1);
figure(1)
p = plot(data);
 axis([0 200 -15 15]); % 200 data points on the x-axis and a range of -15 to 15 on the y-axis.

%% Real-time Data Acquisition and Plotting
pause(1)
tic
while (toc < 30) % run for 30 secs
      [a,~] = accellog(m); % getting new z coordinates from phone
       if length(a) > 200 % keeping a rolling window of most recent 200 data points
        data = a(end-199:end,3);
      else
         data(1:length(a)) = a(:,3); % replaces the oldest data points with the new data
       end
      % redraw plot with new data
      p.YData = data;
      drawnow
  end