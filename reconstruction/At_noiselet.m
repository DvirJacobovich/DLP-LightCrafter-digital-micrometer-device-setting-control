% At_noiselet.m
%
% Adjoint of A_noiselet.m
%
% Written by: Justin Romberg, Georgia Tech, jrom@ece.gatech.edu
% Created: May 2007
%

function v = At_noiselet(y, OMEGA, M)

vn = zeros(M,1);
vn(OMEGA) = y;
v = realnoiselet(vn/sqrt(M));

