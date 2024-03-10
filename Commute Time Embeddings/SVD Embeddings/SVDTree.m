% Computes the left singular matrices U_k and compressed representations of
% T^{2^k} = T_k via SVD.
function[Tree]=SVDTree(T, Levels, opts)
%let T be N by N matrix; P or K.
if ~isfield(opts, 'fraction')         opts.fraction = 0.5;              end; %determines the fraction of singular values retained.
truncpercent = opts.fraction;


N = size(T,1);
Tree = cell(Levels, 1);

j=1;
Tree{j,1} = struct('Level', j, 'Index',1, 'Basis', [], 'Op', [], 'T', [], 'ExtBasis', []);
Tree{j,1}.T    = cell(1);
[U,S,V] = svds(T,ceil(N*truncpercent));

Tree{j,1}.ExtBasis     = U;
Tree{j,1}.Basis = U;
Tree{j,1}.Op        = S*V';

Tree{j,1}.T{1} = Tree{j,1}.Basis'*T*Tree{j,1}.Basis;

for j = 2:Levels
     Tree{j,1} = struct('Level', j, 'Index',1, 'Basis', [], 'Op', [], 'T', [], 'ExtBasis', []);
     Tree{j,1}.T    = cell(1);
[U,S,V]=svds(Tree{j-1,1}.T{1},ceil(size(Tree{j-1,1}.T{1},1)*truncpercent));

Tree{j,1}.Basis = U;
Tree{j,1}.ExtBasis     = Tree{j-1,1}.ExtBasis*U; 
Tree{j,1}.Op        = S*V';

Tree{j,1}.T{1} = Tree{j,1}.Basis'*Tree{j-1}.T{1}*Tree{j,1}.Basis;
end

end



