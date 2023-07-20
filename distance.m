function [d] = distance(a, b)

d = sqrt((a(1) - b(1))^2 + (a(2) - b(2))^2 + (a(3) - b(3))^2 + (a(4) - b(4))^2);