function beatsynccellcsvwrite(file, bts, celldata)
% function beatsynccellcsvwrite(file, bts, celldata)
%
% Write out the beat-synchronous cell data to a csv file.
%
% Parameters:
%     file          the csv file to write to
%     bts           the array of beat times (in seconds)
%     celldata      the cell data (lining up with the beat times)
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

fid = fopen(file, 'w');

for row=1:length(bts)
    fprintf(fid, '%f,', bts(row));
    fprintf(fid, '%s\n', celldata{row});
end

fclose(fid);

end

