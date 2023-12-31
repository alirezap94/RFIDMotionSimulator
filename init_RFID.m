function t = init_RFID(PersonPresent)
% INIT_RFID: Initialize parameters related to RFID transmission and channel
% The function returns a structured array "t" containing all necessary parameters
% and configurations for simulating RFID transmission in a specific channel.

%% RFID PARAMETERS INITIALIZATION

% Communication Specifications
t.fc = 2.4e9;  % Carrier frequency (2.4 GHz is commonly used for WiFi and Bluetooth)
t.c = 3e8 ;     % Speed of light in m/s
t.L = 128;      % Packet length in bits
t.R_b = 100e3;  % Bit rate in bits per second (bps)
t.T_tot = 1;    % Interval between two consecutive transmissions in seconds
t.Npacket = 128;% Number of packets

% Modulation Scheme: BPSK
t.R_s = t.R_b;  % Symbol rate, equals to the bit rate for BPSK modulation in symbols/s (sps)

% Sampling Configurations
t.F_s = 2 * t.R_s;  % Sampling rate, set to two times the symbol rate to satisfy Nyquist in samples/s

% Time Vector for One Transmission Interval
t_tot = 0:1/t.F_s:t.T_tot - 1/t.F_s; % Time vector spanning from 0 to the total transmission time (T_tot)
t.NIntervalSamples = length(t_tot);   % Total number of samples within one transmission interval

% Packet Sampling
t.NPacketSamples = t.Npacket * t.F_s/t.R_s ; % Number of samples per packet

%% CHANNEL PARAMETERS INITIALIZATION

% Channel and Environment Specifications
t.vmax = 1.5; % Maximum relative velocity between transmitter and receiver in m/s
t.dopplermax = t.fc / t.c * t.vmax;

% Multi-Path Effect Parameters
t.tau = zeros(3,1);         % Initializing path delays
t.tau(2:3) = 1e-8*rand(2,1);% Randomizing additional path delays in seconds for multi-path effect

% Path Gain Settings
t.pdb = zeros(3,1);         % Initializing path gains
t.pdb(2:3) = -10*rand(2,1); % Randomizing path gains in dB for non-direct paths

% Signal to Noise Ratio (SNR) Configurations
t.Distance = 1;
t.RSSIinit = -90 - 10*rand(); % Random RSSI value. Adapt the range according to your specific scenario.
t.NoiseFloor = -100; % dB
% Setting the large-scale path loss coefficient (2.5 as a general value/ 
% please check the standard for specific case scenarios)
t.large_scale_coeff = 2.5;

% Observation Interval
t.NObservedInterval = t.NIntervalSamples + 100; % Adjusting observation interval considering maximum delay


if PersonPresent
    % Initialize RayleighChannel object with the person's presence affecting the channel
    t.rayleighChan = comm.RayleighChannel( ...
        'SampleRate', t.F_s, ...
        'PathDelays', t.tau.', ...
        'AveragePathGains', t.pdb.', ...
        'MaximumDopplerShift', t.dopplermax, ...
        'PathGainsOutputPort', true);
else
    % Initialize RayleighChannel object without person's presence affecting the channel
    t.rayleighChan = comm.RayleighChannel( ...
        'SampleRate', t.F_s, ...
        'PathDelays', t.tau.', ...
        'AveragePathGains', t.pdb.', ...
        'MaximumDopplerShift', 0, ...
        'PathGainsOutputPort', true);

end

%% Additional Notes
% *Power*:
% - Active RFID tags typically transmit between -10 dBm (100 uW) and 30 dBm (1 W),
%   depending on application requirements and regulatory limits.
% - RFID readers can transmit at higher power levels, sometimes up to 36 dBm (4 W)
%   (such as under FCC regulations in the USA).
%
% *Bandwidth*:
% - UHF RFID: Operates between 860 MHz and 960 MHz, with channel bandwidths
%   typically between 200 kHz and 500 kHz, depending on the region and standard.
% - Microwave RFID: Might operate at 2.45 GHz or 5.8 GHz, with wider channel
%   bandwidths, possibly around 2 MHz or more, to support higher data rates.

end
