%% =====================================================================================
%%       Filename:  amplitude_plot.m 
%%    Description:  Plot the amplitude of the signal
%%         Author:  Hannan Adil
%%         Email :  adil@stud.fra-uas.de
%%   Organization:  Frankfurt University of Applied Sciences
%% =====================================================================================

function amplitude_plot(amplitude, den)
tiledlayout(2,1)
nexttile
plot(amplitude)
xlabel('No of Packets'), ylabel('Amplitude')
title('With Noise')
grid on 
%axis([0 150 -50 inf])
axis tight

nexttile
plot(den)
xlabel('No of Packets'), ylabel('Amplitude')
title('After Denoise')
grid on 
%axis([0 150 -50 inf])
axis tight
end 