function [algnvalues] = bts_align(bts, atimes, avals)
% function [algnvalues] = bts_align(bts, atimes, avals)
%
% Align a sequence of attack values with the specified beat times
%
% Parameters:
%     bts           the beat times (in seconds) to align with
%     atimes        the attack times (in seconds)
%     avals         the attack values to align
%
% Output:
%     algnvalues    the attack values aligned with the given beat times
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

algnvalues = cell(1, length(bts));
aidx = 1;
bidx = 1;

if length(atimes) > length(bts)
    while atimes{1} > bts(bidx + 1)
        bidx = bidx+1;
    end
    while bidx <= length(bts)
        while aidx < length(atimes) && atimes{aidx} <= bts(bidx)
            aidx = aidx + 1;
        end
        bt = bts(bidx);
        if atimes{aidx} >= bt
            pidx = aidx-1;
            if (pidx < 1); pidx = 1; end
            idxs = [pidx, aidx];
            [mv,mi] = min([abs(atimes{pidx}-bt),abs(atimes{aidx}-bt)]);
            algnvalues{bidx} = avals{idxs(mi)};
        end

        bidx = bidx+1;
    end
else
    if length(atimes) == 1
        for i=1:length(bts)
            algnvalues{i} = avals{1};
        end
    else
        aidx = 2;
        while aidx <= length(atimes)
            nextat = atimes{aidx};
            while bidx < length(bts) && bts(bidx) < nextat
                algnvalues{bidx} = avals{aidx-1};
                bidx = bidx + 1;
            end
            
            pidx = bidx - 1;
            if (pidx < 1); pidx = 1; end
            idxs = [pidx, bidx];
            [mv,mi] = min([abs(bts(pidx)-nextat),abs(bts(bidx)-nextat)]);
            algnvalues{idxs(mi)} = avals{aidx};
            
            aidx = aidx + 1;
        end
        
        for i=bidx:length(bts)
            algnvalues{i} = avals{end};
        end
        
    end
end
    
end

