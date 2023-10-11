function newStd = UpdateStd(OldMean, OldStd, NewMean, NewDataValue, n)
    newStd = sqrt(((n - 1) n OldStd^2 + (n+1)*(NewDataValue - NewMean)^2) / n^2);
end