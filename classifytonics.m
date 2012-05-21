function [marginals, lls] = classifytonics(instance, hmms, normalize, jump)
% function [marginals, lls] = classifytonics(instance, hmms, normalize, jump)
%
% Classify just the tonic (root) for a given instance using the specified
% trained tonic HMMs.
%
% Parameters:
%     instance      the instance to classify (chromagram sequence cell array)
%     hmms          a cell array of trained HMMs to use
%     normalize     whether or not to normalize each instance chromagram
%                   from 0-1 (default true)
%     jump          optional jump offset to only do prediction at certain
%                   points in the instance instead of every frame. (default
%                   0 - classify every frame).
%
% Output:
%     marginals     the calculated marginals for each HMM
%     lls           the calculated log-likelihoods for each HMM
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
if nargin < 3; normalize=1; end
if nargin < 4; jump=0; end

if jump > 1
    k = 1;
    for i=(jump+1):jump:length(instance)
        for j=1:jump
            chrnorm = instance(:,i-jump+j-1);
            if normalize
                chrmax = max(chrnorm);
                if chrmax > 0
                    chrnorm = chrnorm / max(chrnorm);
                    evidence{k}{2,j} = chrnorm;
                else
                    evidence{k}{2,j} = ones(length(chrnorm),1);
                end
            else
                evidence{k}{2,j} = chrnorm;
            end
        end
        k = k+1;
    end
else
    for i=1:length(instance)
        chrnorm = instance(:,i);
        if normalize
            chrmax = max(chrnorm);
            if chrmax > 0
                chrnorm = chrnorm / max(chrnorm);
                evidence{1}{2,i} = chrnorm;
            else
                evidence{1}{2,i} = ones(length(chrnorm),1);
            end
        else
            evidence{1}{2,i} = chrnorm;
        end
    end
end

marginals = cell(length(hmms), 1);
lls = cell(length(hmms), 1);
for i=1:length(hmms)
    for j=1:length(evidence)
        [engine, ll] = enter_evidence(hmms{i},evidence{j});
        lls{i,j} = ll;
        marg = marginal_nodes(engine, 3, length(evidence{j}));
        marginals{i,j} = marg.T;
    end
end

end

