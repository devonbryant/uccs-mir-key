function [tonics, modes, chromas, atslopes, domnotes] = batch_beatsyncfeats(indir, tonic_mode_regx, outdir)
% function [tonics, modes, chromas, atslopes, domnotes] = batch_beatsyncfeats(indir, tonic_mode_regx, outdir)
%
% Extract the beat-synchronous features from all audio files in a
% directory.
%
% Parameters:
%     indir             the directory to read the audio files from
%     tonic_mode_regx   a regular expression to split out the tonic and
%                       root from the file name.  e.g. '[a-g]{1}#?b?|(major|minor)'
%     outdir            directory where to write out the features to csv
%                       files.  (optional)
%
% Output:
%     tonics        the sequence of tonic (root) notes from the files
%     modes         the sequence of modes (key families) from the files
%     chromas       the extracted beat-synchronous chromagrams
%     atslopes      the extracted beat-synchronous attack slopes
%     domnotes      the extracted beat-synchronous dominant notes
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

tonics = {};
modes = {};
chromas = {};
atslopes = {};

files = dir(indir);
notes = Notes();
for i=1:length(files)
    if ~files(i).isdir
        if nargin > 1
            % Attempt to split out the tonic (root) and mode (key family)
            % from the file name
            % e.g. '[a-g]{1}#?b?|(major|minor)'
            tonic_mode = regexpi(files(i).name, tonic_mode_regx, 'match');
            if (length(tonic_mode) > 1)
                tonics{end+1} = notes.noteNum(tonic_mode{1});
                modes{end+1} = tonic_mode{2};
            end
        end
        
        file = strcat(indir, '/', files(i).name);
        
        % Extract the various beat-sync features from the file
        [data,sr,bts,chroma,domnotes,bsas] = beatsyncfeat(file, 11025);
        
        chromas{end+1} = chroma;
        atslopes{end+1} = bsas;
        
        if nargin > 2
            % Write out the features to file
            beatsyncfeatcsvwrite(strcat(outdir, '/', files(i).name, '.chroma.csv'), bts, chroma, 1, 44100, 1024);
            beatsyncfeatcsvwrite(strcat(outdir, '/', files(i).name, '.atslope.csv'), bts, bsas);
            beatsynccellcsvwrite(strcat(outdir, '/', files(i).name, '.domnotes.csv'), bts, domnotes);
        end
    end
end

end

