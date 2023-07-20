function [c, post_vector, n] = my_kmean(data_shuffled, num_tr, num_hd, c)

eta = 1;

for n = 1:num_tr
    x = data_shuffled(1:4, n);

    for i = 1:num_hd
        eu_dist(i) = distance(x, c(:, i));
    end

    [eu_min_value, eu_min_pos] = min(eu_dist);
    c(:, eu_min_pos) = c(:, eu_min_pos) + eta*(x - c(:, eu_min_pos));
    post_vector(n) = eu_min_pos;
end