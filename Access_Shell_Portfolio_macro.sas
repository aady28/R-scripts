
	/*********Start - Create counterparty table************/
	%macro counterparty(data=,outdata=);
		data &outdata;
		Retain counterpartyID PID counterpartyName counterpartyDescription counterpartycountrycode
				userVariableInt	userVariableString1	userVariableString2	userVariableString3	counterpartyType
				isPublicFlag;
		set &data(keep=counterpartyID CountryCode);
		PID="";
		CounterpartyName=counterpartyID;
		counterpartyDescription="";
		counterpartycountrycode=CountryCode;
		userVariableInt="";
		userVariableString1="";
		userVariableString2="";
		userVariableString3="";
		counterpartyType="";
		isPublicFlag="FALSE";
		drop CountryCode;
		run;
		
		proc sort data= &outdata nodupkey;
		by descending counterpartyID ;
	%mend;
	
	/*Remove duplicates from counterparty data*/
	/*********End - Create counterparty table************/
	
	
	
	/*********Start - Create CounterpartyRSquared table****/
	options mprint;
	%macro counterpartyRsq(data=,outdata=,correlationModelEstimate=, rsq=);
		data &outdata.;
			retain counterpartyID correlationModelEstimateName rsquared;
			set &data(keep=counterpartyId &rsq.);
			rsquared=&rsq.;
			correlationModelEstimateName="&correlationModelEstimate.";
			drop &rsq.;
		run;
		
		proc sort data= &outdata nodupkey;
		by descending counterpartyID;
	%mend;
	
	/*********End - Create CounterpartyRSquared table****/
	
	
	
	/*********Start - Create CounterpartyPdsFlexible table****/
	
	%macro counterpartyPdsFlexible(data=,outdata=,beginDate=,term=,pd=);
		data &outdata;
		retain counterpartyID beginDate endDate term &pd.;
		set &data(keep=counterpartyId &pd.);
		beginDate=&begindate;
		endDate="";
		term=&term;
		pd=&pd.;
		drop &pd.;
		run;

		proc sort data= &outdata nodupkey;
		by descending counterpartyID;		
	%mend;		
	
	/*********End - Create CounterpartyRSquared table****/
	
	
	
	/*********Start - covarianceModelFactorCoefficient****/
		
	%macro covModelFactorCoeff(data=,outdata=,WeightDate=,term=,factorSetName='GCORR 2014')	;
	
	data &outdata;
	retain factorSetName weightDate counterpartyID factorCoefficient;
	set &data(keep=counterpartyId RF_Industry Retail_vs_NonRetail);
	factorSetName=&factorSetName;
	WeightDate=&WeightDate;
	run;
	
	proc sort data= &outdata nodupkey;
	by descending counterpartyID  descending factorsetName;	
	
	proc sql;
	create table &outdata as
	select a.*,b.Industry, b.FactorCoefficient from &outdata a
	left join SAS_data.Retail_Industry b
	on a.Retail_vs_NonRetail=b.portfolio;
	quit;
	
	data &outdata;
	set &outdata;
	if Retail_vs_NonRetail ne "Retail" then do;
		FactorCoefficient=1;
		if RF_Industry="" then do;
			RF_Industry="MISCELLANEOUS";
		end;
	end;
	if Retail_vs_NonRetail="Retail" then do;
		RF_Industry=Industry;
	end;
	drop Industry PD Retail_vs_NonRetail;
	rename RF_Industry=FactorName;
	run;

		
	%mend;
	
	
		
	/*********End - Create CounterpartyRSquared table****/
	
	/*********Start - Create termLoanBullet table********/
	
	%macro termLoanBullet(data=,outdata=,instrumentCurrency=,maturityDate=,prepayableFlag=,interestTypeName=,fixedRateInterestFreq=,lgd_temp=);
		data &outdata;
		retain InstrumentID 	instrumentDescription 	instrumentCurrency 		originationDate
				maturityDate	counterpartyId		  	supportingCounterpartyId	supportTypeName	
				prepayableFlag	fixedRate			  	drawnSpread				numberEffective	
				numberActual	lgdScheduleName	lgd		lgdVarianceParam			referenceYieldCurve	
				interestTypeName	upfrontFee			drawnSpreadFreq			fixedRateInterestFreq	
				userVariableInt		userVariableString1	userVariableString2		userVariableString3	
				defaultedAssetFlag	stressedLgd			stressedLgdVarianceParam;
		set &data(keep=Id counterpartyId adj_rate count_obl poolobligors Pool
			&lgd_temp. MPR_Level_1 MPR_Level_2 Portfolio_Flag EquityFlag);
			where EquityFlag='NotEquity';
			instrumentID=ID;
			instrumentDescription=ID;
			instrumentCurrency=&instrumentCurrency;
			originationDate="";
			maturityDate=&maturityDate;
			counterpartyID=counterpartyID;
			supportingCounterpartyId="";
			supportTypeName="";
			prepayableFlag=&prepayableFlag;
			fixedRate=adj_rate;
			drawnSpread="";
			numberEffective=count_obl;
			if poolObligors ne . then do;
				numberEffective=poolObligors;
			end;
			if pool='' then do;
			numberEffective=1;
			end;
			numberActual=numberEffective;
			lgdScheduleName="";
			lgd=&lgd_temp.;
			lgdVarianceParam=1000000;
			referenceyieldcurve="";
			interestTypeName=&interestTypeName;
			upfrontfee="";
			drawnspreadfreq="";
			fixedRateInterestFreq=&fixedRateInterestFreq;
			userVariableInt="";
			userVariableString1=MPR_Level_2;
			userVariableString2=Portfolio_Flag;
			userVariableString3=MPR_Level_1;
			defaultedAssetFlag="False";
			stressedLGD="";
			stressedLGDVarianceParam="";
			drop ID adj_rate count_obl poolObligors &lgd_temp. MPR_Level_1 MPR_Level_2 Portfolio_Flag pool EquityFlag;		
		run;		
		
		proc sort data= &outdata nodupkey;
		by descending  counterpartyID descending InstrumentID;	
	%mend;	
	
	/*********End - Create CounterpartyRSquared table****/
	
	
	/*********Start - Create CommonStock Table***********/
	%macro commonStock(data=,outdata=,quotationCurrency=);
		data &outdata;
		retain instrumentId	instrumentDescription	quotationCurrency	counterpartyId	supportingCounterpartyId	
		supportTypeName	userVariableInt	userVariableString1	userVariableString2	userVariableString3;
		set &data(keep=Id EquityFlag counterpartyId portfolio_flag MPR_Level_1 MPR_Level_2); 
		where EquityFlag='Equity';
		instrumentId=ID;
		instrumentDescription=EquityFlag;
		quotationCurrency=&quotationCurrency;
		supportingCounterpartyId="";
		supportTypeName="";
		userVariableInt="";
		userVariableString1=MPR_Level_2;
		userVariableString2=Portfolio_Flag;
		userVariableString3=MPR_Level_1;
		drop ID EquityFlag portfolio_Flag MPR_Level_1 MPR_Level_2;
		run;
		
		proc sort data= &outdata nodupkey;
		by descending counterpartyID descending instrumentID;	
	
	%mend;		

	/***********End - Create CommonStock Table**********/
	
	/*********Start - Create equityAnalysisParameters Table***********/	
	
	%macro equityAnalysisParameters(data=,outdata=,parametersDate=,lgd_temp=,EAD_temp=);	
		data &outdata;
		retain instrumentId	parametersDate	standDevEquityReturn	expectedExcessEquityReturn	recoveryAmount;
		set &data(keep=Id &EAD_temp. &lgd_temp. EquityFlag);
		where EquityFlag='Equity'
		instrumentId=ID;
		parametersDate=&parametersDate;
		standDevEquityReturn="";	
		expectedExcessEquityReturn="";	
		recoveryAmount=&EAD_temp. *(1-&lgd_temp.);
		drop Id &EAD_temp. &lgd_temp. EquityFlag;
		run;

		proc sort data= &outdata nodupkey;
		by descending instrumentID;	
	%mend;
	/*********End - Create equityAnalysisParameters Table***********/
	
	
	/*********Start - Create Portfolio Table************************/
	
	%macro portfolio(outdata=,portfolioName=);
		data &outdata;
		portfolioName=&portfolioName;
		portfolioActiveUntilDate="";
		run;
	%mend;	
	
	/*********End - Create Portfolio Table************************/
	
	/********Start - Create PortfolioDetails *********************/
	
	%macro portfolioDetail(data=,outdata=,portfolioName=,EAD_temp=);
		data &outdata;
		set &data(keep=Id &EAD_temp. EquityFlag);
		portfolioName=&portfolioName;
		instrumentId=Id;
		holdingAmount=&EAD_temp.;
		if Upcase(EquityFlag) eq "EQUITY" then do;
		numShares=1;
		holdingAmount="";
		end;
		drop ID &EAD_temp. EquityFlag;
		run;
		proc sort data= &outdata nodupkey;
		by descending instrumentID;	
	%mend;
	
	/********End - Create PortfolioDetails *********************/
		
	/********Start - Create instrument Price *********************/
	
	%macro instrumentPrice(data=,outdata=,priceDate=,EAD_temp=);	
		data &outdata;
		set &data(keep=Id &EAD_temp. EquityFlag);
		where EquityFlag="Equity";
		instrumentID=Id;
		priceDate=&priceDate;
		analysisDatePrice=&EAD_temp.;
		horizon="";
		horizonPrice="";
		drop ID &EAD_temp. EquityFlag;
		run;
		proc sort data= &outdata nodupkey;
		by descending instrumentID;	
	%mend;

	/********End - Create instrument Price *********************/
	 
	/********Start - Create importasOfDate**********************/
	 
	%macro importasOfDate(outdata=,asOfDate=);
		data &outdata;
		asOfDate=&asOfDate;
		run;
	%mend;	
	
	/********End - Create importasOfDate**********************/
	

	
	
	
	