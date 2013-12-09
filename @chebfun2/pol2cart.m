function [x, y, z] = pol2cart(th, r, z)
% POL2CART Transform polar to Cartesian coordinates for chebfun2 objects.
%
% [X,Y] = POL2CART(TH,R) transforms corresponding elements of data
% stored in polar coordinates (angle TH, radius R) to Cartesian
% coordinates X,Y.  The arrays TH and R must the same size (or
% either can be scalar).  TH must be in radians.
% 
% [X,Y,Z] = POL2CART(TH,R,Z) transforms corresponding elements of
% data stored in cylindrical coordinates (angle TH, radius R, height
% Z) to Cartesian coordinates X,Y,Z. The arrays TH, R, and Z must be
% the same size (or any of them can be scalar).  TH must be in radians.
% 
% See also SPH2CART.

x = r .* cos( th );
y = r .* sin( th );
z = z;

end