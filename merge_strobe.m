function [signal,slength] = merge_strobe(signals,slengths,toffsets)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function merges/splices a set of strobe sequences.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assert(iscell(signals) && isvector(signals),'Please supply a cell vector of strobe sequences');
nsignals = length(signals);

assert(isvector(slengths) && length(slengths) == nsignals && all(slengths >= 0),'Strobe sequence lengths must be a vector of nonnegative numbers matching the supplied signals');
assert(isvector(toffsets) && length(toffsets) == nsignals && all(toffsets >= 0),'Time offsets must be a vector of nonnegative numbers matching the supplied signals');

s = 1;
signal = offset_strobe(signal{s},toffsets(s))];
slength = slengths(s)+toffsets(s);
for s = 2:nsignals
	signal = [signal; offset_strobe(signal{s},toffsets(s))];
	slength = max(slength,slengths(s)+toffsets(s));
end

% Sort events by time stamp (in case necessary)

signal = sortrows(signal);
