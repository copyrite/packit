function u = udiskaut(z, b)
%UDISKAUT Unit disk automorphism
%   Automorphism of the unit disk, parameterized by the complex number b.
%   Conformally maps the unit disk onto itself as follows:
%
%   b maps to 0
%   b/abs(b) maps to 1
%   -b/abs(b) maps to -1
%
%   If b is zero, the function defaults to the identity map.

p = [-b/abs(b), b, b/abs(b)];
q = [-1, 0, 1];

H1 = [p(2) - p(3), -p(1)*(p(2) - p(3)); p(2) - p(1), -p(3)*(p(2) - p(1))];
H2 = [q(2) - q(3), -q(1)*(q(2) - q(3)); q(2) - q(1), -q(3)*(q(2) - q(1))];

if any(isnan(H1))
    u = z;
    return;
end

H = H2^-1 * H1;
u = (z * H(1, 1) + H(1, 2)) ./ (z * H(2, 1) + H(2, 2));

end