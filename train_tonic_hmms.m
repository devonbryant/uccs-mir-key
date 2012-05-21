function [hmms, bnets] = train_tonic_hmms(tonics, chromas)
% function [hmms, bnets] = train_tonic_hmms(tonics, chromas)
%
% Build and train a series of HMMs to predict/classify a songs tonic (root)
% note.
%
% Parameters:
%     tonics        the instance tonics
%     chromas       the instance extracted chromagrams
%
% Output:
%     hmms          the trained tonic HMMs
%     bnets         the underlying networks for the trained HMMs
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

chromas_by_tonic = cell(12,1);

% Divide all the cases by tonic
notes = Notes();
for ex_i = 1:length(tonics)
    last_t_num = notes.noteNum(tonics{ex_i}{1});
    chrm_ex = {};
    
    for sec_i = 1:length(tonics{ex_i})
        t_num = notes.noteNum(tonics{ex_i}{sec_i});
        if t_num ~= last_t_num
            chromas_by_tonic{last_t_num}{end+1} = chrm_ex;
            chrm_ex = {};
        end
        chrm_ex{end+1} = chromas{ex_i}(:,sec_i);
        last_t_num = t_num;
    end
    
    chromas_by_tonic{last_t_num}{end+1} = chrm_ex;
end

hmms = cell(12,1);
bnets = cell(12,1);

for i=1:length(chromas_by_tonic)
    [hmms{i} bnets{i}] = train_hmm(chromas_by_tonic{i});
end

end
