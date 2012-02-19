function [at,as,bsas] = beatsyncattackslope(data, sr, bts)
% function [at,as,bsas] = beatsyncattackslope(data, sr, bts)
%
% Calculate the beat-synchronous attack-slope of the waveform data using
% the beat times (bts) in seconds and the sampling rate (sr).  The
% attack slope features are calculated using the MIRtoolbox
% 'mirattackslope' algorithms.  See 
% http://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/mirtoolbox/mirtoolbox
% for more information.
%
% Parameters:
%     data      the audio waveform data
%     sr        the sampling rate
%     bts       the beat times (in seconds)
%
% Output:
%     at	    the attack times
%     as        the attack slope values
%     bsas      the beat-synchronous attack slope values (the attack
%               slopes closest to the beat times)
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

a = miraudio(data,sr);
miras = mirattackslope(a);

as = mirgetdata(miras);
at_cell = get(miras, 'FramePos');
at = mean(at_cell{1}{1});

bsas = zeros(size(bts));
bidx = 1;
asidx = 1;
while at(1) > bts(bidx + 1)
    bidx = bidx+1;
end
while bidx <= length(bts)
    while asidx < length(at) && at(asidx) <= bts(bidx)
        asidx = asidx + 1;
    end
    bt = bts(bidx);
    if at(asidx) >= bt
        pidx = asidx-1;
        if (pidx < 1); pidx = 1; end
        idxs = [pidx, asidx];
        [mv,mi] = min([abs(at(pidx)-bt),abs(at(asidx)-bt)]);
        bsas(bidx) = as(idxs(mi));
    end
    
    bidx = bidx+1;
end

end

