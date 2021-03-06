function [ I1, I2 ,nx1,ny1] = FastKSG( X, Y, k, varargin )
%KraskovMI computes the Kraskov estimator for the mutual information.
%   1. Input: X, Y
%             k: nearest neighbour
%             zeroFix (optional): fix the negative estimation to 0 (default
%                                 false);
%
%   univariate: X, Y (n x 1) vector
%   multivariate: X, Y (n x m) matrix (rows=observations,
%   columns=variables)
%
%   2. Output: I1, I2: the two estimator of MI, I(1), I(2) (see Ref.)
%
% Ref: Kraskov, Alexander, Harald Stgbauer, and Peter Grassberger.
%      "Estimating mutual information." Physical review E 69.6 (2004): 066138.
%
% Author: Paolo Inglese <paolo.ingls@gmail.com>
% Last revision: 17-05-2015

if nargin < 3 || nargin > 4
    error('Wrong input number.');
end
if nargin == 3
    zeroFix = false;
end
if nargin == 4
    if ~islogical(varargin{1})
        error('zeroFix must be true or false');
    else
        zeroFix = varargin{1};
    end
end
    

if size(X, 1) ~= size(Y, 1)
    error('X and Y must contain the same number of samples');
end

nObs = size(X, 1);

[IDX,D]=knnsearch([X Y],[X Y],'K',k+1,'Distance','chebychev');

Eps = D(:,end);
if size(X,2)==1
    nx1=binsearch(X,Eps);
else
    nx1=binsearch2d(X,Eps);
end
nx2=nx1;
if size(Y,2)==1
    ny1=binsearch(Y,Eps);
else
    ny1=binsearch2d(Y,Eps);
end
ny2=ny1;

% mutual information estimators
I1 = psi(k) - sum(psi(nx1 + 1) + psi(ny1 + 1)) / nObs + psi(nObs);
I2 = psi(k) - 1/k - sum(psi(nx2) + psi(ny2)) / nObs + psi(nObs);

if (zeroFix)
    if I1 < 0
        warning('First estimator is negative -> 0');
        I1 = 0;
    end
    if I2 < 0
        warning('Second estimator is negative -> 0');
        I2 = 0;
    end
end

end
