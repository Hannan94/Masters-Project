% Preprocessing
% Denoising
% Feature Reduction
% Feature Extraction using PSD
% Statistical Properties 
%% Parameters init:
denoise_lvl = 2;
use_pca = true;
n_components = 10;
svm_kernel = "linear";
x = [];
y = [];

%% Preprocessing 
 dataset_folders = ["dataset_r2"];
for folder = dataset_folders
    sample_files = dir(folder);
    for s_i = 1:length(sample_files)
        file = sample_files(s_i);
        if (not(file.isdir) && not(strcmp(file.name, ".DS_Store")))
            fprintf(strcat(file.name, '\n'));
            filename = file.name;
            angle = get_angle_from_filename(filename);
            angle = str2num(angle);
            
            
            path = strcat(folder, '/',filename);
            csi_values = csi_read(path);
            amplitude = abs(csi_values);
            
           
           amplitude = amplitude(1:120,:); 
           
           
           %Denoising
           den1 = wdenoise(amplitude, 3, 'Wavelet', 'sym6');
           
          
          %PCA         
            [coeff,score,latent,tsquared,explained,mu] = pca(den1);
            
%             
                          for subCarrierNo = 1 :3
                              %perform spectral analysis and get the PSD
                              %and Frequency of ceneter of energy matrix
                             [stft,f,t,ps,fc,tc] = spectrogram((score( : ,subCarrierNo)),hamming(48,'periodic'), 46 ,400,'psd', 'MinThreshold',0,'yaxis'); 
                           
                             %perform haart wavelet of the PSD matrix
                            
                               dwtLevel = 5;
                             
                          
                             [k,l] = haart(abs(ps(1:200,:)), dwtLevel);
                             
                              %perform haart wavelet of the frequency of
                             %center of energy.
                             [s,l] = haart(abs(fc(1:200,:)),dwtLevel);
                             
                             
                             %generate the fecture vector
                               meanTempMatrix = mean(k, 2);
                               maxTempMatrix = max(k,[],2);
                               minTempMatrix = min(k,[],2);
                               peakTempMatrix = maxTempMatrix - minTempMatrix ;
                               stdDevTempMatrix = std(k,0,2);
                               varTempMatrix = var(k, 0,2);
                               skewTempMatrix = skewness(k,1,2);
                               kurtosisTempMatrix = kurtosis(k,1, 2);
                               secCentMomentTempMatrix = moment(k,2,2);
                               thirdCentralMomentTempMatrix = moment(k,3,2);

                           
                                meanFreqTempMatrix = mean(s, 2);
                                maxFreqTempMatrix = max(s,[],2);
                                minFreqTempMatrix = min(s,[],2);
                                peakFreqTempMatrix =  maxFreqTempMatrix - minFreqTempMatrix;
                                stdDevFreqTempMatrix = std(s,0,2);
                                secCentMomentFreqTempMatrix = moment(s,2,2);
                                thirdCentralMomentFreqTempMatrix = moment(s,3,2);
                                skewFreqTempMatrix = skewness(s,1,2);
                                kurtosisFreqTempMatrix = kurtosis(s,1, 2);
                                
                                
                                 if(subCarrierNo == 1)

                                  sub1mean = round(mean(score( : ,subCarrierNo)),4);
                                  sub1median = round(median(score( : ,subCarrierNo)),4);
                                  sub1standardDeviation = round(std(score( : ,subCarrierNo)),4);
                                  sub1interquartileRange = round(iqr(score( : ,subCarrierNo)),4);
                                  sub1secCentralMoment = round(moment(score( : ,subCarrierNo), 2),4);
                                  sub1thirdCentralMoment = round(moment(score( : ,subCarrierNo), 3),4);
                                  sub1skewness = round(skewness(score( : ,subCarrierNo)),4);
                                  sub1kurtosis = round(kurtosis(score( : ,subCarrierNo)),4);
                                  sub1Entropy = round(entropy(score( : ,subCarrierNo)),4);
                                  
                                  sub1_features = [sub1mean, sub1median,sub1standardDeviation, sub1interquartileRange, sub1secCentralMoment, sub1thirdCentralMoment,sub1skewness, sub1Entropy ];
                                  
                                  sub1Ps1Mean = round(meanTempMatrix(1), 4);
                                  sub1Ps2Mean = round(meanTempMatrix(2), 4);
                                  sub1Ps3Mean = round(meanTempMatrix(3), 4);
                                  sub1Ps4Mean = round(meanTempMatrix(4), 4);
                                  sub1Ps5Mean = round(meanTempMatrix(5), 4);
                                  sub1Ps6Mean = round(meanTempMatrix(6), 4);
                                  sub1Ps7Mean = round(meanTempMatrix(7), 4);
                                  
                                  sub1_PS_Mean_Matrix = [sub1Ps1Mean, sub1Ps2Mean, sub1Ps3Mean, sub1Ps4Mean,sub1Ps5Mean, sub1Ps6Mean, sub1Ps7Mean ];
                                  
                                  
                                  sub1Ps1Max = round(maxTempMatrix(1), 4);
                                  sub1Ps2Max = round(maxTempMatrix(2), 4);
                                  sub1Ps3Max = round(maxTempMatrix(3), 4);
                                  sub1Ps4Max = round(maxTempMatrix(4), 4);
                                  sub1Ps5Max = round(maxTempMatrix(5), 4);
                                  sub1Ps6Max = round(maxTempMatrix(6), 4);
                                  sub1Ps7Max = round(maxTempMatrix(7), 4);

                                   sub1_PS_Max_Matrix = [sub1Ps1Max, sub1Ps2Max, sub1Ps3Max, sub1Ps4Max, sub1Ps5Max,sub1Ps6Max,sub1Ps7Max]
                                      

                                  sub1Ps1standardDeviation = round(stdDevTempMatrix(1), 4);
                                  sub1Ps2standardDeviation = round(stdDevTempMatrix(2), 4);
                                  sub1Ps3standardDeviation = round(stdDevTempMatrix(3), 4);
                                  sub1Ps4standardDeviation = round(stdDevTempMatrix(4), 4);
                                  sub1Ps5standardDeviation = round(stdDevTempMatrix(5), 4);
                                 sub1Ps6standardDeviation = round(stdDevTempMatrix(6), 4);
                                 sub1Ps7standardDeviation = round(stdDevTempMatrix(7), 4);
            
                                 sub1_PS_STD_Matrix = [sub1Ps1standardDeviation,sub1Ps2standardDeviation,sub1Ps3standardDeviation, sub1Ps4standardDeviation, sub1Ps5standardDeviation, sub1Ps6standardDeviation, sub1Ps7standardDeviation];

                       
                                  sub1Ps1InterquartileRange = round(iqr(k(1,:)), 4);
                                  sub1Ps2InterquartileRange = round(iqr(k(2,:)), 4);
                                  sub1Ps3InterquartileRange = round(iqr(k(3,:)), 4);
                                  sub1Ps4InterquartileRange = round(iqr(k(4,:)), 4);
                                  sub1Ps5InterquartileRange = round(iqr(k(5,:)), 4);
                                  sub1Ps6InterquartileRange = round(iqr(k(6,:)), 4);
                                  sub1Ps7InterquartileRange = round(iqr(k(7,:)), 4);
                
                                  sub1_PS_IntequatileRange_Matrix = [sub1Ps1InterquartileRange, sub1Ps2InterquartileRange, sub1Ps3InterquartileRange, sub1Ps4InterquartileRange, sub1Ps5InterquartileRange, sub1Ps6InterquartileRange, sub1Ps7InterquartileRange];

                                  sub1Ps1skewness = round(skewTempMatrix(1), 4);
                                  sub1Ps2skewness = round(skewTempMatrix(2), 4);
                                  sub1Ps3skewness = round(skewTempMatrix(3), 4);
                                  sub1Ps4skewness = round(skewTempMatrix(4), 4);
                                  sub1Ps5skewness = round(skewTempMatrix(5), 4);
                                  sub1Ps6skewness = round(skewTempMatrix(6), 4);
                                  sub1Ps7skewness = round(skewTempMatrix(7), 4);
                                  
                                  sub1_PS_skewness_Matrix = [sub1Ps1skewness, sub1Ps2skewness, sub1Ps3skewness, sub1Ps4skewness,sub1Ps5skewness,sub1Ps6skewness, sub1Ps7skewness];

                                  sub1Ps1kurtosis = round(kurtosisTempMatrix(1), 4);
                                  sub1Ps2kurtosis = round(kurtosisTempMatrix(2), 4);
                                  sub1Ps3kurtosis = round(kurtosisTempMatrix(3), 4);
                                  sub1Ps4kurtosis = round(kurtosisTempMatrix(4), 4) ;
                                  sub1Ps5kurtosis = round(kurtosisTempMatrix(5), 4) ;
                                  sub1Ps6kurtosis = round(kurtosisTempMatrix(6), 4);
                                  sub1Ps7kurtosis = round(kurtosisTempMatrix(7), 4);
                                
                                  sub1_PS_kurtosis_Matrix = [sub1Ps1kurtosis, sub1Ps1kurtosis,sub1Ps2kurtosis, sub1Ps3kurtosis, sub1Ps4kurtosis, sub1Ps5kurtosis, sub1Ps6kurtosis, sub1Ps7kurtosis];
                                  
                                  sub1Freq1Mean = round(meanFreqTempMatrix(1), 4);
                                  sub1Freq2Mean = round(meanFreqTempMatrix(2), 4);
                                  sub1Freq3Mean = round(meanFreqTempMatrix(3), 4);
                                  sub1Freq4Mean = round(meanFreqTempMatrix(4), 4);
                                  sub1Freq5Mean = round(meanFreqTempMatrix(5), 4);
                                  sub1Freq6Mean = round(meanFreqTempMatrix(6), 4);
                                  sub1Freq7Mean = round(meanFreqTempMatrix(7), 4);
                                  
                                  
                                  sub1_FreqMean_Matrix = [sub1Freq1Mean, sub1Freq2Mean, sub1Freq3Mean, sub1Freq4Mean, sub1Freq5Mean, sub1Freq6Mean, sub1Freq7Mean];
                                  
                                  

                                  sub1Freq1Max = round(maxFreqTempMatrix(1), 4);
                                  sub1Freq2Max = round(maxFreqTempMatrix(2), 4);
                                  sub1Freq3Max = round(maxFreqTempMatrix(3), 4);
                                  sub1Freq4Max = round(maxFreqTempMatrix(4), 4);
                                  sub1Freq5Max = round(maxFreqTempMatrix(5), 4);
                                  sub1Freq6Max = round(maxFreqTempMatrix(6), 4);
                                  sub1Freq7Max = round(maxFreqTempMatrix(7), 4);
                                  
                                  sub1_FreqMax_Matrix = [sub1Freq1Max, sub1Freq2Max, sub1Freq3Max, sub1Freq4Max, sub1Freq5Max, sub1Freq6Max, sub1Freq7Max];



                                  sub1Freq1standardDeviation = round(stdDevFreqTempMatrix(1), 4);
                                  sub1Freq2standardDeviation = round(stdDevFreqTempMatrix(2), 4);
                                  sub1Freq3standardDeviation = round(stdDevFreqTempMatrix(3), 4);
                                  sub1Freq4standardDeviation = round(stdDevFreqTempMatrix(4), 4);
                                  sub1Freq5standardDeviation = round(stdDevFreqTempMatrix(5), 4);
                                  sub1Freq6standardDeviation = round(stdDevFreqTempMatrix(6), 4);
                                  sub1Freq7standardDeviation = round(stdDevFreqTempMatrix(7), 4);

                                  sub1_FreqSTD_Matrix= [sub1Freq1standardDeviation, sub1Freq2standardDeviation, sub1Freq3standardDeviation, sub1Freq4standardDeviation, sub1Freq5standardDeviation, sub1Freq6standardDeviation, sub1Freq7standardDeviation];
                  

                                  sub1Freq1InterquartileRange = round(iqr(s(1,:)), 4);
                                  sub1Freq2InterquartileRange = round(iqr(s(2,:)), 4);
                                  sub1Freq3InterquartileRange = round(iqr(s(3,:)), 4);
                                  sub1Freq4InterquartileRange = round(iqr(s(4,:)), 4);
                                  sub1Freq5InterquartileRange = round(iqr(s(5,:)), 4);
                                  sub1Freq6InterquartileRange = round(iqr(s(6,:)), 4);
                                  sub1Freq7InterquartileRange = round(iqr(s(7,:)), 4);  
                                  
                                  sub1_FreqInterquartileRange_Matrix=[sub1Freq1InterquartileRange, sub1Freq2InterquartileRange, sub1Freq3InterquartileRange, sub1Freq4InterquartileRange, sub1Freq5InterquartileRange, sub1Freq6InterquartileRange, sub1Freq7InterquartileRange];
                                  
                                  sub1_PS_Vector = [sub1_PS_Mean_Matrix, sub1_PS_Max_Matrix, sub1_PS_STD_Matrix, sub1_PS_IntequatileRange_Matrix, sub1_PS_skewness_Matrix, sub1_PS_kurtosis_Matrix];
                                  sub1_Freq_Vector = [sub1_FreqMean_Matrix,sub1_FreqMax_Matrix, sub1_FreqMax_Matrix,  sub1_FreqSTD_Matrix, sub1_FreqInterquartileRange_Matrix];
                                  
                                 sub1_feauter_Vector = [sub1_features, sub1_PS_Vector,sub1_Freq_Vector ];
                                  
                                 end
                                
                               
                              
                              if(subCarrierNo == 2)

                                  sub2mean = round(mean(score( : ,subCarrierNo)),4);
                                  sub2median = round(median(score( : ,subCarrierNo)),4);
                                  sub2standardDeviation = round(std(score( : ,subCarrierNo)),4);
                                  sub2interquartileRange = round(iqr(score( : ,subCarrierNo)),4);
                                  sub2secCentralMoment = round(moment(score( : ,subCarrierNo), 2),4);
                                  sub2thirdCentralMoment = round(moment(score( : ,subCarrierNo), 3),4);
                                  sub2skewness = round(skewness(score( : ,subCarrierNo)),4);
                                  sub2kurtosis = round(kurtosis(score( : ,subCarrierNo)),4);
                                  sub2Entropy = round(entropy(score( : ,subCarrierNo)),4);
                                  
                                  sub2_features = [sub2mean, sub2median,sub2standardDeviation, sub2interquartileRange, sub2secCentralMoment, sub2thirdCentralMoment,sub2skewness, sub2Entropy ];
                                  
                                  sub2Ps1Mean = round(meanTempMatrix(1), 4);
                                  sub2Ps2Mean = round(meanTempMatrix(2), 4);
                                  sub2Ps3Mean = round(meanTempMatrix(3), 4);
                                  sub2Ps4Mean = round(meanTempMatrix(4), 4);
                                  sub2Ps5Mean = round(meanTempMatrix(5), 4);
                                  sub2Ps6Mean = round(meanTempMatrix(6), 4);
                                  sub2Ps7Mean = round(meanTempMatrix(7), 4);
                                  
                                  sub2_PS_Mean_Matrix = [sub2Ps1Mean, sub2Ps2Mean, sub2Ps3Mean, sub2Ps4Mean,sub2Ps5Mean, sub2Ps6Mean, sub2Ps7Mean ];

                                  sub2Ps1Max = round(maxTempMatrix(1), 4);
                                  sub2Ps2Max = round(maxTempMatrix(2), 4);
                                  sub2Ps3Max = round(maxTempMatrix(3), 4);
                                  sub2Ps4Max = round(maxTempMatrix(4), 4);
                                  sub2Ps5Max = round(maxTempMatrix(5), 4);
                                  sub2Ps6Max = round(maxTempMatrix(6), 4);
                                  sub2Ps7Max = round(maxTempMatrix(7), 4);

                                   sub2_PS_Max_Matrix = [sub2Ps1Max, sub2Ps2Max, sub2Ps3Max, sub2Ps4Max, sub2Ps5Max,sub2Ps6Max,sub2Ps7Max ]


                                  sub2Ps1standardDeviation = round(stdDevTempMatrix(1), 4);
                                  sub2Ps2standardDeviation = round(stdDevTempMatrix(2), 4);
                                 sub2Ps3standardDeviation = round(stdDevTempMatrix(3), 4);
                                  sub2Ps4standardDeviation = round(stdDevTempMatrix(4), 4);
                                  sub2Ps5standardDeviation = round(stdDevTempMatrix(5), 4);
                                 sub2Ps6standardDeviation = round(stdDevTempMatrix(6), 4);
                                 sub2Ps7standardDeviation = round(stdDevTempMatrix(7), 4);
            
                                 sub2_PS_STD_Matrix = [sub2Ps1standardDeviation,sub2Ps2standardDeviation,sub2Ps3standardDeviation, sub2Ps4standardDeviation, sub2Ps5standardDeviation, sub2Ps6standardDeviation, sub2Ps7standardDeviation ];

                       
                                  sub2Ps1InterquartileRange = round(iqr(k(1,:)), 4);
                                  sub2Ps2InterquartileRange = round(iqr(k(2,:)), 4);
                                  sub2Ps3InterquartileRange = round(iqr(k(3,:)), 4);
                                  sub2Ps4InterquartileRange = round(iqr(k(4,:)), 4);
                                 sub2Ps5InterquartileRange = round(iqr(k(5,:)), 4);
                                  sub2Ps6InterquartileRange = round(iqr(k(6,:)), 4);
                                  sub2Ps7InterquartileRange = round(iqr(k(7,:)), 4);
                
                                  sub2_PS_IntequatileRange_Matrix = [sub2Ps1InterquartileRange, sub2Ps2InterquartileRange, sub2Ps3InterquartileRange, sub2Ps4InterquartileRange, sub2Ps5InterquartileRange, sub2Ps6InterquartileRange, sub2Ps7InterquartileRange];

                                  sub2Ps1skewness = round(skewTempMatrix(1), 4);
                                  sub2Ps2skewness = round(skewTempMatrix(2), 4);
                                  sub2Ps3skewness = round(skewTempMatrix(3), 4);
                                  sub2Ps4skewness = round(skewTempMatrix(4), 4);
                                  sub2Ps5skewness = round(skewTempMatrix(5), 4);
                                  sub2Ps6skewness = round(skewTempMatrix(6), 4);
                                  sub2Ps7skewness = round(skewTempMatrix(7), 4);
                                  
                                  sub2_PS_skewness_Matrix = [sub2Ps1skewness, sub2Ps2skewness, sub2Ps3skewness, sub2Ps4skewness,sub2Ps5skewness,sub2Ps6skewness, sub2Ps7skewness];

                                  sub2Ps1kurtosis = round(kurtosisTempMatrix(1), 4);
                                  sub2Ps2kurtosis = round(kurtosisTempMatrix(2), 4);
                                  sub2Ps3kurtosis = round(kurtosisTempMatrix(3), 4);
                                  sub2Ps4kurtosis = round(kurtosisTempMatrix(4), 4) ;
                                  sub2Ps5kurtosis = round(kurtosisTempMatrix(5), 4) ;
                                  sub2Ps6kurtosis = round(kurtosisTempMatrix(6), 4);
                                  sub2Ps7kurtosis = round(kurtosisTempMatrix(7), 4);
                                
                                  sub2_PS_kurtosis_Matrix = [sub2Ps1kurtosis, sub2Ps1kurtosis,sub2Ps2kurtosis, sub2Ps3kurtosis, sub2Ps4kurtosis, sub2Ps5kurtosis, sub2Ps6kurtosis, sub2Ps7kurtosis];
                                  
                                  sub2Freq1Mean = round(meanFreqTempMatrix(1), 4);
                                  sub2Freq2Mean = round(meanFreqTempMatrix(2), 4);
                                  sub2Freq3Mean = round(meanFreqTempMatrix(3), 4);
                                  sub2Freq4Mean = round(meanFreqTempMatrix(4), 4);
                                  sub2Freq5Mean = round(meanFreqTempMatrix(5), 4);
                                  sub2Freq6Mean = round(meanFreqTempMatrix(6), 4);
                                  sub2Freq7Mean = round(meanFreqTempMatrix(7), 4);
                                  
                                  sub2_FreqMean_Matrix = [sub2Freq1Mean, sub2Freq2Mean, sub2Freq3Mean, sub2Freq4Mean, sub2Freq5Mean, sub2Freq6Mean, sub2Freq7Mean];
                                  
                                  

                                  sub2Freq1Max = round(maxFreqTempMatrix(1), 4);
                                  sub2Freq2Max = round(maxFreqTempMatrix(2), 4);
                                  sub2Freq3Max = round(maxFreqTempMatrix(3), 4);
                                  sub2Freq4Max = round(maxFreqTempMatrix(4), 4);
                                  sub2Freq5Max = round(maxFreqTempMatrix(5), 4);
                                  sub2Freq6Max = round(maxFreqTempMatrix(6), 4);
                                  sub2Freq7Max = round(maxFreqTempMatrix(7), 4);
                                  
                                  sub2_FreqMax_Matrix = [sub2Freq1Max, sub2Freq2Max, sub2Freq3Max, sub2Freq4Max, sub2Freq5Max, sub2Freq6Max, sub2Freq7Max];



                                  sub2Freq1standardDeviation = round(stdDevFreqTempMatrix(1), 4);
                                  sub2Freq2standardDeviation = round(stdDevFreqTempMatrix(2), 4);
                                  sub2Freq3standardDeviation = round(stdDevFreqTempMatrix(3), 4);
                                  sub2Freq4standardDeviation = round(stdDevFreqTempMatrix(4), 4);
                                  sub2Freq5standardDeviation = round(stdDevFreqTempMatrix(5), 4);
                                  sub2Freq6standardDeviation = round(stdDevFreqTempMatrix(6), 4);
                                  sub2Freq7standardDeviation = round(stdDevFreqTempMatrix(7), 4);

                                  sub2_FreqSTD_Matrix= [sub2Freq1standardDeviation, sub2Freq2standardDeviation, sub2Freq3standardDeviation, sub2Freq4standardDeviation, sub2Freq5standardDeviation, sub2Freq6standardDeviation, sub2Freq7standardDeviation];
                  

                                  sub2Freq1InterquartileRange = round(iqr(s(1,:)), 4);
                                  sub2Freq2InterquartileRange = round(iqr(s(2,:)), 4);
                                  sub2Freq3InterquartileRange = round(iqr(s(3,:)), 4);
                                  sub2Freq4InterquartileRange = round(iqr(s(4,:)), 4);
                                  sub2Freq5InterquartileRange = round(iqr(s(5,:)), 4);
                                  sub2Freq6InterquartileRange = round(iqr(s(6,:)), 4);
                                  sub2Freq7InterquartileRange = round(iqr(s(7,:)), 4);  
                                  
                                  sub2_FreqInterquartileRange_Matrix=[sub2Freq1InterquartileRange, sub2Freq2InterquartileRange, sub2Freq3InterquartileRange, sub2Freq4InterquartileRange, sub2Freq5InterquartileRange, sub2Freq6InterquartileRange, sub2Freq7InterquartileRange];
                                  
                                  sub2_PS_Vector = [sub2_PS_Mean_Matrix, sub2_PS_Max_Matrix, sub2_PS_STD_Matrix, sub2_PS_IntequatileRange_Matrix, sub2_PS_skewness_Matrix, sub2_PS_kurtosis_Matrix];
                                  sub2_Freq_Vector = [sub2_FreqMean_Matrix,sub2_FreqMax_Matrix, sub2_FreqMax_Matrix,  sub2_FreqSTD_Matrix, sub2_FreqInterquartileRange_Matrix];
                                  
                                 sub2_feauter_Vector = [sub2_features, sub2_PS_Vector,sub2_Freq_Vector ];
                                  
                              end
                             
                             if(subCarrierNo == 3)
                                  sub3mean = round(mean(score( : ,subCarrierNo)),4);
                                  sub3median = round(median(score( : ,subCarrierNo)),4);
                                  sub3standardDeviation = round(std(score( : ,subCarrierNo)),4);
                                  sub3interquartileRange =round( iqr(score( : ,subCarrierNo)),4);
                                  sub3secCentralMoment = round(moment(score( : ,subCarrierNo), 2),4);
                                  sub3thirdCentralMoment = round(moment(score( : ,subCarrierNo), 3),4);
                                  sub3skewness = round(skewness(score( : ,subCarrierNo)),4);
                                  sub3kurtosis = round(kurtosis(score( : ,subCarrierNo)),4);
                                  sub3Entropy = round(entropy(score( : ,subCarrierNo)),4);
                                  
                                  sub3_features = [sub3mean, sub3median,sub3standardDeviation, sub3interquartileRange, sub3secCentralMoment, sub3thirdCentralMoment,sub3skewness, sub3Entropy ];

                                  sub3Ps1Mean =  round(meanTempMatrix(1), 4);
                                  sub3Ps2Mean =  round(meanTempMatrix(2), 4);
                                  sub3Ps3Mean =  round(meanTempMatrix(3), 4);
                                  sub3Ps4Mean =  round(meanTempMatrix(4), 4);
                                  sub3Ps5Mean = round(meanTempMatrix(5), 4);
                                  sub3Ps6Mean = round(meanTempMatrix(6), 4);
                                  sub3Ps7Mean = round(meanTempMatrix(7), 4);
                                  
                                  sub3_PS_Mean_Matrix = [sub3Ps1Mean, sub3Ps2Mean, sub3Ps3Mean, sub3Ps4Mean]%,sub3Ps5Mean, sub3Ps6Mean, sub3Ps7Mean ];

                                  sub3Ps1Max = round(maxTempMatrix(1), 4);
                                  sub3Ps2Max = round(maxTempMatrix(2), 4);
                                  sub3Ps3Max = round(maxTempMatrix(3), 4);
                                  sub3Ps4Max = round(maxTempMatrix(4), 4);
                                 sub3Ps5Max = round(maxTempMatrix(5), 4);
                                  sub3Ps6Max = round(maxTempMatrix(6), 4);
                                 sub3Ps7Max = round(maxTempMatrix(7), 4);

                                  sub3_PS_Max_Matrix = [sub3Ps1Max, sub3Ps2Max, sub3Ps3Max, sub3Ps4Max]%, sub3Ps5Max,sub3Ps6Max,sub3Ps7Max ];


                                  sub3Ps1standardDeviation = round(stdDevTempMatrix(1), 4);
                                  sub3Ps2standardDeviation = round(stdDevTempMatrix(2), 4);
                                  sub3Ps3standardDeviation = round(stdDevTempMatrix(3), 4);
                                  sub3Ps4standardDeviation = round(stdDevTempMatrix(4), 4);
                                  sub3Ps5standardDeviation = round(stdDevTempMatrix(5), 4);
                                  sub3Ps6standardDeviation = round(stdDevTempMatrix(6), 4);
                                  sub3Ps7standardDeviation = round(stdDevTempMatrix(7), 4);
                                  
                                  sub3_PS_STD_Matrix = [sub3Ps1standardDeviation,sub3Ps2standardDeviation,sub3Ps3standardDeviation, sub3Ps4standardDeviation, sub3Ps5standardDeviation, sub3Ps6standardDeviation, sub3Ps7standardDeviation ];
                                  

                                  sub3Ps1InterquartileRange = round(iqr(k(1,:)), 4);
                                  sub3Ps2InterquartileRange = round(iqr(k(2,:)), 4);
                                  sub3Ps3InterquartileRange = round(iqr(k(3,:)), 4);
                                  sub3Ps4InterquartileRange = round(iqr(k(4,:)), 4);
                                  sub3Ps5InterquartileRange = round(iqr(k(5,:)), 4);
                                  sub3Ps6InterquartileRange = round(iqr(k(6,:)), 4);
                                  sub3Ps7InterquartileRange = round(iqr(k(7,:)), 4);
                        
                                  sub3_PS_IntequatileRange_Matrix = [sub3Ps1InterquartileRange, sub3Ps2InterquartileRange, sub3Ps3InterquartileRange, sub3Ps4InterquartileRange, sub3Ps5InterquartileRange, sub3Ps6InterquartileRange, sub3Ps7InterquartileRange];
                                   
                                  
                                  sub3Ps1skewness = round(skewTempMatrix(1), 4);
                                  sub3Ps2skewness = round(skewTempMatrix(2), 4);
                                  sub3Ps3skewness = round(skewTempMatrix(3), 4);
                                  sub3Ps4skewness = round(skewTempMatrix(4), 4);
                                  sub3Ps5skewness = round(skewTempMatrix(5), 4);
                                  sub3Ps6skewness = round(skewTempMatrix(6), 4);
                                  sub3Ps7skewness = round(skewTempMatrix(7), 4);
                                  
                                  sub3_PS_skewness_Matrix = [sub3Ps1skewness, sub3Ps2skewness, sub3Ps3skewness, sub3Ps4skewness,sub3Ps5skewness,sub3Ps6skewness, sub3Ps7skewness];

                                  sub3Ps1kurtosis = round(kurtosisTempMatrix(1), 4);
                                  sub3Ps2kurtosis = round(kurtosisTempMatrix(2), 4);
                                  sub3Ps3kurtosis = round(kurtosisTempMatrix(3), 4);
                                  sub3Ps4kurtosis = round(kurtosisTempMatrix(4), 4);
                                  sub3Ps5kurtosis = round(kurtosisTempMatrix(5), 4); 
                                  sub3Ps6kurtosis = round(kurtosisTempMatrix(6), 4);
                                  sub3Ps7kurtosis = round(kurtosisTempMatrix(7), 4);
                                  
                                  sub3_PS_kurtosis_Matrix = [sub3Ps1kurtosis, sub3Ps1kurtosis,sub3Ps2kurtosis, sub3Ps3kurtosis, sub3Ps4kurtosis, sub3Ps5kurtosis, sub3Ps6kurtosis, sub3Ps7kurtosis];

                                  sub3Freq1Mean = round(meanFreqTempMatrix(1), 4);
                                  sub3Freq2Mean = round(meanFreqTempMatrix(2), 4);
                                  sub3Freq3Mean = round(meanFreqTempMatrix(3), 4);
                                  sub3Freq4Mean = round(meanFreqTempMatrix(4), 4);
                                  sub3Freq5Mean = round(meanFreqTempMatrix(5), 4);
                                  sub3Freq6Mean = round(meanFreqTempMatrix(6), 4);
                                  sub3Freq7Mean = round(meanFreqTempMatrix(7), 4);
                                  
                                  sub3_FreqMean_Matrix = [sub3Freq1Mean, sub3Freq2Mean, sub3Freq3Mean, sub3Freq4Mean, sub3Freq5Mean, sub3Freq6Mean, sub3Freq7Mean];

                                  sub3Freq1Max = round(maxFreqTempMatrix(1), 4);
                                  sub3Freq2Max = round(maxFreqTempMatrix(2), 4);
                                  sub3Freq3Max = round(maxFreqTempMatrix(3), 4);
                                  sub3Freq4Max = round(maxFreqTempMatrix(4), 4);
                                  sub3Freq5Max = round(maxFreqTempMatrix(5), 4);
                                  sub3Freq6Max = round(maxFreqTempMatrix(6), 4);
                                  sub3Freq7Max = round(maxFreqTempMatrix(7), 4);

                                  sub3_FreqMax_Matrix = [sub3Freq1Max, sub3Freq2Max, sub3Freq3Max, sub3Freq4Max, sub3Freq5Max, sub3Freq6Max, sub3Freq7Max];
   
                                  sub3Freq1standardDeviation = round(stdDevFreqTempMatrix(1), 4);
                                  sub3Freq2standardDeviation = round(stdDevFreqTempMatrix(2), 4);
                                  sub3Freq3standardDeviation = round(stdDevFreqTempMatrix(3), 4);
                                  sub3Freq4standardDeviation = round(stdDevFreqTempMatrix(4), 4);
                                  sub3Freq5standardDeviation = round(stdDevFreqTempMatrix(5), 4);
                                  sub3Freq6standardDeviation = round(stdDevFreqTempMatrix(6), 4);
                                  sub3Freq7standardDeviation = round(stdDevFreqTempMatrix(7), 4);
                                  
                                  sub3_FreqSTD_Matrix= [sub3Freq1standardDeviation, sub3Freq2standardDeviation, sub3Freq3standardDeviation, sub3Freq4standardDeviation, sub3Freq5standardDeviation, sub3Freq6standardDeviation, sub3Freq7standardDeviation];

                                  sub3Freq1InterquartileRange = round(iqr(s(1,:)), 4);
                                  sub3Freq2InterquartileRange = round(iqr(s(2,:)), 4);
                                  sub3Freq3InterquartileRange = round(iqr(s(3,:)), 4);
                                  sub3Freq4InterquartileRange = round(iqr(s(4,:)), 4);
                                  sub3Freq5InterquartileRange = round(iqr(s(5,:)), 4);
                                  sub3Freq6InterquartileRange = round(iqr(s(6,:)), 4);
                                  sub3Freq7InterquartileRange = round(iqr(s(7,:)), 4);
                                  
                                   sub3_FreqInterquartileRange_Matrix = [sub3Freq1InterquartileRange, sub3Freq2InterquartileRange, sub3Freq3InterquartileRange, sub3Freq4InterquartileRange, sub3Freq5InterquartileRange, sub3Freq6InterquartileRange, sub3Freq7InterquartileRange]
                                  
                                   sub3_PS_Vector = [sub3_PS_Mean_Matrix, sub3_PS_Max_Matrix, sub3_PS_STD_Matrix, sub3_PS_IntequatileRange_Matrix, sub3_PS_skewness_Matrix, sub3_PS_kurtosis_Matrix];
                                  sub3_Freq_Vector = [sub3_FreqMean_Matrix,sub3_FreqMax_Matrix, sub3_FreqMax_Matrix,  sub3_FreqSTD_Matrix, sub3_FreqInterquartileRange_Matrix];
                                 sub3_feauter_Vector = [sub3_features, sub3_PS_Vector,sub3_Freq_Vector ];
                             end
                             
                          end
                          
                       
                         
                          final_matrix = [sub1_feauter_Vector, sub2_feauter_Vector, sub3_feauter_Vector];
                          
                          matrix = [angle,final_matrix];
                          
                           dlmwrite("dataset_r2_comp3_PSD.csv", matrix, '-append');
                            
                            
                          x = [ x; final_matrix];
                            y = [ y; get_class_index(angle)];
                          
                         
            
            
            
               
        end
    end
end

%% Train test split 80:20

rand_indexes = randperm(size(x,1));
train_indexes = round(size(x,1) * 80 / 100);
x_train = x(rand_indexes(1:train_indexes),:);
y_train = y(rand_indexes(1:train_indexes),:);

x_test = x(rand_indexes(train_indexes+1:end),:);
y_test = y(rand_indexes(train_indexes+1:end),:);

fprintf("X splitted into train/test 80:20");

%% Model init
svm_t = templateSVM('KernelFunction',svm_kernel);
model = fitcecoc(x_train, y_train, "Learners", svm_t);
 %model = fitcecoc(x_train, y_train, "Learners", svm_t,'OptimizeHyperparameters','auto',...
    %'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    %'expected-improvement-plus'));
fprintf(strcat("Model fitted. Kernel:", svm_kernel));

%% Test Model
predictions = predict(model, x_test);
accuracy = sum(predictions == y_test)/length(y_test)*100;
res = sprintf('Model accuracy: %d', round(accuracy));
fprintf(res);
fprintf(newline);

%% functions
function angle = get_angle_from_filename(filename)
filename_arr = split(filename, '_');
angle = filename_arr{2};
end

function class_idx = get_class_index(angle)
if (angle == 30)
    class_idx = 1;
elseif (angle == 60)
    class_idx = 2;
else
    class_idx = 3;
end
end

function ret=extract_statistical_values(packet)
meanTempMatrix = mean(packet);
maxTempMatrix = max(packet);
minTempMatrix = min(packet);
stdDevTempMatrix = std(packet);
varTempMatrix = var(packet);
skewTempMatrix = skewness(packet);
kurtosisTempMatrix = kurtosis(packet);

ret = [meanTempMatrix maxTempMatrix minTempMatrix stdDevTempMatrix varTempMatrix skewTempMatrix kurtosisTempMatrix];

end

function res=apply_pwelch(amp)
fs = 130; % number of packets
res= pwelch(amplitude, [], [], [], fs);
end

function plot_sample(amplitude, wtitle)
tiledlayout(2,1)
nexttile
plot(amplitude)
xlabel('No of Packets'), ylabel('Amplitude')
title(wtitle)
grid on
%axis([0 150 -50 inf])
axis tight
end