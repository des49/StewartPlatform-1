function out = calculate_alpha(l, s, a, p, b, beta, h0)
    out = [];
    for i = 1:6,
        L = l(i)^2 - (s^2 - a^2);
        M = 2*a*((h0+p(3,i)) - b(3,i));
        N = 2*a*(cos(beta(i))*(p(1,i) - b(1,i)) + sin(beta(i))*(p(2,i) - b(2,i)));
        out(end+1) = asin(L/sqrt(M^2 + N^2)) - atan(N/M);
    end
end
    