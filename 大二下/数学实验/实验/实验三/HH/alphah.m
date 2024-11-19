% returns the alpha gating parameter for the h gate at voltage V
function a = alphah(V)

a = 0.07*exp(-0.05*(V+60));