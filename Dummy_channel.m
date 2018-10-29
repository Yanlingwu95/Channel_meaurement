clc
cla 
close all;
clear variables;
load('test_workspace.mat');

% Dummy impluse generation
% for i = 100:100:44100
%     A(i) = round(rand(1,1))/log(i)*5;
% end

t = linspace(0,10,1000);
A = exp(-t)*10;
A = [A zeros(1,length(test_sequence_ex)-length(A))];

figure
stem(A)

test_sequence_ex = test_sequence_ex*2-1;
test_sequence = test_sequence*2-1;

channel = A;
channel_len = length(channel)
%% Channel simulation
sequence_len = length(test_sequence_ex);
record = conv(test_sequence_ex,A);
measured = xcorr(record,test_sequence)/length(test_sequence);
% measured = conv(test_sequence,flip(record))/length(test_sequence);
figure
stem(measured)


