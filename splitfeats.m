function [tr_atslopes,tst_atslopes,tr_chromas,tst_chromas,tr_modes,tst_modes,tr_tonics,tst_tonics] = splitfeats(atslopes,chromas,modes,tonics,tr_pct)
% function scale_map = scale_classes_map(tonics, modes, idxs)
%
% Split sequences of features (attack slope, chromagrams, modes, tonics)
% into training and test sets using a specified split (default 0.6)
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

if nargin < 5; tr_pct = 0.6;

tn_idx = 1;
md_idx = 2;
chr_idx = 3;
as_idx = 4;

% Build up a map with the key 'tonic mode' and the sets of corresponding
% chromas/atslopes/tonics/modes
key_chrom_as_map = containers.Map();
count_map = containers.Map();
notes = Notes();
for i=1:length(chromas)
    key = [notes.noteName(tonics{i}) ' ' modes{i}];
    if ~isKey(key_chrom_as_map, key)
        key_chrom_as_map(key) = cell(1,4);
        count_map(key) = 0;
    end
    
    tmp_val = key_chrom_as_map(key);
    
    tmp_val{tn_idx}{end+1} = tonics{i};
    tmp_val{md_idx}{end+1} = modes{i};
    tmp_val{chr_idx}{end+1} = chromas{i};
    tmp_val{as_idx}{end+1} = atslopes{i};
    
    key_chrom_as_map(key) = tmp_val;
end

tr_count = round(length(chromas) * tr_pct);

tr_atslopes = {}; tr_chromas = {}; tr_modes = {}; tr_tonics = {};
tst_atslopes = {}; tst_chromas = {}; tst_modes = {}; tst_tonics = {};

added = 0;
key_names = keys(key_chrom_as_map);
while added < length(chromas)
    for i=1:length(key_names)
        kn = key_names{i};
        kv = key_chrom_as_map(kn);
        count = count_map(kn);
        if count < length(kv{1})
            if added < tr_count
                tr_tonics{end+1} = kv{tn_idx}{count + 1};
                tr_modes{end+1} = kv{md_idx}{count + 1};
                tr_chromas{end+1} = kv{chr_idx}{count + 1};
                tr_atslopes{end+1} = kv{as_idx}{count + 1};
            else
                tst_tonics{end+1} = kv{tn_idx}{count + 1};
                tst_modes{end+1} = kv{md_idx}{count + 1};
                tst_chromas{end+1} = kv{chr_idx}{count + 1};
                tst_atslopes{end+1} = kv{as_idx}{count + 1};
            end
            added = added + 1;
            count_map(kn) = count + 1;
        end
    end
end

end

