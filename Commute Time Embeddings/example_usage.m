% Use the following to recreate the examples from the paper.
%load('Examples/coranetwork.mat') % Use this line for Cora dataset.
%load('Examples/amazonnetwork.mat') % Use this line for the Amazon Co-Purchase dataset.
load('Examples/butterflynetwork.mat') % Use this line for the butterfly dataset.
%load('Examples/emaileunetwork.mat') % Use this line for the email dataset.

%Options for SVD embeddings
opts.lev1 = 7; %Iterations of SVD algorithm used to compute G
opts.lev2 = 7; %Iterations of SVD algo used to compute embeddings
opts.fraction = 0.5; %Fraction of singular values retained at each level

%Diffusion Wavelets embeddings:
Lev1 = 3; %Iterations of diffusion wavelets used to compute G
Lev2 = 2; %Iterations used to compute embeddings
Prec = 0.001; %Precision
[row,col,data]=DWembedder(network, Lev1,Lev2, Prec);
dim = 10;%max(col);
DW_f1macro = scoring(group,row,col,data, 1, dim);


%SVD embeddings:
[row,col,data]=SVDembedder(network, opts);
dim = max(col);
SVD_f1macro = scoring(group,row,col,data, 1, dim);

%Plots of 2D and 3D embeddings (SVD): (Uncomment the following block of
%code)
% N = length(network);
% V = sparse(row,col,data);
% V = V(:,1:3);
% C = zeros(N,1);
%     for n=1:N
%         for k=1:size(group,2)
%             if group(n,k)==1
%                  C(n)=k;
%             end
%         end
%     end
% figure
% scatter(V(:,1),V(:,2),20,C')
% figure
% scatter3(V(:,1),V(:,2),V(:,3),20,C')

