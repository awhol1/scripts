function ImportStationData()

%===============================================
%
%
% This program takes the data from .grid(.txt) files and extracts it into a
% readable matrix for analysis. For use with BOM rainfall data and
% caculates the SPI for each month with 1-12 scales
%
% This is not a program for distribution!!! 
%
% Author          Date           version
% A.Holmes      4-Dec-13        1.1
%
%===============================================

close all
clear all
       
%===============================================
  
%%
%===============================================
%    Set path and import parameter files
[root_file, root_dir, ~] = uigetfile('C:/*.*', 'Please Select Station Data Initial File'); %set init file

%date = inputdlg({'Enter start date (dd/mm/yyyy format):','Enter end date (dd/mm/yyyy format):'},...
%                    'Input Date Boundaries',...
%                    1,...
%                    {'dd/mm/yyyy','dd/mm/yyyy'});
date = {'01/01/2002';'31/12/2010'};
datestr('1/12/2001  12:00:00','dd/mm/yyyy',2000)
%===============================================

%%
%===============================================
%    open files

% first build file string
B = strsplit(root_file,'_');
D = strsplit(date{1},'/');
E = strsplit(date{2},'/');

%%%%%%%%%%need to fix date issue%%%%%%%%%%%%%%%%%%%%%%




if strcmp(D(2),'02')==1 || strcmp(D(2),'01')==1
   year = num2str(str2double(D(3)) - 1,'%02.0f');
   year = year(3:4);
   season = 'su';
elseif strcmp(D(2),'03')==1 || strcmp(D(2),'04')==1 || strcmp(D(2),'05')==1
    year = D{1, 3}(3:4);
    season = 'au';
elseif strcmp(D(2),'06')==1 || strcmp(D(2),'07')==1 || strcmp(D(2),'08')==1
    year = D{1, 3}(3:4);
    season = 'wi';
elseif strcmp(D(2),'09')==1 || strcmp(D(2),'10')==1 || strcmp(D(2),'11')==1
    year = D{1, 3}(3:4);
    season = 'sp';
else 
   year = num2str(str2double(D(3)) - 1,'%02.0f');
   season = 'su';
end

if strcmp(E(2),'02')==1 || strcmp(E(2),'01')==1 || strcmp(E(2),'12')==1
    season2 = 'su';
elseif strcmp(E(2),'03')==1 || strcmp(E(2),'04')==1 || strcmp(E(2),'05')==1
    season2 = 'au';
elseif strcmp(E(2),'06')==1 || strcmp(E(2),'07')==1 || strcmp(E(2),'08')==1
    season2 = 'wi';
elseif strcmp(E(2),'09')==1 || strcmp(E(2),'10')==1 || strcmp(E(2),'11')==1
    season2 = 'sp';
end

filename =  strcat(B(1),'_',year,'_',season,'_sm.xls') ;
filepath = fullfile(root_dir, filename);
    

%now get first file info to select correct sheet
[~,sheets,~] = xlsfinfo(filepath{1});
[num,~,~] = xlsread(filepath{1}, sheets{1}, 'F:F');

%import 1st sheet, remove null values, and average
num(num == -99) = NaN;

%import second sheet, remove null values
[num2,~,~] = xlsread(filepath{1}, sheets{2}, 'B:B');
num2(num2 == -99.9) = NaN;


% Varify the lenght of each file

if strcmp(season, 'su') == 1
    if strcmp(year, '03') || strcmp(year, '07')
        num(length(num)-48+1:end)=[];
        num2(end)=[];
    end
    
    if length(num)< 4320
        t= NaN(4320,1);t(end-length(num)+1:end,1)=num; num=[]; num = t;
    elseif length(num)> 4320
        num(4321:end)=[];
    end
    if length(num2)> 90
        num2(91:end)=[];
    end
    
elseif strcmp(season, 'sp') == 1
    
    if length(num)< 4368
        t= NaN(4368,1);t(end-length(num)+1:end,1)=num; num=[]; num = t;
    elseif length(num)> 4368
        num(4369:end)=[];
    end
    if length(num2)> 91
        num2(92:end)=[];
    end
    
else
    
   if length(num)< 4416
        t= NaN(4416,1);t=num;t(end-length(num)+1:end,1)=num; num=[]; num = t;
    elseif length(num)> 4320
        num(4416:end)=[];
    end
    if length(num2)> 92
        num2(93:end)=[];
    end
    
end
Data = NaN;
for i=1:48:numel(num)   
    Data(end+1,1) = nanmean(num(i:i+47));
end
Data(1)=[];
Data(:,2) = num2;

if strcmp(filename,root_file) %just used to get rid of the december info
    Data(1:31,:)=[];
end
    

%===============================================

%%
%===============================================
%    reconstruct time series and add every new file to end

while ((str2double(year) == str2double(E{1, 3}(3:4))) && (strcmp(season, season2))) == 0
    
    if strcmp(season,'su')==1
       season = 'au';
       year = num2str(str2double(year) + 1,'%02.0f'); 
    elseif strcmp(season,'au')==1
       season = 'wi';
    elseif strcmp(season,'wi')==1
       season = 'sp'; 
    elseif strcmp(season,'sp')==1
       season = 'su'; 
    end
     
filename =  strcat(B(1),'_',year,'_',season,'_sm.xls') ;
filepath = fullfile(root_dir, filename);
    
[num,~,~] = xlsread(filepath{1}, sheets{1}, 'F:F');
num(num == -99) = NaN;

[num2,~,~] = xlsread(filepath{1}, sheets{2}, 'B:B');
num2(num2 == -99.9) = NaN;
% Varify the lenght of each file

if strcmp(season, 'su') == 1
    if strcmp(year, '03') || strcmp(year, '07')
        num(length(num)-48+1:end)=[];
        num2(end)=[];
    end
    
    if length(num)< 4320
        t= NaN(4320,1);t(end-length(num)+1:end,1)=num; num=[]; num = t;
    elseif length(num)> 4320
        num(4321:end)=[];
    end
    if length(num2)> 90
        num2(91:end)=[];
    end
    
elseif strcmp(season, 'sp') == 1
    
    if length(num)< 4368
        t= NaN(4368,1);t(end-length(num)+1:end,1)=num; num=[]; num = t;
    elseif length(num)> 4368
        num(4369:end)=[];
    end
    if length(num2)> 91
        num2(92:end)=[];
    end
    
else
    
   if length(num)< 4416
        t= NaN(4416,1);t(end-length(num)+1:end,1)=num; num=[]; num = t;
    elseif length(num)> 4416
        num(4416:end)=[];
    end
    if length(num2)> 92
        num2(93:end)=[];
    end
    
end


temp = NaN;
for i=1:48:numel(num)   
    temp(end+1,1) = nanmean(num(i:i+47));
end
temp(1) = [];
temp(:,2) = num2;

if (str2double(year) == str2double(E{1, 3}(3:4))) && (strcmp(season, season2) == 1)
    temp(32:end,:)=[];
end
Data(end+1:end+numel(temp(:,1)),:) = temp(:,:);
clear temp num num2 filename filepath t
end
    
%===============================================

%%
%===============================================
%    save as txt file


     
filename =  strcat(B(1),'_',D{1, 3}(3:4),'_',year,'.txt') ;
filepath = fullfile(root_dir, filename);

fileID = fopen(filepath{1, 1},'w');
fprintf(fileID,'%6s %12s\r\n','SM','Precip');
fprintf(fileID,'%4.2f %5.3f\r\n',Data');
fclose(fileID);




%===============================================
end
