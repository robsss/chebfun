function V = vorticity( F ) 
%VORTICITY  Numerical surface vorticity. 
%   V = VORTICITY(F) returns the numerical surface vorticity of the
%   SPHEREFUNV F. 
%   
%   Vorticity is the defined as the normal component of the surface curl of
%   the vector F to the sphere.  It is the generalization of the
%   standard 2D scalar vorticity for the surface of the sphere..
%
% See also VORT, DIV, GRAD, CURL

% Copyright 2016 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.


%
% Compute the surface curl of the vector field.
%

% Empty check.
if isempty( F )
    V = spherefunv;
    return
end

% Get the domain of the components of the spherefunv.
Fc = F.components;
dom = Fc{1}.domain;

% Vorticity is N dot curl(F), where N is the unit normal to the sphere.
V = dot( spherefunv.unormal( dom ), curl( F ) );

end