# This file was generated, do not modify it. # hide
LinearBinary = @load LinearBinaryClassifier pkg=GLM verbosity=0
logistic_model = LinearBinary();

DecisionTree = @load DecisionTreeClassifier pkg=DecisionTree verbosity=0
tree = DecisionTree()
forest_model = EnsembleModel(atom=tree, n=10);

logistic = machine(logistic_model, (U = df.U, V = df.V), df.class)
fit!(logistic; rows=train)
fitted_params(logistic).coef