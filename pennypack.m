function tri = pennypack( polygon, radius )
%PENNYPACK Penny pack a polygon
%   Given a vector of complex polygon corners, returns a triangulation
%   of a maximal penny pack inside the region.
%   Region must be non-self-intersecting (and probably many other things).

% Some quick and dirty efficiency boosts
p = reshape(polygon - mean(polygon), [numel(polygon) 1]);
circBound = max(abs(p));

gridBound = ceil(circBound/radius/sqrt(3));
[x, y] = meshgrid([flip(-1:-1:-gridBound), 0:1:gridBound], [flip(0:1:gridBound), -1:-1:-gridBound]);
dim = size(x);

centers = [reshape(x, [1, numel(x)]); reshape(y, [1, numel(y)])];
centers = 2*[1 1i]*radius*[1 0.5; 0 sqrt(3)/2]*centers;

diffs = bsxfun(@minus, p, centers);

% A 'penny' is a disk of uniform radius aligned to a hexagonal grid.
% Ignore pennies outside the bounding circle
inpoly = (abs(centers) <= circBound + radius);

% Ignore pennies that overlap polygon vertices
% Note: This is part of point-to-line segment check
inpoly(inpoly) = all(abs(diffs(:, inpoly)) > radius);

% Ignore pennies with centers outside the polygon (by angle computation).
% 0 is outside, 2*pi is inside, so assume anything > pi is in.
inpoly(inpoly) = (abs(sum(angle(diffs(:, inpoly) ./ circshift(diffs(:, inpoly), 1)))) > pi);


% Ignore pennies that overlap polygon lines.
% If point-to-line distance exceeds radius, no further tests are required.
% Otherwise, check whether the penny is far enough off to the side. This is
% done by finding the obliqueness of the triangle between line vertices and
% penny center.

% pointToLine is classic point-to-line computation
pointToLine = @(p1, p2, p3) abs(det([real([p1 p2 p3]); imag([p1 p2 p3]); 1 1 1])) / abs(p2 - p3);
% pointAlign is the extra check for pennies in point-to-line distance
pointAlign = @(p1, p2, p3) (abs(p1 - p2)^2 + abs(p2 - p3)^2 < abs(p1 - p3)^2 || abs(p1 - p3)^2 + abs(p2 - p3)^2 < abs(p1 - p2)^2);

inpoly(inpoly) = all(arrayfun(@(p1, p2, p3)(pointToLine(p1, p2, p3) > radius || pointAlign(p1, p2, p3)), ...
    repmat(centers(inpoly), [numel(p) 1]), repmat(p, [1 nnz(inpoly)]), repmat(circshift(p, 1), [1 nnz(inpoly)])), 1);

% Pennies that fit in the polygon have now been found. Extract the
% list of faces.

% Revert the index list to a grid shape
indexGrid = zeros(dim);
indexGrid(inpoly) = 1:nnz(inpoly);

% Triangles point either up or down, find faces in each of the two classes
upper = logical([indexGrid(1:(end-1), 1:(end-1)) & indexGrid(1:(end-1), 2:end) & indexGrid(2:end, 2:end), zeros(dim(1)-1, 1); zeros(1, dim(2)-1), 0]);
lower = logical([indexGrid(1:(end-1), 1:(end-1)) & indexGrid(2:end, 1:(end-1)) & indexGrid(2:end, 2:end), zeros(dim(1)-1, 1); zeros(1, dim(2)-1), 0]);

% List all triangles (by class)
tri = [indexGrid(upper), indexGrid(circshift(upper, [1 1])), indexGrid(circshift(upper, [0 1]));
       indexGrid(lower), indexGrid(circshift(lower, [1 0])), indexGrid(circshift(lower, [1 1]))];


cla
hold on
plot(gca, [p; p(1)]);
plot(gca, centers, '.');
plot(gca, centers(inpoly), 'o');
viscircles([0 0], circBound);
hold off

end

