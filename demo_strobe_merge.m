%%%%%%%%%%%%%%%%%% Simulation Parameters (override on command line) %%%%%%%%%%%%%%%%%%

defvar('F1',      10      ); % strobe frequency 1 (Hz)
defvar('F2',      7       ); % strobe frequency 2 (Hz)
defvar('T1',      15      ); % total time 1 (secs)
defvar('T2',      10      ); % total time 2 (secs)
defvar('ondur',  'hcycle' ); % cycle "on" duration: 'hcycle' (default = half-cycle), of length (ms)
defvar('toffs',  'splice' ); % time offsets: 'splice', 'super' or a 2-vector of time offsets
defvar('rmode',   1       ); % "regularisation" mode; deal with flash overlaps (zero for none; see regularise_strobe.m)
defvar('fs',      2000    ); % sampling frequency (Hz)
defvar('dfac',    5       ); % spectral power display frequency cutoff factor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates splicing and superimposition of strobe sequences.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create periodic strobe processess

signal1 = gen_strobe_periodic(F1,T1,ondur);
signal2 = gen_strobe_periodic(F2,T2,ondur);

% Merge sequences

[signal,T,Fe] = merge_strobe({signal1,signal2},[T1,T2],toffs,rmode);

T = ceil(T*fs)/fs; % adjust T2 (if necessary) to ensure an *integer* number of samples

[samples,ts] = sample_strobe(signal,fs,T); % sample signal at frequency fs

[spower,f] = pspectrum(samples,fs,'FrequencyLimits',[0,dfac*max(F1,F2)]); % spectral power

% Plot signals and power spectra

if ischar(toffs)
	stoffs = toffs;
else
	stoffs = sprintf('offsets = %d, %d secs',toffs(1),toffs(2));
end

figure(1); clf
sgtitle(sprintf('\nMerged periodic sequences (%s): effective frequency = %g Hz\n',stoffs,Fe),'FontSize',14);

subplot(2,1,1);
plot(ts,samples);
title('Merged signal','FontWeight','normal')
xlabel('Time (secs)')
ylabel('Luminance')
xlim([0,T])
ylim([-0.05,1.05])
set(gca,'TickLength',[0,0]);

subplot(2,1,2);
plot(f,spower);
title('Power spectral density (PSD)','FontWeight','normal')
xlabel('Frequency (Hz)')
ylabel('PSD')
xline(F1,'b');
xline(F2,'b');
xline(Fe,'r');
set(gca,'TickLength',[0,0]);
grid on
