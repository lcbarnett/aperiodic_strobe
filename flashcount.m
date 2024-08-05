function n = flashcount(samples,fdtol)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Count flashes in sampled signal (naive).
%
% Registers "jumps" bigger than flash-detection tolerance fdtol.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 2 || isempty(fdtol), fdtol =  eps; end

n = nnz(diff([0;samples]) > fdtol); % note: need to prefix 0 to detect initial flash
