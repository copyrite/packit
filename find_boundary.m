function pk = find_boundary( packing )
%FINDBOUNDARY Sets a packing's boundary
%   Find and set boundary vertices of a packing. The packing must have its
%   flowers and interior vertices already already set.
%
%   Boundary vertices are assumed to be all non-interior vertices.

packing.boundary = setdiff((1:packing.nv)', packing.interior);
pk = packing;

end

