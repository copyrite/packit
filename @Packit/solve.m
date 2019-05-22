function solve( obj, varargin )
% Packit.SOLVE Solves the given Packit problem

angTol = obj.angTol;
accTol = obj.accTol;

% maxIter = parser.Results.maxIter;

function newRadius = adjustRadius_eucl( labelRadius, degree, anglesum, target )
%ADJUSTRADIUS_EUCL Returns scaling factor of a vertex to meet its target
%   
beta = sin(anglesum / degree / 2);
delta = sin(target / degree / 2);
newRadius = labelRadius * beta * (1 - delta) / (1 - beta) / delta;
end


function newRadius = adjustRadius_hyp( labelRadius, degree, anglesum, target )
%ADJUSTRADIUS_HYP Returns scaling factor of a vertex to meet its target
%   
beta = sin( anglesum / degree / 2 );
delta = sin( target / degree / 2 );
refRadius = max([0, (beta - sqrt(labelRadius)) / (beta * labelRadius - sqrt(labelRadius))]);
newRadius = (2*delta / (sqrt((1 - refRadius)^2 + 4*refRadius*delta^2) + (1 - refRadius)))^2;
end


if (startsWith('Euclidean', obj.geometry))
angleFunc = @alpha_of_triple_eucl;
radiusFunc = @adjustRadius_eucl;
radMin = 0;
radMax = Inf;
end

if (startsWith('Hyperbolic', obj.geometry))
angleFunc = @alpha_of_triple_hyp;
radiusFunc = @adjustRadius_hyp;
radMin = 0;
radMax = 1;
end

while (obj.err > angTol) %&& nIter < maxIter)
    
    prevRadii = obj.radii;
    prevErr = obj.err;
    prevLambda = obj.lambda;
    prevFlag = obj.flag;
    
    % target = obj.target;
    radii = obj.radii;
    err = 0;
    
    % Interior sweep
    for v1=obj.interior'
        flower = obj.flowers{v1};
        % Flowers with cycling neighbors have degree+1 vector entries
        % (might be useful to skip test)
        degree = size(flower, 1) - (flower(1) == flower(end));
        
        theta = 0;
        r1 = radii(v1);

        % Iterate neighbor pairs
        for edge = [flower(1:end-1)'; flower(2:end)']
            r = [r1; radii(edge)];
            theta = theta + angleFunc(r);
        end

        err = err + (theta - obj.target(v1))^2;
        radii(v1) = radiusFunc(radii(v1), degree, theta, obj.target(v1));

    end
    
    err = sqrt(err);
    lambda = err / prevErr;
    flag = 1;

    % Acceleration
    if (prevFlag == 1 && lambda < 1)
        err = lambda*err;
        if (abs(lambda - prevLambda) < accTol)
            lambda = lambda / (1 - lambda);
        end

        pos = (radii > prevRadii);
        neg = (radii < prevRadii);
        lambdaStar = min([ ...
(radMax - radii(pos)) ./ (radii(pos) - prevRadii(pos)); ...
(radMin - radii(neg)) ./ (radii(neg) - prevRadii(neg))]);

        lambda = min(lambda, 0.5*lambdaStar);
        radii = radii + lambda*(radii - prevRadii);
        flag = 0;
    end

    
    obj.prevRadii = prevRadii;
    obj.prevErr = prevErr;
    obj.prevLambda = prevLambda;
    obj.prevFlag = prevFlag;
    
    obj.iter = obj.iter + 1;
    
    obj.radii = radii;
    obj.err = err;
    obj.lambda = lambda;
    obj.flag = flag;
    
end

end

