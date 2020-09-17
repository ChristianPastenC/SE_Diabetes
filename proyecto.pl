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

%Definicion de la funcion principal
main:-
    new(Window, dialog('Sistema experto diabetes')),
    send(Window, size, size(750,600)),
    new(L, dialog_group('')),
    new(R, dialog_group('')),
    send(Window,append,L),
    send(Window, append, R, right),

    new(Fig, figure),
    new(Bitmap, bitmap(resource(tabla),@on)),
    send(Bitmap, name, 1),
    send(Fig,display,Bitmap),
    send(Fig,status,1),
    send(L,display,Fig),

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

    new(@inicio,button('Iniciar Diagnostico', message(@prolog,iniciar))),
    send(Window, append, @inicio),

    send(Window,open_centered).

%Funcion Para el calculo de IMC
imc:-
    get(@pesoItem,selection,AuxKG),
    get(@alturaItem,selection,AuxCM),
    atom_number(AuxKG, KG),
    atom_number(AuxCM, CM),
    M is CM/100, Aux is M*M,
    send(@indice, selection((KG/Aux))).










