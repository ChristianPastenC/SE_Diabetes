% This Buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

%ImportaciÃ³n de la libreria grafica
:- use_module(library(pce)).
:- pce_image_directory('./assets').
:- use_module(library(pce_style_item)).

resource(tabla,image,image('tabla.jpg')).
resource(alimentacion, image, image('alimentacion2.jpg')).
resource(ejercicio, image, image('ejercicio.jpg')).
resource(embarazo, image, image('embarazo.jpg')).
resource(familia, image, image('familia.jpg')).
resource(tabaco, image, image('tabaco.jpg')).
resource(portada, image, image('inicio.jpg')).


%Funcion para el redondeo de numeros decimales
truncate(X,N,Result):- X >= 0, Result is floor(10^N*X)/10^N, !.

%Funcion para mostrar una imagen
show_picture(Window, Image):-
    new(Fig, figure),
    new(Bitmap, bitmap(resource(Image),@on)),
    send(Bitmap, name, 1),
    send(Fig,display,Bitmap),
    send(Fig,status,1),
    send(Window,display,Fig).


%Regla para obesidad
reglaObesidad:-
    new(Window, dialog('Indice de Masa Corporal')),
    send(Window, size, size(750,320)),
    new(L, dialog_group('')),
    send(L,size,size(310,320)),
    new(R, dialog_group('')),
    send(R,size,size(420,320)),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'El Indice de masa corporal (IMC) es un indicador de gordura confiable.
Se considera que un adulto está en sobrepeso si tiene un
IMC de entre los 25 y 29.9 kg/m2 y es
obeso si posee un IMC superior a 30kg/m2.
(IMC = peso[kg]/estatura[m2]).
', font('Arial','',12))),
    send(R, display, Preg,point(20,20)),

    show_picture(L,tabla),
    new(@pesoItem, text_item('Peso en Kilogramos:')),
    send(R,display,@pesoItem,point(40,130)),
    new(@alturaItem, text_item('Altura en centimetros')),
    send(R, display, @alturaItem,point(40,170)),
    new(@texto, label(nombre,'Su indice de masa corporal es:')),
    send(R, display, @texto,point(40,220)),
    new(@indice, label(nombre,'')),
    send(R, display, @indice,point(260,220)),
    new(Calc, button('Calcular IMC', message(@prolog,imc))),
    send(R, display, Calc, point(100,260)),
    new(@reglaUno,button('Siguiente',and(message(@prolog,reglaAlimentacion),message(Window,destroy),message(Window,free)))),
    send(R,display,@reglaUno, point(290,270)),
    send(Window, open_centered).

%Funcion Para el calculo de IMC
imc:-
    get(@pesoItem,selection,AuxKG),
    get(@alturaItem,selection,AuxCM),
    atom_number(AuxKG, KG),
    atom_number(AuxCM, CM),
    M is CM/100, Aux is M*M,
    send(@indice, selection((KG/Aux))).

%Regla para alimentacion
reglaAlimentacion:-
    new(Window, dialog('Alimentacion')),
    send(Window, size, size(750,350)),
    new(L, dialog_group('')),
    send(L,size,size(310,340)),
    new(R, dialog_group('')),
    send(R,size,size(440,340)),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Una dieta sana es la combinación adecuanda
de alimentos de diferentes grupos como son
las frutas, verduras, legumbres (lentejas y alubias),
cereales integrales (como maíz, avena, trigo),
lácteos, carnes y la poca cantidad de grasas saturadas.\n
¿Considera que su alimentación diaria es saludable?
', font('times', 'roman', 12.5))),
    send(R, display, Preg,point(35,50)),
    show_picture(L,alimentacion),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append,si), send(Op,append,no),
    send(R,display,Op,point(60,210)),
    new(@reglaDos,button('Siguiente',and(message(@prolog,reglaActividad),message(Window,destroy),message(Window,free)))),
    send(R,display,@reglaDos, point(310,300)),
    send(Window, open_centered).

%Regla de Actividad Fisica
reglaActividad:-
    new(Window, dialog('Actividad Fisica')),
    send(Window, size, size(750,320)),
    new(L, dialog_group('')),
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Se considera como actividad fÃ­sica cualquier movimiento corporal
producido por los mÃºsculos que exija gasto de energÃ­a.
Por ejemplo: correr, caminar, saltar, practicar un deporte etc.
Â¿QuÃ© tan frecuente realiza actividad fÃ­sica a la semana
durante 30 minutos al dÃ­a como mÃ­nimo?
', font('times', 'roman', 14))),
    send(R, display, Preg),
    show_picture(L,ejercicio),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'ninguna vez'), send(Op,append,'1 a 3 veces por semana'),
    send(Op,append,'3 a 5 veces por semana'), send(Op,append,'toda la semana'),
    send(R,append,Op),
    new(@reglaTres,button('Siguiente',and(message(@prolog,reglaFamilia,Op?selection),message(Window,destroy),message(Window,free)))),
    send(Window,display,@reglaTres, point(350,300)),
    send(Window, open_centered).

%Regla para los antescedentes familiares
reglaFamilia('toda la semana'):-
    send(@result, selection('HAY POCA PROBABILIDAD\n DE QUE USTED TENGA DIABETES')).
reglaFamilia('3 a 5 veces por semana'):-
    send(@result,selection('HAY POCA PROBABILIDAD\n DE QUE USTED TENGA DIABETES')).
reglaFamilia('1 a 3 veces por semana'):-
     new(Window, dialog('Antecedentes Familiares')),
    send(Window, size, size(750,320)),
    new(L, dialog_group('')),
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Â¿Se le ha diagnosticado diabetes a\n alguno de sus familiares allegados
u otros parientes?', font('times', 'roman', 14))),
    send(R, display, Preg),
    show_picture(L,familia),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'si, padres, hermanos, o hijos'), send(Op,append,'si, abuelos, tios o primos'),
    send(Op,append,'no, ninguno'),
    send(R,append,Op),
    new(@reglaCuatro,button('Siguiente',and(message(@prolog,reglaHipertension,Op?selection),message(Window,destroy),message(Window,free)))),
    send(Window,display,@reglaCuatro, point(350,300)),
    send(Window, open_centered).
reglaFamilia('ninguna vez'):-
     new(Window, dialog('Antecedentes Familiares')),
    send(Window, size, size(750,320)),
    new(L, dialog_group('')),
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Â¿Se le ha diagnosticado diabetes a\n alguno de sus familiares allegados
u otros parientes?', font('times', 'roman', 14))),
    send(R, display, Preg),
    show_picture(L,familia),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'si, padres, hermanos, o hijos'), send(Op,append,'si, abuelos, tios o primos'),
    send(Op,append,'no, ninguno'),
    send(R,append,Op),
    new(@reglaCuatro,button('Siguiente',and(message(@prolog,reglaHipertension,Op?selection),message(Window,destroy),message(Window,free)))),
    send(Window,display,@reglaCuatro, point(350,300)),
    send(Window, open_centered).

%Regla Hipertension
reglaHipertension('si, padres, hermanos, o hijos'):-
     send(@result, selection('HAY PROBABILIDAD\n DE QUE USTED TENGA DIABETES')).
reglaHipertension('si, abuelos, tios o primos'):-
     send(@result, selection('EXISTE LA PROBABILIDAD\n DE QUE USTED TENGA DIABETES')).
reglaHipertension('no, ninguno'):-
     new(Window, dialog('Hipertension')),
    send(Window, size, size(750,320)),
    new(L, dialog_group('')),
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Su presion arterial es alta?', font('times', 'roman', 14))),
    send(R, display, Preg),
    show_picture(L,tabaco),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'Si'), send(Op,append,'No'),
    send(R,append,Op),
    new(@reglaCinco,button('Siguiente',and(message(@prolog,reglaEmbarazo,Op?selection),message(Window,destroy),message(Window,free)))),
    send(Window,display,@reglaCinco, point(350,300)),
    send(Window, open_centered).

%Regla Embarazo
reglaEmbarazo('No'):-
    send(@result, selection('USTED PRESENTA LOS FACTORES\n COMUNES DE LA DIABETES TIPO 2,\n POSIBLE DIABETES')).
reglaEmbarazo('Si'):-
     new(Window, dialog('Embarazo')),
    send(Window, size, size(750,320)),
    new(L, dialog_group('')),
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Ah estado embarazada?', font('times', 'roman', 14))),
    send(R, display, Preg),
    show_picture(L,embarazo),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'Si'), send(Op,append,'No'),
    send(R,append,Op),
    new(@reglaSeis,button('Siguiente',and(message(@prolog,reglaGestacional,Op?selection),message(Window,destroy),message(Window,free)))),
    send(Window,display,@reglaSeis, point(350,300)),
    send(Window, open_centered).

%Regla Embarazo Gestacional
reglaGestacional('No'):-
     send(@result, selection('USTED PRESENTA LOS FACTORES\n COMUNES DE LA DIABETES TIPO 2,\n POSIBLE DIABETES')).
reglaGestacional('Si'):-
     new(Window, dialog('Diabetes Gestacional')),
    send(Window, size, size(750,320)),
    new(L, dialog_group('')),
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Padecio de Diabetes Gestacional durante\n su embarazo?', font('times', 'roman', 14))),
    send(R, display, Preg),
    show_picture(L,embarazo),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'Si'), send(Op,append,'No'),
    send(R,append,Op),
    new(@reglaSiete,button('Siguiente',and(message(@prolog,reglaEsp,Op?selection),message(Window,destroy),message(Window,free)))),
    send(Window,display,@reglaSiete, point(350,300)),
    send(Window, open_centered).


%Caso final
reglaEsp('No'):-
  send(@result, selection('USTED PRESENTA LOS FACTORES\n COMUNES DE LA DIABETES TIPO 2,\n POSIBLE DIABETES')).
reglaEsp('Si'):-
  send(@result, selection('USTED PRESENTA UN ALTO \n RIESGO DE TENER DIABETES TIPO 2')).

%Definicion de la funcion principal
main:-
    new(Window, dialog('Sistema Diabetes')),
    send(Window, size, size(750,600)),
    new(L,dialog_group('')),
    new(R,dialog_group('')),
    send(Window,append,L),
    send(Window,append,R,right),
    send(L,size,size(400,600)),
    send(R,size,size(340,600)),

    new(Bienvenida,label(titulo,'BIENVENIDA A SU',font('Corbel','',20))),
    new(Bienvenida2,label(titulo,'DIAGNOSTICO',font('Corbel','',20))),
    new(Sexo,label(titulo,'Mujeres 30-40',font('Arial','',16))),
    new(@inicio,button('Iniciar Diagnostico', message(@prolog,reglaObesidad))),

    show_picture(L,portada),
    send(R,display,Bienvenida,point(40,40)),
    send(R,display,Bienvenida2,point(65,75)),
    send(R,display,Sexo,point(50,150)),
    send(R, display, @inicio,point(30,550)),
    new(@result, label(l,'',font('Arial','',13))),
    send(R, display, @result, point(35,300)),
    new(BtnSalir, button('Salir', and(message(Window,destroy),message(Window,free)))),
    send(R,display,BtnSalir, point(200,550)),
    send(Window,open_centered).


