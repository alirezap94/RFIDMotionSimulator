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
    %%% Large-scale path loss calculation: 
    dist_flag = true;
    while dist_flag
        % Adjusting the distance based on the total time and relative speed
        % New distance calculation with a random component
        t.deltaDist = t.T_tot * (rand() - 0.5)*t.vmax; 
        t.DistanceNew = t.Distance + t.deltaDist; 
        % Ensuring the new distance is within a valid range (0 to 10 meters)
        if (t.DistanceNew > 0.5) && (t.DistanceNew < 10)
            dist_flag = false; 
        end
    end
    
    % Recalculating RSSI based on the new distance and large-scale path loss coefficient
    % RSSI reduction proportional to the logarithm of the ratio of new to old distance
    t.RSSI = t.RSSIinit - 10 * t.large_scale_coeff * log10 (t.DistanceNew) ; 
    % Updating the distance to the new calculated value
    t.Distance = t.DistanceNew; 
else 
    % If no person is present, use the existing tau, pdb, and SNR without additional noise
    t.RSSI = t.RSSIinit; 
end

%% SIMULATE CHANNEL EFFECTS

% Introduce Random Delay
t.NDelaySamples = randi([0, 100]);
% Create received signal by appending zeros to manage delay
Rx = [t.transmitted_signal; zeros(t.NDelaySamples,1)]; 
% Use Rayleigh channel model to get the faded signal
[t.RxFaded, ~] = t.rayleighChan(Rx);

t.RxLargeScale = sqrt(10^(t.RSSI/10)) *t.RxFaded; 

% Introduce Noise
t.RxNoisyFaded = t.RxLargeScale + sqrt(10^(t.NoiseFloor/10))*randn(size(t.RxFaded));

%% OBSERVATION INTERVAL DEFINITION

% Initialize Observation Interval
t.ObservedInterval = zeros(t.NObservedInterval, 1); 
% Assign the noisy faded signal into the observation interval
t.ObservedInterval(1:t.NDelaySamples + t.NIntervalSamples) = t.RxNoisyFaded;

end
