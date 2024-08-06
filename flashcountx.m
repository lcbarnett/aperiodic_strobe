function [n,Fe,fots] = flashcountx(samples,ts,fdthresh,fdms)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Count flashes in sampled signal (robust).
%
% Counts a flash if the signal strength remains above the flash-detection threshold
% fdthresh, for at least the flash-detection maintenance duration fdms. Also returns
% effective frequency and time stamps of onset of flashes.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3 || isempty(fdthresh), fdthresh =  0.5; end % default: halfway
if nargin < 4 || isempty(fdms),     fdms     =  20;  end % default: 50 samples

smin    = min(samples);
smax    = max(samples);
samples = (samples-smin)/(smax-smin); % normalise to [0,1]

n = 0;
oncount = 0;
gotflash = false;
fots = [];
for i = 1:length(samples)
	if samples(i) > fdthresh % signal strength above threshold; now: do we have a flash?
		oncount = oncount+1;
		if oncount == 1 % store flash onset time
			fot = ts(i);
		end
		if oncount > fdms    % we've hit or exceeded maintenance duration
			if ~gotflash     % first hit: we've got a flash - count it!
				gotflash = true;
				n = n+1;
				fots(n) = fot;
			end
		else                 % haven't hit maintenance duration (yet)
			gotflash = false;
		end
	else                     % signal strength below threshold
		oncount = 0;
		gotflash = false;
	end
end
fots = fots(:);
Fe = n/(fots(end)-fots(1)); % take total strobe sequence duration as last flash - first flash
