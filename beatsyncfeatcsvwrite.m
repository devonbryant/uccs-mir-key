function beatsyncfeatcsvwrite(file, bts, data, linearspace, sr, windowlen)
% function beatsyncfeatcsvwrite(file, bts, data, linearspace, sr, windowlen)
%
% Write out the beat-synchronous data to a csv file.
%
% Parameters:
%     file          the csv file to write to
%     bts           the array of beat times (in seconds)
%     data          the data (lining up with the beat times)
%     linearspace	whether or not to linearly space the windows (i.e.
%                   fill in the 'in-between' frames)
%     sr            the target sampling rate
%     windowlen     the window length (frame length) used to calculate the
%                   features
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

if nargin < 4; linearspace = 0; end
if nargin < 5; sr = 22050; end
if nargin < 6; windowlen = 1024; end

if linearspace
    % Find the last time (in seconds) in the beat-synch data matrix
    lasttime = bts(end);
    
    % Create equally spaced frame times based on the step size and sr
    numframes = ceil(lasttime / (windowlen / sr));
    incr = windowlen/sr;
    frametimes = 0:incr:(numframes * incr);
    
    % Create a new matrix to hold all the data frames
    [d_rows, d_cols] = size(data);
    m = zeros(numframes + 1, d_rows);
    
    midx = 1;
    c = zeros(d_rows,1);
    for i = 1:length(bts) + 1
        if i > 1
            c = data(:,i-1);
        end
        
        if i <= length(bts)
            bt = bts(i);
        end
        
        while bt > frametimes(midx)
           m(midx,:) = c;
           midx = midx + 1;
        end
    end
    
    m = [transpose(frametimes) m];
else
    m = [transpose(bts) transpose(data)];
end

% Write out the CSV file
csvwrite(file,m);

end

