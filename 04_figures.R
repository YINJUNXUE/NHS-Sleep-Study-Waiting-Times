Sys.setlocale('LC_CTYPE','English_United States.utf8')
O<-commandArgs(TRUE)[1];out<-file.path(O,'figures');dir.create(out,showWarnings=FALSE)
read<-function(n)read.csv(file.path(O,n),fileEncoding='UTF-8-BOM',check.names=FALSE)
s<-read('period_scores.csv');bg<-read('background_monthly.csv');iq<-read('monthly_IQR.csv');p<-read('PRIMARY.csv');t<-read('Table1.csv')
val<-function(label,col='Primary cohort')as.numeric(t[t$Characteristic==label,col])
export<-function(name,w,h,fun){pdf(file.path(out,paste0(name,'.pdf')),width=w,height=h,family='Helvetica',pointsize=10,useDingbats=FALSE);fun();dev.off();png(file.path(out,paste0(name,'.png')),width=w,height=h,units='in',res=600,type='cairo',pointsize=10);fun();dev.off();tiff(file.path(out,paste0(name,'.tiff')),width=w,height=h,units='in',res=600,type='cairo',compression='lzw',pointsize=10);fun();dev.off()}
flow<-function(){par(mar=c(.4,.4,1.7,.4));plot.new();plot.window(xlim=c(0,1),ylim=c(0,1));title('Figure 1. Study population and observation flow',cex.main=1)
 box<-function(x,y,w,h,label,col='#EAF3FA'){rect(x-w/2,y-h/2,x+w/2,y+h/2,col=col,border='#444444');text(x,y,label,cex=.87)}
 arrow<-function(y1,y2)arrows(.5,y1,.5,y2,length=.07)
 box(.5,.90,.88,.11,paste0(val('Original reporting Sleep Studies codes','Reported NHS framework'),' original provider codes with Sleep Studies reports\n92 monthly Provider workbooks, Jan 2019-Aug 2026'))
 arrow(.845,.805);box(.5,.75,.88,.11,paste0(val('Original NHS Trust codes','Reported NHS framework'),' English NHS Trust codes in the background framework\nOrganisations, not individual hospital sites'))
 arrow(.695,.655);box(.5,.60,.88,.11,'71 frozen NHS Trust identity segments\nIdentity boundaries and availability fixed in SAP-1.0')
 arrow(.545,.505);box(.5,.45,.88,.10,'6,483 calendar identity-months within locked segments')
 arrow(.40,.36);box(.5,.29,.88,.14,'331 excluded identity-months\n47 absent rows; 39 zero N; 244 with N=1-19\n1 official estimated/quality record',col='#F3F3F3')
 arrow(.22,.18);box(.5,.12,.88,.10,'6,152 eligible identity-months, N>=20\nTraining: 3,919; validation: 2,233')
 text(.5,.015,'Codes, identity segments and observations are distinct units; no cross-boundary stitching.',cex=.72)}
trend<-function(){par(mfrow=c(2,1),mar=c(4.5,4.6,2.5,.8),oma=c(4.2,0,0,0),las=1)
 x<-seq_len(nrow(bg));ticks<-seq(1,85,12);shade<-function(yl){rect(15,yl[1],36,yl[2],col='#F0F0F0',border=NA)}
 plot(x,bg$p6_percent,type='n',ylim=c(0,80),xaxt='n',xlab='',ylab='Waiting at least 6 weeks (%)',main='A  Reported NHS Trust aggregate',cex.main=1);shade(c(0,80));lines(x,bg$p6_percent,col='#0072B2',lwd=1.5);axis(1,ticks,2019:2026);points(c(1,92),bg$p6_percent[c(1,92)],pch=19,col='#0072B2');text(2,12,sprintf('Jan 2019: %.2f%%',bg$p6_percent[1]),adj=0,cex=.8);text(91,43,sprintf('Aug 2026: %.2f%%',bg$p6_percent[92]),adj=1,cex=.8)
 plot(x,iq$IQR_pp,type='n',ylim=c(0,65),xaxt='n',xlab='Calendar month',ylab='Between-Trust IQR (percentage points)',main='B  Equal-institution distribution in the frozen 71 framework',cex.main=1);shade(c(0,65));lines(x,iq$IQR_pp,col='#D55E00',lwd=1.5);axis(1,ticks,2019:2026)
 mtext('A: sum Y6 / sum N among actual clean reporting Trusts (N>0); composition varies by month.',outer=TRUE,side=1,line=.6,cex=.71)
 mtext('B: monthly IQR of own proportions among eligible N>=20 institutions; not IQR of period scores.',outer=TRUE,side=1,line=1.55,cex=.71)
 mtext('Grey denotes Mar 2020-Dec 2021 for context; no causal effect or modelled narrowing is implied.',outer=TRUE,side=1,line=2.5,cex=.71)}
persistence<-function(){par(mar=c(4.4,4.5,3.1,1),las=1);xx<-s$training_relative_burden_pp;yy<-s$validation_relative_burden_pp;lim<-range(c(xx,yy));lim<-c(floor(lim[1]/10)*10-5,ceiling(lim[2]/10)*10+5);plot(xx,yy,type='n',xlim=lim,ylim=lim,asp=1,xlab='2019-2023 relative waiting burden (percentage points)',ylab='2024-Aug 2026 relative waiting burden (percentage points)',main='Figure 3. Temporal persistence of relative waiting burden',cex.main=.95,cex.lab=.9);abline(h=0,v=0,col='#AAAAAA',lty=3);abline(0,1,col='#555555',lty=2);points(xx,yy,pch=21,bg='#0072B2',col='white',lwd=.5,cex=.9);legend('topleft',c(sprintf('71 identity segments; Spearman rho = %.3f',p$rho),sprintf('95%% institution-bootstrap CI %.3f to %.3f',p$ci_low,p$ci_high),'Dashed line: y = x, not a fitted regression'),bty='n',cex=.75)}
export('Figure1_Study_Flow',7.1,6.3,flow);export('Figure2_Temporal_Burden_and_Variation',7.1,7.5,trend);export('Figure3_Temporal_Persistence',7.1,6.5,persistence)
writeLines(capture.output(sessionInfo()),file.path(O,'R_SESSION.txt'))