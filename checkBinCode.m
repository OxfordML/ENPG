% Checks binary-coded elements against a test number
% Inputs are a vector d, and the test number 'a' to test against
% Output is a list of indices u for the elements that pass the test
% Mark Ebden, October 2014

function u = checkBinCode (d, a)

N = 15; % how many bits contained in each element
x = de2bi(d,N);
if a > 0,
  u = find(x(:,log2(a)+1)==1);
else
  u = [];
end
