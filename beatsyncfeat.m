function [data,sr,bts,chroma,domnotes,bsas] = beatsyncfeat(file, sr, normalize)
% function [data,sr,bts,chroma,domnotes] = beatsyncfeat(file, sr, normalize)
%
% Calculate the beat-synchronous features for a given audio file.
%
% Parameters:
%     file      the audio file to use
%     sr        the target sampling rate (22050 if not specified)
%     normalize whether or not to normalize the results (default true)
%
% Output:
%     data      the audio waveform data
%     sr        the sampling rate
%     bts       an array of beat times (in seconds)
%     chroma	the averaged chromagrams (lining up with the beat times)
%     domnotes  an array of the most dominant note for each beat
%     bsas      the beat-synchronous attack slope
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

if nargin < 2; sr = 22050; end
if nargin < 3; normalize = 1; end

% Read in the audio data and calculate the beat times
[data,sr] = audioread(file,sr,1);
bts = beattimes(data, sr);

% Extract the various features using the beat times to synchronize
chroma = beatsyncchroma(bts, data, sr);
domnotes = beatsyncdomnotes(chroma);
[at,as,bsas] = beatsyncattackslope(data, sr, bts);

if normalize
   chroma = normV(chroma);
   bsas = normV(bsas);
end

end

function I = normV(A)
    I = A - min(A(:));
    I = I / max(I(:));
end
