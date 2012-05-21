function [marginals, lls, engines, preds] = classify_chroma(instance, hmms)
% function [marginals, lls, engines, preds] = classify_chroma(instance, hmms)
%
% Classify a given chromagram sequence for a collection of trained HMMs.
% This assumes the HMM is a binary classifier.
%
% Parameters:
%     instance      the instance to classify (chromagram sequence cell array)
%     hmms          a cell array of trained HMMs to use
%
% Output:
%     marginals     the calculated marginals for each HMM
%     lls           the calculated log-likelihoods for each HMM
%     engines       the modified engines (incorporating the evidence)
%     preds         the predictions (marginal distribution values for the
%                   predicted class) for each HMM
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


for i=1:length(instance)
    chrnorm = instance(:,i);
    chrmax = max(chrnorm);
    if chrmax > 0
        chrnorm = chrnorm / max(chrnorm);
        evidence{2,i} = chrnorm;
    else
        evidence{2,i} = ones(length(chrnorm),1);
    end
end

marginals = cell(length(hmms), 1);
lls = cell(length(hmms), 1);
engines = cell(length(hmms), 1);
for i=1:length(hmms)
    [engines{i}, lls{i}] = enter_evidence(hmms{i}, evidence);
end

preds = cell(12,length(evidence));
for i=2:length(evidence)
    for j=1:length(engines)
        marg = marginal_nodes(engines{j}, 3, i);
        preds{j,i} = marg.T(2);
    end
end

preds(:,1) = preds(:,2);

end
