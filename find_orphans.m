function pk = find_orphans( packing )
%FINDORPHANS Sets a packing's orphan vertices
%   Find and set orphan vertices (boundary vertices with no interior
%   neighbors) of a packing. Additionally, remove the found orphans from
%   the actual boundary. The packing must have its flowers, interior
%   and boundary already set.

packing.orphans = packing.boundary( ... 
    arrayfun(@(x) all(ismember( packing.flowers{x}, ...
        packing.boundary)), ...
    packing.boundary) ...
);

%   The above expression should read: Orphans are those vertices
%   of the boundary whose neighbors are all boundary vertices.

packing.boundary = setdiff(packing.boundary, packing.orphans);

pk = packing;

end

