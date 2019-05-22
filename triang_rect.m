function tri = triang_rect (x, y)
%TRIANGRECT
%   Generates a triangulation of a rectangle as a list of faces.
%
%	triang_rect (x, y) attaches "envelope shapes" (crossed-out boxes)
%   into a rectangle with x rows, y columns. Each envelope consists of
%   five vertices: Four corners and the center. Corner vertices may be,
%	and generally are, shared with other envelopes.
%
%   If x*y is odd, the centermost vertex is (1 + ni)/2.
%   If x*y is even, it is ((ni+1) + (ni+(x+1)*(y+1))/2.

    ni =  x*y;

    tri = [ repelem(1:ni, 4)', ...
       ni + repelem(1:ni, 4)' + repelem(1:x, 4*y)' + repmat([0; 1; y+2; y+1], [ni 1]) - 1, ...
       ni + repelem(1:ni, 4)' + repelem(1:x, 4*y)' + repmat([1; y+2; y+1; 0], [ni 1]) - 1 ];

end
