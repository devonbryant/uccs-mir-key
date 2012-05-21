function [hmms, bnets, fam_names] = train_key_family_hmms(tonics, modes, chromas, atslopes)
% function [hmms, bnets, fam_names] = train_key_family_hmms(tonics, modes, chromas, atslopes)
%
% Build and train a key family HMM with an observable 12 value gaussian
% node and a binary discrete hidden node for the key family.  The family
% model is trained by running circular permutations on the chromagram
% instances so that the instances are independent of the tonic.
%
% Parameters:
%     tonics        the instance tonics
%     modes         the instance modes
%     chromas       the instance extracted chromagrams
%     atslopes      the instance extracted attack slopes (currently unused)
%
% Output:
%     hmms          the trained key family (mode) HMMs
%     bnets         the underlying networks for the trained HMMs
%     fam_names     the key family names corresponding to the HMM
%                   classifiers
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

% Build up a map with the key 'mode' and the sets of corresponding chromas/atslopes
notes = Notes();
fam_chrom_as_map = containers.Map();
for i=1:length(chromas)
    last_fam = modes{i}{1};
    if ~isKey(fam_chrom_as_map, last_fam)
        fam_chrom_as_map(last_fam) = cell(1,2);
    end
    
    chrm_ex = {}; atsl_ex = {};
    tmp_val = fam_chrom_as_map(last_fam);
    for j=1:length(chromas{i})
        fam = modes{i}{j};
        tonic = notes.noteNum(tonics{i}{1});
        
        if ~strcmp(last_fam, fam)
            tmp_val{chr_idx}{end+1} = chrm_ex;
            tmp_val{as_idx}{end+1} = atsl_ex;
            
            fam_chrom_as_map(last_fam) = tmp_val;
            
            chrm_ex = {}; atsl_ex = {};
            tmp_val = fam_chrom_as_map(fam);
        end
        
        % Run a circular permutation on the chromagram using the tonic
        chr_shift = circshift(chromas{i}(:,j), [1-tonic, 0]);
        
        chrm_ex{end+1} = chr_shift;
        atsl_ex{end+1} = atslopes{i}(j);
        
        last_fam = fam;
    end
    
    tmp_val{chr_idx}{end+1} = chrm_ex;
    tmp_val{as_idx}{end+1} = atsl_ex;
        
    fam_chrom_as_map(last_fam) = tmp_val;
end

% Train a different HMM for each family
hmms = cell(fam_chrom_as_map.Count,1);
bnets = cell(fam_chrom_as_map.Count,1);
fam_names = keys(fam_chrom_as_map);
for i=1:length(fam_names)
    chr_as = fam_chrom_as_map(fam_names{i});
    [hmms{i} bnets{i}] = train_hmm(chr_as{chr_idx}, chr_as{as_idx});
end

end