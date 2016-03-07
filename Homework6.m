%% Quick reminder to Cooper that I used my 2 day extension, and I got an additional extension b/c my first draft got erased
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
[coeffiris, scoreiris, latentiris] = pca(meas); %pca'ed the data for plots
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
%DBSCAN is a clustering method that uses a density based clustering
%algotherim. It randomly selects a point (A) and if A is sufficiently close
%to multiple other points than it marks A as a "core point", otherwise it
%marks A as "noise". A group of core points within a certain distance make
%up a cluster, all the remaining points are considered noise.
%c
data = load('/Users/esteligarcia/Documents/MATLAB/YPML110 DBSCAN Clustering/DBSCAN Clustering/mydata.mat');
X = data.X;
epsilon = 0.5;
MinPts = 10; %set minimum number of points for a cluster
IDX = DBSCAN(X,epsilon,MinPts); %run DBSCAN algorithm
figure;
PlotClusterinResult(X, IDX); %plotted
title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = '...
    num2str(MinPts) ')']);

[coeffX, scoreX, latentX] = pca(X); %pca'ed the data for plots
[idx, C] = kmeans(X, 2); %set 2 clusters using kmeans
figure;
gscatter(scoreX(:, 1), scoreX(:,2), idx); %plotted
legend('cluster1', 'cluster2');
title('mydata in 2 clusters using kmeans');
%Key Differences: The DBSCAN algorithm recognized that the half-donut
%cluster and the circle inside were seperate clusters. On the other hand,
%the kmeans algorithm did not recognize them as seperate and instead tried
%to set a straight line somewhere between the data points.
%d
%DBSCAN works better for seperating clusters that may not have a straight
%line between them, like donut shaped clusters. It is also better if the
%user does not know how many clusters the data has. However, Kmeans is a
%better option if the data has a linear divide and if the user knows how
%many clusters the data should have.
%I spent ~10 hours on this homework. Part of the reason is that I lost the
%changes I made to the original version of the homework, so I had to start
%over. Mary Chang and Linnea Pearson helped me redo my homework.