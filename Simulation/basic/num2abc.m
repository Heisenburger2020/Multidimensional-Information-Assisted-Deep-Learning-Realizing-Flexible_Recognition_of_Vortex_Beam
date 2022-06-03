function A = num2abc(N,LetterCase)
%% Function Description:
% This function returns the N-th english alphabet either in upper or lower
% case as specified by the user. N ranges from 1 to 26. 
%   N = 01 => A
%   N = 26 => Z
%
% AUTHOR: Sugato Ray | Created on: 04-MAR-2017 | ray.sugato[at]gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           PLEASE ACKNOWLEDGE THE AUTHOR IF YOU USE THIS CODE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT:
%   N = an integer from 1 to 26 
%   LetterCase = U or L
%       Othe alternative inputs for LetterCase are:
%                1.   upper/Upper/UPPER/U 
%                2.   lower/Lower/LOWER/L
%
% OUTPUT:
%   A = N-th english alphabet
%
% EXAMPLE:
%   A = num2abc(N,LetterCase);
%
%--------------------------------------------------------------------------

%% Code Section:

    if nargin<2 || isempty(LetterCase)
        LetterCase = 'U';
    elseif isnumeric(LetterCase)
        if (LetterCase==0)
            LetterCase = 'L';
        else
            LetterCase =  'U';
        end    
    elseif ischar(LetterCase)
        LetterCase = upper(LetterCase(1));
        if ~strcmp('L',LetterCase)
            LetterCase = 'U';
        end    
    end
            
    Alphabet = {'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'};
    A = Alphabet{1}(N);
    if strcmp('L',LetterCase)
        A = lower(A);
    end
end

