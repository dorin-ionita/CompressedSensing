function nps = cL(s, x)
    ns = length(x) - s;
    first = abs(x(0:ns-1));
    last = abs(x(ns:legnth(x)));
    temp = [last first];
    nps = temp(0:ns-1);
end