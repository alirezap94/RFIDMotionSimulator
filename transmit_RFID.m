function t = transmit_RFID(t)
% TRANSMIT_RFID: Simulate the transmission of an RFID signal given the parameters in "t".
%
% The function takes a structured array "t" which contains the relevant 
% transmission and channel parameters, and it returns "t" updated with the
% transmitted signal in its field "transmitted_signal".

% INPUT:
% t: Structure containing transmission and channel parameters.
%
% OUTPUT:
% t: Updated structure with added transmitted signal field.
%
%% DATA GENERATION

% Generate Random Binary Data
data = randi([0 1], 1, t.Npacket);  % Generating a random binary vector of length Npacket

%% MODULATION

% BPSK Modulation
packet_symbols = pskmod(data, 2);  % BPSK modulating the random binary data

%% UPSAMPLING

% Up-sample Symbols
% repelem function is used to repeat each symbol (F_s/R_s) times to match
% the desired sampling rate F_s, effectively achieving up-sampling.
packet_waveform = repelem(packet_symbols, t.F_s/t.R_s); 

%% TRANSMISSION

% Initialize Transmission Signal
transmitted_signal = zeros(t.NIntervalSamples, 1); % Initializing the transmitted signal with zeros
% Embed Packet Waveform into Transmission Signal
% The packet waveform is placed at the start of the transmission signal. 
% The rest remains zero, representing no transmission.
transmitted_signal(1:t.NPacketSamples) = packet_waveform; 

% Update Structure with Transmitted Signal
t.transmitted_signal = transmitted_signal; % Storing the transmitted signal into the structure "t"

end
