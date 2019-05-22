function pk = packit( varargin )
%PACKIT Streamlined constructor of a Packit instance
%   PACKIT() returns an empty Packit instance.
%
%   PACKIT(combinatorics) solves the circle packing problem posed by the
%   given combinatorics, using hyperbolic geometry and infinite boundary
%   radii. Note that 0 denotes infinite radius and 1 denotes zero radius
%   in hyperbolic setting.
%   Valid inputs for 'combinatorics' are triangulations, either as
%   
%       - a list of faces, as a 3-by-n matrix of indices, or
%       - a list of flowers, as a cell array of vectors.
%
%   PACKIT(combinatorics, geometry) solves the circle packing problem
%   posed by the given combinatorics in the given geometry.
%   Valid inputs for 'geometry' are
%
%       'Euclidean'
%       'Hyperbolic'
%
%   or truncations thereof. In euclidean geometry boundary radii are
%   set to 1. In hyperbolic geometry boundary radii are set to Inf.
%
%   PACKIT(combinatorics, geometry, bdfun) solves the circle packing
%   problem posed by the given combinatorics, in the given geometry and
%   using the given boundary radii.
%   Valid inputs for boundary radii are vectors with as many entries as
%   there are boundary vertices, and entries 'r' satisfy
%       0 <  r < Inf in euclidean setting and
%       0 <= r < 1 in hyperbolic.
%
%   PACKIT(combinatorics, geometry, bdfun, intfun) solves the circle
%   packing problem posed by the given combinatorics, in the given
%   geometry, and using the given boundary and interior radii.
%   Interior radii are subject to change during iteration and are only used
%   as initial radii.
%   Valid inputs for interior radii are vectors with as many entries as
%   there are interior vertices, and entries 'r' satisfy
%       0 <  r < Inf in euclidean setting and
%       0 <= r < 1 in hyperbolic.

    GEOM = {'Euclidean', 'Hyperbolic'};
    DEFAULTGEOM = GEOM{2};
    pk = Packit();

    p = inputParser;
    addOptional(p, 'combinatorics', [], @(x) ((isnumeric(x) && size(x, 2) == 3) || (iscell(x) && all(cellfun(@(y) isnumeric(y), x)))));
    addOptional(p, 'geometry', DEFAULTGEOM, @(x) (isempty(x) || any(validatestring(x, GEOM))));
    addOptional(p, 'bdfun', [], @(x) (isnumeric(x)))
    addOptional(p, 'intfun', [], @(x) (isnumeric(x)))
    parse(p, varargin{:});

    
    % Input combinatorics, if given
    if (~isempty(p.Results.combinatorics))
        if (iscell(p.Results.combinatorics))
            pk.flowers = p.Results.combinatorics;
        else
            pk.flowers = tri2flowers(p.Results.combinatorics);
        end
    end
    
    % Compute some combinatorial constants
    pk.nv = numel(pk.flowers);
    
    find_interior(pk);
    pk.ni = numel(pk.interior);
    
    find_boundary(pk);
    pk.nb = numel(pk.boundary);
    
    find_orphans(pk);
    pk.no = numel(pk.orphans);
    
    % Input combinatorics, if given
    if (~isempty(p.Results.geometry))
        pk.geometry = validatestring(p.Results.geometry, GEOM);
    else
        pk.geometry = DEFAULTGEOM;
    end
    
    % Input boundary radii, if given
    pk.radii = zeros(pk.nv, 1);
    if (isempty(p.Results.bdfun))
        if (strcmp(pk.geometry, 'Euclidean'))
            pk.radii(pk.boundary) = 1;
        end
    elseif (isnumeric(p.Results.bdfun))
        pk.radii(pk.boundary) = p.Results.bdfun;
    end
    
    % Input initial interior radii, if given
    if (isempty(p.Results.intfun))
        if (strcmp(pk.geometry, 'Euclidean'))
            pk.radii(pk.interior) = 1;
        else
            pk.radii(pk.interior) = 0.5;
        end
    elseif (isnumeric(p.Results.intfun))
        pk.radii(pk.interior) = p.Results.intfun;
    end
    
    pk.prevRadii = pk.radii;
    
    pk.angTol = pk.ni*10^-12;
    
    pk.solve();
    
end
