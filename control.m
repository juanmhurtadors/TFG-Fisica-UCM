clear all;

HIGH=1;
LOW=0;

ENA="D11";
IN1="D10";
IN2="D9";

ENB="D4";
IN3="D5";
IN4="D6";

ar=arduino('COM6','Uno','Trace',true);

%writePWMVoltage(a, ENA, 5); 
%Set the spinning direction clockwise:

Nt=600; %Num of data points / image files. Max allowed is 999, see file format
Totalthours=6;
Deltat=Totalthours*3600/Nt;
%vol=num2str(14.8);

time=60;
% facmin=60;
% fachour=60;

cam=webcam(2); 
a = arduino('COM3','nano33IoT');

q1=string(datetime('now','TimeZone','local','Format','y_MM_dd_HH-mm-ss'));%Metadatos
q2=strcat('records 14.9Vfuent 2htot',q1);%Nombre de la carpeta
mkdir(q2);%Crea la carpeta

q3=string(datetime('now','TimeZone','local','Format','y_MM_dd_HH-mm-ss'));
q4=strcat('tabledata 14.9Vfuent 2htot',q3,'.xlsx');%Nombre del archivo Excel

Nt1=Nt;
NUM1=1:Nt1;
Totalthours1=Totalthours/2;
Deltat1=Totalthours1*3600/Nt1;
V61=zeros(1,Nt1); 
V71=zeros(1,Nt1);
writeDigitalPin(ar,ENA, HIGH); writeDigitalPin(ar,IN1, LOW);   writeDigitalPin(ar,IN2, HIGH);%Azimut
writeDigitalPin(ar,ENB, HIGH); writeDigitalPin(ar,IN3, LOW);   writeDigitalPin(ar,IN4, HIGH);%Elevación (Sube)
% mypi = raspi();
% configurePin(mypi, 12, 'PWM');
% writePWMVoltage(ar,ENB, 5);
fg1=figure(1)
for index1=1:Nt1
    %Acquire frame for processing
    img1=snapshot(cam);
    qq1=sprintf('shot%03d.jpg',index1);
    %filename1=fullfile('c:\','Users','Juan Manuel.DESKTOP-3R9HSH2','Downloads',q2,qq1,filesep);%Especificar la ruta carpeta de almacenamiento
    cd(q2)
    imwrite(img1,qq1)
    cd('C:\Users\Juan Manuel.DESKTOP-3R9HSH2\Downloads')
    %img1=snapshot(cam); filename1=sprintf('shot%03d.jpg',index1); imwrite(img1,filename1); %end %if (TAKE_SHOTS)
    V61(index1)=readVoltage(a,'A2'); subplot(2,1,1); grid on; hold on; plot(V61); title('Azimut'); xlabel('No. de Medidas'); ylabel('Voltaje'); legend('Dato'); hold on; %end  % Azimuth (TAKE_AZ)
    V71(index1)=readVoltage(a,'A3'); subplot(2,1,2); grid on; hold on; plot(V71); title('Elevación'); xlabel('No. de Medidas'); ylabel('Voltaje'); legend('Dato'); hold on; %end % Elevation (TAKE_EL)
    delay(Deltat1)
end
M1=[NUM1' V61' V71'];
cd(q2)
writematrix(M1,q4,'Sheet',1)
cd('C:\Users\Juan Manuel.DESKTOP-3R9HSH2\Downloads')

writeDigitalPin(ar,ENA, HIGH); writeDigitalPin(ar,IN1, LOW);   writeDigitalPin(ar,IN2, LOW);%Azimut
writeDigitalPin(ar,ENB, HIGH); writeDigitalPin(ar,IN3, LOW);   writeDigitalPin(ar,IN4, LOW);%Elevación
pause(time)

Nt2=Nt;
NUM2=1:Nt2;
Totalthours2=Totalthours/2;
Deltat2=Totalthours2*3600/Nt2;
V62=zeros(1,Nt2); 
V72=zeros(1,Nt2);
writeDigitalPin(ar,ENA, HIGH); writeDigitalPin(ar,IN1, LOW);   writeDigitalPin(ar,IN2, HIGH);%Azimut
writeDigitalPin(ar,ENB, HIGH); writeDigitalPin(ar,IN3, HIGH);   writeDigitalPin(ar,IN4, LOW);%Elevación
fg2=figure(2)
for index2=1:Nt2
    %Acquire frame for processing
    img2=snapshot(cam);
    qq2=sprintf('shot%03d.jpg',Nt1+index2);
    %filename2=fullfile('c:\','Users','Juan Manuel.DESKTOP-3R9HSH2','Downloads',q2,qq2,filesep);%Especificar la ruta carpeta de almacenamiento
    cd(q2)
    imwrite(img2,qq2);
    cd('C:\Users\Juan Manuel.DESKTOP-3R9HSH2\Downloads')
    %img2=snapshot(cam); filename2=sprintf('shot%03d.jpg',Nt1+index2); imwrite(img2,filename2); %end %if (TAKE_SHOTS)
    V62(index2)=readVoltage(a,'A2'); subplot(2,1,1); grid on; hold on; plot(V62); title('Azimut');xlabel('No. de Medidas'); ylabel('Voltaje'); legend('Dato'); hold on; %end  % Azimuth (TAKE_AZ)
    V72(index2)=readVoltage(a,'A3'); subplot(2,1,2); grid on; hold on; plot(V72); title('Elevación'); xlabel('No. de Medidas'); ylabel('Voltaje'); legend('Dato'); hold on; %end % Elevation (TAKE_EL)
    delay(Deltat2)
end
M2=[NUM2' V62' V72'];
cd(q2)
writematrix(M2,q4,'Sheet',2)
cd('C:\Users\Juan Manuel.DESKTOP-3R9HSH2\Downloads')

writeDigitalPin(ar,ENA, HIGH); writeDigitalPin(ar,IN1, LOW);   writeDigitalPin(ar,IN2, LOW);%Azimut
writeDigitalPin(ar,ENB, HIGH); writeDigitalPin(ar,IN3, LOW);   writeDigitalPin(ar,IN4, LOW);%Elevación
pause(time)

writeDigitalPin(ar,ENA,LOW); writeDigitalPin(ar,IN1, LOW);   writeDigitalPin(ar,IN2, LOW);%Azimut
writeDigitalPin(ar,ENB,LOW); writeDigitalPin(ar,IN3, LOW);   writeDigitalPin(ar,IN4, LOW);%Elevación

cd(q2)%Cambia a la carpeta records
% save('videorecord.m','-ascii') 
saveas(fg1,'cicloascendente.jpg')
saveas(fg2,'ciclodescendente.jpg')
NN=Nt1+Nt2;
s=string(datetime('now','TimeZone','local','Format','yMMdd_HH_mm_ss')) %Nombre del video
vid=VideoWriter(s)
open(vid)
for index=1:NN
    r=sprintf('shot%03d.jpg',index)
    T=imread(r)
    pause(0.5)
    writeVideo(vid,T)
end
close(vid)

return

% s=string(datetime('now','TimeZone','local','Format','yMMdd_HH_mm_ss'))
% vid=VideoWriter(s)
% open(vid)
% for index=1:Nt
%     r=sprintf('shot%03d.jpg',index)
%     T=imread(r)
%     pause(0.5)
%     writeVideo(vid,T)
% end
% close(vid)

cd('C:\Users\Juan Manuel.DESKTOP-3R9HSH2\Downloads')

function delay(seconds)
% function pause the program
% seconds = delay time in seconds
tic;
    while toc < seconds %Nos valemos del comando tic toc para hacer el comando de tiempos entre los hsot de la cámara
    end
end

%Control especializado/avanzado con con el comando PWM
%delay(10);
 % // Set the spinning direction counter-clockwise:
 % writeDigitalPin(a,in1, LOW);  writeDigitalPin(a,in2, HIGH);
%delay(10);
% // Stop and exit
%writeDigitalPin(a,in2, LOW);
%writePWMVoltage(a, ENA, 0);
%clear a;

%Instantáneas en el proceso de medición

% for index = 1:Nt
%     if mod(index,5)==0
%         img = snapshot(cam);
%         qq=sprintf('shot%03d.jpg',index);
%         filename=fullfile('c:\','Descargas','TFG Física',q2,qq,filesep);%Especificar la ruta carpeta de almacenamiento
%         imwrite(img,filename);
% 
%     else
%         % Acquire frame for processing
%         img = snapshot(cam);
%         filename=sprintf('shot%03d.jpg',index);
%         imwrite(img,filename)
%         % V6(index)=readVoltage(a,'A6');
%         delay(Deltat)
%     end
% end

%Ajustar opciones de ejecución para la monitorizacion