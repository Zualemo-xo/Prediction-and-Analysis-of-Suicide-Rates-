df<-read.table('F:/Sem 5th/DV and FDA proj/Suicides in India 2001-2012.csv',header=T, sep=",")
head(df)
#Data Cleaning
#Replacing Values for UT
df["State"][df["State"] == "A & N Islands"]<-"A & N Islands-Ut"
df["State"][df["State"] == "Chandigarh"]<-"Chandigarh-Ut"
df["State"][df["State"] == "D & N Haveli"]<-"D & N Haveli-Ut"
df["State"][df["State"] == "Daman & Diu"]<-"Daman & Diu-Ut"
df["State"][df["State"] == "Lakshadweep"]<-"Lakshadweep-Ut"
df["State"][df["State"] == "Delhi"] <-"Delhi-Ut"
head(df)
#Renaming causes
df["Type"][df["Type"]=="Bankruptcy or Sudden change in Economic"]<-"Sudden change in Economic Status or Bankruptcy"
df["Type"][df["Type"]=="By Other means (please specify)"]<-"By Other means"
df["Type"][df["Type"]=="Not having Children(Barrenness/Impotency"]<-"Not having Children(Impotency)"
df["Type"][df["Type"]=="By Jumping from (Building)"]<-"By Jumping from Building"
df["Type"][df["Type"]=="Hr. Secondary/Intermediate/Pre-Universit"]<-"Hr. Secondary/Intermediate/Pre-University"
df["Type"][df["Type"]=="Failure in Examination"]<-"Examination Failure"
df["Type"][df["Type"]=="By coming under running vehicles/trains"]<-"By road/railway accidents" 
head(df)

#drop the unwanted State-titles
df1 <- df[!(df$State=="Total (Uts)" | df$State=="Total (All India)" |  df$State=="Total (States)"),]
#drop the values ==0 under Total
df2 <- df1[!(df1$Total==0),]
# drop the unwanted Types
df2 <- df2[!(df2$Type=="By Other means" | df2$Type=="Others (Please Specify)" | df2$Type=="Causes Not known" |  df2$Type=="Other Causes (Please Specity)"),]

#Spliting the dataframe into smaller dataframe based on the column "Type_code"
split<-split(df,f=df$Type_code)
causesdf<-data.frame(split['Causes'])
colnames(causesdf)<- c("State", "Year", "Type_code","Type","Gender","Age_group","Total")
edudf<-data.frame(split['Education_Status'])
colnames(edudf)<- c("State", "Year", "Type_code","Type","Gender","Age_group","Total")
meansdf<-data.frame(split['Means_adopted'])
colnames(meansdf)<- c("State", "Year", "Type_code","Type","Gender","Age_group","Total")
professionaldf<-data.frame(split['Professional_Profile'])
colnames(professionaldf)<- c("State", "Year", "Type_code","Type","Gender","Age_group","Total")
socialdf<-data.frame(split['Social_Status'])
colnames(socialdf)<- c("State", "Year", "Type_code","Type","Gender","Age_group","Total")
