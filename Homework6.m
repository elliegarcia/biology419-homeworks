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
%% 2
load fisheriris
fitcdiscr(meas, species)
length(species)
%ignore this
obj = fitcdiscr(meas, species, 'discrimtype', 'linear');
[label, score, cost] = predict(obj, meas);