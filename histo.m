function [] = histo(data, bins)

h = histogram(data, 50)

for i = 1:length(h.BinCounts)
    fprintf('Bin %d: %.2f up to %.2f km/h → %d points\n', ...
        i, h.BinEdges(i), h.BinEdges(i+1), h.BinCounts(i));
end
end