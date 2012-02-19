function bts = beattimes(data, sr)
% function bts = beattimes(data, sr)
%
% Calculate the beat times (in secs) for the waveform data and sample rate
% (sr).  The beat times are calculated using the LabROSA Music Beat
% Tracking algorithms. See http://labrosa.ee.columbia.edu/projects/coversongs/
% for more information.
%
% Parameters:
%     data      the audio waveform data
%     sr        the sampling rate
%
% Output:
%     bts       an array of beat times (in seconds)
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

bts = beat(data, sr, [240 1.5], [6 0.8], 0);

end

