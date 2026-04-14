clc;clear;clear sound;

fprintf('Audio Isolation from MP4 using FFT\n');
% ask use for audio file
[fileName, filePath] = uigetfile( ...
    {'*.mp4;*.m4a;*.mp3;*.wav', 'Audio/Video Files (*.mp4, *.m4a, *.mp3, *.wav)'}, ...
    'Select an audio/video file');

if isequal(fileName,0)
    fprintf('No file selected. Program ended.\n');
    return;
end

fullFileName = fullfile(filePath,fileName);

[audio_in, audio_freq_samp1] = audioread(fullFileName);

% convert file to mono
if size(audio_in,2) == 2
    audio_in = mean(audio_in,2);
end

fprintf('Loaded file: %s\n', fileName);
fprintf('Sample rate: %d Hz\n', audio_freq_samp1);
fprintf('Duration: %.2f seconds\n', length(audio_in)/audio_freq_samp1);

length_audio = length(audio_in);
df = audio_freq_samp1 / length_audio; %frequency resolution


% x axis for frequencies(Hz)
frequency_audio = -audio_freq_samp1/2 : df : audio_freq_samp1/2 - df;

maxFreq = audio_freq_samp1 / 2;

fprintf('\nEnter the frequency range you want to keep.\n');
fprintf('Valid range: 0 to %.2f Hz\n', maxFreq);

while true
    lower_threshold = input('Enter lower cutoff frequency (Hz): ');
    upper_threshold = input('Enter upper cutoff frequency (Hz): ');

    if lower_threshold >= 0 && upper_threshold <= maxFreq && lower_threshold < upper_threshold
        break;
    else
        fprintf('Invalid range. Try again.\n');
    end
end

tic

% fourier transform for entier file
FFT_audio_in = fftshift(fft(audio_in) / length_audio);

% input audio plot
figure;
subplot(2,1,1);
plot(frequency_audio, abs(FFT_audio_in));
title('FFT of Input Audio');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

val = abs(frequency_audio) >= lower_threshold & abs(frequency_audio) <= upper_threshold;

% copying FFT values
FFT_filtered = FFT_audio_in;
FFT_removed = FFT_audio_in;

FFT_filtered(~val) = 0;
FFT_removed(val) = 0;

fprintf("Time to execute: %.2f", toc);

% FFT filtered audio
subplot(2,1,2);
plot(frequency_audio, abs(FFT_filtered));
title(sprintf('FFT of Filtered Audio (%.1f Hz to %.1f Hz)', lower_threshold, upper_threshold));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

% get time signal back
FFT_filtered_time = ifftshift(FFT_filtered);
FFT_removed_time = ifftshift(FFT_removed);

filtered_audio = real(ifft(FFT_filtered_time * length_audio));
removed_audio = real(ifft(FFT_removed_time * length_audio));

% play fildered audio
fprintf('\nPlaying filtered audio:\n');
player = audioplayer(filtered_audio, audio_freq_samp1);
playblocking(player);
stop(player);