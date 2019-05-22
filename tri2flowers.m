function [flowers, interior] = tri2flowers( tri )
%TRI2FLOWERS Converts a triangulation into a cell array of neighborhoods
%   Extracts the oriented neighborhoods of each vertex of a triangulation.
%
%   The triangulation is assumed to be orientable. Parameter 'tri' is
%   assumed to be an n-by-3 matrix of indices (1, ..., n) representing a
%   list of its oriented faces. Return value is a cell array of vectors
%   containing indices of neighboring vertices.


if (~isnumeric(tri))
    error('Triangulation matrix is not numeric.');
end

if (size(tri, 2) ~= 3)
    error('Triangulation matrix must have 3 columns.');
end

% Approximate required size
alloc = (ceil(numel(tri) / max(max(tri)))+1);
flowers = cell(max(max(tri)), 1);



for face=tri'

    for ord = [face, circshift(face, 1), circshift(face, 2)]

        % 'one' is the 'first' neighbor
        % 'two' is the 'second' neighbor
        % 'last' is the first NaN after the last non-Nan, or zero
        one = find(flowers{ord(1)} == ord(2), 1);
        two = find(flowers{ord(1)} == ord(3), 1);
        last = max([0, find(isnan(flowers{ord(1)}) == 0, 1, 'last') + 1]);

        % Neither vertex was found. Add a new 2-string of
        % consecutive vertices.
        if (isempty(one) && isempty(two))
            if (last == 0)
                flowers{ord(1)} = nan(alloc, 1);
            end
            flowers{ord(1)}((last+1):(last+3), 1) = [ord(2:3); NaN];
            continue;
        end
        
        % The following two cases: One vertex was found.
        % Add the other after or before the existing one, respectively.
        
        if (isempty(two))
            flowers{ord(1)}((one+1):(last+1)) = [ord(3); flowers{ord(1)}((one+1):last)];
            continue;
        end
        
        if (isempty(one))
            flowers{ord(1)}(two:(last+1)) = [ord(2); flowers{ord(1)}(two:last)];
            continue;
        end
        
        % Both vertices are already present, so two unconnected strings of
        % neighbors must be joined.
        if (nnz(isnan(flowers{ord(1)}(1:last))) > 1)
            
            % Rotate string containing second vertex to top
            flowers{ord(1)}(1:last) = circshift(flowers{ord(1)}(1:last), 1-two);
            
            firstnan = find(isnan(flowers{ord(1)}), 1);
            tail = flowers{ord(1)}((firstnan+1):last);
            one = find(tail == ord(2), 1);
            
            % Rotate string containing first vertex to bottom
            flowers{ord(1)}((firstnan+1):last) = circshift(tail, size(tail, 1) - one - 1);
            lastnan = find(isnan(flowers{ord(1)}(1:(last-1))), 1, 'last');
            
            % Omit a NaN, rotate so that last and first segment join
            flowers{ord(1)}(1:(last-1)) = circshift(flowers{ord(1)}(1:(last-1)), -lastnan);

        else
            % If only the final NaN separator is present, the flower cycles
            % and has been completed.
            flowers{ord(1)} = [flowers{ord(1)}(1:(last-1)); ord(3)];
        end
    end

end

% Clean up NaNs in boundary flowers
bdLogical = cellfun(@(x) any(isnan(x)), flowers);
interior = find(~bdLogical);
flowers(bdLogical) = cellfun(@(x) x(1:find(~isnan(x), 1, 'last')), flowers(bdLogical), 'UniformOutput', 0);

end