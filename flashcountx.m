function n = flashcountx(samples,fs,fdthresh,fdmd)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Count flashes in sampled signal (robust).
%
% Counts a flash if the signal strength remains above the flash-detection threshold
% fdthresh, for at least the flash-detection maintenance duration fdmd.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3 || isempty(fdthresh), fdthresh =  0.5;   end % default: halfway
if nargin < 4 || isempty(fdmd),     fdmd     =  50/fs; end % default: 50 samples [fdmd = 0.25/F is better generally]

smin    = min(samples);
smax    = max(samples);
samples = (samples-smin)/(smax-smin); % normalise to [0,1]
fdmi    = round(fs*fdmd);             % number of samples for maintenance duration

n = 0;
oncount = 0;
gotflash = false;
for i = 1:length(samples)
	if samples(i) > fdthresh % signal strength above threshold; now: do we have a flash?
		oncount = oncount+1;
		if oncount > fdmi    % we've hit or exceeded maintenance duration
			if ~gotflash     % first hit: we've got a flash - count it!
				n = n+1;
				gotflash = true;
			end
		else                 % haven't hit maintenance duration (yet)
			gotflash = false;
		end
	else                     % signal strength below threshold
		oncount = 0;
		gotflash = false;
	end
end
