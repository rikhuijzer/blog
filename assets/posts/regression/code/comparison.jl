# This file was generated, do not modify it. # hide
write_csv("comparison", # hide
DataFrame(
	model = ["Linear regression", "Logistic regression"],
	S = r_2.([S(digits, predict(m2)), S(digits, predict(m3))]),
	accuracy = r_2.([accuracy(digits, binary_values(m2)), accuracy(digits, binary_values(m3))])
)
) # hide