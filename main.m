% MAIN: RFID MOTION SIMULATOR
% This script simulates the transmission of an active RFID tag within a specified environment
% and analyses the received signal under specific channel conditions.

clc; clear; close all;  % Clearing console, variables, and closing all figures

% PARAMETERS
NumTransmissions = 10; % Total number of RFID transmissions (in seconds)
PersonPresnt = true;   % Logical flag indicating the presence of a person

% INITIALIZATION
t = init_RFID(); % Initializing RFID parameters and settings through a custom function

% Pre-allocating observation vector to store received signals over multiple transmissions
Observation = zeros(NumTransmissions * t.NObservedInterval, 1); 

% MAIN SIMULATION LOOP
for IterTransmission = 1:NumTransmissions
    
    % TRANSMISSION
    % Transmitting RFID signal and updating parameters (e.g., transmitted signal)
    t = transmit_RFID(t);  
    
    % CHANNEL
    % Modeling the channel effects (multipath, fading, etc.) on the transmitted signal
    t = channel_RFID(t, PersonPresnt);  
    
    % STORING OBSERVATIONS
    % Extracting and storing the observed interval for each transmission cycle
    interval = t.NObservedInterval*(IterTransmission-1) + 1:t.NObservedInterval*(IterTransmission);  
    Observation(interval) = t.ObservedInterval; 
    
end

% SIGNAL PROCESSING
% Calculating the power of the observed signal
PowerObservation = abs(Observation).^2 ;

% Applying a moving average filter (with a window size equivalent to packet samples) to smooth the signal
window_size = t.NPacketSamples;
smoothed_data = movmean(PowerObservation, window_size, 'Endpoints','discard');

% VISUALIZATION
% Plotting the smoothed data for visualization and analysis
plot(smoothed_data)