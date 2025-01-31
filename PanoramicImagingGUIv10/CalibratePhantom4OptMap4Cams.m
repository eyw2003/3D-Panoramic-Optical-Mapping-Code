function[TSquare, SSquare, RSquare, QSquare, k1, k2, k3, k4] = CalibratePhantom4OptMap4Cams(TwoA, TwoB, TwoC, TwoD, Dice3DCartA, Dice3DCartB, Dice3DCartC, Dice3DCartD) 

n = length(TwoA);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Generate T
A = zeros(2*n,11);
for i = 1:2*n
    if mod(i,2)==0   %%even rows
    A(i,1) = 0;
    A(i,2) = Dice3DCartA(i/2,1);
    A(i,3) = -1.*TwoA(i/2,2).*Dice3DCartA(i/2,1);
    A(i,4) = 0;
    A(i,5) = Dice3DCartA(i/2,2);
    A(i,6) = -1.*TwoA(i/2,2).*Dice3DCartA(i/2,2);
    A(i,7) = 0;
    A(i,8) = Dice3DCartA(i/2,3);
    A(i,9) = -1.*TwoA(i/2,2).*Dice3DCartA(i/2,3);
    A(i,10) = 0;
    A(i,11) = 1;  

    else             %%odd rows
    A(i,1) = Dice3DCartA(round(i/2),1);
    A(i,2) = 0;
    A(i,3) = -1.*TwoA(round(i/2),1).*Dice3DCartA(round(i/2),1);
    A(i,4) = Dice3DCartA(round(i/2),2);
    A(i,5) = 0;
    A(i,6) = -1.*TwoA(round(i/2),1).*Dice3DCartA(round(i/2),2);
    A(i,7) = Dice3DCartA(round(i/2),3);
    A(i,8) = 0;
    A(i,9) = -1.*TwoA(round(i/2),1).*Dice3DCartA(round(i/2),3);
    A(i,10) = 1;
    A(i,11) = 0;
    end
end

B = zeros(2*n,1);
for i = 1:2*n
    if mod(i,2)==0; %%even
        B(i,1) = TwoA(i/2,2);
    else           %%odd
        B(i,1) = TwoA(round(i/2),1);
    end
end

T = A\B;
k1 = T(3).*Dice3DCartA(1,1)+T(6).*Dice3DCartA(1,2)+T(9).*Dice3DCartA(1,3)+1;
TSquare = [T(1),T(2),T(3) ; T(4),T(5),T(6) ; T(7), T(8),T(9) ; T(10),T(11),1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Generate S

m = length(TwoB);
C = zeros(2*m,11);
for i = 1:2*m
    if mod(i,2)==0
    C(i,1) = 0;
    C(i,2) = Dice3DCartB(i/2,1);
    C(i,3) = -1.*TwoB(i/2,2).*Dice3DCartB(i/2,1);
    C(i,4) = 0;
    C(i,5) = Dice3DCartB(i/2,2);
    C(i,6) = -1.*TwoB(i/2,2).*Dice3DCartB(i/2,2);
    C(i,7) = 0;
    C(i,8) = Dice3DCartB(i/2,3);
    C(i,9) = -1.*TwoB(i/2,2).*Dice3DCartB(i/2,3);
    C(i,10) = 0;
    C(i,11) = 1;  

    else    
    C(i,1) = Dice3DCartB(round(i/2),1);
    C(i,2) = 0;
    C(i,3) = -1.*TwoB(round(i/2),1).*Dice3DCartB(round(i/2),1);
    C(i,4) = Dice3DCartB(round(i/2),2);
    C(i,5) = 0;
    C(i,6) = -1.*TwoB(round(i/2),1).*Dice3DCartB(round(i/2),2);
    C(i,7) = Dice3DCartB(round(i/2),3);
    C(i,8) = 0;
    C(i,9) = -1.*TwoB(round(i/2),1).*Dice3DCartB(round(i/2),3);
    C(i,10) = 1;
    C(i,11) = 0;
    end
end
D = zeros(2*m,1);
for i = 1:2*m
    if mod(i,2)==0
        D(i,1) = TwoB(i/2,2);
    else
        D(i,1) = TwoB(round(i/2),1);
    end
end

S = C\D;
k2 = S(3).*Dice3DCartB(1,1)+S(6).*Dice3DCartB(1,2)+S(9).*Dice3DCartB(1,3)+1;
SSquare = [S(1),S(2),S(3) ; S(4),S(5),S(6) ; S(7), S(8),S(9) ; S(10),S(11),1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Generate R

o = length(TwoC);
E = zeros(2*o,11);
for i = 1:2*o
    if mod(i,2)==0
    E(i,1) = 0;
    E(i,2) = Dice3DCartC(i/2,1);
    E(i,3) = -1.*TwoC(i/2,2).*Dice3DCartC(i/2,1);
    E(i,4) = 0;
    E(i,5) = Dice3DCartC(i/2,2);
    E(i,6) = -1.*TwoC(i/2,2).*Dice3DCartC(i/2,2);
    E(i,7) = 0;
    E(i,8) = Dice3DCartC(i/2,3);
    E(i,9) = -1.*TwoC(i/2,2).*Dice3DCartC(i/2,3);
    E(i,10) = 0;
    E(i,11) = 1;  

    else    
    E(i,1) = Dice3DCartC(round(i/2),1);
    E(i,2) = 0;
    E(i,3) = -1.*TwoC(round(i/2),1).*Dice3DCartC(round(i/2),1);
    E(i,4) = Dice3DCartC(round(i/2),2);
    E(i,5) = 0;
    E(i,6) = -1.*TwoC(round(i/2),1).*Dice3DCartC(round(i/2),2);
    E(i,7) = Dice3DCartC(round(i/2),3);
    E(i,8) = 0;
    E(i,9) = -1.*TwoC(round(i/2),1).*Dice3DCartC(round(i/2),3);
    E(i,10) = 1;
    E(i,11) = 0;
    end
end
F = zeros(2*o,1);
for i = 1:2*o
    if mod(i,2)==0
        F(i,1) = TwoC(i/2,2);
    else
        F(i,1) = TwoC(round(i/2),1);
    end
end

R = E\F;
k3 = R(3).*Dice3DCartC(1,1)+R(6).*Dice3DCartC(1,2)+R(9).*Dice3DCartC(1,3)+1;
RSquare = [R(1),R(2),R(3) ; R(4),R(5),R(6) ; R(7), R(8),R(9) ; R(10),R(11),1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Generate Q

p = length(TwoD);
K = zeros(2*p,11);
for i = 1:2*p
    if mod(i,2)==0
    K(i,1) = 0;
    K(i,2) = Dice3DCartD(i/2,1);
    K(i,3) = -1.*TwoD(i/2,2).*Dice3DCartD(i/2,1);
    K(i,4) = 0;
    K(i,5) = Dice3DCartD(i/2,2);
    K(i,6) = -1.*TwoD(i/2,2).*Dice3DCartD(i/2,2);
    K(i,7) = 0;
    K(i,8) = Dice3DCartD(i/2,3);
    K(i,9) = -1.*TwoD(i/2,2).*Dice3DCartD(i/2,3);
    K(i,10) = 0;
    K(i,11) = 1;  

    else    
    K(i,1) = Dice3DCartD(round(i/2),1);
    K(i,2) = 0;
    K(i,3) = -1.*TwoD(round(i/2),1).*Dice3DCartD(round(i/2),1);
    K(i,4) = Dice3DCartD(round(i/2),2);
    K(i,5) = 0;
    K(i,6) = -1.*TwoD(round(i/2),1).*Dice3DCartD(round(i/2),2);
    K(i,7) = Dice3DCartD(round(i/2),3);
    K(i,8) = 0;
    K(i,9) = -1.*TwoD(round(i/2),1).*Dice3DCartD(round(i/2),3);
    K(i,10) = 1;
    K(i,11) = 0;
    end
end
L = zeros(2*p,1);
for i = 1:2*p
    if mod(i,2)==0
        L(i,1) = TwoD(i/2,2);
    else
        L(i,1) = TwoD(round(i/2),1);
    end
end

Q = K\L;
k4 = Q(3).*Dice3DCartD(1,1)+Q(6).*Dice3DCartD(1,2)+Q(9).*Dice3DCartD(1,3)+1;
QSquare = [Q(1),Q(2),Q(3) ; Q(4),Q(5),Q(6) ; Q(7), Q(8),Q(9) ; Q(10),Q(11),1];

