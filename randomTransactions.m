function generatedTransactions = randonTransactions (transactionCount, itemCount, itemPerTransactionRange)
generatedTransactions = {};
% items = [1:itemCount]';

for t = 1:transactionCount
    eachTransactionSize = randi(itemPerTransactionRange);
    itemList = [];
    for k = 1:eachTransactionSize
        item = randi([1, itemCount]);
        itemList = [itemList; item];
    end
    generatedTransactions{t, 1} = itemList;
end