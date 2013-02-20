% Test file for funcheb2/times.

function pass = test_times(pref)

% Get preferences.
if (nargin < 1)
    pref = funcheb2.pref();
end

% Generate a few random points to use as test values.
rngstate = rng();
rng(6178);
x = 2 * rand(100, 1) - 1;

% Random numbers to use as arbitrary multiplicative constants.
alpha = -0.194758928283640 + 0.075474485412665i;
beta = -0.526634844879922 - 0.685484380523668i;

%%
% Check operation in the face of empty arguments.

f = funcheb2();
g = funcheb2(@(x) x, pref);
pass(1) = (isempty(f .* f) && isempty(f .* g) && isempty(g .* f));

%%
% Check multiplication by scalars.

f_op = @(x) sin(x);
f = funcheb2(f_op, pref);
pass(2:3) = test_mult_function_by_scalar(f, f_op, alpha, x);

f_op = @(x) [sin(x) cos(x)];
f = funcheb2(f_op, pref);
pass(4:5) = test_mult_function_by_scalar(f, f_op, alpha, x);

% Can't multiply by matrix of scalars with more than one row.
try 
    g = f .* [1 2 ; 3 4];
    pass(6) = false;
catch ME
    pass(6) = strcmp(ME.identifier, 'CHEBFUN:FUNCHEB2:times:dim');
end

% This should fail with a dimension mismatch error.
try
    g = f .* [1 2 3];
    pass(7) = false;
catch ME
    pass(7) = strcmp(ME.identifier, 'CHEBFUN:FUNCHEB2:times:dim');
end

%%
% Check multiplication by constant functions.

f_op = @(x) sin(x);
f = funcheb2(f_op, pref);
g_op = @(x) alpha*ones(size(x));
g = funcheb2(g_op, pref);
pass(8) = test_mult_function_by_function(f, f_op, g, g_op, x, false);

% This should fail with a dimension mismatch error from funcheb2.mtimes().
try
    f_op = @(x) [sin(x) cos(x)];
    f = funcheb2(f_op, pref);
    g_op = @(x) repmat([alpha, beta], size(x, 1), 1);
    g = funcheb2(g_op, pref);
    h = test_mult_function_by_function(f, f_op, g, g_op, x, false);
    pass(9) = false;
catch ME
    pass(9) = strcmp(ME.identifier, 'CHEBFUN:FUNCHEB2:mtimes:size2');
end

%%
% Spot-check multiplication of two funcheb2 objects for a few test functions.

f_op = @(x) ones(size(x));
f = funcheb2(f_op, pref);
pass(10) = test_mult_function_by_function(f, f_op, f, f_op, x, false);

f_op = @(x) exp(x) - 1;
f = funcheb2(f_op, pref);

g_op = @(x) 1./(1 + x.^2);
g = funcheb2(g_op, pref);
pass(11) = test_mult_function_by_function(f, f_op, g, g_op, x, false);

g_op = @(x) cos(1e4*x);
g = funcheb2(g_op, pref);
pass(12) = test_mult_function_by_function(f, f_op, g, g_op, x, false);

g_op = @(t) sinh(t*exp(2*pi*1i/6));
g = funcheb2(g_op, pref);
pass(13) = test_mult_function_by_function(f, f_op, g, g_op, x, false);

%%
% Check operation for vectorized funcheb2 objects.

f = funcheb2(@(x) [sin(x) cos(x) exp(x)], pref);
g = funcheb2(@(x) tanh(x), pref);
h1 = f .* g;
h2 = g .* f;
pass(14) = isequal(h1, h2);
h_exact = @(x) [tanh(x).*sin(x) tanh(x).*cos(x) tanh(x).*exp(x)];
err = feval(h1, x) - h_exact(x);
pass(15) = max(abs(err(:))) < 10*h1.epslevel;

g = funcheb2(@(x) [sinh(x) cosh(x) tanh(x)], pref);
h = f .* g;
h_exact = @(x) [sinh(x).*sin(x) cosh(x).*cos(x) tanh(x).*exp(x)];
err = feval(h, x) - h_exact(x);
pass(16) = max(abs(err(:))) < 10*h.epslevel;

% This should fail with a dimension mismatch error.
try
    g = funcheb2(@(x) [sinh(x) cosh(x)], pref);
    h = f .* g;
    pass(17) = false;
catch ME
    pass(17) = strcmp(ME.identifier, 'CHEBFUN:FUNCHEB2:times:dim2');
end

%%
% Check specially handled cases, including some in which an adjustment for
% positivity is performed.

f_op = @(t) sinh(t*exp(2*pi*1i/6));
f = funcheb2(f_op, pref);
pass(18) = test_mult_function_by_function(f, f_op, f, f_op, x, false);

g_op = @(t) conj(sinh(t*exp(2*pi*1i/6)));
g = conj(f);
pass(19:20) = test_mult_function_by_function(f, f_op, g, g_op, x, true);

f_op = @(x) exp(x) - 1;
f = funcheb2(f_op, pref);
pass(21:22) = test_mult_function_by_function(f, f_op, f, f_op, x, true);

%%
% Check that multiplication and direct construction give similar results.

tol = 10*eps;
g_op = @(x) 1./(1 + x.^2);
g = funcheb2(g_op, pref);
h1 = f .* g;
h2 = funcheb2(@(x) f_op(x) .* g_op(x), pref);
pass(23) = norm(h1.values - h2.values, 'inf') < tol;

%%
% Restore the RNG state.

rng(rngstate);

end

% Test the multiplication of a FUNCHEB2 F, specified by F_OP, by a scalar ALPHA
% using a grid of points X in [-1  1] for testing samples.
function result = test_mult_function_by_scalar(f, f_op, alpha, x)
    g1 = f .* alpha;
    g2 = alpha .* f;
    result(1) = isequal(g1, g2);
    g_exact = @(x) f_op(x) .* alpha;
    result(2) = norm(feval(g1, x) - g_exact(x), 'inf') < 10*g1.epslevel;
end

% Test the addition of two FUNCHEB2 objects F and G, specified by F_OP and
% G_OP, using a grid of points X in [-1  1] for testing samples.  If CHECKPOS
% is TRUE, an additional check is performed to ensure that the values of the
% result are all nonnegative; otherwise, this check is skipped.
function result = test_mult_function_by_function(f, f_op, g, g_op, x, checkpos)
    h = f .* g;
    h_exact = @(x) f_op(x) .* g_op(x);
    result(1) = norm(feval(h, x) - h_exact(x), 'inf') < 10*h.epslevel;
    if ( checkpos )
        result(2) = all(h.values >= 0);
    end
end
