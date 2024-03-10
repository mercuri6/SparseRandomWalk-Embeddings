%Scoring function: Uses k-nearest neighbors to assign class labels to
%embeddings, then computes F1 Macro score.
function [F1macro]=scoring(group, row, col, data, trainpercent, dim) 
N = length(group);
V = sparse(row,col,data,N,N);
V = V(:,1:dim);
%shuffle data
grouppoints = zeros(N,1);
    for n=1:N
        for k=1:size(group,2)
            if group(n,k)==1
                 grouppoints(n)=k;
            end
        end
    end
Vprime = [V,grouppoints];
shuf = randperm(size(V,1));
Vshuffle = Vprime(shuf,:);
Vshuf = Vshuffle(:,1:size(V,2));
yshuf = Vshuffle(:,size(V,2)+1);
groupshuf = group(shuf,:);

%train/test data
train_percent = trainpercent;
 training_size = round(train_percent*size(V,1));
  
      X_train = Vshuf(1:training_size,:);
      y_train = yshuf(1:training_size);
      X_test = Vshuf(training_size+1:N,:);
      y_test = yshuf(training_size+1:N);
      
 %fit model (k nearest neighbors)
 mdl = fitcknn(X_train,y_train,'NumNeighbors',4);
% [label,score,cost] = predict(mdl,Vshuf);
[label,score,cost] = predict(mdl,[X_test,y_test]);
 
 [tpr,fpr,thresholds] = roc(groupshuf',score');
% figure;
% plotroc(groupshuf',score')
 
[c,cm,ind,per] = confusion(groupshuf',score'); 
clear precision recall F1macro F1
for i=1:size(group,2)
    precision(i) = per(i,3);
    recall(i) = cm(i,i)/sum(cm(i,:));
    if precision(i)~=0 || recall(i)~=0
        F1(i) = 2*recall(i)*precision(i)/(precision(i)+recall(i));
    else
        F1(i) = 0;
    end
end
F1macro = sum(F1)/size(group,2);



end
