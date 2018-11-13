function pass = test_sqrt( pref ) 

% Grab some preferences
if ( nargin == 0 )
    pref = chebfunpref();
end
tol = 1e7*pref.techPrefs.chebfuneps; 

% Example 1
f = sqrt(ballfun(@(x,y,z)x.^4,'cart'));
exact = ballfun(@(x,y,z)x.^2,'cart');
pass(1) = norm( f - exact ) < tol;

if (nargout > 0)
    pass = all(pass(:));
end
end
