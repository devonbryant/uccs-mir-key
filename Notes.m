classdef Notes
% A notes class that holds mappings between note names (A, A#, Bb, etc.)
% and their note numbers (1-12).
%
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
    
    properties (SetAccess = private, GetAccess = private)
        NoteNames
        AltNoteNames
    end
    
    methods
        function Nts = Notes(NoteNames, AltNoteNames)
            if nargin < 1
                Nts.NoteNames = {'A','A#','B','C','C#','D','D#','E','F','F#','G','G#'};
                Nts.AltNoteNames = {'A','Bb','B','C','Db','D','Eb','E','F','Gb','G','Ab'};
            elseif nargin < 2
                Nts.NoteNames = NoteNames;
                Nts.AltNoteNames = {'A','Bb','B','C','Db','D','Eb','E','F','Gb','G','Ab'};
            else
                Nts.NoteNames = NoteNames;
                Nts.AltNoteNames = AltNoteNames;
            end
        end
        
        function N = noteNum(Nts, noteName)
            N = 0;
            for i=1:length(Nts.NoteNames)
                if strcmpi(noteName, Nts.NoteNames{i})
                    N = i;
                end
            end
            if N == 0
                for i=1:length(Nts.AltNoteNames)
                    if strcmpi(noteName, Nts.AltNoteNames{i})
                        N = i;
                    end
                end
            end
        end
        
        function N = noteName(Nts, noteNum)
            N = Nts.NoteNames{noteNum};
        end
    end
    
end

