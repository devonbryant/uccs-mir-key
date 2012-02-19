function domnotes = beatsyncdomnotes(chroma)
% function chroma = beatsyncdomnotes(chroma)
%
% Calculate the beat-synchronous dominating notes from the beat-synch
% chromagram.  This assumes the chromagram is from [A,A#,...,G,G#]
%
% Parameters:
%     chroma    the beat-synchronous chromagram
%
% Output:
%     domnotes  an array of the most dominant note for each beat
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

notes = {'A','A#','B','C','C#','D','D#','E','F','F#','G','G#'};
domnotes = cell(1, length(chroma));

nidx = 1;
for c = chroma
    [mv, mi] = max(c);
    domnotes{nidx} = notes{mi};
    nidx = nidx+1;
end

end

