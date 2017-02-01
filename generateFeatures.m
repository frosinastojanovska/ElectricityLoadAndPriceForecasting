function [X, dates, labels] = generateFeatures(data, holidays)
% GENERATEFEATURES generates a matrix of features variables for the load
% forecasting model. 
%
% USAGE:
% [X, dates, labels] = generateFeatures(data, holidays)
%
% Inputs:
% data     : A Dataset array of historical weather and load information
% holidays : A vector of holidays. If this is not specified.
%
% Outputs:
% X     : A matrix of features data where each row corresponds to an
%         observation (hourly load) and each column corresponds to a variable
% dates : A vector of dates for each observation
% labels: A cell array of strings describing each predictor


% Convert Dates into a Numeric Representation
try
    dates = data.DateNum;
catch 
    dates = datenum(data.DateTime, 'yyyy-mm-dd HH:MM:SS') + (data.Hour-1)/24;
end

if all(floor(dates)==dates) % true if dates don't include any hour information
    dates = dates + (data.Hour-1)/24;
end

holidays = datenum(holidays);

% Create Features
%load = double(data(1:end-24, 6));
load=data.KWHh;
prevDaySameHourLoad = [ NaN(24,1); load(1:end-24)];
%prevWeekSameHourLoad = [NaN(168,1); double(data(1:end-168, 6))];
prev24HrAveLoad = filter(ones(1,24)/24, 1, load);

% Date predictors
dayOfWeek = weekday(dates);

% Non-business days
isWorkingDay = ~ismember(floor(dates),holidays) & ~ismember(dayOfWeek,[1 7]);
%[~,~,isWorkingDay] = createHolidayDates(data.NumDate);

temperature = data.MeanTemperature;
dewPoint = data.MeanDewPointC;
hour = data.Hour;

X = [temperature dewPoint hour dayOfWeek isWorkingDay prevDaySameHourLoad prev24HrAveLoad ];
labels = {'MeanTemperature', 'MeanDewPointC', 'Hour', 'Weekday', 'IsWorkingDay', 'prevDaySameHourLoad', 'prev24HrAveLoad'};



function y = rep24(x)
y = repmat(x(:), 1, 24)';
y = y(:);