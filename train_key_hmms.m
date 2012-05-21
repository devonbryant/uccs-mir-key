function [hmms, bnets, key_names] = train_key_hmms(tonics, modes, chromas, atslopes)
% function [hmms, bnets, key_names] = train_key_hmms(tonics, modes, chromas, atslopes)
%
% Build and train a key a series of HMMs for each song key.
%
% Parameters:
%     tonics        the instance tonics
%     modes         the instance modes
%     chromas       the instance extracted chromagrams
%     atslopes      the instance extracted attack slopes (currently unused)
%
% Output:
%     hmms          the trained key HMMs
%     bnets         the underlying networks for the trained HMMs
%     key_names     the key names corresponding to the HMM classifiers
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

chr_idx = 1;
as_idx = 2;

% Build up a map with the key 'tonic mode' and the sets of corresponding chromas/atslopes
key_chrom_as_map = containers.Map();
for i=1:length(chromas)
    last_key = [tonics{i}{1} ' ' modes{i}{1}];
    if ~isKey(key_chrom_as_map, last_key)
        key_chrom_as_map(last_key) = cell(1,2);
    end
    
    chrm_ex = {}; atsl_ex = {};
    tmp_val = key_chrom_as_map(last_key);
    for j=1:length(chromas{i})
        key = [tonics{i}{j} ' ' modes{i}{j}];
        
        if ~strcmp(last_key, key)
            tmp_val{chr_idx}{end+1} = chrm_ex;
            tmp_val{as_idx}{end+1} = atsl_ex;
            
            key_chrom_as_map(last_key) = tmp_val;
            
            chrm_ex = {}; atsl_ex = {};
            tmp_val = key_chrom_as_map(key);
            
            fprintf('Switched from ''%s'' to ''%s''', last_key, key);
        end
        
        chrm_ex{end+1} = chromas{i}(:,j);
        atsl_ex{end+1} = atslopes{i}(j);
        
        last_key = key;
    end
    
    tmp_val{chr_idx}{end+1} = chrm_ex;
    tmp_val{as_idx}{end+1} = atsl_ex;
        
    key_chrom_as_map(last_key) = tmp_val;
end

% circshift(c, [2, 0]) // Circular permutation of chromagram

% Train a different HMM for each key
hmms = cell(key_chrom_as_map.Count,1);
bnets = cell(key_chrom_as_map.Count,1);
key_names = keys(key_chrom_as_map);
for i=1:length(key_names)
    chr_as = key_chrom_as_map(key_names{i});
    [hmms{i} bnets{i}] = train_hmm(chr_as{chr_idx}, chr_as{as_idx});
end

end

