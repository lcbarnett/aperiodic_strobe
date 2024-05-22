function signal = offset_strobe(signal,t)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function offsets the strobe sequence 'signal' by time t
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assert(ismatrix(signal) && size(signal,2) == 2,'Bad signal - must be a 2-column matrix');

signal = [signal(:,1)+t signal(:,2)];
