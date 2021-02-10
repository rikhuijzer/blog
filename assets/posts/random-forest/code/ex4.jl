# This file was generated, do not modify it. # hide
@load LinearBinaryClassifier pkg=GLM verbosity=0
logistic_model = LinearBinaryClassifier();

DecisionTree = @load DecisionTreeClassifier verbosity=0
forest_model = EnsembleModel(atom=(@load DecisionTreeClassifier), n=10);

logistic = machine(logistic_model, (U = df.U, V = df.V), df.class)
fit!(logistic; rows=train)
fitted_params(logistic).coef