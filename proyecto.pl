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
resource(embarazo, image, image('emabarazo.jpg')).
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
    send(Window, size, size(750,300)),
    new(L, dialog_group('')),
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),
    new(Preg, label(nombre, 'El Indice de masa corporal (IMC) es un indicador de gordura confiable para las personas\n
Se considera que un adulto está en sobrepeso si tiene un
IMC de entre los 25 y 29.9 kg/m2 y es
obeso si posee un IMC superior a 30kg/m2.\n
(IMC = peso[kg]/estatura[m2]).
')),
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
    send(Window, open_centered).

%Funcion Para el calculo de IMC
imc:-
    get(@pesoItem,selection,AuxKG),
    get(@alturaItem,selection,AuxCM),
    atom_number(AuxKG, KG),
    atom_number(AuxCM, CM),
    M is CM/100, Aux is M*M,
    send(@indice, selection((KG/Aux))).


%Definicion de la funcion principal
main:-
    new(Window, dialog('Sistema Diabetes')),
    send(Window, size, size(250,250)),
    new(@inicio,button('Iniciar Diagnostico', message(@prolog,reglaObesidad))),
    send(Window, append, @inicio),
    new(BtnSalir, button('Salir', and(message(Window,destroy),message(Window,free)))),
    send(Window,display,BtnSalir, point(200,230)),
    send(Window,open_centered).











