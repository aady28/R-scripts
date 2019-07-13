/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/***************************************************************Start - 2017 Scenario*************************************************/
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/


	
/*****************************************Start - Access Shell for ICAAP Y0 NormalRun portfolio*****************************************/	
		proc sql inobs=20;
		create table SAS_Data.FINAL_MIGRATION_ICAAP_Y0_B_NR as
		select * from SAS_DATA.FINAL_MIGRATION_ICAAP;
		quit;
		
		
		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_NR;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Jun18_v3_NR');
		CounterpartyID=compress(CounterpartyID||'_Jun18_v3_NR');
		run;
		
		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_NR,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_NR,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y0_actual);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_NR,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y0_actual);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_NR,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_NR,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y0_actual);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_NR,outdata=SAS_data.commonstock,quotationCurrency='SAR');
		Proc export data=SAS_data.commonstock
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\commonstock.csv"	
		dbms=csv
		replace;
		run;

		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_NR,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y0_actual,EAD_temp=EAD_2018);	
		Proc export data=SAS_data.equityAnalysisParameters
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\equityAnalysisParameters.csv"	
		dbms=csv
		replace;
		run;

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Base NR ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_NR,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Base NR ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_NR,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	
		Proc export data=SAS_data.instrumentPrice
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\instrumentPrice.csv"	
		dbms=csv
		replace;
		run;

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y0\ICAAP\NormalRun\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		

/*****************************************End - Access Shell for ICAAP Y0 NormalRun portfolio*****************************************/	

/*====================================================================================================================================/

/*****************************************Start - Access Shell for ICAAP Y0 Equity2Loan portfolio*****************************************/	

		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_EL;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Jun18_v3_Base_EL');
		CounterpartyID=compress(CounterpartyID||'_Jun18_v3_EL');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		run;

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_EL,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_EL,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y0_actual);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_EL,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y0_actual);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_EL,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_EL,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y0_actual);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP1,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP1,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y0_Actual,EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Base EL ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_EL,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Base EL ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP1,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y0\ICAAP\Equity2Loan\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/*****************************************End - Access Shell for ICAAP Y0 Equity2Loan portfolio*****************************************/	

/*====================================================================================================================================/

/*****************************************Start - Access Shell for ICAAP Y0 LargePool portfolio*****************************************/	

		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_LP;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Jun18_v3_Base_LP');
		CounterpartyID=compress(CounterpartyID||'_Jun18_v3_LP');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		if pool="" then do;
		counterpartyID=ID;
		end;
		run;
		
		
		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_LP,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y0\ICAAP\LargePool\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_LP,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y0_actual);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y0\ICAAP\LargePool\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_LP,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y0_actual);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y0\ICAAP\LargePool\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_LP,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y0\ICAAP\LargePool\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_LP,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y0_actual);
		data SAS_data.termloanbullet;
		set SAS_data.termloanbullet;
		numberEffective=100000;
		numberActual=numberEffective;
		run;
		
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y0\ICAAP\LargePool\termloanbullet.csv"	
		dbms=csv
		replace;
		run;		

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP2,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y0\ICAAP\LargePool\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP2,outdata=SAS_data.equityAnalysisParameters,parametersDate='03/31/2017',lgd_temp=LGD_Y0_Actual,EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y0\ICAAP\LargePool\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Base LP ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y0\ICAAP\LargePool\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y0_B_LP,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Base LP ICAAP",ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y0\ICAAP\LargePool\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP2,outdata=SAS_data.instrumentPrice,priceDate='03/31/2017',ead_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y0\ICAAP\LargePool\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y0\ICAAP\LargePool\importasofDate.csv"	
		dbms=csv
		replace;
		run;

/*****************************************End - Access Shell for ICAAP Y0 LargePool portfolio*****************************************/	



/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/***************************************************************End - 2017 Scenario*************************************************/
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/***************************************************************Start - 2017 Scenario*************************************************/
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/



/************************************************Start - Access Shell for ICAAP Y1Base NormalRun portfolio*****************************************/	
		
		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_NR;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_B_Jun18_NR');
		CounterpartyID=compress(CounterpartyID||'Y1_B_Jun18_NR');
		run;		
		
		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_NR,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_NR,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_Base);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_NR,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_Base);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_NR,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_NR,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_Base);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_NR,outdata=SAS_data.commonstock,quotationCurrency='SAR');
		Proc export data=SAS_data.commonstock
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\commonstock.csv"	
		dbms=csv
		replace;
		run;

		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_NR,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y1_Base,EAD_temp=EAD_2018);	
		Proc export data=SAS_data.equityAnalysisParameters
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\equityAnalysisParameters.csv"	
		dbms=csv
		replace;
		run;

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1Base NormalRun ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_NR,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1Base NormalRun ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_NR,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	
		Proc export data=SAS_data.instrumentPrice
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\instrumentPrice.csv"	
		dbms=csv
		replace;
		run;

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\Base\ICAAP\NormalRun\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/************************************************End - Access Shell for ICAAP Y1Base NormalRun portfolio*****************************************/	

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1Base Equity2Loan portfolio*****************************************/	

		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_EL;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_B_Jun18_EL');
		CounterpartyID=compress(CounterpartyID||'Y1_B_Jun18_EL');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		run;

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_EL,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_EL,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_Base);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_EL,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_Base);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_EL,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_EL,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_Base);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_EL,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_EL,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y1_Base,EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1Base Equity2Loan ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_EL,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1Base Equity2Loan ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_EL,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\Base\ICAAP\Equity2Loan\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/************************************************End - Access Shell for ICAAP Y1Base Equity2Loan portfolio*****************************************/	

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1Base LargePool portfolio*****************************************/	

		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_LP;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_B_Jun18_LP');
		CounterpartyID=compress(CounterpartyID||'Y1_B_Jun18_LP');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		if pool="" then do;
		counterpartyID=ID;
		end;
		run;

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_LP,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_LP,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_Base);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_LP,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_Base);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_LP,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_LP,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_Base);
		data SAS_data.termloanbullet;
		set SAS_data.termloanbullet;
		numberEffective=100000;
		numberActual=numberEffective;
		run;
		
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\termloanbullet.csv"	
		dbms=csv
		replace;
		run;		

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_LP,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_LP,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018');	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1Base LargePools ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_LP,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1Base LargePools ICAAP",ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_B_LP,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',ead_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\Base\ICAAP\LargePool\importasofDate.csv"	
		dbms=csv
		replace;
		run;

/************************************************End - Access Shell for ICAAP Y1Base LargePool portfolio*****************************************/	

/*==============================================================================================================================================*/

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S1 NormalRun portfolio*****************************************/	
		
		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_NR;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S1_Jun18_NR');
		CounterpartyID=compress(CounterpartyID||'Y1_S1_Jun18_NR');
		run;		
		
		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_NR,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_NR,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S1);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_NR,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S1);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_NR,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_NR,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S1);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_NR,outdata=SAS_data.commonstock,quotationCurrency='SAR');
		Proc export data=SAS_data.commonstock
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\commonstock.csv"	
		dbms=csv
		replace;
		run;

		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_NR,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y1_S1,EAD_temp=EAD_2018);	
		Proc export data=SAS_data.equityAnalysisParameters
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\equityAnalysisParameters.csv"	
		dbms=csv
		replace;
		run;

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S1 NormalRun ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_NR,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S1 NormalRun ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_NR,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	
		Proc export data=SAS_data.instrumentPrice
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\instrumentPrice.csv"	
		dbms=csv
		replace;
		run;

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S1\ICAAP\NormalRun\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/************************************************End - Access Shell for ICAAP Y1S1 NormalRun portfolio*****************************************/	

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S1 Equity2Loan portfolio*****************************************/	



		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_EL;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S1_Jun18_EL');
		CounterpartyID=compress(CounterpartyID||'Y1_S1_Jun18_EL');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		run;

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_EL,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_EL,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S1);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_EL,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S1);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_EL,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_EL,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S1);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_EL,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_EL,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y1_S1,EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S1 Equity2Loan ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_EL,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S1 Equity2Loan ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_EL,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S1\ICAAP\Equity2Loan\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/************************************************End - Access Shell for ICAAP Y1S1 Equity2Loan portfolio*****************************************/	

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S1 LargePool portfolio*****************************************/	

		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_LP;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S1_Jun18_LP');
		CounterpartyID=compress(CounterpartyID||'Y1_S1_Jun18_LP');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		if pool="" then do;
		counterpartyID=ID;
		end;
		run;

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_LP,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_LP,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S1);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_LP,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S1);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_LP,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_LP,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S1);
		data SAS_data.termloanbullet;
		set SAS_data.termloanbullet;
		numberEffective=100000;
		numberActual=numberEffective;
		run;
		
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\termloanbullet.csv"	
		dbms=csv
		replace;
		run;		

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_LP,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_LP,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018');	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S1 LargePools ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_LP,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S1 LargePools ICAAP",ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S1_LP,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',ead_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S1\ICAAP\LargePool\importasofDate.csv"	
		dbms=csv
		replace;
		run;

/************************************************End - Access Shell for ICAAP Y1S1 LargePool portfolio*****************************************/	

/*==============================================================================================================================================*/

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S2 NormalRun portfolio*****************************************/	
		
		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_NR;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S2_Jun18_v3_NR');
		CounterpartyID=compress(CounterpartyID||'Y1_S2_Jun18_v3_NR');
		run;		

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_NR,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_NR,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S2);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_NR,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S2);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_NR,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_NR,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S2);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_NR,outdata=SAS_data.commonstock,quotationCurrency='SAR');
		Proc export data=SAS_data.commonstock
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\commonstock.csv"	
		dbms=csv
		replace;
		run;

		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_NR,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y1_S2,EAD_temp=EAD_2018);	
		Proc export data=SAS_data.equityAnalysisParameters
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\equityAnalysisParameters.csv"	
		dbms=csv
		replace;
		run;

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S2 NormalRun ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_NR,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S2 NormalRun ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_NR,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	
		Proc export data=SAS_data.instrumentPrice
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\instrumentPrice.csv"	
		dbms=csv
		replace;
		run;

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S2\ICAAP\NormalRun\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/************************************************End - Access Shell for ICAAP Y1S2 NormalRun portfolio*****************************************/	

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S2 Equity2Loan portfolio*****************************************/	


		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_EL;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S2_Jun18_v3_EL');
		CounterpartyID=compress(CounterpartyID||'Y1_S2_Jun18_v3_EL');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		run;

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_EL,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_EL,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S2);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_EL,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S2);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_EL,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_EL,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S2);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_EL,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_EL,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y1_S2,EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S2 Equity2Loan ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_EL,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S2 Equity2Loan ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_EL,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S2\ICAAP\Equity2Loan\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/************************************************End - Access Shell for ICAAP Y1S2 Equity2Loam portfolio*****************************************/	

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S2 LargePool portfolio*****************************************/	

		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_LP;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S2_Jun18_v3_LP');
		CounterpartyID=compress(CounterpartyID||'Y1_S2_Jun18_v3_LP');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		if pool="" then do;
		counterpartyID=ID;
		end;
		run;
		
		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_LP,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_LP,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S2);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_LP,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S2);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_LP,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_LP,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S2);
		data SAS_data.termloanbullet;
		set SAS_data.termloanbullet;
		numberEffective=100000;
		numberActual=numberEffective;
		run;
		
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\termloanbullet.csv"	
		dbms=csv
		replace;
		run;		

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_LP,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_LP,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018');	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S2 LargePools ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_LP,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S2 LargePools ICAAP",ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S2_LP,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',ead_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S2\ICAAP\LargePool\importasofDate.csv"	
		dbms=csv
		replace;
		run;

/************************************************End - Access Shell for ICAAP Y1S2 LargePool portfolio*****************************************/	

/*==============================================================================================================================================*/

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S3 NormalRun portfolio*****************************************/	
		
		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_NR;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S3_Jun18_v3_NR');
		CounterpartyID=compress(CounterpartyID||'Y1_S3_Jun18_v3_NR');
		run;		

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_NR,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_NR,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S3);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_NR,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S3);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_NR,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_NR,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S3);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_NR,outdata=SAS_data.commonstock,quotationCurrency='SAR');
		Proc export data=SAS_data.commonstock
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\commonstock.csv"	
		dbms=csv
		replace;
		run;

		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_NR,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y1_S3,EAD_temp=EAD_2018);	
		Proc export data=SAS_data.equityAnalysisParameters
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\equityAnalysisParameters.csv"	
		dbms=csv
		replace;
		run;

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S3 NormalRun ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_NR,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S3 NormalRun ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_NR,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	
		Proc export data=SAS_data.instrumentPrice
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\instrumentPrice.csv"	
		dbms=csv
		replace;
		run;

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S3\ICAAP\NormalRun\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/************************************************End - Access Shell for ICAAP Y1S3 NormalRun portfolio*****************************************/	

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S3 Equity2Loan portfolio*****************************************/	

		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_EL;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S3_Jun18_v3_EL');
		CounterpartyID=compress(CounterpartyID||'Y1_S3_Jun18_v3_EL');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		run;


		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_EL,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_EL,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S3);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_EL,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S3);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_EL,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_EL,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S3);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_EL,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_EL,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y1_S3,EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S3 Equity2Loan ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_EL,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S3 Equity2Loan ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_EL,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S3\ICAAP\Equity2Loan\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/************************************************End - Access Shell for ICAAP Y1S3 Equity2Loan portfolio*****************************************/	

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S3 LargePool portfolio*****************************************/	

		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_LP;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S3_Jun18_v3_LP');
		CounterpartyID=compress(CounterpartyID||'Y1_S3_Jun18_v3_LP');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		if pool="" then do;
		counterpartyID=ID;
		end;
		run;

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_LP,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_LP,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S3);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_LP,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S3);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_LP,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_LP,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S3);
		data SAS_data.termloanbullet;
		set SAS_data.termloanbullet;
		numberEffective=100000;
		numberActual=numberEffective;
		run;
		
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\termloanbullet.csv"	
		dbms=csv
		replace;
		run;		

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_LP,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_LP,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018');	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S3 LargePools ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_LP,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S3 LargePools ICAAP",ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S3_LP,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',ead_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S3\ICAAP\LargePool\importasofDate.csv"	
		dbms=csv
		replace;
		run;

/************************************************End - Access Shell for ICAAP Y1S3 LargePool portfolio*****************************************/	

/*==============================================================================================================================================*/

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S4 NormalRun portfolio*****************************************/	
		
		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_NR;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S4_Jun18_v3_NR');
		CounterpartyID=compress(CounterpartyID||'Y1_S4_Jun18_v3_NR');
		run;		

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_NR,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_NR,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S4);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_NR,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S4);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_NR,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_NR,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S4);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_NR,outdata=SAS_data.commonstock,quotationCurrency='SAR');
		Proc export data=SAS_data.commonstock
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\commonstock.csv"	
		dbms=csv
		replace;
		run;

		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_NR,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y1_S4,EAD_temp=EAD_2018);	
		Proc export data=SAS_data.equityAnalysisParameters
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\equityAnalysisParameters.csv"	
		dbms=csv
		replace;
		run;

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S4 NormalRun ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_NR,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S4 NormalRun ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_NR,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	
		Proc export data=SAS_data.instrumentPrice
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\instrumentPrice.csv"	
		dbms=csv
		replace;
		run;

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S4\ICAAP\NormalRun\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/************************************************End - Access Shell for ICAAP Y1S4 NormalRun portfolio*****************************************/	

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S4 Equity2Loan portfolio*****************************************/	

		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_EL;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S4_Jun18_v3_EL');
		CounterpartyID=compress(CounterpartyID||'Y1_S4_Jun18_v3_EL');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		run;

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_EL,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_EL,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S4);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_EL,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S4);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_EL,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_EL,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S4);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_EL,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_EL,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y1_S4,EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S4 Equity2Loan ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_EL,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S4 Equity2Loan ICAAP", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_EL,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S4\ICAAP\Equity2Loan\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
/************************************************End - Access Shell for ICAAP Y1S4 Equity2Loan portfolio*****************************************/	

/*==============================================================================================================================================*/

/************************************************Start - Access Shell for ICAAP Y1S4 LargePool portfolio*****************************************/	

		data SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_LP;
		set SAS_DATA.FINAL_MIGRATION_ICAAP;
		ID=compress(ID||'_Y1_S4_Jun18_v3_LP');
		CounterpartyID=compress(CounterpartyID||'Y1_S4_Jun18_v3_LP');
		if	EquityFlag='Equity' then do;
		ID=compress(ID||'_X');
		end;
		EquityFlag='NotEquity';
		if pool="" then do;
		counterpartyID=ID;
		end;
		run;

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_LP,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_LP,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y1_S4);
		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_LP,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y1_S4);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_LP,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_LP,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y1_S4);
		data SAS_data.termloanbullet;
		set SAS_data.termloanbullet;
		numberEffective=100000;
		numberActual=numberEffective;
		run;
		
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\termloanbullet.csv"	
		dbms=csv
		replace;
		run;		

/*		%commonStock(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_LP,outdata=SAS_data.commonstock,quotationCurrency='SAR');*/
/*		Proc export data=SAS_data.commonstock*/
/*		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\commonstock.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/
/**/
/*		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_LP,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018');	*/
/*		Proc export data=SAS_data.equityAnalysisParameters*/
/*		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\equityAnalysisParameters.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018Y1S4 LargePools ICAAP");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_LP,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018Y1S4 LargePools ICAAP",ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

/*		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_ICAAP_Y1_S4_LP,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',ead_temp=EAD_2018);	*/
/*		Proc export data=SAS_data.instrumentPrice*/
/*		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\instrumentPrice.csv"	*/
/*		dbms=csv*/
/*		replace;*/
/*		run;*/

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y1\S4\ICAAP\LargePool\importasofDate.csv"	
		dbms=csv
		replace;
		run;

/*****************************************End - Access Shell for ICAAP Y1S4 LargePool portfolio*****************************************/	



/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/***************************************************************End - 2017 Scenario*************************************************/
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

