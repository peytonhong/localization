function P = get_SV_position(fxL, fxR)
% stereo vision�� �� ��� ���� ���� ��ġ(fxL, fxR)�κ��� ������ ��ġ�� ����ϴ� �Լ�

Origin = [400; -1000; 0];   % stereo vision�� ��ġ�� ������ global ��ǥ
width = 0.07;   % stereo vision ���� ���� (����� �� ���ݰ� �����ϰ� ����)
% stereo vision���� �� camera�� ���� ��ġ (��, ��)
OxL = [Origin(1)-width; Origin(2); Origin(3)];  % ���� ī�޶� ����
OxR = [Origin(1)+width; Origin(2); Origin(3)];  % ���� ī�޶� ����

% Newton-Raphson method
X = [10; 1];    % X=[t;s]; initial value
X_prev = X;

J = [(fxL(1)-OxL(1)), -(fxR(1)-OxR(1));
    (fxL(2)-OxL(2)), -(fxR(2)-OxR(2));
    (fxL(3)-OxL(3)), -(fxR(3)-OxR(3))];

f = [X(1)*(fxL(1)-OxL(1))-X(2)*((fxR(1)-OxR(1)))+OxL(1)-OxR(1);
    X(1)*(fxL(2)-OxL(2))-X(2)*((fxR(2)-OxR(2)))+OxL(2)-OxR(2);
    X(1)*(fxL(3)-OxL(3))-X(2)*((fxR(3)-OxR(3)))+OxL(3)-OxR(3);];

X = X - pinv(J)*f;

iter = 0;

while norm(X - X_prev) > 10^-5    
    X_prev = X;
    
    J = [(fxL(1)-OxL(1)), -(fxR(1)-OxR(1));
        (fxL(2)-OxL(2)), -(fxR(2)-OxR(2));
        (fxL(3)-OxL(3)), -(fxR(3)-OxR(3))];
    
    f = [X(1)*(fxL(1)-OxL(1))-X(2)*((fxR(1)-OxR(1)))+OxL(1)-OxR(1);
        X(1)*(fxL(2)-OxL(2))-X(2)*((fxR(2)-OxR(2)))+OxL(2)-OxR(2);
        X(1)*(fxL(3)-OxL(3))-X(2)*((fxR(3)-OxR(3)))+OxL(3)-OxR(3);];
    
    X = X - pinv(J)*f;
    
    iter = iter + 1;
    
    if iter > 1000
        break
    end
    
%     fprintf('iter=%d, X=%.3f, Y=%.3f, Z=%.3f\n',iter, X(1), X(2), X(3));
end

u1 = [(fxL(1)-OxL(1)); (fxL(2)-OxL(2)); (fxL(3)-OxL(3))];
u2 = [(fxR(1)-OxR(1)); (fxR(2)-OxR(2)); (fxR(3)-OxR(3))];

P1 = [OxL(1) + X(1)*u1(1); OxL(2) + X(1)*u1(2); OxL(3) + X(1)*u1(3)];
P2 = [OxR(1) + X(2)*u2(1); OxR(2) + X(2)*u2(2); OxR(3) + X(2)*u2(3)];

P = mean([P1, P2], 2);  % P1�� P2 ������ ����� ������ ��ġ ���� P�� �����

end