% clc
clear all
close all

A = 1;
B = 2;
C = 3;
M = 4; 
M1 = 5;
L = struct ('x', {}, 'y', {});

L(M).x  = 0;
L(M).y  = 0;

r = zeros(1,3);
theta = zeros(1,3);
  
T = 100;
s = [1, 3/4, 1/2];
S = s*T;

ERR = zeros(3, 181); 
mean_ERR = zeros(3, 181);
THETA = zeros(1, 181);

% A: red, B: blue, C: green
tic;
K = 10e6;
k = 1;
while (k <= K)

    L(A).x = 2*T*(rand(1,1)-.5);
    L(B).x = 2*T*(rand(1,1)-.5);
    L(C).x = 2*T*(rand(1,1)-.5);
    L(A).y = 2*T*(rand(1,1)-.5);
    L(B).y = 2*T*(rand(1,1)-.5);
    L(C).y = 2*T*(rand(1,1)-.5);    
    
    P = [L(A).x, L(A).y, 0];
    Q = [L(B).x, L(B).y, 0];
    R = [L(C).x, L(C).y, 0];
    theta(1) = atan2(norm(cross(P,Q)),dot(P,Q))*180/pi;
    theta(2) = atan2(norm(cross(Q,R)),dot(Q,R))*180/pi;
    theta(3) = atan2(norm(cross(R,P)),dot(R,P))*180/pi;    
    theta = sort(theta);
    theta = theta(2:3);
    index = round(mean(theta))+1;
    if(THETA(index) >= K/175)
        continue;
    end
    THETA(index) = THETA(index) + 1;
    
    r(A) = ((L(M).x - L(A).x)^2 + (L(M).y - L(A).y)^2) ^.5;
    r(B) = ((L(M).x - L(B).x)^2 + (L(M).y - L(B).y)^2) ^.5;
    r(C) = ((L(M).x - L(C).x)^2 + (L(M).y - L(C).y)^2) ^.5;
    
    for l = 1:3
        L(M1) = tri_loc(L(A:C), r+S(l), 0);
        err = ((L(M1).x)^2 + (L(M1).y)^2) ^.5;
        ERR(l, index) = ERR(l, index) + err;
    end
    
    if (~mod(k,100))
        clc
        t = toc;
        p = k/K;
        fprintf(1,'Progress: %3.1f%% Time Elapsed : %.0fs Time Remaining : %.0fs End Time : %.0fs', p*100, t, t/p-t, t/p);
    end
    
    k = k + 1;
end

for l = 1:3
    mean_ERR(l, :) = ERR(l, :)./THETA/T/2;
end

figure(3)
plot(THETA)

save mean_ERR mean_ERR