
		data SAS_DATA.FINAL_MIGRATION_RAROC;
		set SAS_DATA.FINAL_MIGRATION_RAROC;
		ID=compress(ID||'_RAROC_Jun18');
		CounterpartyID=compress(CounterpartyID||'_RAROC_Jun18');
		run;

		%counterparty(data=SAS_DATA.FINAL_MIGRATION_RAROC,outdata=SAS_data.counterparty);		
		Proc export data=SAS_data.counterparty
		outfile="&Output_Path.\Y0\RAROC\counterparty.csv"	
		dbms=csv
		replace;
		run;
		
		%counterpartyRsq(data=SAS_DATA.FINAL_MIGRATION_RAROC,outdata=SAS_data.CounterpartyRSquared,correlationModelEstimate=GCORR 2015,rsq=Rsq_Y0_actual);

		Proc export data=SAS_data.CounterpartyRSquared
		outfile="&Output_Path.\Y0\RAROC\CounterpartyRSquared.csv"	
		dbms=csv
		replace;
		run;
				
		%counterpartyPdsFlexible(data=SAS_DATA.FINAL_MIGRATION_RAROC,outdata=SAS_data.counterpartyPDsFlexible,beginDate='06/30/2018',term=1, pd=PD_Y0_Actual);
		Proc export data=SAS_data.counterpartyPDsFlexible
		outfile="&Output_Path.\Y0\RAROC\counterpartyPDsFlexible.csv"	
		dbms=csv
		replace;
		run;
		
		%covModelFactorCoeff(data=SAS_DATA.FINAL_MIGRATION_RAROC,outdata=SAS_data.covarianceModelFactorCoeff,WeightDate='06/30/2018',term=1,factorSetName='GCORR 2015');
		Proc export data=SAS_data.covarianceModelFactorCoeff
		outfile="&Output_Path.\Y0\RAROC\covarianceModelFactorCoefficient.csv"	
		dbms=csv
		replace;
		run;

		%termLoanBullet(data=SAS_DATA.FINAL_MIGRATION_RAROC,outdata=SAS_data.termloanbullet,instrumentCurrency='SAR',maturityDate='06/30/2019',prepayableFlag=0,interestTypeName='Fixed',fixedRateInterestFreq='Annual',lgd_temp=LGD_Y0_Actual);
		Proc export data=SAS_data.termloanbullet
		outfile="&Output_Path.\Y0\RAROC\termloanbullet.csv"	
		dbms=csv
		replace;
		run;

		%commonStock(data=SAS_DATA.FINAL_MIGRATION_RAROC,outdata=SAS_data.commonstock,quotationCurrency='SAR');
		Proc export data=SAS_data.commonstock
		outfile="&Output_Path.\Y0\RAROC\commonstock.csv"	
		dbms=csv
		replace;
		run;

		%equityAnalysisParameters(data=SAS_DATA.FINAL_MIGRATION_RAROC,outdata=SAS_data.equityAnalysisParameters,parametersDate='06/30/2018',lgd_temp=LGD_Y0_Actual,EAD_temp=EAD_2018);	
		Proc export data=SAS_data.equityAnalysisParameters
		outfile="&Output_Path.\Y0\RAROC\equityAnalysisParameters.csv"	
		dbms=csv
		replace;
		run;

		%portfolio(outdata=SAS_DATA.portfolio,portfolioName="Albilad Jun 2018 RAROC");
		Proc export data=SAS_DATA.portfolio
		outfile="&Output_Path.\Y0\RAROC\portfolio.csv"	
		dbms=csv
		replace;
		run;

		%portfolioDetail(data=SAS_DATA.FINAL_MIGRATION_RAROC,outdata=SAS_data.portfolioDetail,portfolioName="Albilad Jun 2018 RAROC", ead_temp=EAD_2018);
		Proc export data=SAS_data.portfolioDetail
		outfile="&Output_Path.\Y0\RAROC\portfolioDetail.csv"	
		dbms=csv
		replace;
		run;

		%instrumentPrice(data=SAS_DATA.FINAL_MIGRATION_RAROC,outdata=SAS_data.instrumentPrice,priceDate='06/30/2018',EAD_temp=EAD_2018);	
		Proc export data=SAS_data.instrumentPrice
		outfile="&Output_Path.\Y0\RAROC\instrumentPrice.csv"	
		dbms=csv
		replace;
		run;

		%importasOfDate(outdata=SAS_DATA.importasofDate,asOfDate='06/30/2018');		
		Proc export data=SAS_DATA.importasofDate
		outfile="&Output_Path.\Y0\RAROC\importasofDate.csv"	
		dbms=csv
		replace;
		run;
		
		/***********************************End - Access Shell for RAROC portfolio******************************************************************************/

