% This Buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

%ImportaciÃ³n de la libreria grafica
:- use_module(library(pce)).
:- pce_image_directory('./assets').
:- use_module(library(pce_style_item)).
% :- encoding(utf8).

resource(tabla,image,image('tabla.jpg')).
resource(alimentacion, image, image('alimentacion2.jpg')).
resource(actividad, image, image('actividad2.jpg')).
resource(embarazo, image, image('embarazo2.jpg')).
resource(familia, image, image('familia2.jpg')).
resource(hipertension, image, image('hiper.jpg')).
resource(portada, image, image('inicio.jpg')).
resource(gestacional, image, image('gestacional.jpg')).
resource(fondo, image, image('fondo.jpg')).

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
    send(Window, size, size(780,380)),
    new(L, dialog_group('')),
    send(L,size,size(310,320)),
    new(R, dialog_group('')),
    send(R,size,size(420,320)),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'El índice de masa corporal (IMC)\n es un indicador de gordura confiable.
Se considera que un adulto esta en sobrepeso
si tiene un IMC de entre los 25 y 29.9 kg/m2
y es obeso si posee un IMC superior a 30kg/m2.
(IMC = peso[kg]/estatura[m2]).', font(arial,arial,13))),
    send(R, display, Preg,point(20,20)),

    show_picture(L,tabla),
    new(@pesoItem, text_item('Peso en Kilogramos:')),
    send(R,display,@pesoItem,point(40,150)),
    new(@alturaItem, text_item('Altura en centimetros')),
    send(R, display, @alturaItem,point(40,180)),
    new(@texto, label(nombre,'Su índice de masa corporal es:',font(arial,arial,13))),
    send(R, display, @texto,point(40,230)),
    new(@indice, label(nombre,'')),
    send(R, display, @indice,point(260,230)),
    new(Calc, button('Calcular IMC', message(@prolog,imc))),
    send(Calc,font,font(arial,bold,13)),
    send(R, display, Calc, point(100,270)),
    new(@reglaUno,button('Siguiente',and(message(@prolog,reglaAlimentacion),message(Window,destroy),message(Window,free)))),
    send(@reglaUno,font,font(arial,arial,13)),
    send(@reglaUno,colour,colour('blue')),
    send(Window,display,@reglaUno, point(390,350)),
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
    new(Window, dialog('Alimentación')),
    send(Window, size, size(780,380)),
    new(L, dialog_group('')),
    send(L,size,size(310,340)),
    new(R, dialog_group('')),
    send(R,size,size(440,340)),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Una dieta sana es la combinación adecuada
de alimentos de diferentes grupos como son
las frutas, verduras, legumbres (como lentejas y alubias),
cereales integrales (como maíz, avena, trigo),
lácteos, carnes y la poca cantidad de grasas saturadas.\n
¿Considera que su alimentación diaria es saludable?
', font('Arial', '', 14))),
    send(R, display, Preg,point(35,50)),
    show_picture(L,alimentacion),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append,si), send(Op,append,no),
    send(R,display,Op,point(60,210)),
    new(@reglaDos,button('Siguiente',and(message(@prolog,reglaActividad),message(Window,destroy),message(Window,free)))),
    send(@reglaDos,font,font(arial,arial,13)),
    send(@reglaDos,colour,colour('blue')),
    send(Window,display,@reglaDos, point(390,350)),
    send(Window, open_centered).

%Regla de Actividad Fisica
reglaActividad:-
    new(Window, dialog('Actividad Fisica')),
    send(Window, size, size(780,380)),
    new(L, dialog_group('')),
    send(L,size,size(330,320)),
    new(R, dialog_group('')),
    send(R,size,size(420,320)),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'Se considera como actividad física cualquier
movimiento corporal producido por los músculos
que exija gasto de energía. Por ejemplo: correr,
caminar, saltar, practicar un deporte etc.\n
¿Qué tan frecuente realiza actividad física a
la semana durante 30 minutos al día como minimo?', font(arial, arial, 14))),
    send(R, display, Preg,point(30,35)),
    show_picture(L,actividad),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'ninguna vez'), send(Op,append,'1 a 3 veces por semana'),
    send(Op,append,'3 a 5 veces por semana'), send(Op,append,'toda la semana'),
    send(R,display,Op,point(60,180)),
    new(@reglaTres,button('Siguiente',and(message(@prolog,reglaFamilia,Op?selection),message(Window,destroy),message(Window,free)))),
    send(@reglaTres,font,font(arial,arial,13)),
    send(@reglaTres,colour,colour('blue')),
    send(Window,display,@reglaTres, point(390,350)),
    send(Window, open_centered).

%Regla para los antescedentes familiares
reglaFamilia('toda la semana'):-
    send(@result, selection('HAY POCA PROBABILIDAD\n DE QUE USTED TENGA DIABETES TIPO 2')),
    clear.
reglaFamilia('3 a 5 veces por semana'):-
    send(@result,selection('HAY POCA PROBABILIDAD\n DE QUE USTED TENGA DIABETES TIPO 2')),
    clear.
reglaFamilia('1 a 3 veces por semana'):-
    new(Window, dialog('Antecedentes Familiares')),
    send(Window, size, size(780,380)),
    new(L, dialog_group('')),
    send(L,size,size(360,320)),
    new(R, dialog_group('')),
    send(R,size,size(390,320)),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, '¿Se le ha diagnosticado diabetes a\n alguno de sus familiares allegados
u otros parientes?', font('Arial', '', 14))),
    send(R, display, Preg,point(35,35)),
    show_picture(L,familia),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'si, padres, hermanos, o hijos'), send(Op,append,'si, abuelos, tios o primos'),
    send(Op,append,'no, ninguno'),
    send(R,display,Op,point(60,140)),
    new(@reglaCuatro,button('Siguiente',and(message(@prolog,reglaHipertension,Op?selection),message(Window,destroy),message(Window,free)))),
    send(@reglaCuatro,font,font(arial,arial,13)),
    send(@reglaCuatro,colour,colour('blue')),
    send(Window,display,@reglaCuatro, point(390,350)),
    send(Window, open_centered).
reglaFamilia('ninguna vez'):-
     new(Window, dialog('Antecedentes Familiares')),
    send(Window, size, size(780,380)),
    new(L, dialog_group('')),
    send(L,size,size(360,320)),
    new(R, dialog_group('')),
    send(R,size,size(390,320)),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, '¿Se le ha diagnosticado diabetes a\n alguno de sus familiares allegados
u otros parientes?', font('Arial', '', 14))),
    send(R, display, Preg),
    show_picture(L,familia),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'si, padres, hermanos, o hijos'), send(Op,append,'si, abuelos, tios o primos'),
    send(Op,append,'no, ninguno'),
    send(R,display,Op,point(60,140)),
    new(@reglaCuatro,button('Siguiente',and(message(@prolog,reglaHipertension,Op?selection),message(Window,destroy),message(Window,free)))),
    send(@reglaCuatro,font,font(arial,arial,13)),
    send(@reglaCuatro,colour,colour('blue')),
    send(Window,display,@reglaCuatro, point(390,350)),
    send(Window, open_centered).

%Regla Hipertension
reglaHipertension('si, padres, hermanos, o hijos'):-
     send(@result, selection('PROBABLEMENTE\n  USTED TIENE DIABETES TIPO 2')),
     clear.
reglaHipertension('si, abuelos, tios o primos'):-
     send(@result, selection('EXISTE LA PROBABILIDAD\n DE QUE USTED TENGA DIABETES TIPO 2')),
     clear.
reglaHipertension('no, ninguno'):-
    new(Window, dialog('Hipertension')),
    send(Window, size, size(780,380)),
    new(L, dialog_group('')),
    send(L,size,size(400,320)),
    new(R, dialog_group('')),
    send(R,size,size(350,320)),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, '¿Tiene la presión arterial alta?', font('Arial','',14))),
    send(R, display, Preg,point(30,40)),
    show_picture(L,hipertension),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'Si'), send(Op,append,'No'),
    send(R,display,Op,point(60,120)),
    new(@reglaCinco,button('Siguiente',and(message(@prolog,reglaEmbarazo,Op?selection),message(Window,destroy),message(Window,free)))),
    send(@reglaCinco,font,font(arial,arial,13)),
    send(@reglaCinco,colour,colour('blue')),
    send(Window,display,@reglaCinco, point(390,350)),
    send(Window, open_centered).

%Regla Embarazo
reglaEmbarazo('No'):-
    send(@result, selection('USTED PRESENTA LOS FACTORES\n COMUNES DE LA DIABETES TIPO 2,\n ES PROBABLE QUE TENGA
ESTA ENFERMEDAD')),
    clear.
reglaEmbarazo('Si'):-
     new(Window, dialog('Embarazo')),
    send(Window, size, size(780,380)),
    new(L, dialog_group('')),
    send(L,size,size(400,320)),
    new(R, dialog_group('')),
    send(R,size,size(350,320)),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, '¿Ha estado embarazada?', font('Arial', '', 14))),
    send(R, display, Preg, point(20,35)),
    show_picture(L,embarazo),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'Si'), send(Op,append,'No'),
    send(R,display,Op,point(50,100)),
    new(@reglaSeis,button('Siguiente',and(message(@prolog,reglaGestacional,Op?selection),message(Window,destroy),message(Window,free)))),
    send(@reglaSeis,font,font(arial,arial,13)),
    send(@reglaSeis,colour,colour('blue')),
    send(Window,display,@reglaSeis, point(390,350)),
    send(Window, open_centered).

%Regla Embarazo Gestacional
reglaGestacional('No'):-
     send(@result, selection('USTED PRESENTA LOS FACTORES\n COMUNES DE LA DIABETES TIPO 2,\n ES PROBABLE QUE
TENGA ESTA ENFERMEDAD')),
     clear.
reglaGestacional('Si'):-
     new(Window, dialog('Diabetes Gestacional')),
    send(Window, size, size(780,380)),
    new(L, dialog_group('')),
    send(L,size,size(400,320)),
    new(R, dialog_group('')),
    send(R,size,size(350,320)),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, '¿Padeció de Diabetes Gestacional durante\n su embarazo?', font('Arial', '', 14))),
    send(R, display, Preg, point(20,35)),
    show_picture(L,gestacional),
    new(Op, menu(seleccione, marked)),
    send(Op, layout, orientation:= vertical),
    send(Op, append, 'Si'), send(Op,append,'No'),
    send(R,display,Op,point(50,100)),
    new(@reglaSiete,button('Siguiente',and(message(@prolog,reglaEsp,Op?selection),message(Window,destroy),message(Window,free)))),
    send(@reglaSiete,font,font(arial,arial,13)),
    send(@reglaSiete,colour,colour('blue')),
    send(Window,display,@reglaSiete, point(390,350)),
    send(Window, open_centered).


%Caso final
reglaEsp('No'):-
  send(@result, selection('USTED PRESENTA LOS FACTORES\n COMUNES DE LA DIABETES TIPO 2,\n ES PROBALE QUE TENGA
ESTA ENFERMEDAD')),
  clear.
reglaEsp('Si'):-
  send(@result, selection('USTED PRESENTA UN ALTO \n RIESGO DE TENER DIABETES TIPO 2')),
  clear.

%Definicion de la funcion principal
init:-
    new(Window, dialog('Sistema Diabetes')),
    send(Window, size, size(800,620)),
    new(L,dialog_group('')),
    new(R,dialog_group('')),
    send(Window,append,L),
    send(Window,append,R,right),
    send(L,size,size(400,600)),
    send(R,size,size(360,600)),

    new(Bienvenida,label(titulo,'BIENVENIDA A SU',font(corbel,bold,20))),
    new(Bienvenida2,label(titulo,'DIAGNÓSTICO',font(corbel,bold,20))),
    new(Sexo,label(titulo,'Mujeres 30-40',font(arial,'',16))),
    new(@inicio,button('Iniciar Diagnóstico', message(@prolog,reglaObesidad))),
    send(@inicio,font,font(arial,bold,14)),

    show_picture(L,portada),
    show_picture(R,fondo),
    send(R,display,Bienvenida,point(60,50)),
    send(R,display,Bienvenida2,point(85,80)),
    send(R,display,Sexo,point(90,130)),
    send(R, display, @inicio,point(140,550)),
    new(@result, label(l,'Podrá consultar aquí su resultado
al término de su prueba',font(arial,arial,14))),
    send(R, display, @result, point(35,300)),
    new(BtnSalir, button('Salir', and(message(Window,destroy),message(Window,free),message(@result,free)))),
    send(BtnSalir,font,font(arial,arial,14)),
    send(R,display,BtnSalir, point(50,550)),
    send(Window,open_centered).

%Funcion para limpiar variables
clear:-
    send(@inicio,free),
    send(@alturaItem,free),send(@pesoItem,free),
    send(@texto,free),send(@indice,free),
    send(@reglaUno,free),send(@reglaDos,free),
    send(@reglaTres,free),send(@reglaCuatro,free),
    send(@reglaCinco,free),send(@reglaSeis,free),
    send(@reglaSiete,free).

:-init.















