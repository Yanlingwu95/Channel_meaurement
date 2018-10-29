clc
clear all;
close all;

%% Create .wav file from mls_generator
Fs = 44.1e3;                        %Set audio sampling frequency
mls_record = audiorecorder(Fs,16,1);%Create recording argument          
% n = round(log(Fs/2+1)/log(2));          %Set n to nearest integer
n =16;
test_sequence = 2*mls_generator(n,1)-1; %Create mls sequence 2^n long

save('test_sequence.mat','test_sequence');
audiowrite('test_sequence.wav',test_sequence,Fs);

T = 3;     %Set how many periods test_sequence_ex will repeat
% test_sequence_ex = zeros([1,T].*size(test_sequence));
test_sequence_ex = test_sequence;
for t = 1:T-1
    test_sequence_ex = [test_sequence_ex test_sequence];
end

time = size(test_sequence_ex)/Fs;
size = size(test_sequence_ex);
size = size(2);
time(2)

soundsc(test_sequence_ex,Fs)
recordblocking(mls_record,time(2))

record_data = getaudiodata(mls_record);
max_point = max(record_data);
record_data = record_data/max_point;

time2 = linspace(0,time(2),Fs*time(2));

%% Channel recovery
measured = xcorr(record_data,test_sequence)/length(test_sequence);
% measured = conv(test_sequence,flip(record))/length(test_sequence);
max_point2 = max(measured);
measured = measured/max_point2;
time3 = linspace(0,length(measured)/Fs,length(measured));

figure
subplot(2,1,1)
plot(time2,record_data)
subplot(2,1,2)
plot(time3,measured)

