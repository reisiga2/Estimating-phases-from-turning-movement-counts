% This function gives out training data from the raw data. Raw data
% requires some filtratin and correction to generate training data. 

function [training_data,time,realPhases] =  data_filteration(data_file_name ,ManIDList)

   exprData = readExcelData(data_file_name); % reads data from an excel sheet
   data1 = translate_data(exprData,ManIDList); % tranfer the maneuver IDs to 1 to 12
   data2 = filterzeros(data1); % remove any zero(errors) in maneuver IDs
   data3 = filterConflicts(data2); % remove conflicting maneuvers from data
   
   training_data = (data3(:,1))';
   time = (data3(:,2))';
   realPhases = (data3(:,3))';
 end