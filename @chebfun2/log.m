function f = log( f )
%LOG Natural logarithm of a chebfun2.
% 
% LOG(F) is the natural logarithm of F. This function does not
% work if the function passes through or becomes numerically close to
% zero.

if ( isempty( f ) ) % check for empty chebfun2.
    return 
end 

% positive/negative test. 
% [bol wzero] = singlesigntest(f); 

% if bol == 0 || wzero == 1
%    error('CHEBFUN2:LOG','A change of sign/zero has been detected, unable to represent the result.'); 
% end

% Still call the constructor in case we missed a change of sign. 
op = @(x,y) log( feval(f, x, y) );  % Resample.
f = chebfun2( op, f.domain );       % Call constructor. 

end