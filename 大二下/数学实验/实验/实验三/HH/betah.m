% returns the beta gating parameter for the h gate at voltage V
function b = betah(V)

b = 1./(exp(-(V+30)/10)+1);
