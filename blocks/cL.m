function nps = cL(s, x)
    ns = length(x) - s;
    first = abs(x(1:ns));
    last = abs(x(ns+1:legnth(x)));
    temp = [last first];
    nps = temp(1:ns);
end