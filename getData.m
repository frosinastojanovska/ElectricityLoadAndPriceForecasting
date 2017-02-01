function [ data, dates ] = getData(file, sheet, range)
%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%    Worksheet: England
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

%% Import the data, extracting spreadsheet dates in Excel serial date format
[~, ~, raw, dates] = xlsread(file,sheet,range,'',@convertSpreadsheetExcelDates);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[1,2]);
raw = raw(:,[4,5,6]);
dates = dates(:,3);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),dates); % Find non-numeric cells
dates(R) = {NaN}; % Replace non-numeric Excel dates with NaN

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
LCLid = cellVectors(:,1);
stdorToU = cellVectors(:,2);
DateTime = datetime([dates{:,1}].', 'ConvertFrom', 'Excel');
MeanTemperature = data(:,1);
MeanDewPointC= data(:,2);
KWHh= data(:,3);
Hour= hour(DateTime);
DateNum= datenum(DateTime);

data = struct('LCLid', LCLid,'stdorToU', stdorToU,'DateTime', DateTime,'MeanTemperature', MeanTemperature,'MeanDewPointC',MeanDewPointC,'DateNum', DateNum, 'Hour', Hour, 'KWHh', KWHh);
