function alpha = alpha_of_triple_eucl( r )
%THREECIRCLEANGLE_EUCL Angle of the triangle defined by three radii
%   A 3-element vector of reals 'r' spans a triangle between three circles'
%   centers. Return the angle of the triangle that lies inside
%   the first circle.
%   Euclidean variant.

alpha = 2 * asin(sqrt( prod(r(2:3)) / prod(r(1) + r(2:3)) ));

end
