function pk = find_interior( packing )
%FINDINTERIOR Sets a packing's interior
%   Find and set interior vertices of a packing. The packing must have its
%   flowers already set.
%
%   The requirement for an interior vertex is given simply as having a
%   cyclic flower. If this is not the case, the simplicial complex probably
%   describes something that is not a surface and Circlepack won't find
%   anything sensible. This is ignored, however.

packing.interior = find(arrayfun(@(x) ...
    (~isempty(packing.flowers{x}) && (packing.flowers{x}(1) == packing.flowers{x}(end))), (1:packing.nv)'));
pk = packing;

end

