% This Buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

%Importación de la libreria grafica
:- use_module(library(pce)).
:- pce_image_directory('./assets').
:- use_module(library(pce_style_item)).

resource(tabla,image,image('tablaIMC.jpeg')).
resource(alimentacion, image, image('alimentacion.jpg')).
resource(ejercicio, image, image('ejercicio.jpg')).
resource(embarazo, image, image('embarazo.jpg')).
resource(familia, image, image('familia.jpg')).
resource(tabaco, image, image('tabaco.jpg')).

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
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'El Indice de masa corporal (IMC) es\n un indicador de gordura confiable para las personas\n
Se considera que un adulto está en sobrepeso si tiene un
IMC de entre los 25 y 29.9 kg/m2 y es
obeso si posee un IMC superior a 30kg/m2.\n
(IMC = peso[kg]/estatura[m2]).
', font('times', 'roman', 14))),
    send(R, display, Preg),
    show_picture(L,tabla),
    new(@pesoItem, text_item('Peso en Kilogramos:')),
    send(R,append,@pesoItem),
    new(@alturaItem, text_item('Altura en centimetros')),
    send(R, append, @alturaItem),
    new(@texto, label(nombre,'Su indice de masa corporal es:')),
    send(R, append, @texto),
    new(@indice, label(nombre,'')),
    send(R, append, @indice),
    new(Calc, button('Calcular IMC', message(@prolog,imc))),
    send(R, append, Calc),
    new(@reglaUno,button('Siguiente',and(message(@prolog,reglaAlimentacion),message(Window,destroy),message(Window,free)))),
    send(Window,display,@reglaUno, point(350,300)),
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
    send(Window, size, size(750,320)),
    new(L, dialog_group('')),
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Una dieta sana es la\n combinación adecuanda de alimentos de diferentes\n grupos como son las frutas,verduras,\n legumbres (como lentejas y alubias),\n
cereales integrales (como maíz, avena, trigo),\n lácteos, carnes y la poca cantidad\n de grasas saturadas.\n
¿Considera que su alimentación diaria es saludable?
', font('times', 'roman', 14))),
    send(R, display, Preg),
    show_picture(L,alimentacion),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append,si), send(Op,append,no),
    send(R,append,Op),
    new(@reglaDos,button('Siguiente',and(message(@prolog,reglaActividad),message(Window,destroy),message(Window,free)))),
    send(Window,display,@reglaDos, point(350,300)),
    send(Window, open_centered).

%Regla de Actividad Fisica
reglaActividad:-
    new(Window, dialog('Actividad Fisica')),
    send(Window, size, size(750,320)),
    new(L, dialog_group('')),
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Se considera como actividad física cualquier movimiento corporal
producido por los músculos que exija gasto de energía.
Por ejemplo: correr, caminar, saltar, practicar un deporte etc.
¿Qué tan frecuente realiza actividad física a la semana
durante 30 minutos al día como mínimo?
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
    new(Preg, label(nombre, '¿Se le ha diagnosticado diabetes a\n alguno de sus familiares allegados
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
    new(Preg, label(nombre, '¿Se le ha diagnosticado diabetes a\n alguno de sus familiares allegados
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
    send(Window, size, size(250,250)),
    new(@inicio,button('Iniciar Diagnostico', message(@prolog,reglaObesidad))),
    send(Window, append, @inicio),
    new(@result, label(l,'')),
    send(Window, append, @result),
    new(BtnSalir, button('Salir', and(message(Window,destroy),message(Window,free)))),
    send(Window,display,BtnSalir, point(200,230)),
    send(Window,open_centered).

