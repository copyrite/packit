function tri = triang_koch ( gen )
%TRIANGKOCH
%   Generates a triangulation of a Koch snowflake as a list of faces.
%   First generates the boundary of a generation 'gen' snowflake, then
%   inserts interior points.
%   (Note: If done purely combinatorically, this could be a lot faster.)

    function new = iter(old)
        x = old;
        y = circshift(old, -1);
        new = reshape([3*x, 2*x + y, 2*x+y + exp(-1i*pi/3)*(y - x), x + 2*y].'/3, [4*numel(old), 1]);
    end

if (numel(gen) ~= 1)
    error('Erroneous parameter given to Koch snowflake');
end

koch = zeros(3*4^gen, 1);
koch(1:3) = 1i*exp((0:2) * 2i * pi/3);

for i=1:gen
    koch(1:(3*4^i)) = iter(koch(1:(3*4^(i-1))));
end



% Find a set of integer coordinates for boundary vertices

basis = [koch(2); koch(end)] - koch(1);
basis = [real(basis) imag(basis)];

coord = round(([real(koch) imag(koch)] - [real(koch(1)) imag(koch(1))]) / basis);
coord = coord - min(coord) + 1;

mat = zeros(max(coord));
mat(sub2ind(size(mat), coord(:, 1), coord(:, 2))) = 1;

% Fill in interior


if (gen >= 1)
    mat(coord(1, 1)+1, coord(1, 2)+1) = 2;
    
    while (true)
    new = ((mat == 0) & ((circshift(mat, [1 0]) == 2) | (circshift(mat, [0 -1]) == 2) | (circshift(mat, [1 -1]) == 2) ...
                       | (circshift(mat, [-1 0]) == 2) | (circshift(mat, [0 1]) == 2) | (circshift(mat, [-1 1]) == 2)));
                   
    if (all(new == 0))
        break;
    end
    
    mat = mat + 2*new;
    
    end
end

nz = find(mat);
mat(nz) = 1:numel(nz);
left = mat & circshift(mat, [0 -1]) & circshift(mat, [-1 0]);
right = mat & circshift(mat, [1 0]) & circshift(mat, [0 1]);

tri = [[mat(left),  mat(circshift(left,  [1  0])), mat(circshift(left,  [0  1]))]; ...
       [mat(right), mat(circshift(right, [-1 0])), mat(circshift(right, [0 -1]))]];

end
