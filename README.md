# CEC470SPR2026

MATLAB project for audio isolation using the Fast Fourier Transform (FFT).

## Overview
This project loads an audio file, converts it to the frequency domain with an FFT, keeps only a selected frequency band, and reconstructs the filtered audio signal.

It also includes a second script that adds band-limited noise to an audio file for testing.

## Files
- `Audio_Isolation_FFT.m` - main FFT audio isolation script
- `NoiseMaker.m` - adds band-limited noise to an audio file
- `.mp3`, `.wav`, `.m4a`, or `.mp4` files - input audio files

## Main Script
The main MATLAB script:
- opens an audio file
- converts stereo to mono
- computes the FFT
- applies a band-pass frequency mask
- reconstructs the filtered signal with the inverse FFT
- plots the original and filtered spectra
- plays the filtered audio

### Frequency Band Used
Current values in the script:
- Lower cutoff: `450 Hz`
- Upper cutoff: `22050 Hz`

## Noise Script
The noise script:
- loads an audio file
- creates random noise
- band-pass filters the noise between two frequencies
- adds the noise to the audio
- normalizes the result
- saves the noisy output as a `.wav` file

### Noise Band Used
Current values in the script:
- Lower cutoff: `100 Hz`
- Upper cutoff: `300 Hz`

## Requirements
- MATLAB
- Audio file supported by `audioread`

## How to Run

### Audio Isolation
1. Open MATLAB.
2. Run the FFT script.
3. Select an audio file when prompted.
4. The script will:
   - process the audio
   - show the input and filtered spectra
   - play the filtered audio

### Noise Generator
1. Put the input audio file in the same folder as the script.
2. Set the filename in the script.
3. Run the noise script.
4. The processed file will be saved as a new `.wav` file.

## Purpose
This project was made for CEC470 Spring 2026 to demonstrate FFT-based audio processing in MATLAB.

## Notes
- Stereo audio is converted to mono before processing.
- The filtered signal is normalized before playback.
- The noise output is saved as WAV for faster writing.
