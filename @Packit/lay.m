function centers = lay( obj )
% Packit.LAY
%   Lay out a circle packing according to its combinatorics and radii

%   Finds a vector of complex centers of circles of a packing. The centers
%   are assumed to be solved to sufficient precision.

obj.centers = nan(obj.nv, 1);

    function dist = dist_hyp(r)
        % Euclidean distance from origin to sum(r) hyperbolic distance
        % away, expressed as label radii.

        % Note: The method finds EUCLIDEAN coordinates of HYPERBOLIC centers.

        % Label radius = exp(-2 * Hyperbolic radius)
        % Hyperbolic radius = ln (1 / sqrt(Label radius))
        % Euclidean distance = (exp(Hyp. dist.) - 1) / (exp(Hyp.dist) + 1)

        
        % Hyperbolic distance H = H(0, C):
        % H(0, C) = ln (1/sqrt(L1)) + ... + ln (1/sqrt(Ln))
        %         = ln (1/sqrt(L1* ... *Ln))
        %         = ln (1/sqrt(L1* ... *Ln))

        % Euclidean distance E = E(0, C):
        % E(0, c2) = (exp(H) - 1) / (exp(H) + 1)
        %          = (1 - sqrt(L1*...Ln)) / (1 + sqrt(L1*...*Ln))
        dist = (1 - sqrt(prod(r))) / (1 + sqrt(prod(r)));
    end

    function [] = align_hyp(pack, coord)
        pack.centers = udiskaut(pack.centers, coord);
        pack.visual = udiskaut(pack.visual, coord);
    end

    function [] = align_eucl(pack, coord)
        pack.centers = pack.centers - coord;
        pack.visual = pack.visual - coord;
    end

if (startsWith('Euclidean', obj.geometry))
    distFunc = @sum;
    angleFunc = @alpha_of_triple_eucl;
    alignFunc = @align_eucl;
end

if (startsWith('Hyperbolic', obj.geometry))
    distFunc = @dist_hyp;
    angleFunc = @alpha_of_triple_hyp;
    alignFunc = @align_hyp;
end

% Assigning an interior vertex to 0 and one neighbor to the real axis
v = [obj.interior(1); obj.flowers{obj.interior(1)}(1:2)];
r = obj.radii(v);

obj.centers(v) = [0; distFunc(r([1 2])); distFunc(r([1 3]))*exp(1i*angleFunc(r))];
obj.visual(v, 1:2) = [-distFunc(r(1)), distFunc(r(1));
                      distFunc(r(1)), distFunc(r([1 2 2]));
                      [distFunc(r(1)), distFunc(r([1 3 3]))]*exp(1i*angleFunc(r))];
obj.visual(v, 3) = ((1 + 1i)*obj.visual(v, 1) + (1 - 1i)*obj.visual(v, 2))/2;

cont = 1;
while (cont == 1)
    cont = 0;
    for v1 = obj.interior'

        if (isnan(obj.centers(v1)))
            continue;
        end

        for v = [v1*ones(1, size(obj.flowers{v1}, 1)-1); obj.flowers{v1}(1:end-1)'; obj.flowers{v1}(2:end)']
            % Add a center if v1, v2 have centers but v3 doesn't
            if (isnan(obj.centers(v(3))) && ~isnan(obj.centers(v(2))))
                r = obj.radii(v);
                % Center, rotate and assign
                
                alignFunc(obj, obj.centers(v(1)));
                
                obj.visual = obj.visual * exp(-1i * angle(obj.centers(v(2))));
                obj.centers = obj.centers * exp(-1i * angle(obj.centers(v(2))));
                
                obj.centers(v(3)) = distFunc(r([1 3])) * exp(1i*angleFunc(r));
                
                obj.visual(v(3), 1:2) = [distFunc(r(1)), distFunc(r([1 3 3]))]*exp(1i*angleFunc(r));
                obj.visual(v(3), 3) = ((1 + 1i)*obj.visual(v(3), 1) + (1 - 1i)*obj.visual(v(3), 2))/2;
                
                cont = 1;
            end

            % Same but mirrored
            if (isnan(obj.centers(v(2))) && ~isnan(obj.centers(v(3))))
                r = obj.radii(v);
                % Center, rotate and assign

                alignFunc(obj, obj.centers(v(1)));
                
                obj.visual = obj.visual * exp(-1i * angle(obj.centers(v(3))));
                obj.centers = obj.centers * exp(-1i * angle(obj.centers(v(3))));
                
                obj.centers(v(2)) = distFunc(r([1 2])) * exp(-1i*angleFunc(r));
                
                obj.visual(v(2), 1:2) = [distFunc(r(1)), distFunc(r([1 2 2]))]*exp(-1i*angleFunc(r));
                obj.visual(v(2), 3) = ((1 + 1i)*obj.visual(v(2), 1) + (1 - 1i)*obj.visual(v(2), 2))/2;
                
                cont = 1;
            end
        end
    end    
end


% Center to the circle closest to center of mass
[~, i] = min(abs(obj.centers - mean(obj.centers, 'omitnan')));
alignFunc(obj, obj.centers(i));
centers = obj.centers;



end