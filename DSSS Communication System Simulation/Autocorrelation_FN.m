% Define the spreading sequences for User 1 and User 2
spreading_sequence_user1 = [1, 1, 1, 1, 1, 1, 1, 1];
spreading_sequence_user2 = [1, 1, 1, 1, -1, -1, -1, -1];
% Compute the autocorrelation functions
autocorr_function_user1 = xcorr(spreading_sequence_user1);
autocorr_function_user2 = xcorr(spreading_sequence_user2);
% Normalize the autocorrelation functions
autocorr_function_user1 = autocorr_function_user1 / max(abs(autocorr_function_user1));
autocorr_function_user2 = autocorr_function_user2 / max(abs(autocorr_function_user2));
% Create a figure for the subplots
figure;
% Plot the autocorrelation function for User 1
subplot(2,1,1); % Create the first subplot
stem(-length(spreading_sequence_user1)+1:length(spreading_sequence_user1)-1, autocorr_function_user1, 'filled');
title('Autocorrelation Function of Spreading Sequence for User 1');
xlabel('Lag');
ylabel('Autocorrelation');
grid on;
% Plot the autocorrelation function for User 2
subplot(2,1,2); % Create the second subplot
stem(-length(spreading_sequence_user2)+1:length(spreading_sequence_user2)-1, autocorr_function_user2, 'filled');
title('Autocorrelation Function of Spreading Sequence for User 2');
xlabel('Lag');
ylabel('Autocorrelation');
grid on;
