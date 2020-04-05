%% =====================================================================================
%%       Filename:  CSI_Amplitude.m 
%%    Description:  Surface plot of the sample 
%%         Author:  Hannan Adil
%%         Email :  adil@stud.fra-uas.de
%%   Organization:  Frankfurt University of Applied Sciences
%% =====================================================================================

function csi_plot(amplitude)
surf(amplitude)
colormap winter
shading interp
xlabel('No of Packets')
xlabel('Subcarriers')
end
