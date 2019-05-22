function alpha = alpha_of_triple_hyp( r )
%THREECIRCLEANGLE_HYP Angle of the triangle defined by three radii
%   A 3-element vector of reals 'r' spans a triangle between three circles'
%   centers. Return the angle of the triangle that lies inside
%   the first circle.
%   Hyperbolic variant.

alpha = 2 * asin(sqrt( r(1) * prod(1 - r(2:3)) / prod(1 - r(1)*r(2:3)) ));

end
