library(shiny)
library(plotly)
library(DT)
#install.packages('tidyverse')
#install.packages('caret')
#install.packages("plotly")
library(tidyverse)
library(caret)
library(dplyr)
library(ggplot2)
library(plotly)
library(treemapify)
library(stringr)  
library(ggthemes)
library(plotrix)

df<-read.table('Suicides in India 2001-2012.csv',header=T, sep=",")
#head(df)


#Data Cleaning
#Replacing Values for UT
df["State"][df["State"] == "A & N Islands"]<-"A & N Islands-Ut"
df["State"][df["State"] == "Chandigarh"]<-"Chandigarh-Ut"
df["State"][df["State"] == "D & N Haveli"]<-"D & N Haveli-Ut"
df["State"][df["State"] == "Daman & Diu"]<-"Daman & Diu-Ut"
df["State"][df["State"] == "Lakshadweep"]<-"Lakshadweep-Ut"
df["State"][df["State"] == "Delhi"] <-"Delhi-Ut"
#head(df)
#Renaming causes
df["Type"][df["Type"]=="Bankruptcy or Sudden change in Economic"]<-"Sudden change in Economic Status or Bankruptcy"
df["Type"][df["Type"]=="By Other means (please specify)"]<-"By Other means"
df["Type"][df["Type"]=="Not having Children(Barrenness/Impotency"]<-"Not having Children(Impotency)"
df["Type"][df["Type"]=="By Jumping from (Building)"]<-"By Jumping from Building"
df["Type"][df["Type"]=="Hr. Secondary/Intermediate/Pre-Universit"]<-"Hr. Secondary/Intermediate/Pre-University"
df["Type"][df["Type"]=="Failure in Examination"]<-"Examination Failure"
df["Type"][df["Type"]=="By coming under running vehicles/trains"]<-"By road or railway accidents" 
df["Type"][df["Type"]=="Bankruptcy or Sudden change in Economic Status"]<-"Sudden change in Economic Status or Bankruptcy"
df["Type"][df["Type"]=="Not having Children (Barrenness/Impotency"]<-"Not having Children(Impotency)"
#causescount
#head(df)

#drop the unwanted State-titles
df1 <- df[!(df$State=="Total (Uts)" | df$State=="Total (All India)" |  df$State=="Total (States)"),]
#drop the values ==0 under Total
df2 <- df1[!(df1$Total==0),]
# drop the unwanted Types
df2 <- df2[!(df2$Type=="By Other means" | df2$Type=="Others (Please Specify)" | df2$Type=="Causes Not known" |  df2$Type=="Other Causes (Please Specity)"),]

#Spliting the dataframe into smaller dataframe based on the column "Type_code"
causesdf=filter(df2,df2$Type_code=="Causes")
edudf=filter(df2,df2$Type_code=="Education_Status")
meansdf=filter(df2,df2$Type_code=="Means_adopted")
professionaldf=filter(df2,df2$Type_code=="Professional_Profile")
socialdf=filter(df2,df2$Type_code=="Social_Status")

load("model2.Rdata")
summary(model)
shinyServer(function(input,output){

  
  output$plot1<-renderPlot({
    
    gper<-df2 %>% select(Gender,Total)%>% group_by(Gender)%>% summarise(total_all=sum(Total))%>%mutate(rs=sum(total_all), percent=round((total_all/rs)*100))
    #gper
    label <-  
      c( paste(gper$Gender[1],gper$percent[1],'%',sep=' '),
         paste(gper$Gender[2],gper$percent[2],'%',sep=' '))
    colr<-c("palevioletred1","dodgerblue2")
    pie3D(gper$percent,labels=label,labelcex=1.1,explode=0.4,col=colr,main="Male and Female Suicide Count Percentage")
    
  })
  
  output$plot2<-renderPlotly({
    
    typedf<-df2%>%select(Type,Total) %>% 
      group_by(Type)%>% summarise(Total=sum(Total))
    typedf<-as.data.frame(typedf) %>%  arrange(desc(Total)) %>%head(10)
    #typedf
    
    figpie <- plot_ly(typedf, labels = ~Type, values = ~Total, type = 'pie',
                      textposition = 'inside',
                      textinfo = 'label+percent',
                      insidetextfont = list(color = '#FFFFFF'),
                      hoverinfo = 'text',
                      text = ~paste(Total),
                      marker = list(colors = colors,line = list(color = '#FFFFFF', width = 1)),
                      showlegend = FALSE)
    
    figpie <- figpie %>% layout(title = "Top 10 Types Of Suicide Methods")
    figpie
    
    
  })
  
  output$plot3<-renderPlotly({
    
    temp <- df2 %>% group_by(Year) %>% summarise(total_case=sum(Total))
    #temp
    fig <- plot_ly(
      x = temp$Year,
      y = temp$total_case,
      type = "bar", color=temp$Year )
    
    fig <- fig %>% layout(title = "Suicide Trend Over the years",
                          barmode = 'group',
                          xaxis = list(title = "Years"),
                          yaxis = list(title = "Count"))
    
    fig
    
    
  })
  
  output$plot4<-renderPlotly({
    
    type_codedf=df2%>%select(Total,Year,Type_code) %>% group_by(Type_code)%>%summarise(Total=sum(Total))
    type_codedf<-as.data.frame(type_codedf)
    #head(type_codedf)
    
    ggplot(type_codedf, aes(x=Type_code,y=Total, fill=Type_code))+geom_bar(stat="identity")+
      theme(legend.position="bottom") + ggtitle("Type Code VS Total Count")
  })
  
  output$plot5<-renderPlotly({
    
    treedf<-df2%>%select(State,Year,Total) %>% 
      group_by(State,Year)%>% summarise(Total=sum(Total))
    fig <- plot_ly(treedf, x = ~State, y = ~Total, type = 'scatter',size= ~Total,color= ~State)
    fig
    
  })
  
  output$plot6<-renderPlot({
    
    topstate<-df2%>%filter(!State %in% c("Total (All India)","Total (States)","Total (Uts)"))%>%select(State,Year,Total) %>% group_by(State)%>% 
      summarise(Total=sum(Total)) %>% arrange(desc(Total))%>% head(10)
    topstate<-as.data.frame(topstate)
    #topstate
    
    ggplot(topstate, aes(area = Total, fill = State , label = State)) +
      geom_treemap() +
      geom_treemap_text(fontface = "italic",  place = "centre",grow = TRUE)+
      labs( title="Top 10 States with Higher Rates")
    
  })
  
  output$plot7<-renderPlotly({
    
    topstate<-df2%>%filter(!State %in% c("Total (All India)","Total (States)","Total (Uts)"))%>%select(State,Year,Total) %>% group_by(State)%>% 
      summarise(Total=sum(Total)) %>% arrange(desc(Total))%>% head(10)
    topstate<-as.data.frame(topstate)
    
    fig <- plot_ly(topstate, x = ~State, y = ~Total, type = 'scatter',size= ~Total,color= ~State)
    fig
    
  })
  
  
  output$plot8<-renderPlotly({
    
    bottomstate<-df%>%filter(!State %in% c("Total (All India)","Total (States)","Total (Uts)"))%>% 
      select(State,Year,Total)%>% 
      group_by(State)%>% 
      summarise(Total=sum(Total)) %>% 
      arrange((Total))%>%head(10)
    bottomstate<-as.data.frame(bottomstate)
    #bottomstate
    
    ggplot(bottomstate,aes(x=factor(State,level=State),y=Total,color=State))+geom_point(size=4)+
      geom_segment(aes(xend=State,y=0,yend=Total),size=2)+
      theme(legend.position="none",axis.text.x=element_text(angle=90))+
      labs( title="Bottom 10 States")
    
  })
  
  output$plot9<-renderPlotly({
    colr<-c("palevioletred1","goldenrod3","orangered4","mistyrose4","mediumpurple3","slateblue4","slateblue","slategray4","tan")
    ss<-df2 %>% filter(Type_code =="Social_Status")%>% select(Gender,Total,Type)%>% group_by(Gender,Type)%>% summarise(ttotal=sum(Total))
    ss%>% ggplot(aes(x=str_sub(Type,1,15),y=ttotal,fill=Type))+geom_boxplot()+scale_fill_manual(values=colr)+theme(legend.position = "bottom",axis.text.x = element_text(angle=90))+labs(x="Social Status",y="Total Count")
    

  })
  
  output$plot10<-renderPlotly({
    colr<-c("palevioletred1","goldenrod3","orangered4","mistyrose4","mediumpurple3","slateblue4","slateblue","slategray4","tan")
    ss<-df2 %>% filter(Type_code =="Social_Status")%>% select(Gender,Total,Type)%>% group_by(Gender,Type)%>% summarise(ttotal=sum(Total))
    ss%>% ggplot(aes(x=str_sub(Type,1,15),y=ttotal,fill=Gender))+geom_bar(stat="identity",position="fill")+scale_fill_manual(values=colr)+theme(legend.position = "bottom",axis.text.x = element_text(angle=90))+labs(x="Social Status",y="Total Count")
    
  })
  
  output$plot11<-renderPlotly({
    colr<-c("palevioletred1","goldenrod3","orangered4","mistyrose4","mediumpurple3","slateblue4","slateblue","slategray4","tan")
    ss<-df2 %>% filter(Type_code =="Professional_Profile")%>% select(Gender,Total,Type)%>% group_by(Gender,Type)%>% summarise(ttotal=sum(Total))
    ss%>% ggplot(aes(x=str_sub(Type,1,15),y=ttotal,fill=Gender))+geom_bar(stat="identity",position="fill")+scale_fill_manual(values=colr)+theme(legend.position = "bottom",axis.text.x = element_text(angle=90))+labs(x="Professional_Profile",y="Total Count")
    

    
  }) 
  
  output$plot12<-renderPlotly({
    colr<-c("palevioletred1","dodgerblue4","goldenrod3","orangered4",
            "lightsalmon4","mistyrose4","mediumpurple3","slateblue4","slateblue","slategray4","tan")
    sc_type<-df2 %>% filter(Type_code =="Education_Status")%>% select(Gender,Total,Type)%>% group_by(Gender,Type)%>% summarise(ttotal=sum(Total))
    sc_type %>% ggplot(aes(x=str_sub(Type,1,15),y=ttotal,fill=Type))+geom_boxplot()+scale_fill_manual(values=colr)+theme(legend.position = "bottom",axis.text.x = element_text(angle=90))+labs(x="Education Level",y="count")
    
    
    
  })
  
  
  output$plot13<-renderPlotly({

    colr<-c("palevioletred1","goldenrod3","orangered4","mistyrose4","mediumpurple3","slateblue4","slateblue","slategray4","tan")
    ss<-df2 %>% filter(Type_code =="Means_adopted")%>% select(Gender,Total,Type)%>% group_by(Gender,Type)%>% summarise(ttotal=sum(Total))
    ss%>% ggplot(aes(x=str_sub(Type,1,15),y=ttotal,fill=Gender))+geom_bar(stat="identity",position="fill")+scale_fill_manual(values=colr)+theme(legend.position = "bottom",axis.text.x = element_text(angle=90))+labs(x="Means_adopted",y="Total Count")
    
  }) 
  
  output$plot14<-renderPlotly({
    colr<-c("palevioletred1","goldenrod3","orangered4","mistyrose4","mediumpurple3","slateblue4","slateblue","slategray4","tan")
    ma_type<-df2 %>% filter(Type_code =="Means_adopted") %>%group_by(Type,Gender,Age_group)%>%summarize(mtot=sum(Total))
    ma_type%>%ggplot(aes(x=Type,y=mtot,fill=Age_group))+geom_bar(stat="identity",
                                                                 position="stack")+scale_fill_manual(values=colr)+theme(legend.position = "bottom",axis.text.x = element_text(angle=90))+labs(x="Means Adopted",y="Count")
    
    
  }) 
  
  output$plot15<-renderPlotly({
    colr<-c("palevioletred1","goldenrod3","orangered4","mistyrose4","mediumpurple3","slateblue4","slateblue","slategray4","tan")
    df2 %>% filter(Type_code=="Causes" & Type %in% c("Failure in Examination","Family Problems","Other Prolonged Illness","Unemployment","Dowry Dispute","Poverty","Insanity/Mental Illness"))%>%select(Year,Total,Type)%>% group_by(Year,Type)%>%summarise(ytot=sum(Total))%>% 
      ggplot(aes(x=factor(Year),y=ytot,color=Type,group=Type))+geom_line(size=1)+scale_color_manual(values=colr)+
      theme(legend.position = "bottom",axis.text.x = element_text(angle=65,vjust=0.5))+labs(x="Year",y="Count")+geom_point(size=2)
    
    
    
  }) 
  
  output$plot16<-renderPlotly({

    df2 %>% filter(Type_code=="Causes" & Type %in% c("Failure in Examination","Family Problems","Other Prolonged Illness","Unemployment","Dowry Dispute","Poverty","Insanity/Mental Illness"))%>%select(Year,Total,Type)%>% group_by(Year,Type)%>%summarise(ytot=sum(Total))%>% 
      ggplot(aes(x=factor(Year),y=ytot,color=Type,group=Type))+geom_line(size=1)+scale_color_manual(values=colr)+
      theme(legend.position = "bottom",axis.text.x = element_text(angle=65,vjust=0.5))+labs(x="Year",y="Count")+geom_point(size=2)
    
  }) 
  param2=0
  param3=0
  param4=0
  param5=0
  param6=0
  param7=0
  

  newdata<-data.frame(Year=double(),Age_group_15_29=double(),Age_group_30_44=double(),Age_group_45_59=double(),Age_group_60=double(),State_Maharashtra=double(),State_WestBengal=double())
  #newdata<-data.frame(Year=double(),Age_group=double(),Age_group21=double(),Age_group30=double(),Age_group40=double(),State=double(),State2=double())
  tableData <- eventReactive(input$Submit, {
    if(as.character(input$AgeInp)=="Age_group15-29")
    {param2=1
    param3=0
    param4=0
    param5=0}
    
    
    if(as.character(input$AgeInp)=="Age_group30-44")
    {param2=0
    param3=1
    param4=0
    param5=0}
    
    if(as.character(input$AgeInp)=="Age_group45-59")
    {param2=0
    param3=0
    param4=1
    param5=0}
    
    if(as.character(input$AgeInp)=="Age_group60+")
    {param2=0
    param3=0
    param4=0
    param5=1}
    
    if(as.character(input$AgeInp)=="Age_group60+")
    {param2=0
    param3=0
    param4=0
    param5=1}
    
    if(as.character(input$StateInp)=="StateMaharashtra")
    {param6=1
    param7=0}
    
    if(as.character(input$StateInp)=="StateWest Bengal")
    {param6=0
    param7=1}
    
    newdata[nrow(newdata) + 1,] = c(as.double(input$Year),param2, param3,param4,param5,param6,param7)

    return(model%>%predict(newdata))
  })
  
  output$prediction<-renderTable({tableData()})
  #newdata<-data.frame(Year=c(reactive(as.double(input$YearInp))),Age_group15=as,param3,param4,param5,State=c(reactive(as.character(input$StateInp))))
  #newdata
  #newdata<-data.frame(Year=double(),Age_group15=character(),Age_group21=character(),Age_group30=character(),Age_group40=character(),State=character())
  #output$prediction<-renderText(model%>%predict(newdata))
  
  
  
})
