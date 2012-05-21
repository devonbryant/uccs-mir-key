function [hmms, bnets] = traintonichmms(tonics, chromas, atslopes, normalize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4; normalize=1; end

hmms = cell(12,1);
for i=1:12
    hmms{i} = smoother_engine(jtree_2TBN_inf_engine(get_dbn()));
end

cases = cell(1,12);
for i=1:length(chromas)
    tonic = tonics{i};
    k = length(cases{tonic}) + 1;
    for j=1:length(chromas{i})
        chrnorm = chromas{i}(:,j);
        if normalize
            chrmax = max(chrnorm);
            if chrmax > 0
                chrnorm = chrnorm / max(chrnorm);
                cases{tonic}{k}{2,j} = chrnorm;
            else
                cases{tonic}{k}{2,j} = ones(length(chrnorm),1);
            end
        else
            cases{tonic}{k}{2,j} = chrnorm;
        end
    end
%     fprintf('Cases{%d}{%d}{2,1-%d}\n',tonic,k,length(chromas{i}));
end

for i=1:length(cases)
% for i=1:4
    [bnets{i}, LL, hmms{i}] = learn_params_dbn_em(hmms{i}, cases{i}, 'max_iter', 10);
end

% cnum = 1;
% hmmnum = 1;
% for i=1:length(chromas{cnum})
%     chrnorm = chromas{cnum}(:,i);
%     chrmax = max(chrnorm);
%     if chrmax > 0
%         chrnorm = chrnorm / max(chrnorm);
%         evidence{2,i} = chrnorm;
%     else
%         evidence{2,i} = ones(length(chrnorm),1);
%     end
% end
% [engine3, ll] = enter_evidence(hmms{hmmnum},evidence);
% marg = marginal_nodes(engine3, 3, length(chromas{cnum}));
% marg.T

end

function bnet = get_dbn()
    ss = 2;
    intra = zeros(ss);
    intra(1,2) = 1;
    inter = zeros(2);
    inter(1,1) = 1;
    Q = 2; O = 12;
    ns = [Q O];
    dnodes = 1;
    onodes = 2;
    bnet = mk_dbn(intra, inter, ns, 'discrete', dnodes, 'observed', onodes);
    bnet.CPD{1} = tabular_CPD(bnet,1);
    bnet.CPD{2} = gaussian_CPD(bnet,2);
    bnet.CPD{3} = tabular_CPD(bnet,3);
end
