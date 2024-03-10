%%%% lennard jones N cluster
kb = 1;
T = 0.08; %temperature
beta = 1/(kb*T);
atoms = 38;
nodes = load('LJ38mindata (2).txt');
ts= load('LJ38tsdata.txt'); 
%nodes = readmatrix('LJ8mindatanewnew.txt','ExpectedNumVariables',28,'NumHeaderLines',0,'LineEnding',']','Whitespace','\n');
%ts = load('LJ8tsdatanewnew.txt');
nodes_reorder=zeros(size(nodes));
for k=1:size(nodes,1)
    nodes_reorder(nodes(k,1),:) = nodes(k,:);
end
nodes=nodes_reorder;
V = nodes(:,2);
v = nodes(:,4); %might need exp of these
O = nodes(:,3);
Vk = ts(:,1);
vk = ts(:,5);
Ok = ts(:,4);
coords = nodes(:,5:size(nodes,2));
N = size(nodes,1);
kap = 3*atoms-6; %vibrational deg of freedom
Anode = 731;%2; %731 global min--the 2nd lowest is 269
Bnode = 4799;%4; %highest min in the database (41 of full, 4799 of small)
%Anode=1;
%Bnode=2;


newlist=[];
for i=1:N
    if V(i)<-170.9
        newlist=[newlist,i];
    end
end
N=length(newlist);
nodes = nodes(newlist,:);
ts_new = [];
for k=1:size(ts,1)
    if isempty(find(newlist==ts(k,2))) || isempty(find(newlist==ts(k,3)))
    else
        ts_new = [ts_new; ts(k,1), find(newlist==ts(k,2)), find(newlist==ts(k,3)), ts(k,4), ts(k,5)];
    end
end
ts = ts_new;
V = nodes(:,2);
v = nodes(:,4);
O = nodes(:,3);
Vk = ts(:,1);
vk = ts(:,5);
Ok = ts(:,4);
Anode = find(newlist==Anode);
Bnode = find(newlist==Bnode);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
adj2=zeros(N,N);
adj = zeros(N,N);
L = sparse(zeros(N,N));
for k=1:size(ts,1)
    i=ts(k,2);
    j=ts(k,3);
    adj(i,j)=1;
    adj(j,i)=1;
    %if i<=N && j<=N
        if Vk(k)<adj2(i,j) %so adj2 can be usedin disconnectivitygraphinfo
    adj2(i,j)=Vk(k);%adj2(i,j)+1;
    adj2(j,i)=adj2(i,j);
        end
    if vk(k)>0 
        L(i,j)=L(i,j) + (O(i)/Ok(k))*(v(i)/vk(k))^(kap-1)*v(i)*exp(-beta*(Vk(k)-V(i)));
        L(j,i)=L(i,j);

    end
    %end
%             if L(i,j) == Inf
%             break;
%         end
end

for k=1:N
    L(k,k)=-sum(L(k,:));
end
   B = [zeros(N,1);1];
   K=[L,ones(N,1)];
%stationaryprobs = mrdivide(B.',K); 

stationaryprobs = zeros(N,1);
Z = @(beta) sum( exp(-beta.*V)./(O.*v.^kap) );
for i=1:N
   stationaryprobs(i) = (-beta*V(i))-log(O(i)*v(i)^kap);
end
stationaryprobs = stationaryprobs./sum(stationaryprobs);
% 
% Lhat = zeros(N,N);
% for k=1:N
%     for l=1:N
%         Lhat(k,l)=(stationaryprobs(l)/stationaryprobs(k))*L(l,k);        
%     end
% end
Lhat = L;
%calculate committors
M = L;
M(Anode,:) = zeros(1,N); 
M(Bnode,:) = zeros(1,N);
M(Anode,Anode) = 1;
M(Bnode,Bnode)=1;
b = zeros(N,1);
b(Anode) = 0;
b(Bnode) = 1;

%qplus = M\b;
qplus = pinv(full(M))*b;

M = Lhat;
b = zeros(N,1);
M(Anode,:) = zeros(1,N); 
M(Bnode,:) = zeros(1,N);
M(Anode,Anode)=1;
M(Bnode,Bnode)=1;
b = zeros(N,1);
b(Anode) = 1;
b(Bnode) = 0;

%qminus = M\b;
qminus = pinv(full(M))*b;




%calculate flux:
f=zeros(N,N);
for k=1:N
    for l=1:N
        
        if k~=l
            f(k,l)=stationaryprobs(k)*qminus(k)*L(k,l)*qplus(l);
             %f(k,l)=qminus(k)*L(k,l)*qplus(l);

        else
            f(k,l)=0;
        end
        
    end
end

effectivecurrent=zeros(N,N);
for k=1:N
    for l=1:N
        effectivecurrent(k,l)=max([f(k,l)-f(l,k),0]);
    end
end


T = eye(N,N)*-diag(L)-L;
                
         