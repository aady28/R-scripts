		
		/********************************************************************************************/
		/*1.1 Define input path, input files and output path*/
		
		%let Input_path=C:\Users\AGGARWNI\Documents\BAB June runs\WIP\2. Access Shell Preparation and Codes\Input;
		%let Supple_data_path=C:\Users\AGGARWNI\Documents\BAB June runs\WIP\2. Access Shell Preparation and Codes\Input;
		%let equity_file_name= 2018 June - Equity;
		%let FI_file_name= 2018 June - Banks;
		%let NonRetail_file_name= 2018 June - Non_Retail;
		%let Retail_file_name= 2018 June - Retail;
		%let Output_path=C:\Users\AGGARWNI\Documents\BAB June runs\WIP\2. Access Shell Preparation and Codes\Output;
		%let Output_File=Raw_data_combined.csv;
		%let Output_File2=output2.csv;
		libname SAS_Data "C:\Users\AGGARWNI\Documents\BAB June runs\WIP\2. Access Shell Preparation and Codes";
		%let Analysis_Date ="30Jun2018"d;
/**/	%include "C:\Users\AGGARWNI\Documents\BAB June runs\WIP\2. Access Shell Preparation and Codes\Code\Access_Shell_Portfolio_macro.sas";
		/*******************************************************************************************/
		
		/*******************************************************************************************/
		
		/*1.2 Get time stamp*/
		%let timestamp=%sysfunc(datetime(),B8601DT.);
		
		/*Set options for log file*/
/**/	options nosource;
		options nosource2 nomlogic nonotes nomprint;
		
		/*Create log file*/
/*	proc printto log="&Output_Path.\log&timestamp..txt";*/
/*		run;*/
/*		*/
		proc printto log="&Output_Path.\log&timestamp..txt";
		run;
		/*******************************************************************************************/
		/****************************Start - Clear Existing SAS Data****************************************/
		
		
		
		/****************************End - Clear Existing SAS Data****************************************/
		
		/*******************************************************************************************/
		/*Start - load equity data*/
		
		  data SAS_data.equity;
/* $150*/ infile "&Input_Path.\&equity_file_name..csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		  format Portofolio_Flag $150.;format CIF $150.;format Main_CIF $150.;format Contract_refer $150.;format Country $150.;format Rating $150.;format Product_Type $150.;format Deal_Type $150.;format Category $150.;format Category_Descritpion $150.;format Principle_SAR BEST32.;format Exposure_in_SAR BEST32.;format Value_Date $150.;format Maturity_Date $150.;format Rate BEST32.;format Basel_Asset_Class $150.;format MPR_Level_1 $150.;format MPR_Level_2 $150.;
		  Input Portofolio_Flag $  CIF $  Main_CIF $  Contract_refer $  Country $  Rating $  Product_Type $  Deal_Type $  Category $  Category_Descritpion $  Principle_SAR   Exposure_in_SAR   Value_Date $  Maturity_Date $  Rate   Basel_Asset_Class $  MPR_Level_1 $  MPR_Level_2 $                                
		  ; run;


		/*check sum of principal, exposure and outstanding balance*/
		proc sql;
		create table sas_data.test as
		select portofolio_flag, sum(Principle_SAR) as principle, sum(Exposure_in_SAR) as Exposure,sum(rate) as sum_rate from SAS_data.Equity group by portofolio_flag;
		quit;

		/*End - load equity data*/
		/*************************************************************************************************/
		
		/*************************************************************************************************/
		/*Start - load FI data*/
/*		*/
		data SAS_data.FI;
		infile "&Input_Path.\&FI_file_name..csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		format Portofolio_Flag $150.;format CIF $150.;format Main_CIF $150.;format Contract_refer $150.;format Country $150.;format External_Rating $150.;format Agency $150.;format Segment $150.;format Product_Type $150.;format Deal_Type $150.;format Category $150.;format Category_Descritpion $150.;format Principle_SAR BEST32.;format Exposure_in_SAR BEST32.;format Value_Date $150.;format Maturity_Date $150.;format Rate BEST32.;format Basel_Asset_Class $150.;format MPR_Level_1 $150.;format MPR_Level_2 $150.;
		Input Portofolio_Flag $  CIF $  Main_CIF $  Contract_refer $  Country $  External_Rating $  Agency $  Segment $  Product_Type $  Deal_Type $  Category $  Category_Descritpion $  Principle_SAR   Exposure_in_SAR   Value_Date $  Maturity_Date $  Rate   Basel_Asset_Class $  MPR_Level_1 $  MPR_Level_2 $                          
		; run;
		
		/*check sum of principal, exposure and outstanding balance*/
		proc sql;
		create table sas_data.test as
		select Portofolio_flag,sum(Principle_SAR) as Principle, sum(Exposure_In_SAR) as Exposure, sum(rate) as sum_rate from SAS_data.FI group by portofolio_flag;
		quit;
;		
		/*End - load FI data*/
		/*************************************************************************************************/
		
		/*************************************************************************************************/
		/*Start - load NonRetail data*/
		data SAS_data.NonRetail;
		infile "&Input_Path.\&NonRetail_file_name..csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		format Portofolio_Flag $150.;format CIF $150.;format Main_CIF $150.;format Contract_refer $150.;format Country $150.;format Rating $150.;format Segment $150.;format NAICS_Code $150.;format NAICs_Description $150.;format Product_Type $150.;format Deal_Type $150.;format Category $150.;format Category_Descritpion $150.;format Principle_SAR BEST32.;format Exposure_in_SAR BEST32.;format Value_Date $150.;format Maturity_Date $150.;format Rate BEST32.;format Basel_Asset_Class $150.;format MPR_Level_1 $150.;format MPR_Level_2 $150.;
		Input Portofolio_Flag $  CIF $  Main_CIF $  Contract_refer $  Country $  Rating $  Segment $  NAICS_Code $  NAICs_Description $  Product_Type $  Deal_Type $  Category $  Category_Descritpion $  Principle_SAR   Exposure_in_SAR   Value_Date $  Maturity_Date $  Rate   Basel_Asset_Class $  MPR_Level_1 $  MPR_Level_2 $                       
		; run;
		
		data numberrating;
		infile "&Input_Path.\numberratingtoexternalrating.csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		format Grade $150.; format External_Rating $150.;
		Input Grade $ External_Rating $;
		run;
		
		data nonretail;
		set SAS_data.NonRetail;
		format nr_ID $15.;
		nr_ID=compress('ID'||substr(compress(put((100000000+_n_),best12.)),2,12));
		if Rating = "A" then
		Rating = "A2";
		run;
		
		proc sql;
		create table NonRetail1 as select a.*,b.Grade from NonRetail a left join numberrating b
		on a.Rating = b.External_Rating
		order by nr_ID ;
		quit;
		
		proc sql;
		create table test as select * from nonretail1 where
		Grade ne '';
		quit;
		
		data SAS_data.NonRetail;
		set NonRetail1;
		if Grade <> "" then
		rating = Grade;
		drop Grade nr_ID;
		run;
/**//*what* is being checked*/
		/*check sum of principal, exposure and outstanding balance*/
		proc sql;
		create table sas_data.test as
		select count(CIF) as nrow, portofolio_flag,sum(Principle_SAR) as Principle,sum(Exposure_in_SAR) as exposure, sum(rate) as sum_rate from SAS_data.NonRetail group by portofolio_flag;
		quit;
				
		/*End - load NonRetail data*/
		/*************************************************************************************************/
		
		/*************************************************************************************************/
		/*Start - load Retail data*/
		
		data SAS_data.Retail;
		infile "&Input_Path.\&Retail_file_name..csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		format Portofolio_Flag $150.;format CIF $150.;format Main_CIF $150.;format Contract_refer $150.;format Country $150.;format Segment $150.;format Industry $150.;format Sector $150.;format Product_Type $150.;format Deal_Type $150.;format Category $150.;format Category_Descritpion $150.;format Principle_SAR BEST32.;format Exposure_in_SAR BEST32.;format Value_Date $150.;format Maturity_Date $150.;format Rate BEST32.;format Basel_Asset_Class $150.;format MPR_Level_1 $150.;format MPR_Level_2 $150.;
		Input Portofolio_Flag $  CIF $  Main_CIF $  Contract_refer $  Country $   Segment $  Industry $ Sector $ Product_Type $  Deal_Type $  Category $  Category_Descritpion $  Principle_SAR   Exposure_in_SAR   Value_Date $  Maturity_Date $  Rate   Basel_Asset_Class $  MPR_Level_1 $  MPR_Level_2 $       
		;  run;

		/*check sum of principal, exposure and outstanding balance*/
		proc sql;
		create table sas_data.test as
		select portofolio_flag,sum(Principle_SAR) as Principle, sum(Exposure_in_SAR) as Exposure,sum(rate) as sum_rate from SAS_data.Retail group by portofolio_flag;
		quit;
		
		/*End - load Retail data*/
		/*************************************************************************************************/
				
		/*************************************************************************************************/
		/*Merge all the dataset*/
			 data SAS_data.Raw_data;
			 set SAS_data.equity SAS_data.NonRetail SAS_data.Retail SAS_data.FI;
			 format InstrumentID $15.;
/*Best12*/   InstrumentID=compress('ID'||substr(compress(put((100000000+_n_),best12.)),2,12)||'_'||substr(Portofolio_flag,1,2));
		     run;

		proc means data = SAS_data.Raw_data;
		class Portofolio_Flag;
		output out = sas_data.totexp sum(Exposure_in_SAR)=;
		run;
		
		data check;
		set SAS_data.Raw_data;
		if Principle_SAR eq .;
		run;
		
		
		data SAS_data.Raw_data;
		set SAS_data.Raw_data;
		if Principle_SAR eq . then Principle_SAR = 0;
		run; 

	/* Checking for Liabilities (Positive Exposure) */
		data check;
		set SAS_data.Raw_data;
		if Principle_SAR > 0 ;
		run; 
	
	/* Deleting Liabilities (Positive Exposure) */
		data SAS_data.Raw_data;
		set SAS_data.Raw_data;
		if Principle_SAR > 0 then delete;
		run; 
		
		data SAS_data.Raw_data;
		set SAS_data.Raw_data;
		if Principle_SAR < 0 then do;
		Principle_SAR1=Principle_SAR*(-1);
		Exposure_in_SAR1=Exposure_in_SAR*(-1);
		end;
		drop Principle_SAR Exposure_in_SAR;
		rename Principle_SAR1=Principle_SAR; 
		rename Exposure_in_SAR1 = Exposure_in_SAR;
		run; 
		
		/*Export the merged data with unique identifier*/
			proc export data=SAS_data.Raw_data
		    outfile="&Output_Path.\&output_file."
		    dbms=csv
		    replace;
			run;

        proc means data = sas_data.Raw_data nway noprint;
		class Portofolio_Flag;
		output out = sas_data.totexp sum(Exposure_in_SAR) = ;
		run;
		
		/*Create Transit_Data1 on which Data Processing Steps will be performed*/
		data SAS_data.Transit_Data1;
		set SAS_data.Raw_data;
		run;
				
		/*****************************************************************************************************************/

		/*****************************************************************************************************************/

/**/	%macro countobs(TableName);
			data _null_;
				set &TableName. nobs=n;
				call symputx("n_Final_migration",trim(left(put(n,8.))));
				stop;
			run;
			
			%put "&TableName. has &n_Final_migration. observations.";
		
		%mend countobs;
		
		%countobs(SAS_data.equity);
		%countobs(SAS_data.fi);
		%countobs(SAS_data.NonRetail);
		%countobs(SAS_data.Retail);
		%countobs(SAS_data.Raw_data);
		
		%put "The concatenation is completed.";
		
		
/*/*		/*To reset the destination for the SAS log and procedure output to the default, use the PROC PRINTTO statement without options.*/
		proc printto;
		run;
		/*****************************************************************************************************************/

		
		/***********************************************************************************************************************/
		/******************************2. Start - Append qualitative information to Raw Data**************************************/
		/***********************************************************************************************************************/
		
		/************************2.1 start-create EquityFlag and MutualFundFlag *********************/
		
		/*Check number of equity in merged data*/

proc freq data = SAS_data.Transit_Data1;
tables product_type;
run;

		Data SAS_data.Transit_Data2;
	    Set SAS_data.Transit_Data1;
	    format EquityFlag $20.;
	    format MutualFundFlag $20.;
	    EquityFlag = "NotEquity";
	    if upcase(Portofolio_flag) eq "EQUITY" then do;
		    EquityFlag = "Equity";
	    end;
	    MutualFundFlag = "NotMF";
	    if upcase(Product_Type) eq "MF" then do;
		    MutualFundFlag = "MF";
	    end;
		run;


		/*check balance of equity and MF with deal_type_freq table*/
		proc sql;
		create table sas_data.test as
		select EquityFlag,sum(Principle_SAR) as Principle, sum(Exposure_in_SAR) as Exposure from SAS_data.Transit_Data2 group by EquityFlag;
		quit;

		proc sql;
		create table sas_data.test as
		select MutualFundFlag,sum(Principle_SAR) as Principle, sum(Exposure_in_SAR) as Exposure from SAS_data.Transit_Data2 group by MutualFundFlag;
		quit;

		/*check count of equity and MF with deal_type_freq table*/

		/************************2.1 End-create EquityFlag ***********************/		
		
		/************************2.2 Start - Transform StartDate(ValueDate) and MaturityDate********/
		
		data SAS_data.Transit_Data2;
    	Retain InstrumentID StartDate MaturityDate;
    	set SAS_data.Transit_Data2 ;
       	format StartDate ddmmyy10. MaturityDate ddmmyy10.;
       	informat StartDate ddmmyy10. MaturityDate ddmmyy10.;   
/**/   	ID=InstrumentID;	
		    StartDate=mdy(scan(Value_Date,2,"/"),scan(Value_Date,1,"/"),scan(Value_Date,3,"/"));
		    MaturityDate=mdy(scan(Maturity_Date,2,"/"),scan(Maturity_Date,1,"/"),scan(Maturity_Date,3,"/"));
	    drop ID Value_Date Maturity_Date;	    
    	run;
		
		data check;
		set SAS_data.Transit_Data2;
		if StartDate eq . or MaturityDate eq . ;
		run;
		
		
		/************************End - Transform StartDate(ValueDate) and MaturityDate********/
		/************************2.2 start-create BankFlag ***********************/

        proc freq data =  SAS_data.Transit_Data2 noprint;
        tables portofolio_flag /out = portfolio_check;
        run;
 
		Data SAS_data.Transit_Data2;
	    Set SAS_data.Transit_Data2;
	    format BankFlag $20.;
	    BankFlag = "NotBank";
	    if upcase(portofolio_flag) eq "BANK (FI)" then do;
		    BankFlag = "Bank";
	    end;
		run;

		proc sql;
		create table sas_data.test as
		select BankFlag,sum(Principle_SAR) as Principle, sum(Exposure_in_SAR) as Exposure from SAS_data.Transit_Data2 group by BankFlag;
		quit;
		
		/************************2.2 End-create BankFlag **************************/	

		/************************2.3 Start - Create Category Retail/NonRetail******/
		
		/****Assign NonRetail Category**********/
		data SAS_data.Transit_Data2;
		format retail_vs_nonretail $150.;
		set SAS_data.Transit_Data2;
		retail_vs_nonretail='Non Retail';
		if portofolio_flag = 'Retail' then do;
		retail_vs_nonretail='Retail';
		end;
		run;
	
		proc sql;
		create table sas_data.test as
		select retail_vs_nonretail,sum(Principle_SAR) as Principle, sum(Exposure_in_SAR) as Exposure from SAS_data.Transit_Data2 group by retail_vs_nonretail;
		quit;
		
		
/*		*/
		/*	start-set exception Category=16711 and portfolio=non Retail*/
		data SAS_data.Transit_Data2;
		set SAS_data.Transit_Data2;
		if portofolio_flag='Non Retail' and category='16711' then do;
			retail_vs_nonretail='Non Retail';
		end;
		run;			
		
/*		proc sql;*/
/*		create table SAS_data.test as*/
/*		select a.* from SAS_DATA.TRANSIT_DATA3 a where category='90002';*/
/*		quit;*/
		
		proc sql;
		create table sas_data.test as
		select retail_vs_nonretail,sum(Principle_SAR) as Principle, sum(Exposure_in_SAR) as Exposure from SAS_data.Transit_Data2 group by retail_vs_nonretail;
		quit;


		/************************2.3 End - Create Category Retail/NonRetail*********/

		/************************2.4 start-create CounterpartyID *******************/
		
		data check;
		set SAS_data.Transit_Data2;
		if Main_CIF eq "";
		run;
		
		Data SAS_data.Transit_Data2;
	    Set SAS_data.Transit_Data2;
	    format CounterpartyID $50.;
	    CounterpartyID = CIF;
	    if Main_CIF ne "" then do;
		    CounterpartyID = Main_CIF;
	    end;
		run;


		/************************2.4 End-create CounterpartyID ********************/		

		/************************2.5 Start - Create Pool *********************/
		/*****check sectors present in data*/
		proc freq data=SAS_data.Transit_Data2 ;
		table sector*retail_vs_nonretail/ missing  norow nocol nocum nopercent;
		run;
		
		proc sql;
		create table test1 as
		select count(Exposure_in_SAR) as count from sas_data.Transit_data2
		where Exposure_in_SAR eq . ;
		quit;
		
		/**********update sector***********/
		data SAS_data.Transit_Data2;
		set SAS_data.Transit_Data2;
		format sector_updated $150.;
		if upcase(sector) ne 'INDIVIDUAL GOVERNEMENT EMPLOYEES'  then do;
			sector_updated='Other';
		end;
		if upcase(sector)='INDIVIDUAL GOVERNEMENT EMPLOYEES'  then do;
			sector_updated='IGE';
		end;
		run;
		
		proc freq data=SAS_DATA.TRANSIT_DATA2;
		table sector*sector_updated/norow nocol nocum nopercent;
		run;
		
		/**********load pool info**********/
		%let pool_info = pool info;
		
		data SAS_DATA.Pool_Info;
		infile "&Supple_data_path.\&pool_info..csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		format Retail_vs_NonRetail $150.; format Sector $150.; format Mortgage_Flag $150.; format Pool $150.;
		Input Retail_vs_NonRetail $ Sector $  Mortgage_Flag $ Pool $;  
		run;
		
		/******Create Pool based on Category,Sector and Mortgage*****/
		
		proc freq data = SAS_DATA.TRANSIT_DATA2;
		tables product_type/out = check;
		run;
		
		data SAS_DATA.TRANSIT_DATA2;
		set SAS_DATA.TRANSIT_DATA2;
		if upcase(Product_Type) = "MORTGAGE" then mortgage_flag='Yes';
		if upcase(Product_Type) in ("NON-MORTGAGE","NON MORTGAGE") then mortgage_flag='No';
		run;
		
		data SAS_DATA.TRANSIT_DATA2;
		set SAS_DATA.TRANSIT_DATA2;
		if upcase(Product_Type) = "YES" then mortgage_flag='Yes';
		if upcase(Product_Type) in ("NO") then mortgage_flag='No';
		run;
		
		
		
		proc freq data = SAS_DATA.TRANSIT_DATA2;
		tables Product_Type*mortgage_flag ;
		run;
		
		proc sql;
		create table SAS_data.Transit_Data2 as
		select a.* , b.Pool
		from SAS_data.Transit_Data2 a
		left join SAS_data.POOL_INFO b
		on a.Retail_vs_NonRetail=b.Retail_vs_NonRetail
		and a.sector_updated=b.sector
		and upper(a.mortgage_flag)=upper(b.mortgage_flag)
		order by InstrumentID;
		quit;

		proc freq data=SAS_DATA.TRANSIT_DATA2;
		table Pool*Retail_vs_Nonretail Mortgage_flag/norow nocol nocum nopercent;
		run;
	
		
		/********overrule pool for special category********/
		%let overrule_pool=overrule_pool;
		
		/***************load special pool***********/
		data SAS_data.Overrule_Pool;
		infile "&Supple_data_path.\&overrule_pool..csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		format category $150.; format pool_1 $150.;
		Input category $ pool_1 $;  
		run;

/*		proc sql;*/
/*		create table SAS_data.test as*/
/*		select a.* from SAS_DATA.TRANSIT_DATA3 a where category='90001';*/
/*		quit;*/
/*		*/
		proc sql;
		create table SAS_data.Transit_Data2 as
		select a.* , b.pool_1 from SAS_data.Transit_Data2 a
		left join SAS_data.overrule_pool b
		on a.category=b.category
		order by InstrumentID;
		quit;
		
/*[wrong]proc sql;
		create table SAS_data.testt1 as	
		select *
		from SAS_data.Transit_Data2 as D1, SAS_data.overrule_pool as D2
		left join SAS_data.overrule_pool
		on D1.category = D2.category
		order by InstrumentID;
		run;
			
*/		
		data SAS_data.Transit_Data2;
		set SAS_data.Transit_Data2;
		if pool_1 ne "" then do;
		pool=pool_1;
		end;
		drop pool_1;
		run;				
		
		proc sql;
		create table sas_data.test as
		select a.* from SAS_DATA.TRANSIT_DATA2 a where a.category='16301';
		quit;
		
		
		/************Set pool manually	*/
		data SAS_data.Transit_Data2;
		set SAS_data.Transit_Data2;
		if lowcase(Retail_vs_NonRetail)='non retail' and category='16711' then do;
		pool='Overdrawn Accounts FCY';
		end;		
		if lowcase(Retail_vs_NonRetail)='non retail' and category='16301' and lowcase(MPR_Level_2)='corporate banking' then do;
		pool='Musharakah Bank Share Corporate';
		end;
		if lowcase(Retail_vs_NonRetail)='non retail' and category='16301' and lowcase(MPR_Level_2)='business banking' then do;
		pool='Musharakah Bank Share Business';
		end;
		run;

		/*****Verify pool and retail/nonretail mapping**********/
		proc freq data=sas_Data.Transit_data2;
		tables pool*retail_vs_nonretail/missing norow nocol nopercent;
		run;
		
		/******validate special pool obligors*/
		data sas_data.temp;
		set sas_data.transit_data2(where=(category in ('90000','90001','90002','16711','16301')));
		run;
		
		proc datasets library=Sas_Data;
		delete temp;
		run;
		
		/************************2.5 End-Create Pool ***********************************************/		
		
		/***********************2.6 Start - Create Number of PoolObligors***************************/
		
		/*Load SpecialPoolObligors*/
		%let Spc_pool=SpecialPoolObligors;
		
		data SAS_Data.Spc_Pool_obl;
		infile "&Supple_data_path.\&Spc_pool..csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		format pool $150.; format poolobligors $150.;
		Input pool $ poolobligors $;  
		run;
				
		/*********Append Count of PoolObligors******/
		proc sql;
		create table SAS_data.pool_obl as 	
		select Retail_vs_NonRetail,pool,count(InstrumentID)as count_obl from SAS_data.Transit_Data2
		group by Retail_vs_NonRetail,pool
		order by Retail_vs_nonretail,pool;
		quit;
		
		proc sql;
		create table SAS_data.Transit_Data2 as
		select a.*, b.count_obl 
		from SAS_data.Transit_Data2 a
		left join SAS_data.Pool_Obl b
		on a.pool=b.pool;
		quit;
		
		/****************Update count for specialPoolObligors*************/
		proc sql;
		create table SAS_data.Transit_Data2 as
		select a.*, b.poolobligors 
		from SAS_data.Transit_Data2 a
		left join SAS_data.Spc_Pool_Obl b
		on a.pool=b.pool;
		quit;
		
		/******validate total count for pools*/
		proc sql;
		create table SAS_data.temp as 	
/**/	select Retail_vs_NonRetail,pool,min(count_obl)as count_obl,min(poolobligors) as spc_pool_obl from SAS_data.Transit_Data2
		group by Retail_vs_NonRetail,pool
		order by Retail_vs_nonretail,pool;
		quit;
		
		proc datasets library=Sas_Data;
		delete temp;
		run;		
		/***********************2.6 End - Create Number of PoolObligors***************************/
		
/*added by Nishant*/
/*Update Start date and maturity date		*/
proc sql ;
create table test as select * from SAS_data.Transit_Data2 where StartDate = .;
quit;
/*15585*/

/*seting default start date as 31/12/2017*/

proc sql;
create table check as select * from SAS_data.Transit_Data2 where StartDate = "31Dec2017"d;
quit;
/*213*/

data SAS_data.Transit_Data2;
set SAS_data.Transit_Data2;
if StartDate = . then
StartDate = "31Dec2017"d;
run;

proc sql;
create table check as select * from SAS_data.Transit_Data2 where StartDate = "31Dec2017"d;
quit;
/*15798 */

proc sql ;
create table test as select * from SAS_data.Transit_Data2 where MaturityDate = .;
quit;
/*15583*/

proc sql;
create table test as select * from SAS_data.Transit_Data2 where 
MaturityDate = . and Pool ne "";
quit;
/*15001*/

proc sql;
create table test1 as select * from SAS_data.Transit_Data2 where 
MaturityDate = . and Pool = "";
quit;
/*582*/

data SAS_data.Transit_Data2;
set SAS_data.Transit_Data2;
if MaturityDate = . and Pool = "IGE Mortgage" then
MaturityDate = StartDate+10*365+2;
if MaturityDate = . and Pool = "IGE Non-Mortgage" then
MaturityDate = StartDate+5*365+1;
if MaturityDate = . and Pool = "Other Mortgage" then
MaturityDate = StartDate+10*365+2;
if MaturityDate = . and Pool = "Other Non-Mortgage" then
MaturityDate = StartDate+5*365+1;
if MaturityDate = . and Pool = "" then
MaturityDate = StartDate+3*365+1;
run;

proc sql;
create table test as select * from SAS_data.Transit_Data2 where 
MaturityDate = . or StartDate = .;
quit;

/*End setting default start dates and maturity dates*/


				/***********************2.7 Start - Create RF Industry************************************/
		
		/*load NAICS & T24 to Industry mapping*/
		%let NAICS_map=NAICS mapping 2014;
		%let Industry_T24=Industry_T24;

		data SAS_data.NAICS_MAP;
		infile "&Supple_data_path.\&NAICS_map..csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		format NAICS_Code $150.; format RF_Industry $150.;
		Input NAICS_Code $ RF_Industry $ ;  
		run;
		
		data SAS_data.Industry_T24;
		infile "&Supple_data_path.\&Industry_T24..csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		format Industry $150.; format Description $150.; format RiskFrontier_Industry $150.; 
		Input Industry $ Description $ RiskFrontier_Industry $;  
		run;
		
		/*Merge NAICS Industry with client data*/
		proc sql;
		create table SAS_data.Transit_Data2 as
		select a.* , b.RF_Industry from SAS_data.Transit_Data2 a
		left join SAS_data.NAICS_MAP b
		on a.NAICS_Code=b.NAICS_Code
		order by InstrumentID;
		quit;
		
		/*Merge T_24 Industry with client data*/
		proc sql;
		create table SAS_data.Transit_Data2 as
		select a.* , b.RiskFrontier_Industry from SAS_data.Transit_Data2 a
		left join SAS_data.Industry_T24 b
		on a.Industry=b.Industry
		order by InstrumentID;
		quit;
		
		/*Combine RF_Industry*/
		data SAS_data.Transit_Data2;
		set SAS_data.Transit_Data2;
		format RF_Industry1 $150.;
		RF_Industry1=RF_Industry;
		if RF_Industry="" then do;
		RF_Industry1=RiskFrontier_Industry;
		end;
		drop RF_Industry;
		rename RF_Industry1=RF_Industry;
		run;
		
		/*Create RF Industry for Retail category & Bank*/
		data SAS_data.Transit_Data2;
		set SAS_data.Transit_Data2;
		if Retail_vs_NonRetail='Retail' then do;
			RF_Industry='Retail';
		end;
		if portofolio_flag='BANK (FI)' then do;
			RF_Industry='BANKS AND S&LS';
		end;
		if RF_Industry="" then do;
			RF_Industry="MISCELLANEOUS";
		end;
		run;
		
		proc means data=SAS_DATA.TRANSIT_DATA2 sum nmiss;
		var Exposure_In_SAR;
		class retail_vs_nonretail RF_Industry;
		run;
		
		proc freq data=SAS_DATA.TRANSIT_DATA2;
		table RF_Industry*Retail_vs_NonRetail/nocum norow nocol nopercent;
		run;
		
		/*****************************2.7 End-Create RF Industry***********************/
		
		/*****************************2.8 Start - append Country code *****************/
		/****Extract unique countries reported in data*/
		proc freq data=SAS_DATA.TRANSIT_DATA2;
		table country*Retail_vs_NonRetail/nocum norow nocol nopercent;
		run;
			
		%let country_code=country_code;
	
		proc import datafile="&Supple_data_path.\&country_code..csv" out=SAS_data.country_code
		dbms=csv
		replace;
/**/	guessingrows= 20000;
		run;
		
		proc sort data=	SAS_DATA.COUNTRY_CODE noduprec;
		by country;
		run;
		
		proc sql;
		create table SAS_data.Transit_Data2 as
		select a.* , b.CountryCode
		from SAS_data.Transit_Data2 a 
		left join SAS_data.country_code b
/**/	on trim(lower(a.country))=trim(lower(b.country)) 
		order by InstrumentID;
		quit;
		
		proc sql;
		create table sas_data.test as
		select countrycode,retail_vs_nonretail,sum(Principle_SAR) as Principle, sum(Exposure_in_SAR) as Exposure from SAS_data.Transit_Data2 group by countrycode,retail_vs_nonretail;
		quit;

		/*****check CounterpartyID is associated with single country*/
		proc sql;
		create table SAS_data.temp as
		select CounterpartyID, countrycode, count(counterpartyID) as count from SAS_data.Transit_data2
		group by counterpartyID, countrycode
		order by count;
		quit;
		
		proc sql;
		create table SAS_data.temp as
		select a.*, count(counterpartyID) as count_country 
		from  SAS_DATA.TEMP a
		group by counterpartyID;
		quit;
		
		proc sql;
		create table SAS_data.temp as
		select * from SAS_DATA.TRANSIT_DATA2 where counterpartyID='0';
		quit;
		
		/*****************************2.8 End - append Country code *******************/
		
		/*****************************2.9 Load Retail RF Industry**********************/			
		%let Retail_Industry=Retail_Industry;
	
		proc import datafile="&Supple_data_path.\&Retail_Industry..csv" out=SAS_data.Retail_Industry
		dbms=csv
		replace;
		guessingrows= 20000;
		run;
		
		Proc export data=SAS_Data.Transit_data2
		outfile="&Output_Path.\Transit_data2.csv"	
		dbms=csv
		replace;
		run;

		
		/***********************************************************************************************************************/
		/******************************2. End - Append qualitative information to Raw Data**************************************/
		/***********************************************************************************************************************/
		
		
		
		/***********************************************************************************************************************/
		/******************************3. Start - Append quantitative information to Raw Data***********************************/
		/***********************************************************************************************************************/
		
		/************************3.1 Start-combine EAD ***********************************/
		
	
		/*	Combine EAD*/
		data SAS_data.Transit_Data3;
		set SAS_data.Transit_Data2;
		Principle=Principle_SAR;
		EAD=Exposure_in_SAR;
		if Portofolio_Flag in ("BANK (FI)") then do;
/**/		Principle=Principle_SAR;
		end;
		run;		
		/*******Verify EAD by portofolio*********/
		proc sql;
		create table sas_data.temp as
		select portofolio_flag,sum(Principle) as sum_principle,sum(EAD)as sum_EAD  from SAS_data.Transit_data3 group by Portofolio_flag;
		quit;

		/************************3.1 End-combine EAD ***********************************/		

		/************************3.2 start-remove zero EAD or defaulted deals *********************/

		/********Save deal to be removed*************/

		Proc sql;
		create table SAS_data.defaulted_or_zeroEAD_instrument as
		select * from SAS_DATA.TRANSIT_DATA3 
		where 		(EAD=0 or EAD=.);
		quit;

		proc export data=SAS_data.defaulted_or_zeroEAD_instrument
		    outfile="&Output_Path.\def_instrumentsv2.csv"
		    dbms=csv
		    replace;
		run;

		Proc sql;
		create table SAS_data.Transit_Data3 as
		select * from SAS_DATA.TRANSIT_DATA3 
		where (EAD<>0 and EAD <> .);
		quit;

		
		proc sql;
		create table sas_data.temp as
		select portofolio_flag, sum(Principle) as Principle,sum(EAD)as sum_EAD from SAS_data.Transit_Data3 group by Portofolio_flag;
		quit;
		
		
		/************************3.2 End-remove zero EAD and defaulted deals ***********************/		
		
		/************************3.3 start - Update rate********************************************/
		
/**//*	RATIO CHECKS */
	
		/*validate that rate is correctly loaded*/
		proc sql;
		create table SAS_data.test as
		select sum(rate) from sas_data.NonRetail;
		quit;
		
	
		/*adjust  rate on same scale*/
		data SAS_data.Transit_Data3;
		set SAS_data.Transit_Data3;
		format adj_rate best32.;
	    adj_rate=rate*0.01;
		run;
		
		proc sql;
		create table SAS_data.temp as
		select portofolio_flag, sum(adj_rate) as sum_adj_rate from SAS_DATA.TRANSIT_DATA3 group by portofolio_flag;
		quit;
		
		/************Create fallback rate for Retail/NonRetail Portfolio*****/
		proc sql;
        create table SAS_data.avg_int as
/**/    select Retail_vs_NonRetail, sum(case when adj_rate not in (.,0) then adj_rate*EAD end)/sum(case when adj_rate not in (.,0) then EAD end) as avg_rate
        from SAS_data.Transit_Data3
        group by Retail_vs_NonRetail;
        quit;
              
        /***********Assign fallback rate to instruments with missing rate***/      
/*		Check if mutual fund doesn't have rate reported in data        */
        
        proc sql;
        create table SAS_data.Transit_Data3 as
        select a.* , b.avg_rate from SAS_data.Transit_Data3 a
        left join SAS_data.AVG_INT b
        on a.Retail_vs_NonRetail=b.Retail_vs_NonRetail
        order by InstrumentID;
        quit;
		
			
		data SAS_data.Transit_Data3;
		set SAS_data.Transit_Data3;
		format temp_rate best32.;
		temp_rate=adj_rate;
		if adj_rate=. then do;
		temp_rate=avg_rate;
		end;
		drop adj_rate;
		rename temp_rate=adj_rate;
		run;
	
		proc sql;
		create table SAS_data.temp as
		select sum(adj_rate) as sum_adj_rate from SAS_DATA.TRANSIT_DATA3;
		quit;
		
		/************************3.3 End - Update rate********************************************/
						
		/************************3.4 Start - PD **********/

		%let PD_map=PD_map_ICAAP;
	
		proc import datafile="&Supple_data_path.\&PD_map..csv" out=SAS_data.PD_map
		dbms=csv
		replace;
		guessingrows= 20000;
		run;
		
/**//* rating_upd */		
		data SAS_data.Transit_Data3;
		set SAS_data.Transit_Data3;
		format rating_upd $150.;
		if Retail_vs_NonRetail="Retail" then do;
		rating_upd=Pool;
		end;		
		if Retail_vs_NonRetail="Non Retail" then do;
		rating_upd=rating;
		end;
		if Portofolio_flag="BANK (FI)" then do;
		rating_upd=External_Rating;
		end;
		if Portofolio_flag="EQUITY" then do;
		rating_upd=Rating;		
		end;
		run;
		
		proc freq data=SAS_DATA.NONRETAIL; 
		table Rating/nocol norow nopercent nocum;
		run;
				
		proc freq data=SAS_DATA.EQUITY; 
		table Rating/nocol norow nopercent nocum;
		run;

		proc freq data=SAS_DATA.FI; 
		table External_Rating/nocol norow nopercent nocum;
		run;

		proc freq data=SAS_DATA.Transit_data3; 
		table Rating_upd/nocol norow nopercent nocum;
		run;

		/*Assign rating 5b */
		data SAS_data.Transit_Data3;
		set SAS_data.Transit_Data3;
		rating_upd1=rating_upd;
/**/	if Retail_vs_NonRetail='Non Retail' and UPCASE(rating_upd) in ('','UNRATED') then do;
		rating_upd1='NonRetailFallback';
		end;
/**/	if Portofolio_flag='BANK (FI)' and UPCASE(rating_upd) in ("",'UNRATED',"#N/A","N/A") then do;
		rating_upd1='BankFallback';
		end;
		run;

		proc freq data=SAS_DATA.Transit_Data3; 
		table rating_upd1/nocol norow nopercent nocum;
		run;
				
		proc sql;
		create table SAS_data.Transit_Data3 as
		select a.* , b.PD_Rating  from SAS_data.Transit_Data3 a 
		left join  SAS_data.PD_map b
		on upcase(a.Rating_upd1)=upcase(b.PD_Rating)
		order by InstrumentID;
		quit;
		
		data SAS_data.Transit_Data3;
		set SAS_data.Transit_Data3;
		if PD_Rating="" and Retail_vs_NonRetail='Retail' then do;
		rating_upd1='Other Non-Mortgage' ;
		end;
		if Retail_vs_NonRetail='Non Retail' and PD_Rating="" then do;
		rating_upd1='NonRetailFallback';
		end;
		drop PD_Rating;
		run;
		
		proc sql;
		create table SAS_data.Transit_Data3 as
		select a.* , b.*
		from SAS_data.Transit_Data3 a left join  SAS_data.PD_map b
		on upcase(a.Rating_upd1)=upcase(b.PD_Rating)
		order by InstrumentID;
		quit;

		proc sql;
		create table sas_data.temp as
		select avg(PD_Y0_actual) as avg_pd,sum(PD_Y0_actual) as sum_pd from sas_data.Transit_data3;
		quit;
				
		/************************3.4 End - append PD **********/
		

		/************************3.5 Start - append LGD **********/
		
		%let LGD_map=LGD_map_ICAAP;
	
		/***********load supplementary file for LGD************/
		proc import datafile="&Supple_data_path.\&LGD_map..csv" out=SAS_data.LGD_map
		dbms=csv
		replace;
		guessingrows= 20000;
		run;
		
/*	Applying cap and floor to lgd*/

/*		data SAS_data.LGD_map;*/
/*		set SAS_data.LGD_map;*/
/*		if LGD = "Non Retail" then do;*/
/*		if LGD_Y0_actual >0.6 then do; */
/*		LGD_Y0_actual  = 0.6;*/
/*		end;*/
/*		if LGD_Y0_actual <0.5 then do; */
/*		LGD_Y0_actual  = 0.5;*/
/*		end;*/
/*		*/
/*		if LGD_Y1_Base >0.6 then do; */
/*		LGD_Y1_Base  = 0.6;*/
/*		end;*/
/*		if LGD_Y1_Base <0.5 then do; */
/*		LGD_Y1_Base  = 0.5;*/
/*		end;*/
/*		end;*/
/*		run;*/
/*		*/
/*		%macro LGD_floor();*/
/*		%do i=1 %to 4;*/
/*		data SAS_data.LGD_map;*/
/*		set SAS_data.LGD_map;*/
/*		if LGD = "Non Retail" then do;*/
/*		if LGD_Y1_S&i. > 0.6 then do;*/
/*		LGD_Y1_S&i. = 0.6;*/
/*		end;*/
/*		if LGD_Y1_S&i. <0.5 then do;*/
/*		LGD_Y1_S&i.  = 0.5;*/
/*		end;*/
/*		end;*/
/*		%end;*/
/*		run;*/
/*		%mend LGD_floor();*/
/*		*/
/*		%LGD_floor();*/
/*		*/
/*		*/
/*		*/
				
	
		data SAS_data.Transit_Data3;
		set SAS_data.Transit_Data3;
		format LGD_Portfolio $150.;
		LGD_Portfolio=Retail_vs_NonRetail;
		if Upcase(EquityFlag)='EQUITY' then do;
		LGD_Portfolio='EQUITY';
		end;
		run;
		
		proc sql;
		create table SAS_data.Transit_Data3 as
		select a.* , b.*
		from SAS_data.Transit_Data3 a left join SAS_Data.LGD_map b
		on lower(a.lgd_portfolio)=lower(b.LGD) 
		order by InstrumentID;
		quit;
		
		proc sql;
		create table sas_data.temp as
		select lgd_portfolio,count(lgd_portfolio) as count,avg(LGD_Y0_actual) as avg_lgd_y0,sum(LGD_Y0_actual) as sum_lgd_y0 from sas_data.Transit_data3 
		group by lgd_portfolio;
		quit;


		/************************3.5 End - append LGD **********/
	
		/************************3.6 Start - Derive RSQ******************/
		
		data SAS_data.Transit_Data3;
		set SAS_data.Transit_Data3;
		PD_temp=PD_Y0_Actual;
		x = exp(-50*PD_temp);
	    y = (1 - x)/(1-exp(-50));
	    rsq_Y0_actual = 0.12*y + 0.24*(1 - y);	

		x = exp(-50*PD_Y1_Base);
	    y = (1 - x)/(1-exp(-50));
	    rsq_Y1_base = 0.12*y + 0.24*(1 - y);	
	    
		x = exp(-50*PD_Y2_Base);
	    y = (1 - x)/(1-exp(-50));
	    rsq_Y2_base = 0.12*y + 0.24*(1 - y);	

		x = exp(-50*PD_Y3_Base);
	    y = (1 - x)/(1-exp(-50));
	    rsq_Y3_base = 0.12*y + 0.24*(1 - y);	

		if Pool='IGE Mortgage' or Pool='Other Mortgage' then do;
		rsq_Y0_actual=0.15;
		rsq_Y1_base=0.15;
		rsq_Y2_base=0.15;
		rsq_Y3_base=0.15;
		end;
		drop PD_temp x y;
		run;
		
		proc sql;
		create table sas_data.temp as
		select avg(rsq_Y0_actual) as avg_rsq_y0,sum(rsq_Y0_actual) as sum_rsq_y0 from sas_data.Transit_data3 ;
		quit;
				
		%macro mac();
		%do i=1 %to 3;
		%do j=1 %to 4;
		Data SAS_data.Transit_Data3;
	    Set SAS_data.Transit_Data3;
	    format rsq_Y&i._S&j. best32.;
	    format x best32.;
	    format y best32.;
	    
	    PD_temp=PD_Y&i._S&j.;
	    x = exp(-50*PD_temp);
	    y = (1 - x)/(1-exp(-50));
	    rsq_Y&i._S&j. = 0.12*y + 0.24*(1 - y);
		if Pool='IGE Mortgage' or Pool='Other Mortgage' then do;
		rsq_Y&i._S&j.=0.15;
		end;
	    drop x y PD_temp;
	    %end;
	    %end;
		run;
		%mend mac;
		%mac();

			
		/************************3.6 End - Derive RSQ******************/
		
		/************************3.7 Start - Combine Principle*****************/
		

		/*******Verify Principal by portofolio*********/
/*		proc sql;*/
/*		create table sas_data.temp as*/
/*		select portofolio_flag,count(portofolio_flag) as count_instrument,sum(principle)as sum_principal,*/
/*		sum(Principle_SAR) as raw_sum_principal, sum(Principle_In_SAR_000) as raw_sum_principal_000,sum(EAD) as EAD from SAS_data.Transit_data3 ;*/
/*		quit;*/

/*		proc datasets library=Sas_Data;*/
/*		delete temp;*/
/*		run;*/
		
		
		/************************3.7 End - Combine Principle*****************/

		/************************3.8 Start - Apply Growth rate****************/
		
/*		data SAS_data.Growth_Rate;*/
/*		infile "&Supple_data_path.\growth_rate.csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;*/
/*		format Retail_vs_NonRetail $150.; format Y2015 best32.;format Y2016 best32.;format Y2017 best32.;format Y2018 best32.;*/
/*		Input Retail_vs_NonRetail $ Y2015 $ Y2016 $ Y2017 $ Y2018 $;  */
/*		run;*/

		%let growth_rate = EAD with Growth Rate(19-21); 
		
		data SAS_data.Growth_Rate;
		infile "&Supple_data_path.\&growth_rate..csv" delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
		format EAD_Key $150.; format Y2019 best32.;format Y2020 best32.;format Y2021 best32.;
		Input EAD_Key $ Y2019 $ Y2020 $ Y2021 $;  
		run;
	
	    data SAS_data.Growth_Rate;
	    set SAS_data.Growth_Rate;
	    EAD_Key = compress(EAD_key, '');
	    run;

		data SAS_data.Transit_Data3;
		set SAS_data.Transit_Data3;
		format EAD_Key $150.;
		EAD_Key = compress(Product_Type||'_'||Basel_Asset_Class);
		run;
		
		proc sql;
		create table SAS_data.Transit_Data3 as
		select a.*,b.* from SAS_data.Transit_Data3 a
		left join SAS_data.Growth_Rate b
		on strip(upcase(a.EAD_Key))=strip(upcase(b.EAD_Key));
		quit;
		
		
		data check;
		set SAS_data.Transit_Data3;
		if Y2019 eq .;
		run;
		
		proc freq data = SAS_data.Transit_Data3;
		tables EAD_key/ out = a;
		run;
		
		proc freq data = SAS_data.Transit_Data3;
		tables EAD_Key*Y2019;
		run;
		
		data SAS_data.Transit_Data3;
		set SAS_data.Transit_Data3;
		EAD_2018=EAD;
		EAD_2019=EAD*Y2019;
		EAD_2020=EAD*Y2020;
		EAD_2021=EAD*Y2021;
/*		Principle_2015=Principle*Y2015;*/
/*		Principle_2016=Principle*Y2016;*/
/*		Principle_2017=Principle*Y2017;*/
/*		Principle_2018=Principle*Y2018;*/
		run;
		
		/************************3.8 End - Apply Growth rate******************/


		/***********************************************************************************************************************/
		/******************************3. End - Append quantitative information to Raw Data***********************************/
		/***********************************************************************************************************************/


		/***********************************************************************************************************************/
		/******************************4. Start - Create Data for Access shell**************************************************/
		/***********************************************************************************************************************/
	
	
		/************************4.1 start-create date file *********************/
	
		Data SAS_Data.InstrumentDates(keep=InstrumentID StartDate MaturityDate EquityFlag);
	    Set SAS_DATA.TRANSIT_DATA3(where=(Pool eq ""));
		run;
		
		
		proc export data=SAS_Data.InstrumentDates
		    outfile="&Output_Path.\InstrumentDates.csv"
		    dbms=csv
		    replace;
		run;

	
		/************************4.1 End-create date file ***********************************/			
		
		/************************4.2 start- Group EAD portion by category and pool *********************/	
		proc freq data=sas_data.transit_data3;
		table Pool*Retail_vs_NonRetail/norow nocol nopercent nocum;
		run;	
		
		PROC SQL;
			CREATE TABLE SAS_Data.PoolByCategories AS
				SELECT f.Pool
					, f.Category
/**/				, sum(f.EAD)/b.PoolEAD AS EADPortion format=percent8.3
				FROM SAS_Data.Transit_Data3 f
				LEFT JOIN (	SELECT Pool
							, sum(EAD) AS PoolEAD
						FROM SAS_Data.Transit_Data3
						GROUP BY Pool
					) b
					ON f.Pool = b.Pool
				WHERE f.Pool ne ""
				GROUP BY f.Pool
					, f.Category
				HAVING count(*) > 1
			;
		QUIT;	
		
		proc export data=SAS_Data.PoolByCategories
		    outfile="&Output_Path.\PoolByCategories.csv"
		    dbms=csv
		    replace;
		run;	
		
		/************************End-EAD portion by category and pool ***********************************/		
		
		/************************Start - Create MasterData**********************************************/
		data SAS_Data.Master_Data;
		set SAS_Data.Transit_Data3;
		run;

		Proc export data=SAS_Data.Master_Data
		outfile="&Output_Path.\Master_Data.csv"	
		dbms=csv
		replace;
		run;
		/************************End - Create MasterData**********************************************/

		/************************Start - Create PoolData**********************************************/
			PROC SQL;
			CREATE TABLE SAS_data.Pool_data AS
				SELECT  max(f.Portofolio_flag) as Portfolio_flag, f.pool as CounterpartyID,
				max(EquityFlag) as EquityFlag, max(Retail_vs_NonRetail) as Retail_Vs_NonRetail,
				sum(f.Principle) as Principle,	max(f.MPR_LEVEL_1) as MPR_LEVEL_1,
				max(f.MPR_LEVEL_2) as MPR_LEVEL_2,max(f.countrycode) as countrycode,
				max(f.pool) as ID, sum(f.EAD) as EAD, sum(f.EAD_2018) as EAD_2018,
				sum(f.EAD_2019) as EAD_2019, sum(f.EAD_2020) as EAD_2020, sum(f.EAD_2021) as EAD_2021,
				max(f.Pool) as pool,
				max(f.count_obl) as count_obl, max(f.poolobligors) as poolobligors,
				sum(f.EAD*f.adj_rate)/sum(f.EAD) as adj_rate, max(f.RF_Industry) as RF_Industry,
				max(f.PD_Rating) as PD_Rating,	max(f.PD_Y0_actual) as PD_Y0_actual,	
				max(f.PD_Y1_base) as PD_Y1_base,								max(f.PD_Y1_S1) as PD_Y1_S1,	
				max(f.PD_Y1_S2) as PD_Y1_S2,	max(f.PD_Y1_S3) as PD_Y1_S3,	max(f.PD_Y1_S4) as PD_Y1_S4,	
				max(f.PD_Y2_base) as PD_Y2_base,								max(f.PD_Y2_S1) as PD_Y2_S1,	
				max(f.PD_Y2_S2) as PD_Y2_S2,	max(f.PD_Y2_S3) as PD_Y2_S3,	max(f.PD_Y2_S4) as PD_Y2_S4,	
				max(f.PD_Y3_base) as PD_Y3_base,								max(f.PD_Y3_S1) as PD_Y3_S1,	
				max(f.PD_Y3_S2) as PD_Y3_S2,	max(f.PD_Y3_S3) as PD_Y3_S3,	max(f.PD_Y3_S4) as PD_Y3_S4, 	
				max(f.LGD_Y0_actual) as LGD_Y0_actual,							max(f.LGD_Y1_base) as LGD_Y1_base,								
				max(f.LGD_Y1_S1) as LGD_Y1_S1,	max(f.LGD_Y1_S2) as LGD_Y1_S2,	max(f.LGD_Y1_S3) as LGD_Y1_S3,	
				max(f.LGD_Y1_S4) as LGD_Y1_S4,	max(f.LGD_Y2_base) as LGD_Y2_base,
				max(f.LGD_Y2_S1) as LGD_Y2_S1,	max(f.LGD_Y2_S2) as LGD_Y2_S2,	max(f.LGD_Y2_S3) as LGD_Y2_S3,	
				max(f.LGD_Y2_S4) as LGD_Y2_S4,	max(f.LGD_Y3_base) as LGD_Y3_base,
				max(f.LGD_Y3_S1) as LGD_Y3_S1,	max(f.LGD_Y3_S2) as LGD_Y3_S2,	max(f.LGD_Y3_S3) as LGD_Y3_S3,	
				max(f.LGD_Y3_S4) as LGD_Y3_S4,	max(f.Rsq_Y0_actual) as Rsq_Y0_actual, 
				max(f.Rsq_Y1_base) as Rsq_Y1_base,  							max(f.Rsq_Y1_S1) as Rsq_Y1_S1,
				max(f.Rsq_Y1_S2) as Rsq_Y1_S2,	max(f.Rsq_Y1_S3) as Rsq_Y1_S3,  max(f.Rsq_Y1_S4) as Rsq_Y1_S4,	
				max(f.Rsq_Y2_base) as Rsq_Y2_base,								max(f.Rsq_Y2_S1) as Rsq_Y2_S1,	
				max(f.Rsq_Y2_S2) as Rsq_Y2_S2,	max(f.Rsq_Y2_S3) as Rsq_Y2_S3,	max(f.Rsq_Y2_S4) as Rsq_Y2_S4,	
				max(f.Rsq_Y3_base) as Rsq_Y3_base,								max(f.Rsq_Y3_S1) as Rsq_Y3_S1,	
				max(f.Rsq_Y3_S2) as Rsq_Y3_S2,	max(f.Rsq_Y3_S3) as Rsq_Y3_S3,	max(f.Rsq_Y3_S4) as Rsq_Y3_S4,	
				max(f.EquityFlag) as EquityFlag					
				FROM SAS_DATA.Master_Data f 
				where f.pool <> "" group by f.pool ;
		QUIT;
		
		/************************Start - Create NonPoolData**********************************************/

		PROC SQL;
			CREATE TABLE SAS_data.NonPool_data AS
				SELECT  max(f.Portofolio_flag) as Portfolio_flag, f.CounterpartyID as CounterpartyID,
				max(EquityFlag) as EquityFlag, max(Retail_vs_NonRetail) as Retail_Vs_NonRetail,
				sum(f.Principle) as Principle,	max(f.MPR_LEVEL_1) as MPR_LEVEL_1,
				max(f.MPR_LEVEL_2) as MPR_LEVEL_2,max(f.countrycode) as countrycode,
				max(f.InstrumentID) as ID, sum(f.EAD) as EAD, sum(f.EAD_2018) as EAD_2018,
				sum(f.EAD_2019) as EAD_2019, sum(f.EAD_2020) as EAD_2020, sum(f.EAD_2021) as EAD_2021,
				max(f.Pool) as pool,
				max(f.count_obl) as count_obl, max(f.poolobligors) as poolobligors,
				sum(f.EAD*f.adj_rate)/sum(f.EAD) as adj_rate, max(f.RF_Industry) as RF_Industry,
				max(f.PD_Rating) as PD_Rating,	max(f.PD_Y0_actual) as PD_Y0_actual,	
				max(f.PD_Y1_base) as PD_Y1_base,								max(f.PD_Y1_S1) as PD_Y1_S1,	
				max(f.PD_Y1_S2) as PD_Y1_S2,	max(f.PD_Y1_S3) as PD_Y1_S3,	max(f.PD_Y1_S4) as PD_Y1_S4,	
				max(f.PD_Y2_base) as PD_Y2_base,								max(f.PD_Y2_S1) as PD_Y2_S1,	
				max(f.PD_Y2_S2) as PD_Y2_S2,	max(f.PD_Y2_S3) as PD_Y2_S3,	max(f.PD_Y2_S4) as PD_Y2_S4,	
				max(f.PD_Y3_base) as PD_Y3_base,								max(f.PD_Y3_S1) as PD_Y3_S1,	
				max(f.PD_Y3_S2) as PD_Y3_S2,	max(f.PD_Y3_S3) as PD_Y3_S3,	max(f.PD_Y3_S4) as PD_Y3_S4, 	
				max(f.LGD_Y0_actual) as LGD_Y0_actual,							max(f.LGD_Y1_base) as LGD_Y1_base,								
				max(f.LGD_Y1_S1) as LGD_Y1_S1,	max(f.LGD_Y1_S2) as LGD_Y1_S2,	max(f.LGD_Y1_S3) as LGD_Y1_S3,	
				max(f.LGD_Y1_S4) as LGD_Y1_S4,	max(f.LGD_Y2_base) as LGD_Y2_base,
				max(f.LGD_Y2_S1) as LGD_Y2_S1,	max(f.LGD_Y2_S2) as LGD_Y2_S2,	max(f.LGD_Y2_S3) as LGD_Y2_S3,	
				max(f.LGD_Y2_S4) as LGD_Y2_S4,	max(f.LGD_Y3_base) as LGD_Y3_base,
				max(f.LGD_Y3_S1) as LGD_Y3_S1,	max(f.LGD_Y3_S2) as LGD_Y3_S2,	max(f.LGD_Y3_S3) as LGD_Y3_S3,	
				max(f.LGD_Y3_S4) as LGD_Y3_S4,	max(f.Rsq_Y0_actual) as Rsq_Y0_actual, 
				max(f.Rsq_Y1_base) as Rsq_Y1_base,  							max(f.Rsq_Y1_S1) as Rsq_Y1_S1,
				max(f.Rsq_Y1_S2) as Rsq_Y1_S2,	max(f.Rsq_Y1_S3) as Rsq_Y1_S3,  max(f.Rsq_Y1_S4) as Rsq_Y1_S4,	
				max(f.Rsq_Y2_base) as Rsq_Y2_base,								max(f.Rsq_Y2_S1) as Rsq_Y2_S1,	
				max(f.Rsq_Y2_S2) as Rsq_Y2_S2,	max(f.Rsq_Y2_S3) as Rsq_Y2_S3,	max(f.Rsq_Y2_S4) as Rsq_Y2_S4,	
				max(f.Rsq_Y3_base) as Rsq_Y3_base,								max(f.Rsq_Y3_S1) as Rsq_Y3_S1,	
				max(f.Rsq_Y3_S2) as Rsq_Y3_S2,	max(f.Rsq_Y3_S3) as Rsq_Y3_S3,	max(f.Rsq_Y3_S4) as Rsq_Y3_S4,	
				max(f.EquityFlag) as EquityFlag					
				FROM SAS_DATA.Master_Data f 
/*				LEFT JOIN (	SELECT Pool*/
/*							FROM SAS_data.POOL_INFO ) b*/
/*							ON f.Pool = b.Pool*/
/*							WHERE b.Pool <> "" */
/**/			where f.pool = "" group by f.InstrumentID ;
		QUIT;
		

		/************************Start - Create Final Migration Data**********************************************/	
		data SAS_data.FINAL_MIGRATION;
		set SAS_data.Pool_Data SAS_data.NonPool_Data;
		run;
		
		/***********validate total exposure in final data*******/
		proc sql;
		create table sas_data.temp as
		select portfolio_flag,sum(EAD) from SAS_DATA.FINAL_MIGRATION group by portfolio_flag;
		quit;
				
		/****start-Create Final Migration data for RAROC*/
		data SAS_Data.Final_migration_RAROC;
		set SAS_data.FINAL_MIGRATION;
		run;
		
		Proc export data=SAS_Data.FINAL_MIGRATION_RAROC
		outfile="&Output_Path.\FINAL_MIGRATION_RAROC.csv"	
		dbms=csv
		replace;
		run;

		/****start-Create Final Migration data for ICAAP*/
		data SAS_Data.Final_migration_ICAAP;
		set SAS_data.FINAL_MIGRATION(where=(upcase(Portfolio_flag) ne "BANK (FI)"));
		run;
			
	
		Proc export data=SAS_Data.FINAL_MIGRATION_ICAAP
		outfile="&Output_Path.\FINAL_MIGRATION_ICAAP.csv"	
		dbms=csv
		replace;
		run;
	
	
		/***********************************Start - Access Shell for RAROC portfolio******************************************************************************/
		/***********************Create EAD by CounterpartyID*******************************/
		
		proc sql;
        create table SAS_Data.EAD_by_Counterparty as
        select counterpartyID,sum(EAD) AS EAD from SAS_DATA.FINAL_MIGRATION
        where pool="" group by counterpartyID;
        quit;

		proc sql;
		create table test as
		select pool,sum(EAD) from SAS_DATA.FINAL_MIGRATION group by pool;
		quit;

/**/
		/*******************Create quantile of EAD for RAROC*****************************************/
		proc univariate data= SAS_DATA.EAD_by_Counterparty noprint PCTLDEF=3;
                 var EAD;
                 output out=SAS_Data.EAD_percentiles pctlpts=5 to 100 by 5 pctlpre=EAD_;          
        run;

		proc transpose data=SAS_Data.EAD_percentiles
		out = SAS_Data.EAD_percentiles;
		run;

		data SAS_Data.EAD_percentiles;
		set SAS_Data.EAD_percentiles;
		_NAME_=scan(_NAME_,2,"_");
		drop _Label_;
		rename _NAME_=Quantile Col1=EAD;
		run;
		
		Proc export data=SAS_Data.EAD_percentiles
		outfile="&Output_Path.\Y0\RAROC\EAD_percentiles.csv"	
		dbms=csv
		replace;
		run;
		
		Proc export data=SAS_Data.EAD_by_Counterparty
		outfile="&Output_Path.\Y0\RAROC\EAD_by_Counterparty.csv"	
		dbms=csv
		replace;
		run;
    	/*******************************************************************************************/
    	
    	
    	/*****************************Profit Rate - RAROC**************************************************/
    	data SAS_Data.ProfitRate;
    	set SAS_Data.Final_Migration_RAROC(Keep=ID adj_rate);
    	run;
    	
		Proc export data=SAS_Data.ProfitRate
		outfile="&Output_Path.\Y0\RAROC\ProfitRate.csv"	
		dbms=csv
		replace;
		run;
    	
    	
    	/*********************Start - Create Principal table for RAROC******************/
		data SAS_data.Principal_Data_RAROC;
		set SAS_data.Master_Data(keep=InstrumentID pool Retail_vs_NonRetail Principle 
										EAD count_obl);

		run;
			
		
		data SAS_data.Principal_Data_RAROC;
		set SAS_data.Principal_Data_RAROC;
		if pool="" or count_obl=1 then do;
			if principle="" then delete;
		end;
		if pool<> "" & count_obl >1 then do;
			if principle="" then do;
				principle=EAD;
			end;
		end;
		run;
		
		
		
		/*********************End - Create Principal table for RAROC******************/
    	
		/************************Start - Create Principal PoolData RAROC**********************************************/    	
    	PROC SQL;
			CREATE TABLE SAS_data.Principal_data_Pool_RAROC AS
				SELECT  f.pool as CounterpartyID, sum(f.Principle) as Principle				
				FROM SAS_Data.Principal_Data_RAROC f 
				where f.pool <> "" group by f.pool ;
		QUIT;
		
		/************************Start - Create Principal NonPoolData RAROC**********************************************/

		PROC SQL;
			CREATE TABLE SAS_Data.Principal_data_NonPool_RAROC AS
				SELECT  f.instrumentID as CounterpartyID, sum(f.Principle) as Principle				
				FROM SAS_Data.Principal_Data_RAROC f 
				where f.pool = "" group by f.InstrumentID;
		QUIT;
		
	
		/************************Start - Create Principal DAta for RAROC**********************************************/	
		data SAS_data.Principal_data_RAROC;
		set SAS_data.Principal_data_Pool_RAROC SAS_Data.Principal_data_NonPool_RAROC;
		run;
		
		Proc export data=SAS_Data.Principal_data_RAROC
		outfile="&Output_Path.\Y0\RAROC\Principal_data_RAROC.csv"	
		dbms=csv
		replace;
		run;
    	
		

		
		
