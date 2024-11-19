% returns the alpha gating parameter for the m gate at voltage V
function a = alpham(V)

badIndices = find(abs(V+35)<1e-4);
goodIndices = find(abs(V+35)>=1e-4);

a(goodIndices) = -0.1*(V(goodIndices)+35)./(exp(-(V(goodIndices)+35)/10)-1);
if(max(size(badIndices))>0)
    a(badIndices) = 1./(1-(V(badIndices)+35)/20);
end