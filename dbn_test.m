load 'beatsyncfeat_data.mat'

ss = 2;
intra = zeros(ss);
intra(1,2) = 1;
inter = zeros(2);
inter(1,1) = 1;
Q = 2; O = 12;
ns = [Q O];
dnodes = 1;
onodes = 2;
eclass1 = [1 2];
eclass2 = [3 2];
%bnet = mk_dbn(intra, inter, ns, 'discrete', dnodes, 'observed', onodes, 'eclass1', eclass1, 'eclass2', eclass2);
bnet = mk_dbn(intra, inter, ns, 'discrete', dnodes, 'observed', onodes);
bnet.CPD{1} = tabular_CPD(bnet,1);
bnet.CPD{2} = gaussian_CPD(bnet,2);
bnet.CPD{3} = tabular_CPD(bnet,3);
%engine = smoother_engine(hmm_2TBN_inf_engine(bnet));
engine = smoother_engine(jtree_2TBN_inf_engine(bnet));

% ss = 2;%slice size(ss)
% ncases = 10;%number of examples
% T=10;
% max_iter=2;%iterations for EM
% cases = cell(1, ncases);
% for i=1:ncases
%     ev = sample_dbn(bnet, T);
%     cases{i} = cell(ss,T);
%     cases{i}(onodes,:) = ev(onodes, :);
% end
% [bnet2, LLtrace] = learn_params_dbn_em(engine, cases, 'max_iter', 4);

for i=1:length(chromas)
%     if tonics{i} == 1
        for j=1:length(chromas{i})
%           cases{i}{1,j} = tonics{i};
            chrnorm = chromas{i}(:,j);
            chrmax = max(chrnorm);
            if chrmax > 0
                chrnorm = chrnorm / max(chrnorm);
                cases{i}{2,j} = chrnorm;
            end
        end
%     end
end

[bnet2, LLtrace, engine2] = learn_params_dbn_em(engine, cases, 'max_iter', 8);

cnum = 1;
for i=1:length(chromas{cnum})
    chrnorm = chromas{cnum}(:,i);
    chrmax = max(chrnorm);
    if chrmax > 0
        chrnorm = chrnorm / max(chrnorm);
        evidence{2,i} = chrnorm;
    else
        evidence{2,i} = ones(length(chrnorm),1);
    end
end
[engine3, ll] = enter_evidence(engine2,evidence);
marg = marginal_nodes(engine3, 3, length(chromas{cnum}));
