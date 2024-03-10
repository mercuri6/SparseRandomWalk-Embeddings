% Creates embeddings for a network represented by matrix T using the
% commute time with SVD algorithm.
function [row, col, data]=SVDembedder(T, opts)
%options structure:
if ~isfield(opts, 'lev1')         opts.lev1 = 5;              end;
if ~isfield(opts, 'lev2')         opts.lev2 = opts.lev1;              end;
Levels = opts.lev1;
Levels2 = opts.lev2;


N=length(T);
 for i=1:length(T)
      T(i,:) = T(i,:)./sum(T(i,:));
 end

Tree = SVDTree(T, Levels, opts);

G = (sparse(eye(size(T)))+T);
for k=1:Levels
    sz = size((Tree{k,1}.T{1}));
    G =Tree{k,1}.ExtBasis*(sparse(eye(sz))+Tree{k,1}.T{1})*Tree{k,1}.ExtBasis'*G;
end

vol = N;

GTree = SVDTree(vol*G, Levels2, opts);

V = GTree{Levels2,1}.ExtBasis*GTree{Levels2,1}.Op;% Final embedding matrix

 [row, col, data] = find(V);
end
