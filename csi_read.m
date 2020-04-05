%% =====================================================================================
%%       Filename:  CSI_Amplitude.m 
%%    Description:  extract the CSI, payload, and packet status information from the bf file
%%         Author:  Hannan Adil
%%         Email :  adil@stud.fra-uas.de
%%   Organization:  Frankfurt University of Applied Sciences
%% =====================================================================================

function amplitude = csi_read(file)
packet_matrix = read_bf_file(file);
 amplitude = zeros(length(packet_matrix), 1*3*30);
 for i = 1:length(packet_matrix)
     packet_row = packet_matrix(i);
     csi = packet_row{1}.csi;
     for subcarriers = 1:size(csi,3)
         for Nt = 1:size(csi,2)
             for Nr = 1:size(csi,1)
                 amplitude(i, subcarriers + 30*(Nt-1 + (Nr-1)*3)) = real(csi(Nr, Nt, subcarriers));
                 
             end
         end
     end
     
 end
 