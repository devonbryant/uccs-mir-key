function chroma = beatsyncchroma(bts, data, sr)
% function chroma = beatsyncchroma(bts, data, sr)
%
% Calculate the beat-synchronous chroma profile of the waveform data using
% the given beat times (bts) in seconds and the sampling rate (sr).  The
% chroma features are calculated using the LabROSA Chroma Feature Analysis
% and Synthesis algorithms.  See 
% http://www.ee.columbia.edu/~dpwe/resources/matlab/chroma-ansyn/ for more
% information.
%
% Parameters:
%     bts       the beat times (in seconds)
%     data      the audio waveform data
%     sr        the sampling rate
%
% Output:
%     chroma	the averaged chromagrams (lining up with the beat times)
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

f_ctr = 1000;
f_sd = 1;
fftlen = 2 ^ (round(log(sr*(2048/22050))/log(2)));
nbin = 12;

Y = chromagram_IF(data, sr, fftlen, nbin, f_ctr, f_sd);
  
ffthop = fftlen/4;
sgsrate = sr/ffthop;

chroma = beatavg(Y, bts*sgsrate);

end

