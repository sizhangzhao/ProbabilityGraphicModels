testdata = load("exampleIOPA5.mat");

[toy_network, toy_factors] = ConstructToyNetwork(1, 0.1);
num_vars = length(toy_network.names);
A0 = ones(1, num_vars);
evidence = zeros(1, num_vars);
[M, all_samples] = MCMCInference(toy_network, toy_factors, evidence, "Gibbs", 50, 250, 1, A0);
A0 = ones(1, num_vars) * 2;
[M_2, all_samples_2] = MCMCInference(toy_network, toy_factors, evidence, "Gibbs", 50, 250, 1, A0);