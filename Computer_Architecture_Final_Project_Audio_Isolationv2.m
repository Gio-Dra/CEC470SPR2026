%% CEC 470 Computer Architecture Final Project 
% Authors: Christian Ney, Gianni Dragos, Fiya Clerget, Angel Madrigal

% Description: This program selects a audio file, the user 
% would input their range of frequencies they would want to remove,
% the program then removes that frequency range with a bandpass filter.

clc;
clear;
clear sound;

fprintf('=== Audio Isolation using FFT ===\n');

%% Load File
[fileName, filePath] = uigetfile( ...
    {'*.mp4;*.m4a;*.mp3;*.wav'}, ...
    'Select an audio file');

if isequal(fileName,0)
    fprintf('No file selected.\n');
    return;
end

fullFile = fullfile(filePath, fileName);
[audio, Fs] = audioread(fullFile);

% Convert to mono if needed
if size(audio,2) == 2
    audio = mean(audio,2);
end

fprintf('Loaded: %s\n', fileName);
fprintf('Sample Rate: %d Hz\n', Fs);

%% User Input
maxFreq = Fs/2;

fprintf('\nChoose frequency band (Hz)\n');
fprintf('Range: 0 to %.0f Hz\n', maxFreq);

while true
    %f_low  = input('Lower cutoff: ');
    %f_high = input('Upper cutoff: ');
    f_low = 450;
    f_high = 22050;
    
    if f_low >= 0 && f_high <= maxFreq && f_low < f_high
        break;
    else
        fprintf('Invalid range. Try again.\n');
    end
end

tic

%% FFT 
N = length(audio);
X = fft(audio);

% Frequency axis (positive side only)
f = (0:N-1)*(Fs/N);
half = 1:floor(N/2);

f_plot = f(half);
X_plot = X(half);
%% Filter (Band-Pass) 
% Keep frequencies in band AND mirrored negative side
mask = (f >= f_low & f <= f_high) | ...
       (f >= Fs - f_high & f <= Fs - f_low);

X_filtered = X;
X_filtered(~mask) = 0;

%% Back to Time 
audio_filtered = real(ifft(X_filtered));

% Normalize
audio_filtered = audio_filtered / max(abs(audio_filtered));

fprintf("Processing time: %.2f sec\n", toc);

%% Convert frequency axis to kHz
f_plot_kHz = f_plot / 1000;

%% Plot Input Spectrum
figure;
subplot(2,1,1);
plot(f_plot_kHz, 20*log10(abs(X_plot)+1e-12));
title('Input Spectrum');
xlabel('Frequency (kHz)');
ylabel('Magnitude (dB)');
xlim([f_low f_high] / 1000);
grid on;

%% Plot Filtered Spectrum 
Xf_plot = X_filtered(half);
subplot(2,1,2);
plot(f_plot_kHz, 20*log10(abs(Xf_plot)+1e-12));
title('Filtered Spectrum');
xlabel('Frequency (kHz)');
ylabel('Magnitude (dB)');
xlim([f_low f_high] / 1000);
grid on;
%% Play Audio
fprintf('\nPlaying filtered audio...\n');
sound(audio_filtered, Fs);
