function hmm = traintonichmm(chromas, atslopes, normalize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3; normalize=1; end

ss = 2;
intra = zeros(ss);
intra(1,2) = 1;
inter = zeros(2);
inter(1,1) = 1;
Q = 12; O = 12;
ns = [Q O];
dnodes = 1;
onodes = 2;
bnet = mk_dbn(intra, inter, ns, 'discrete', dnodes, 'observed', onodes);
bnet.CPD{1} = tabular_CPD(bnet,1);
bnet.CPD{2} = gaussian_CPD(bnet,2);
bnet.CPD{3} = tabular_CPD(bnet,3);
engine = smoother_engine(jtree_2TBN_inf_engine(bnet));

for i=1:length(chromas)
    for j=1:length(chromas{i})
        chrnorm = chromas{i}(:,j);
        if normalize
            chrmax = max(chrnorm);
            if chrmax > 0
                chrnorm = chrnorm / max(chrnorm);
                cases{i}{2,j} = chrnorm;
            else
                cases{i}{2,j} = ones(length(chrnorm),1);
            end
        else
            cases{i}{2,j} = chrnorm;
        end
    end
end

[bnet2, LLtrace, hmm] = learn_params_dbn_em(engine, cases, 'max_iter', 8);