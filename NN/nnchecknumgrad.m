function nnchecknumgrad(nn, x, y)
    epsilon = 1e-6;
    er = 1e-8;
    n = nn.n;
    for l = 1 : (n - 1)
        for i = 1 : size(nn.W{l}, 1)
            for j = 1 : size(nn.W{l}, 2)
                nn_m = nn; nn_p = nn;
                nn_m.W{l}(i, j) = nn.W{l}(i, j) - epsilon;
                nn_p.W{l}(i, j) = nn.W{l}(i, j) + epsilon;
                rng(0);
                nn_m = nnff(nn_m, x, y);
                rng(0);
                nn_p = nnff(nn_p, x, y);
                dW = (nn_p.L - nn_m.L) / (2 * epsilon);
                e = abs(dW - nn.dW{l}(i, j));
                
                assert(e < er, 'numerical gradient checking failed');
            end
        end

        for i = 1 : size(nn.b{l}, 1)
            nn_m = nn; nn_p = nn;
            nn_m.b{l}(i) = nn.b{l}(i) - epsilon;
            nn_p.b{l}(i) = nn.b{l}(i) + epsilon;
            rng(0);
            nn_m = nnff(nn_m, x, y);
            rng(0);
            nn_p = nnff(nn_p, x, y);
            db = (nn_p.L - nn_m.L) / (2 * epsilon);
            e = abs(db - nn.db{l}(i));
            assert(e < er, 'numerical gradient checking failed');
        end
    end
end
