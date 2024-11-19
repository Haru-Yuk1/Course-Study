% returns the beta gating parameter for the m gate at voltage V
function b = betam(V)

b = 4*exp(-(V+60)/18);