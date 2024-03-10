% Creates embeddings based on commute time with diffusion wavelets for a
% network represented by T.
function [row, col, data]=DWembedder(T, Levels, Levels2, Precision)
N = length(T);
  for i=1:length(T)
      T(i,:) = T(i,:)./sum(T(i,:));
  end
Options.ExtBases = 1;
Options.Wavelets = 0;
gsoptions.QRroutine = 'suitesparse'; % Must have SuiteSparse installed to use this option. Otherwise use 'gsqr'.
Options.GSOptions = gsoptions;
Tree = DWPTree(T, Levels, Precision, Options);

G0 = sparse(eye(N,N)) + T;
G = G0;
% Compute G with Schultz method:
for K=1:Levels
    n = length(Tree{K,1}.T{1});
    G = Tree{K,1}.ExtBasis*(sparse(eye(n,n))+Tree{K,1}.T{1})*Tree{K,1}.ExtBasis'*G;
end

vol = N;
GTree = DWPTree(vol*G, Levels2, Precision, Options);

V = GTree{Levels2,1}.ExtBasis;% Final embedding matrix
  
[row, col, data] = find(V);
end
