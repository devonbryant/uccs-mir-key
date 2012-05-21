function [tr_idxs, tst_idxs] = rand_split_idxs(num_samples, split_pct)
% function [tr_idxs, tst_idxs] = rand_split_idxs(num_samples, split_pct)
%
% Get a random split of training/test indexes
%
% Parameters:
%     num_samples   the number of samples to split
%     split_pct     the split percentage (% training - default 0.6)
%
% Output:
%     tr_idxs       the training indexes
%     tst_idxs      the test indexes
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
if nargin < 2; split_pct = 0.6; end

tr_size = floor(num_samples * split_pct);

tr_idxs = zeros(1,tr_size);
tst_idxs = zeros(1,(num_samples-tr_size));

rnums = randperm(num_samples);
for i=1:tr_size
    tr_idxs(i) = rnums(i);
end

for i=(tr_size+1):num_samples
    tst_idxs(i-tr_size) = rnums(i);
end

end

