function [hmm, bnet] = train_hmm(chromas, atslopes)
% function [hmm, bnet] = train_hmm(chromas, atslopes)
%
% Build and train a chromagram HMM with an observable 12 value gaussian
% node and a binary discrete hidden node.
%
% Parameters:
%     chromas       the chromagram sequence instances
%     atslopes      currently unused
%
% Output:
%     hmm           the trained HMM
%     bnet          the underlying network for the trained hmm
%
% License:
%     UCCS MIR Key Detection
%     Copyright (C) 2012  Devon Bryant
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU Affero General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU Affero General Public License for more details.
%
%     You should have received a copy of the GNU Affero General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

engine = smoother_engine(jtree_2TBN_inf_engine(bnet));

for i=1:length(chromas)
    for j=1:length(chromas{i})
        chrnorm = chromas{i}{j};
        chrmax = max(chrnorm);
        if chrmax > 0
            chrnorm = chrnorm / max(chrnorm);
            cases{i}{2,j} = chrnorm;
        else
            cases{i}{2,j} = ones(length(chrnorm),1);
        end
    end
end

[bnet, LLtrace, hmm] = learn_params_dbn_em(engine, cases, 'max_iter', 10);

end

