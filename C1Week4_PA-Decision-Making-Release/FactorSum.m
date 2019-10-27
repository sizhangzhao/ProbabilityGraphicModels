function combinedU = FactorSum(U)

	combinedU = U(1);
  combinedU.val = exp(combinedU.val);

  for i = 2:length(U)
    temU = U(i);
    temU.val = exp(temU.val/1000);
    combinedU = FactorProduct(combinedU, temU);
  end

  combinedU.val = log(combinedU.val);

end
