% returns the alpha gating parameter for the n gate at voltage V
function a = alphan(V)

badIndices = find(abs(V+50)<1e-4);
goodIndices = find(abs(V+50)>=1e-4);

a(goodIndices) = -0.01*(V(goodIndices)+50)./(exp(-(V(goodIndices)+50)/10)-1);
if(max(size(badIndices))>0)
    a(badIndices) = .1./(1-(V(badIndices)+50)/20);
end