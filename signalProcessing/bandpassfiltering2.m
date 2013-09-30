function data2 = bandpassfiltering2(data,f1,f2,complexity,fs)
data1 = lowpassfiltering2(data, f2, complexity, fs);
data2 = highpassfiltering2(data1, f1, complexity, fs);

end

