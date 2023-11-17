function t = channel_RFID(t, PersonPresent)
% CHANNEL_RFID: Simulates an RFID communication channel considering person presence.
%
% The function takes:
%   - "t" which contains relevant transmission and channel parameters,
%   - a boolean "PersonPresent" indicating the presence of a person.
% It returns "t" updated with received signals and observation intervals.
%
% INPUT:
% t: Struct containing transmission and channel parameters.
% PersonPresent: Boolean indicating presence of a person in the channel.
%
% OUTPUT:
% t: Updated struct with received and observation interval fields.
%
%% CONDITIONAL CHANNEL BEHAVIOR

if PersonPresent
    % If a person is present, modify tau and pdb with some random variation and
    % add a random component to SNR (Signal to Noise Ratio)
    t.tau(2:3) = t.tau(2:3) + 1e-10*randn(2,1);
    t.pdb(2:3) = t.pdb(2:3) + randn(2,1);
    t.SNR = t.SNR + 1e-1*randn(); 
    
    % Initialize RayleighChannel object with the person's presence affecting the channel
    rayleighChan = comm.RayleighChannel( ...
        'SampleRate', t.F_s, ...
        'PathDelays', t.tau.', ...
        'AveragePathGains', t.pdb.', ...
        'MaximumDopplerShift', t.dopplermax, ...
        'PathGainsOutputPort', true);
else 
    % If no person is present, use the existing tau, pdb, and SNR without additional noise
    
    % Initialize RayleighChannel object without person's presence affecting the channel
    rayleighChan = comm.RayleighChannel( ...
        'SampleRate', t.F_s, ...
        'PathDelays', t.tau.', ...
        'AveragePathGains', t.pdb.', ...
        'MaximumDopplerShift', 0, ...
        'PathGainsOutputPort', true);
end

%% SIMULATE CHANNEL EFFECTS

% Introduce Random Delay
t.NDelaySamples = randi([0, 100]);
% Create received signal by appending zeros to manage delay
Rx = [t.transmitted_signal; zeros(t.NDelaySamples,1)]; 
% Use Rayleigh channel model to get the faded signal
[t.RxFaded, ~] = rayleighChan(Rx);

% Introduce Noise
t.RxNoisyFaded = awgn(t.RxFaded, t.SNR);

%% OBSERVATION INTERVAL DEFINITION

% Initialize Observation Interval
t.ObservedInterval = zeros(t.NObservedInterval, 1); 
% Assign the noisy faded signal into the observation interval
t.ObservedInterval(1:t.NDelaySamples + t.NIntervalSamples) = t.RxNoisyFaded;

end
