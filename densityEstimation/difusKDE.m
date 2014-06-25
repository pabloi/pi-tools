function [density] = difusKDE(samples,xmesh)
%difusKDE Computing density estimation by diffusion (extending the work of
%Botev, kde.m). This function allows for multi-dimensional data, and
%inhomogeneous and anisotropic difussion (i.e. variable non-spherical
%gaussian kernels). However, it is not as efficient in its computation.

%Inputs:
%samples: NxM matrix, containing N samples of M-dimensional data.
%xmesh: cell-array of length M, each cell containing a vector. The i-th
%vector represents the coordinates of the grid in the i-th dimension (grid
%is rectangular).

t_end=1; %Diffusion time. This is probably a parameter the user would like control over.
dt=.001; %Time-step length for discrete simulation of the diffusion equation.
N=round(t_end/dt); %Number of steps in the simulation.

M=size(samples,2); %Dimensionality of the data.
gridSize=cellfun('length',xmesh); 
Ngrid=prod(gridSize); %total number of grid points to evaluate at.

%% Compute conductivity at each point of the grid (gridSize x MxM matrix)
conductivity=

%% Initial guess at the density: spread each sample proportionally among the 2^M closest grid-points
density=

%% Iterate
for step=1:N
    gradient= %gridSize x M matrix, representing the M-dimensional gradient in each of the Ngrid points.
    density=density+dt*divergence(tensorProduct(conductivity,gradient));
end


end

%% Aux functions:
function y=divergence(x)

end

function x=gradient(y)

end

function z=tensorProduct(x,y)
sX=size(x);
sY=size(y);
if sX(end)~=sY(1)
    throw(MException('tensorProduct:BadSize','Tensor sizes do not match.'));
    return
end
newX=reshape(x,sX(1:end-1),sX(end));
newY=y(:,:);
newZ=newX*newY;
z=reshape(newZ,sX(1:end-1),sY(2:end));
end