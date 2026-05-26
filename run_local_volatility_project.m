%% 2.1
clc;
clearvars;

T=[0.205479452054795,0.301369863013699,0.490410958904110,0.723287671232877,1.04931506849315,1.47123287671233,2.04657534246575,2.96712328767123];

Fwd=[2684.73500000000,2687.07000000000,2685.40800000000,2691.09700000000,2697.18500000000,2701.35600000000,2709.96900000000,2725.56900000000];


K=[2375,2250,2125,1925,1750,1600,1450,1250;
    2600,2575,2525,2450,2400,2325,2250,2175;
    2650,2650,2625,2625,2600,2575,2550,2525;
    2675,2675,2675,2700,2700,2700,2700,2725;
    2700,2725,2725,2750,2775,2825,2850,2900;
    2750,2775,2800,2850,2900,2975,3050,3200;
    2825,2875,2950,3050,3150,3275,3450,3600];

MktVol=[0.140300000000000,0.164500000000000,0.205300000000000,0.236700000000000,0.255200000000000,0.261800000000000,0.267100000000000,0.273400000000000;
    0.107300000000000,0.119500000000000,0.136700000000000,0.155800000000000,0.167900000000000,0.179300000000000,0.187600000000000,0.195700000000000;
    0.0950000000000000,0.103000000000000,0.119100000000000,0.130500000000000,0.143100000000000,0.153700000000000,0.162200000000000,0.173200000000000;
    0.0909000000000000,0.0977000000000000,0.110600000000000,0.120100000000000,0.131200000000000,0.141400000000000,0.150200000000000,0.161400000000000;
    0.0840000000000000,0.0889000000000000,0.102900000000000,0.113900000000000,0.123000000000000,0.130000000000000,0.139000000000000,0.151900000000000;
    0.0761000000000000,0.0825000000000000,0.0935000000000000,0.103200000000000,0.110900000000000,0.117700000000000,0.125600000000000,0.137100000000000;
    0.0701000000000000,0.0764000000000000,0.0817000000000000,0.0886000000000000,0.0921000000000000,0.0970000000000000,0.103200000000000,0.119900000000000];

[rows, cols] = size(K);
K_norm = K ./ repmat(Fwd, rows, 1);

% Dupire solver settings
Lt = 120;
Lh = 200;
K_min = 0.1;
K_max = 3;
Scheme = 'cn';

% calibration settings
Threshold = 0.0010;
MaxIter = 100;
tic
[V, ModelVol, MaxErr] =calibrator(T,K_norm,MktVol,Threshold,MaxIter,Lt,Lh,K_min,K_max,Scheme);
toc
% plot local volatility function vs market implied volatility
figure;
plot(K(:,1),MktVol(:,1),'o',K(:,1),ModelVol(:,1),':.',K(:,1),V(:,1),':.b','linewidth',1.5);
title('Calibrated model and local volatility for asset E CORP');
legend('MktVol','ModelVol','LocalVol')

figure;
plot(MaxErr,'.','MarkerSize',15);
title('calibration error at each iteration of the fixed-point calibration');
%% 2.2
S0=2680.99;
k1=0.9;
k2=1.1;
K1=k1*S0;
K2=k2*S0;
strike=[K1 K2];

DF=[0.996125000000000,0.994334000000000,0.991277000000000,0.985434000000000,0.978722000000000,0.969614000000000,0.956780000000000,0.937240000000000];
expiry=0.5;

N = 1000000; %MC simulations
M = 100; %timesteps

% MC simulation (Local Vol)
% monte carlo 
S = lv_simulation_log(T,Fwd,V,K,N,M,expiry);

% LV price of a call option
discount_factor = interp1(T,DF,expiry); % = discount(T,r,expiry)
lv_price1= discount_factor*mean(max(S(1,:) - strike(1),0));
lv_price2= discount_factor*mean(max(S(1,:) - strike(2),0));

% LV implied volatility
fwd = interp1(T,Fwd,expiry); % = forward(T,r,q,expiry);
lv_impl_vol1 = blsimpv(fwd,strike(1),0,expiry,lv_price1/discount_factor);
lv_impl_vol2 = blsimpv(fwd,strike(2),0,expiry,lv_price2/discount_factor);

%% 2.3
% MC simulation (Black)
expiry(1) = 2;
expiry(2) = expiry(1) + 0.5;
strikes = [0.9 1.1];
% MC settings

N=1000000; %MC simulations
M=50; %timesteps

% MC simulation
S = lv_simulation_log(T,Fwd,V,K,N,M,expiry);

% option price
discount_factor = interp1(T,DF,expiry(2));
price_fw_starting(1) = discount_factor*mean(max(S(2,:) - strikes(1)*S(1,:),0));
price_fw_starting(2) = discount_factor*mean(max(S(2,:) - strikes(2)*S(1,:),0));

fwd(1) = interp1(T,Fwd,expiry(1));
fwd(2) = interp1(T,Fwd,expiry(2));
model_impl_vol = blsimpv(fwd(2),strikes*fwd(1),0,expiry(2)-expiry(1),price_fw_starting/discount_factor);

%% 2.4
% spot start option data
Expiry = 0.5;

% Dupire solver details
Lt = 10;
Lh = 200;
K_min = 0.1;
K_max = 3;
Scheme = 'cn';

% compute price of spot-start call options 
[ k, C ] = solve_dupire( T, K_norm, V, Expiry, Lt, Lh, K_min, K_max, Scheme);    

% compute model implied volatilities
perc_strikes_spot_start=[];
model_impl_vol_spot_start=[];
for i=1:length(k)
    if k(i)>=0.9001 && k(i)<1.1
        perc_strikes_spot_start = [perc_strikes_spot_start k(i)];
        model_impl_vol_spot_start = [model_impl_vol_spot_start blsimpv(1,k(i),0,Expiry,C(i))];
    end
end



% option prices
perc_strikes = 0.9:0.05:1.1;
model_impl_vol=[];
for x = perc_strikes
    P = discount_factor*mean(max(S(2,:) - x*S(1,:),0));
    model_impl_vol = [model_impl_vol, blsimpv(fwd(2),x*fwd(1),0,expiry(2)-expiry(1),P/discount_factor)];
end

plot(perc_strikes_spot_start,model_impl_vol_spot_start,perc_strikes,model_impl_vol);
title('Model implied vol with option maturity 6m');
legend('Spot vol','Fwd vol (starts in 2y)')

skew(1)=(model_impl_vol_spot_start(end)-model_impl_vol_spot_start (1)) / (perc_strikes_spot_start(end)-perc_strikes_spot_start(1));
skew(2)=(model_impl_vol(end) -model_impl_vol(1)) / (perc_strikes(end)-perc_strikes(1));
skew
%2.5


%% 3
T_fail=[0.00821917808219178,0.0191780821917808];
Fwd_fail=[4.50708300000000,4.50708300000000];
spotprice_fail=4.5071;

implvol_fail=[0.190250000000000,0.120250000000000;
    0.197500000000000,0.327500000000000;
    0.205000000000000,0.135000000000000;
    0.217500000000000,0.147500000000000;
    0.232250000000000,0.162250000000000];

strikes_fail=[4.41060113476000,4.41060113476000;
    4.45479258923200,4.45479258923200;
    4.50809196514400,4.50809196514400;
    4.56929539367200,4.56929539367200;
    4.63266758963200,4.63266758963200];
discounts_fail=[1,1];

% normalized market strikes
[rows, cols] = size(strikes_fail);
fail_strikes_norm = strikes_fail ./ repmat(Fwd_fail, rows, 1);

% Dupire solver settings
Lt = 120;
Lh = 200;
K_min = 0.1;
K_max = 5;
Scheme = 'cn';

% calibration settings
Threshold = 0.0010;
MaxIter = 100;

[V, fail_ModelVol, MaxErr] = calibrator(T_fail,fail_strikes_norm,implvol_fail,Threshold,MaxIter,Lt,Lh,K_min,K_max,Scheme);

% plot local volatility function vs market implied volatility
figure;
plot(strikes_fail(:,1),impvol_fail(:,1),'o',strikes_fail(:,1),fail_ModelVol(:,1),':.',strikes_fail(:,1),V(:,1),':.b','linewidth',1.5);
title('Calibrated model and local volatility for asset E CORP');
legend('MktVol','ModelVol','LocalVol')

figure;
plot(MaxErr,'.','MarkerSize',15);
title('calibration error at each iteration of the fixed-point calibration');

%% convexity of call option prices

blsprice(spotprice_fail, strikes_fail(:,1), 0, T_fail(1),implvol_fail(:,1))

%i prezzi della seconda colonna sono concavi
blsprice(spotprice_fail, strikes_fail(:,2), 0, T_fail(2), implvol_fail(:,2))
figure
plot(fail_strikes_norm,blsprice(spotprice_fail, strikes_fail(:,1), 0, T_fail(1), implvol_fail(:,1)))
title('EU CALL PRICES FOR EXPIRY T1=0.0082')
hold on
figure
plot(fail_strikes_norm,blsprice(spotprice_fail, strikes_fail(:,2), 0,T_fail(2),implvol_fail(:,2)))
title('EU CALL PRICES FOR EXPIRY T2=0.0192')
%% 4.1

% spot
spot_eurusd =134.680000000000;

% market expiries; coincide with expiries of the LV matrix
T_eurusd = [0.104109589041096,0.150684931506849,0.235616438356164,0.312328767123288,0.564383561643836,0.816438356164384,1.06575342465753];

% forwards at market expiries
Fwd_eurusd = [134.682500000000,134.709500000000,134.745400000000,134.781700000000,134.869800000000,134.940400000000,134.991900000000];

% market deltas
Delta = [ 0.1 0.25 0.5 0.75 0.9];

% LV matrix
MktVol_eurusd = [0.0800744483332817,0.0707146842908789,0.0726903702904014,0.0791579693643420,0.0868220958573838,0.0911804732653901,0.0938549190317784;
    0.0728658265358673,0.0657576339756681,0.0708066134982187,0.0752178038417575,0.0829130243418675,0.0864589767111788,0.0889201554240715;
    0.0669026760457685,0.0659773283497778,0.0680219739091080,0.0730224496229431,0.0795949814299979,0.0828101508268840,0.0851948393226038;
    0.0655051751734955,0.0680621555575044,0.0667306903524883,0.0720969349225603,0.0783675371016200,0.0817169426910263,0.0841185459580260;
    0.0648775798547618,0.0679844133004429,0.0684572850838984,0.0725517727498051,0.0792482874873220,0.0820817225097814,0.0843646774682699];

domestic_discounts_eurusd=[0.999916000000000,0.999899000000000,0.999885000000000,0.999845000000000,0.999726000000000,0.999536000000000,0.999910000000000];
foreign_discounts_eurusd=[0.999934560959311,1.00011801559623,1.00037053964211,1.00060000621102,1.00113488027027,1.00146857480250,1.00222565138848];
% market strikes
K_eurusd = zeros(length(Delta),length(T_eurusd));

discounts_eurusd = domestic_discounts_eurusd./foreign_discounts_eurusd;
% find K such that BS_Delta(K,Fwt,T,MktVol) = Delta
for i = 1:length(Delta)
    for j = 1:length(T_eurusd)
        K_eurusd(i,j) = fzero(@(Strike) blsdelta(Fwd_eurusd(j),Strike,0,T_eurusd(j),MktVol_eurusd(i,j))-(1-Delta(i)), Fwd_eurusd(j));
    end
end

% normalized market strikes
[rows, cols] = size(K_eurusd);
K_norm = K_eurusd ./ repmat(Fwd_eurusd, rows, 1);

% Dupire solver settings
Lt = 100;
Lh = 300;
K_min = 0.5;
K_max = 2.5;
Scheme = 'cn';

% calibration settings
Threshold = 0.0010;
MaxIter = 100;

[V, ModelVol, MaxErr] = calibrator(T_eurusd,K_norm,MktVol_eurusd,Threshold,MaxIter,Lt,Lh,K_min,K_max,Scheme);

% plot local volatility function vs market implied volatility
figure;
plot(K_eurusd(:,1),MktVol_eurusd(:,1),'o',K_eurusd(:,1),ModelVol(:,1),':.',K_eurusd(:,1),V(:,1),':.b','linewidth',1.5);
title('Calibrated model and local volatility for asset EUR/USD');
legend('MktVol','ModelVol','LocalVol');

figure;
plot(MaxErr,'.','MarkerSize',15);
title('calibration error at each iteration of the fixed-point calibration');

%% 4.2
% option data
expiry = T_eurusd(5);
strike = K_eurusd(2, 5);

% MC settings
N = 1000000; %MC simulations
M = 100; %timesteps

% MC simulation (LV)
S = lv_simulation_log(T_eurusd,Fwd_eurusd,V,K_eurusd,N,M,expiry);


discount_factor = interp1(T_eurusd,discounts_eurusd,expiry);
% vanilla option price (LV)
lv_vanilla_price = discount_factor*mean(max(S(1,:) - strike,0));
% digital option price
lv_digital_price = discount_factor*mean(max(S(1,:)>strike,0));

%95% confidence interval

err_vanilla = 2*sqrt(std(max(S(1,:) - strike,0)))/sqrt(N);
err_digital = 2*sqrt(std(max(S(1,:) > strike,0)))/sqrt(N);



%% 4.3 

% MC simulation (Black)

sigma = MktVol_eurusd(2, 5); % model parameter
N_B = 100000; %MC simulations
S_B = black_simulation_log(T_eurusd,Fwd_eurusd,sigma,N_B,expiry); 

% Black price of a vanilla call option
vanilla_price_black = discount_factor*mean(max(S_B(1,:) - strike,0));

% Black price of a digital call option
digital_price_black = discount_factor*mean(max(S_B(1,:) > strike,0));

%95% confidence interval

err_vanilla_black = 2*sqrt(std(max(S_B(1,:) - strike,0)))/sqrt(N);
err_digital_black = 2*sqrt(std(max(S_B(1,:) > strike,0)))/sqrt(N);
