function reinit( packing )
%Packit.REINIT Reinitialize a Packit
%   Revert a packing to its initial values.

packing.iter = 0;

packing.radii = packing.initRadii;
packing.err = packing.angTol + 1;
packing.flag = 0;

packing.prevRadii = nan([packing.nv 1]);
packing.prevErr = packing.angTol + 1;
packing.prevFlag = 0;

end

