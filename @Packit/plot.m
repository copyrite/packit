function fig = plot( packing )
% Packit.PLOT Plots the given packing

if isempty(packing.visual)
    packing.lay;
end

fig = figure();

% Using a supplementary visualization array is useful for its
% independence of geometry. A packing ready to be plotted has an array
% containing three distinct points on the boundary of each circle.

% For each circle, apply three-point circle formula:
% Find the center (xc, yc) and radius sqrt(xc^2 + yc^2) of a circle
% passing through two points and origin

% x1^2 - 2x1 xc + xc^2 + y1^2 - 2y1 yc + yc^2 - r^2 = 0
% x2^2 - 2x2 xc + xc^2 + y2^2 - 2y2 yc + yc^2 - r^2 = 0
% xc^2 + yc^2 - r^2 = 0

% x1^2 - 2x1 xc + y1^2 - 2y1 yc = 0
% x2^2 - 2x2 xc + y2^2 - 2y2 yc = 0

% xc (2x1) + yc (2y1) = x1^2 + y1^2
% xc (2x2) + yc (2y2) = x2^2 + y2^2
% r = sqrt(xc^2 + yc^2)

anchor = packing.visual(:, 1);
packing.visual = packing.visual - anchor;

% TODO check (2 * [ ... ] \ [ ... ]) order
euclCenters = arrayfun( @(x, y)([1 1i] * (2 * [real(x) imag(x); real(y) imag(y)] \ [abs(x)^2; abs(y)^2])), packing.visual(:, 2), packing.visual(:, 3));
euclRadii = abs(euclCenters);
euclCenters = euclCenters + anchor;

packing.visual = packing.visual + anchor;

cla;
viscircles([real(euclCenters), imag(euclCenters)], euclRadii, 'Color', 'k', 'LineWidth', 1);
axis equal;

end