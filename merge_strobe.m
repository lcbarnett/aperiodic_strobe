function [signal,T,Fe] = merge_strobe(signals,Ts,toffs,rmode)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function merges/splices a set of strobe sequences.
%
% signals    cell vector of strobe sequences
% Ts         Time lengths of the sequences in 'signals'
% toffs      vector of time offsets (or special values 'super' [superpose] and 'splice')
% rmode      regularisation mode (deal with overlapping flashes), or 0 for no regularisation (default)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 4 || isempty(rmode), rmode =  0; end

assert(iscell(signals) && isvector(signals),'Please supply a cell vector of strobe sequences');
nsignals = length(signals);

assert(isvector(Ts) && length(Ts) == nsignals && all(Ts >= 0),'Strobe sequence lengths must be a vector of nonnegative numbers matching the supplied signals');

if ischar(toffs)
	if     strcmpi(toffs,'super')  % superimose
		toffs = zeros(nsignals);
	elseif strcmpi(toffs,'splice') % splice sequentially
		Ts = Ts(:);
		toffs = [0;cumsum(Ts(1:end-1))];
	else
		error('Unknown merge mode')
	end
else
	assert(isvector(toffs) && length(toffs) == nsignals && all(toffs >= 0),'Time offsets must be a vector of nonnegative numbers matching the supplied signals');
end

s = 1;
signal = offset_strobe(signals{s},toffs(s));
T = Ts(s)+toffs(s);
for s = 2:nsignals
	signal = [signal; offset_strobe(signals{s},toffs(s))];
	T = max(T,Ts(s)+toffs(s));
end

% Sort events by time stamp (in case necessary)

signal = sortrows(signal);

% Regularise signal (deal with overlaps)

if rmode > 0
	signal = regularise_strobe(signal,rmode);
end

% Effective frequency

Fe = size(signal,1)/T;
