function scale_map = scale_classes_map(tonics, modes, idxs)
% function scale_map = scale_classes_map(tonics, modes, idxs)
%
% Build a map of scale names to index values
%
% Parameters:
%     tonics        the scale tonics (roots)
%     modes         the scale modes (key families)
%     idxs          the index values to map
%
% Output:
%     scale_map     a map of scale names to index values
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
if nargin < 3; idxs = 1:length(tonics); end

scale_map = containers.Map();
count = 1;
for i=1:length(idxs)
    idx = idxs(i);
    tonic_inst = tonics{idx};
    for j=1:length(tonic_inst)
        scale_name = [tonic_inst{j}, ' ', modes{idx}{j}];
        if ~isKey(scale_map, scale_name)
            scale_map(scale_name) = count;
%             fprintf('%s = %d\n', scale_name, count);
            count = count + 1;
        end
    end
end

end

