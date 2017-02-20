function [zachmurzenia,mapka_biala,mapka_nieb,wszystkie_mapki] = oblicz_zachmurzenie_do_gui(title,lista,sciezka)

    [rr cc] = meshgrid(1:1024);
    C = uint8(sqrt((rr-512).^2+(cc-512).^2)<=512);
    C_wiele=zeros(1024,1024,3);
    C_wiele(:,:,1)=C;
    C_wiele(:,:,2)=C;
    C_wiele(:,:,3)=C;
    tlo = imread('blue.JPG');
    tlo = imcrop(tlo,[267.5 112.5 1023 1023]);
    tlo=double(tlo.*uint8(C_wiele));
    tlo_area =(tlo(:,:,2)./tlo(:,:,1))<1.2;
    tlo_area_count = bwarea(tlo_area);
    


    if nargin == 3
    mapka_nieb=zeros(length(lista),1024,1024,3);
    mapka_biala=zeros(length(lista),1024,1024,3);
    wszystkie_mapki=uint8(zeros(length(lista),1024,1024,3));
    zachmurzenia = zeros(length(lista),1);
    figure
        for i=1:length(lista)
            mapka=imread([sciezka,lista{i}]);

            
            plt = imcrop(mapka,[267.5 112.5 1023 1023]);
            mapka_wyc=double(plt.*uint8(C_wiele));
            wszystkie_mapki(i,:,:,:)=plt.*uint8(C_wiele);

            imshow(plt,'InitialMagnification',37)
            
            mapka_nieb(i,:,:,1) = (mapka_wyc(:,:,3)./mapka_wyc(:,:,1))>1.6;
            mapka_nieb(i,:,:,2) = (mapka_wyc(:,:,3)./mapka_wyc(:,:,1))>1.6;
            mapka_nieb(i,:,:,3) = (mapka_wyc(:,:,3)./mapka_wyc(:,:,1))>1.6;
            nieb_area = bwarea(squeeze(mapka_nieb(i,:,:,1)));
            
            mapka_biala(i,:,:,1) = (mapka_wyc(:,:,2)./mapka_wyc(:,:,1))<1.2;
            mapka_biala(i,:,:,2) = (mapka_wyc(:,:,2)./mapka_wyc(:,:,1))<1.2;
            mapka_biala(i,:,:,3) = (mapka_wyc(:,:,2)./mapka_wyc(:,:,1))<1.2;

            bial_area = bwarea(squeeze(mapka_biala(i,:,:,1)))-tlo_area_count;
            zachmurzenia(i)=bial_area/(bial_area+nieb_area);

            M(i)=getframe;
        end
    end

save([title,'.mat'],'zachmurzenia')
movie2avi(M,[title,'.avi'],'fps',2)
end

