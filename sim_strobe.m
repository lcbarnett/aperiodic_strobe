%%%%%%%%%%%%%%%%%% Simulation Parameters (override on command line) %%%%%%%%%%%%%%%%%%

defvar('F',       10      ); % strobe frequency (Hz)
defvar('T',       10      ); % total time (secs)
defvar('osig',    50      ); % onset time: 'periodic', 'Poisson', or jitter std. dev (ms)
defvar('relo',    false   ); % orelative onset time with Gamma jitter? Else (default) periodic onset time with Gaussian jitter
defvar('ondur',  'hcycle' ); % cycle "on" duration: 'hcycle' (default = half-cycle), of length (ms)
defvar('dsig',   'fixed'  ); % on-duration: 'fixed', or jitter std. dev (ms)
defvar('rmode',   0       ); % "regularisation" mode; deal with flash overlaps (zero for none; see regularise_strobe.m)
defvar('fs',      2000    ); % sampling frequency (Hz)
defvar('dfac',    5       ); % spectral power display frequency cutoff factor
defvar('seed',    []      ); % random seed (empty for no seed)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates aperiodic signal generation and sampling.
%
% The function gen_strobe_periodic(F,T,ondur) generates a periodic square-wave signal
% with frequency F over a time segment of length T. The parameter ondur sets the "on"
% duration of a cycle; by default, ondur is set to half a cycle (cycle length is 1/F).
%
% The function gen_strobe_aperiodic(F,T,osig,relo,ondur,dsig,rmode) generates an aperiodic
% square-wave signal with average frequency F over a time segment of length T. See
% gen_strobe_periodic.m for a detailed description of the parameters.
%
% The function sample_strobe(signal,fs,T) samples the signal at frequency fs, over
% a time segment of length T.
%
% The function pspectrum(...) (from the Matlab Signal Processing Toolbox) estimates
% the power spectral density (PSD) of the sampled signal.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = ceil(T*fs)/fs; % adjust T (if necessary) to ensure an *integer* number of samples

% Create a regular periodic strobe process

signal_p = gen_strobe_periodic(F,T,ondur);

[samples_p,ts] = sample_strobe(signal_p,fs,T); % sample signal at frequency fs

[spower_p,f] = pspectrum(samples_p,fs,'FrequencyLimits',[0,dfac*F]); % spectral power

% Create an aperiodic strobe process

[signal_a,Fe,sdescrip] = gen_strobe_aperiodic(F,T,osig,relo,ondur,dsig,rmode,seed);

[samples_a,ts] = sample_strobe(signal_a,fs,T); % sample signal at frequency fs

[spower_a,f] = pspectrum(samples_a,fs,'FrequencyLimits',[0,dfac*F]); % spectral power

fprintf('\nEffective frequency = %g Hz\n\n',Fe);

% Plot signals and power spectra

figure(1); clf
sgtitle(sprintf('\nAperiodic: %s\n',sdescrip),'FontSize',14);

subplot(3,1,1);
plot(ts,samples_p);
title('Periodic signal','FontWeight','normal')
xlabel('Time (secs)')
ylabel('Luminance')
ylim([-0.05,1.05])
set(gca,'TickLength',[0,0]);

subplot(3,1,2);
plot(ts,samples_a);
title('Aperiodic signal','FontWeight','normal')
xlabel('Time (secs)')
ylabel('Luminance')
ylim([-0.05,1.05])
set(gca,'TickLength',[0,0]);

subplot(3,1,3);
plot(f,[spower_p spower_a]);
title('Power spectral density (PSD)','FontWeight','normal')
xlabel('Frequency (Hz)')
ylabel('PSD')
xline(F,'b');
xline(Fe,'r');
legend({'periodic','aperiodic'})
set(gca,'TickLength',[0,0]);
grid on
