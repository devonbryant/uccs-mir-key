function [tonics, modes, beatnums, chromas, atslopes, domnotes] = lab_beatsyncfeat_ext(indir, outdir)
% function [tonics, modes, beatnums, chromas, atslopes, domnotes] = lab_beatsyncfeat_ext(indir, outdir)
%
% Extract the beat-synchronous features for all audio files in a given
% directory.  Additionally, parse the annotated tonics, modes, and beats
% according to the formats specified by the Queen Mary University
% Annotations (http://isophonics.net/datasets).  Note: this function
% assumes the audio files and the annotation files are named the same.
%
% Parameters:
%     indir         the directory containing the audio (mp3/wav/au/aiff)
%                   and annotation (.lab & .bts) files.
%     outdir        optional output directory of where to write the
%                   extracted features as .csv files.
%
% Output:
%     tonics        the sequence of tonic (root) notes from the .lab files
%     modes         the sequence of modes (key families) from the .lab files
%     beatnums      the beat numbers from the .bts files
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

files = dir(indir);
notes = Notes();
filesMap = containers.Map();
for i=1:length(files)
    if ~files(i).isdir
        fname = files(i).name;
        
        % Test Audio File
        splitname = regexpi(fname, '\.(mp3|wav|au|aiff?)', 'split');
        fidx = 0;
        if length(splitname) > 1
            fidx = 1;
        else
            % Test Key File
            splitname = regexpi(fname, '\.lab', 'split');
            if length(splitname) > 1
                fidx = 2;
            else
                % Test Beats File
                splitname = regexpi(fname, '\.bts', 'split');
                if length(splitname) > 1
                    fidx = 3;
                end
            end
        end
        
        if fidx > 0
            sname = splitname{1};
            if ~isKey(filesMap, sname)
                filesMap(sname) = cell(1,3);
            end
            
            fileEntry = filesMap(sname);
            
            fileEntry{fidx} = strcat(indir, '/', fname);
            
            filesMap(sname) = fileEntry;
        end
    end
end

tonics = cell(1,filesMap.length);
modes = cell(1,filesMap.length);
beatnums = cell(1,filesMap.length);
chromas = cell(1,filesMap.length);
atslopes = cell(1,filesMap.length);
domnotes = cell(1,filesMap.length);

file_keys = keys(filesMap);
sr = 11025;
for i=1:length(file_keys)
    fileEntry = filesMap(file_keys{i});
    audiofname = fileEntry{1};
    keysfname = fileEntry{2};
    btsfname = fileEntry{3};
    
    % Extract the various beat-sync features from the audio file
    [data,sr,bts,chromas{i},domnotes{i},atslopes{i}] = beatsyncfeat(audiofname, sr);
    
    % Get the lab keys data (start time and key)
    [tonics{i} modes{i}] = labfeats(keysfname, bts);
    
    if btsfname
        % Get the beat numbers data (1,2,3,4,1,2,3,4...)
        beatnums{i} = btfeats(btsfname, bts);
    end
    
    if nargin > 1
        % Write out the features to file
        beatsyncfeatcsvwrite(strcat(outdir, '/', file_keys{i}, '.chroma.csv'), bts, chromas{i}, 1, 44100, 1024);
        beatsyncfeatcsvwrite(strcat(outdir, '/', file_keys{i}, '.atslope.csv'), bts, atslopes{i});
        beatsynccellcsvwrite(strcat(outdir, '/', file_keys{i}, '.domnotes.csv'), bts, domnotes{i});
        beatsynccellcsvwrite(strcat(outdir, '/', file_keys{i}, '.tonics.csv'), bts, tonics{i});
        beatsynccellcsvwrite(strcat(outdir, '/', file_keys{i}, '.modes.csv'), bts, modes{i});
        if btsfname
            beatsynccellcsvwrite(strcat(outdir, '/', file_keys{i}, '.btnums.csv'), bts, beatnums{i});
        end
    end
end

end

function [tonics families] = labfeats(labfile, bts)
    keysfid = fopen(labfile);
    keysdata = textscan(keysfid, '%f %*f %*s %s');
    fclose(keysfid);

    keytimes = {};
    keytonics = {};
    keyfamilies = {};
    for k=1:length(keysdata{1})
        if ~isempty(keysdata{2}{k})
            keytimes{end+1} = keysdata{1}(k);
            % Split the key (e.g. 'C#:minor' or 'F') into root/family
            keyval = regexpi(keysdata{2}{k}, '\w*#?\w*', 'match');
            keytonics{end+1} = keyval{1};
            if length(keyval) > 1
                keyfamilies{end+1} = keyval{2};
            else
                keyfamilies{end+1} = 'major';
            end
        end
    end
    
    tonics = bts_align(bts,keytimes,keytonics);
    families = bts_align(bts,keytimes,keyfamilies);
    
    % Fill in any missing values
%     tonics = fillvals(tonics);
%     families = fillvals(families);
end

function [beatnums] = btfeats(btfile, bts)
    btsfid = fopen(btfile);
    btsdata = textscan(btsfid, '%f %d');
    fclose(btsfid);

    bttimes = num2cell(btsdata{1}');
    btnums = num2cell(btsdata{2}');
    
    beatnums = bts_align(bts,bttimes,btnums);
    
    % Fill in any missing values
%     beatnums = fillvals(beatnums);
end

function B = fillvals(B)
    i = 1;
    while isempty(B{i}); i = i+1; end
    
    % Initial value
    lastval = B{i};
    for i=1:length(B)
        if isempty(B{i})
            B{i} = lastval;
        else
            lastval = B{i};
        end
    end
end

