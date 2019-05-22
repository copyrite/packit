classdef Packit < handle
% A minimal class for circle packings
%
% Usage:
%   mp = packit([1 2 3; 1 3 4; 1 4 2]);
%
% Fields:
%   flowers (cell array)
%       Array of vertex lists of oriented neighborhoods
%   interior (vector)
%       List of interior vertices
%   boundary (vector)
%       List of boundary vertices, but not orphans
%   orphans (vector)
%       List of orphan vertices (boundary vertices with only interior
%       neighbors)
%   target (function handle or vector)
%       Maps vertex indices to corresponding target angle sums
%   geometry (string)
%       String describing how various angle and distance computations
%       should be performed
%   centers (vector)
%       Vector of euclidean/hyperbolic centers of circles as complex
%   visual (matrix)
%       Supplementary data for visualization of hyperbolic packings
% 
%   nv, ni, nb, no (scalar)
%       Number of vertices, interior vertices, boundary vertices
%       and orphan vertices, respectively
% 
%   initRadii (vector)
%       List of radii in the initial iterate
%   iter (scalar)
%       Number of iterations performed on this packing
%   angTol (scalar)
%       Tolerance for error in angle sums
%   accTol (scalar)
%       Tolerance for applying acceleration factor
% 
%   radii (vector)
%       List of radii in current iterate
%   err (scalar)
%       Error in angle sums in current iterate
%   flag (scalar)
%       Acceleration requires two consecutive flagged iterates
%   lambda (scalar)
%       Acceleration factor
% 
%   prevRadii, prevErr, prevFlag, prevLambda
%       As above, but for the previous iterate
% 
    properties(Access = public)
        GEOMETRIES = {'Euclidean', 'Hyperbolic'}
        
        %% fields
        flowers
        interior
        boundary
        orphans
        target
        geometry
        centers
        visual
        
        % number of: vertices, interior, boundary, orphan, faces
        nv
        ni
        nb
        no
        
        initRadii
        iter
        angTol
        accTol
        
        radii
        err
        flag
        lambda
        
        prevRadii
        prevErr
        prevFlag
        prevLambda
        
    end

    methods
        function obj = Packit(varargin)
            obj.flowers     = cell(0);
            obj.interior    = [];
            obj.boundary    = [];
            obj.orphans     = [];
            obj.target      = @(x) (2*pi);
            obj.geometry    = 'Euclidean';
            obj.centers     = [];
            obj.visual      = [];
            
            obj.nv          = 0;
            obj.ni          = 0;
            obj.nb          = 0;
            obj.no          = 0;
            
            obj.initRadii   = [];
            obj.iter        = 0;
            obj.angTol      = 10^-9;
            obj.accTol      = 1;

            obj.radii       = [];
            obj.err         = obj.angTol + 1;
            obj.flag        = 0;
            obj.lambda      = -1;
            
            obj.prevRadii   = [];
            obj.prevErr     = obj.angTol + 1;
            obj.prevFlag    = 0;
            obj.prevLambda  = -1;
            
        end
        
        init(obj, varargin)
        solve(obj, varargin)
        lay(obj)
        plot(obj)
        
    end
    
end