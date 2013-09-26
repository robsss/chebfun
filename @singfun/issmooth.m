function out = issmooth(f)
%ISEQUAL   Test if a SINGFUN object F is smooth.
%   ISSMOOTH(F) returns TRUE if the SINGFUN objects F has negligible EXPONENTS
%   or if the SMOOTHPART is zero. The test is FALSE otherwise.

% Copyright 2013 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% Get tolerance for exponents:
tol = singfun.pref.singfun.exponentTol;

% A function is smooth if it has negligible exponents or if the SMOOTHPART
% is zero:
out = all(abs(f.exponents) < tol) || iszero(f.smoothPart);

end
