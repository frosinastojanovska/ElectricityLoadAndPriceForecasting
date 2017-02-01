%% Automate the Data Import Process
% This script imports data from the Zonal hourly spreadsheets provided by
% ISO New England (www.iso-ne.com). The folder containing these
% spreadsheets should be specified below. By default it is assumed to be a
% folder called "Data" in the same folder as this script. The data that is
% read in is saved as a MAT-file in the same folder.

folder = 'Data';
% Example: folder = 'C:\Temp\Data';

% By default the sheet name is ISONE CA. However, it can easily be changed
% to ME, CT, VT, NH, RI, SEMASS, WCMASS or NEMASSBOST to extract zonal data
sheetname = 'ISO data';

yr = 2012;

% Import data for 2012
data = dataset('XLSFile', sprintf('%s\\2012_smd_hourly.xls',folder), 'Sheet', sheetname);

% Add a column 'Year'
data.Year = 2012 * ones(length(data),1);
    
% Import data for other years
for yr = 2013:2014

    % Read in data into a dataset array
	x = dataset('XLSFile', sprintf('%s\\%d_smd_hourly.xls',folder,yr), 'Sheet', sheetname);
    
    % Add a column 'Year'
    x.Year = yr*ones(length(x),1);
    
    % Concatenate the datasets together
    data = [data; x];
end

% Calculate numeric date
%data.NumDate = datenum(data.DateTime, 'dd.mm.yyyy HH:MM:SS');

folder = 'Load\\Data\\';

save([folder genvarname(sheetname) '.mat'], 'data');