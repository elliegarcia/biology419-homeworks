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
title('Cumulative Sum of Variance by number of PCs')
variance = cumsum(latent)/sum(latent); 
max(find(variance < 0.95)) %number of PCs needed to explain 95% of data (~52) 
%c and d
linearvec = zeros(1,400); %empty vector for LDA, QDA, and decision tree respectively
quadraticvec = zeros(1,400);
decisiontreevec = zeros(1, 400);

for i = 1:400
    permuted = randperm(numel(G)); %randomly selecting
    test = permuted(1:floor(numel(G)*0.2)); %creating test set
    train = permuted(ceil((numel(G)*0.2)):end); %creating train set
    train10 = scorepc(train, 1:10); %selecting first 10 PC scores
    test10 = scorepc(test, 1:10);
    objlin = fitcdiscr(train10,G(train),'discrimtype','linear'); %returning a discriminanty analysis classifier
    objquad = fitcdiscr(train10,G(train),'discrimtype','pseudoquadratic');
    plinear = predict(objlin,test10);% making pediction for test data
    pquadratic = predict(objquad,test10);
    templin = mean(plinear' == G(test));
    tempquad = mean(pquadratic' == G(test));
    linearvec(i) = templin;
    quadraticvec(i) = tempquad;
    treefit = fitctree(train10, G(train));
    treepredict = predict(treefit, test10);
    temptree = mean(treepredict' == G(test));
    decisiontreevec(i) = temptree;
end;
mean(linearvec) %mean of 400 runs of the LDA, final cv accuracy is ~97 percent
mean(quadraticvec) %mean of 400 runs of QDA, final cv accuracy is ~85 percent
mean(decisiontreevec) %mean of 400 runs of decision tree, final cv accuracy is ~76 percent
view(treefit, 'mode', 'graph')
%% 2
load ('fisheriris')
%a
length(species) %number of flowers in the dataset (150 flowers)
width(array2table(meas))%number of measurements (4 measurements) 
fitcdiscr(meas, species) %species under class names: setosa, versicolor, virginica
%b
[coeffiris, scoreiris, latentiris] = pca(meas); %pca data for plots
[idx2, C] = kmeans(meas, 2); %used kmeans to sort meas into 2 clusters
figure;
gscatter(scoreiris(:, 1), scoreiris(:,2), idx2); %plotted scores using idx
title('Fishers Iris Data in 2 Clusters');
legend('cluster1', 'cluster2');

[idx3, C] = kmeans(meas, 3); %used kmeans to sort meas into 3 clusters
figure;
gscatter(scoreiris(:, 1), scoreiris(:,2), idx3); %plotted scores using idx
title('Fishers Iris Data in 3 Clusters');
legend('cluster1', 'cluster2', 'cluster3');

[idx4, C] = kmeans(meas, 4); %used kmeans to sort meas into 4 clusters
figure;
gscatter(scoreiris(:, 1), scoreiris(:,2), idx4); %plotted scores using idx
title('Fishers Iris Data in 4 Clusters');
legend('cluster1', 'cluster2', 'cluster3', 'cluster4');
%c
%One method to try is the elbow method, which looks at the percent of
%variance explained as a function of the number of clusters. The point
%where the marginal gain begins to drop would be the number of clusters to
%use.
%% 3
