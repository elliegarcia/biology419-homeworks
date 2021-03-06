%% 1
load('/Users/esteligarcia/Documents/MATLAB/Biology 419/CancerMicroarray.mat')
%a
length(RawMetaData.SampleName) %for number of samples (83 samples)
length(X) %number of genes profiled (2308 genes)
%b
[coeff, scorepc, latent] = pca(X); %found PCA
figure; %plotted the cumulative sum of the variance explained
stairs(cumsum(latent)/sum(latent));
xlabel('number of PCs')
ylabel('cumulative sum of the variance explained')
variance = cumsum(latent)/sum(latent); 
max(find(variance < 0.95)) %number of PCs needed to explain 95% of data 
%c
vectoraccuracy = [] %empty vector for matrix
linearaccuracy = []
for i = 1:400
    permuted = randperm(numel(G)) %randomly selecting
    test = permuted(1:floor(numel(G)*0.2)); %creating test set
    train = permuted(ceil((numel(G)*0.2)):end); %creating train set
    train10 = score(train, 1:10) %selecting first 10 PC scores
    test10 = score(test, 1:10)
    objlin = fitcdiscr(training10,G(test),'discrimtype','linear');
    objquad = fitcdiscr(training10,G(train),'discrimtype','pseudoquadratic');
    plinear = predict(objlin,test10);% making pediction for test data
    pquadratic = predict(objquad,test10);
    mean(plinear' == G(train))
    mean(pquadratic' == G(train))
end;
%% I don't understand this but it seems to work
obj = fitcdiscr(score(:, 10), G, 'discrimtype', 'linear');
[label, scorelin, cost] = predict(obj, score(:,10))
%quadratic analysis
objquad = fitcdiscr(score(:,10), G, 'discrimtype', 'quadratic');
[labelquad, scorequad, costquad] = predict(objquad, score(:,10));
%used this model
obj = fitcdiscr(meas, species, 'discrimtype', 'linear');
[label, score, cost] = predict(obj, meas);
%d
%% 2
load fisheriris
%a
length(species) %number of flowers in the dataset
meastable = array2table(meas)
width(meastable) %number of measurements
fitcdiscr(meas, species) %species under class names: setosa, versicolor, virginica
%b
rng(1); % For reproducibility
[idx,C] = kmeans(meas,2);
coeff = pca(meas)
figure;
plot(meas(:,1),meas(:,2),'k*','MarkerSize',5);
title 'Fisher''s Iris Data';
xlabel 'Petal Lengths (cm)';
ylabel 'Petal Widths (cm)';

rng(1); % For reproducibility
[idx,C] = kmeans(meas,3);
coeff = pca(meas)
figure;
plot(X(:,1),X(:,2),'k*','MarkerSize',5);
title 'Fisher''s Iris Data';
xlabel 'Petal Lengths (cm)';
ylabel 'Petal Widths (cm)';

rng(1); % For reproducibility
[idx,C] = kmeans(meas,4);
coeff = pca(meas)
figure;
plot(X(:,1),X(:,2),'k*','MarkerSize',5);
title 'Fisher''s Iris Data';
xlabel 'Petal Lengths (cm)';
ylabel 'Petal Widths (cm)';