%% 1
load('CancerMicroarray.mat')
%a
length(RawMetaData.SampleName) %for number of samples
length(X) %number of genes profiled
%b
[coeff, score, latent] = pca(X); %found PCA
figure; %plotted the cumulative sum of the variance explained
stairs(cumsum(latent)/sum(latent));
%based on the graph looks like it's 53 PC's, I don't know how to find this
%any other way
%c
%I don't understand this but it seems to work
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