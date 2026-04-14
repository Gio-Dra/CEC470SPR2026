clc; clear; close all;

%% Parameters
filename = 'Nutcracker.mp3';
f1 = 100;
f2 = 300;
noise_gain = 2;

%% Load audio
[x, Fs] = audioread(filename);

%% Design filter once
[b, a] = butter(4, [f1 f2]/(Fs/2), 'bandpass');

%% Make noise
noise = randn(size(x));

%% Filter noise faster
bp_noise = filter(b, a, noise);

%% Add noise
x_noisy = x + noise_gain * bp_noise;

%% Prevent clipping
m = max(abs(x_noisy), [], 'all');
if m > 1
    x_noisy = x_noisy / m;
end

%% New filename
[~, name, ~] = fileparts(filename);
new_name = sprintf('%s_noise_%d_%d.wav', name, f1, f2);

%% Save as WAV (faster than mp3)
audiowrite(new_name, x_noisy, Fs);

disp(['Saved as: ', new_name]);