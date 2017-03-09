clear all;
tic;
%% Transaction specification
transactionCount = 200;
itemCount = 50;
itemPerTransactionRange = [2, 5];
%% Define minimum Candidate and minimum confidence
minPercent = 0.015;
sup_min = round(transactionCount * minPercent);
conf_min = round(transactionCount * minPercent);
%% Generate transactions
% transactions = randomTransactions(transactionCount, itemCount, itemPerTransactionRange);
% save('transactions', 'transactions')

% GAI
sup_min = 2;
transactions = {[41;38;28;11] [45;22;48] [15;6;7;8;9] [24;49;43] [34;16;41;42] [2;35;26;46] [27;4;10;23] [49;32;7;8;9] [2;19;17;47] [36;14;45] [6;7;8;9] [36;31;24] [44;41] [43;34;31;11] [44;5;42;9] [41;11;49] [32;36;40] [36;7] [10;24;27;16] [23;41;40;39] [46;15;26;33] [15;41] [10;4] [34;31;46] [46;45] [5;8;6;30] [25;8;34;28] [31;18] [4;14;35;47] [19;26;14;25] [3;14;25] [34;16;41;42] [7;35;31;41] [28;9;10;30] [49;28] [13;42] [32;26;48] [26;8] [32;29;28;33] [34;16;41;42] [4;12] [22;23] [20;40] [45;2] [48;49;1] [14;48;29] [16;21;48;44] [13;7;44;9] [27;39;26;18] [2;34;6;10] [29;13;16] [39;7] [28;33;17] [5;44] [44;32;13;24] [44;25] [16;19;12] [30;1;49;48] [38;5] [4;6] [5;42;32;29] [42;43] [45;40;23] [39;21;32] [30;5;31;49] [27;1;28;33] [43;16;39] [41;27;26] [32;28] [13;40] [46;17;10] [33;11] [25;38;24] [22;6] [28;35;32;1] [23;49;6] [14;31] [13;19;20;22] [26;47;10;42] [23;42;18;28] [21;20] [33;30;46] [15;34;17;23] [11;45;26;43] [14;25;17;10] [31;29] [18;38;39;6] [31;32] [40;43;12] [30;33;4] [49;8;24] [8;49] [17;2] [29;43;11] [8;39] [37;12;9;29] [41;12;20;3] [24;18] [21;39;10] [7;26] [19;36;23;5] [2;39;17] [35;19;20;22] [45;21;40] [37;12;46] [49;3;27] [48;22] [46;3;32] [19;20;22] [33;5;49] [3;44;35;17] [47;26;10;25] [19;26;15] [39;36;20;27] [4;17;45] [32;41;12;42] [23;37;36] [4;9;3] [33;12;30;32] [46;3;27;13] [9;4] [13;28;31;36] [46;34;49;35] [31;32;33;46] [6;39] [4;9;46;39] [20;43] [6;28] [33;24] [24;8;22;23] [48;12] [48;43;20;44] [46;45;19] [32;5] [39;16;5] [28;21;24;17] [25;45] [32;36;47;46] [41;7] [23;17;26] [16;15;4] [26;12;7] [49;14] [41;21;47] [27;12] [34;14;33] [27;9] [48;10;39] [18;3;40] [35;41] [38;48] [37;25;34;35] [30;43] [49;12] [41;28;3;32] [26;11] [14;47;18;45] [2;13;12] [14;23] [1;16;39] [27;42;3;1] [3;40] [21;12;7] [37;36] [3;20;40] [19;38] [5;18;31] [35;38;26;40] [14;35] [34;8;45] [44;28] [25;7;39;6] [22;27] [20;31;26;32] [38;24;48] [23;6;5;32] [21;49;43;18] [3;20] [11;46] [22;14;12] [12;23] [9;42;7] [37;31] [39;10] [12;36] [24;15;30;35] [13;40;14;25] [13;20;29] [6;25] [34;22] [31;46] [39;11;12;10] [42;11;45] [8;5;7] [26;24;48] [12;33;16] [39;8;27;4] [46;25] [36;8;27;25] [24;29;1;30]}';

% load transactions
%% Testbook testcase
% sup_min = 2;
% transactionCount = 4;
% itemCount = 5;
% transactions{1, 1} = [1;3;4];
% transactions{2, 1} = [2;3;5];
% transactions{3, 1} = [1;2;3;5];
% transactions{4, 1} = [2;5];
%%
transactionCount = size(transactions, 1);
%% Declare Candidate and List variables for any Itemset length
Candidate = {};
List = {};
RemovedItemset = {};
skip = false;
%%
for itemsetIndex = 1:3
    %% Declare each Candidate for itemsetIndex
    if itemsetIndex == 1
        Candidate{itemsetIndex, 1} = [1:itemCount]';
    else % List -> Candidate
        % Joining
        lastList = List{itemsetIndex-1, 1};
        newCandidate = [];
        for i = 1:size(lastList, 1)
            for j = 1:size(lastList, 1)
                newItemset = union(lastList(i, :), lastList(j, :));
                if length(newItemset) == itemsetIndex
                    newCandidate = [newCandidate; newItemset];
                    Candidate{itemsetIndex, 1} = unique(newCandidate, 'rows');
                end
            end
        end
        %         % Self joining
        %         [X,Y] = meshgrid(List{itemsetIndex-1, 1}, List{itemsetIndex-1, 1});
        %         Candidate{itemsetIndex, 1} = [X(:) Y(:)];
        %         % Except the same item join with itself
        %         clearedCandidate = (Candidate{itemsetIndex, 1}(:, 1) == Candidate{itemsetIndex, 1}(:, 2));
        %         Candidate{itemsetIndex, 1}(clearedCandidate, :) = [];
    end
    Candidate{itemsetIndex, 2} = zeros(size(Candidate{itemsetIndex, 1}, 1), 1);
    %% scan and count sup
    for c = 1:size(Candidate{itemsetIndex, 1}, 1)
        itemset = Candidate{itemsetIndex, 1}(c, :)';
        for t = 1:transactionCount
            transaction = transactions{t};
            test = ismember(itemset, transaction);
            if all(test)
                Candidate{itemsetIndex, 2}(c) = Candidate{itemsetIndex, 2}(c) + 1;
            end
        end
    end
    %% Test the candidate -> list
    List{itemsetIndex, 1} = Candidate{itemsetIndex, 1};
    List{itemsetIndex, 2} = Candidate{itemsetIndex, 2};
    candidateCondition = Candidate{itemsetIndex, 2} < sup_min;
    RemovedItemset{itemsetIndex, 1} = List{itemsetIndex, 1}(candidateCondition, :);
    List{itemsetIndex, 1}(candidateCondition, :) = [];
    List{itemsetIndex, 2}(candidateCondition, :) = [];
end

%% Association Rules
associationRules = {};
for k = 1:size(List{itemsetIndex, 1}, 1)
    itemset = List{itemsetIndex, 1}(k, :);
    sup = List{itemsetIndex, 2}(k);
    for it = 1:itemsetIndex
        % forward
        union{it} = itemset;
        tail{it, 1} = union{it};
        head{it, 1} = tail{it, 1}(it);
        tail{it, 1}(it) = [];
        head{it, 2} = tail{it, 1};
        tail{it, 2} = head{it, 1};
        unionIdx = find(ismember(List{length(union{it}), 1}, union{it}, 'rows') == 1);
        unionFreq = List{length(union{it}), 2}(unionIdx);
        for w = 1:2
            tailIdx = find(ismember(List{length(tail{it, w}), 1}, tail{it, w}, 'rows') == 1);
            tailFreq = List{length(tail{it, w}), 2}(tailIdx);
            support = unionFreq / transactionCount;
            confidence = support / tailFreq;
            disp([num2str(head{it, w}) ' -> ' num2str(tail{it, w}) ' (' num2str(support*100) '%, ' num2str(confidence*100) '%)']);
            associationRules{end+1, 1} = {head{it, w} tail{it, w} support confidence};
        end
    end    
end

toc;