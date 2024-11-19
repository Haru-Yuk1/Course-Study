% returns the beta gating parameter for the n gate at voltage V
function b = betan(V)

b = 0.125*exp(-(V+60)/80);