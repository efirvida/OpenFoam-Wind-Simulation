/*--------------------------------*- C++ -*----------------------------------*\
| =========                 |                                                 |
| \\      /  F ield         | foam-extend: Open Source CFD                    |
|  \\    /   O peration     | Version:     3.2                                |
|   \\  /    A nd           | Web:         http://www.foam-extend.org         |
|    \\/     M anipulation  |                                                 |
\*---------------------------------------------------------------------------*/
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      blockMeshDict;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
m4_divert(-1)
#----------------------------------
m4_changecom(//)m4_changequote([,])
m4_define(calc, [m4_esyscmd(perl -e 'printf ($1)')])
m4_define(pi, 3.14159265358979323844)
m4_define(rad, [calc($1*pi/180.0)])
#----------------------------------

#----------------------------------
# Unidades (convertToMeters)
m4_define(units, 1)

# Datos del disco del rotor
m4_define(r_rotor, 62.9)            # radio del rotor
m4_define(z_rotor_pos, 3.5)         # disco del rotor z+
m4_define(z_rotor_neg, -30)         # disco del rotor z-

# Bloques parte frontal
m4_define(x_front, 40)              # bloques direccion eje x
m4_define(y_front, 40)              # bloques direccion eje y
m4_define(z_front, 40)              # bloques direccion eje x
m4_define(grading_front, 1 1 0.1)   # gradiente 

# Bloques parte media
m4_define(x_med, 40)
m4_define(y_med, 40)
m4_define(z_med, 40)
m4_define(grading_med, 1 1 1)

# Bloques parte trasera
m4_define(x_tras, 40)
m4_define(y_tras, 40)
m4_define(z_tras, 70)
m4_define(grading_tras, 1 1 10)

#----------------------------------

m4_define(r_int,  [calc(1.5*r_rotor)])     # radio del disco del rotor  1.5 * radio del rotor
m4_define(r_ext,  [calc(5*r_rotor)])       # radio exterior del dominio 5.0 * radio del rotor
m4_define(entrada,  [calc(1.5*r_ext)])     # posicion del patch de entada direccion eje z 1.5 * radio del rotor
m4_define(salida, [calc(5*r_ext)])         # posicion del patch de entada direccion eje z 4.5 * radio del rotor

# definicion de los arcos
m4_define(r_int_arc, [calc(r_int*sin(rad(45)))])
m4_define(r_ext_arc, [calc(r_ext*sin(rad(45)))])

m4_divert(0)

convertToMeters units;

vertices
(
    ( -r_ext      0  -entrada )
    ( 0      -r_ext  -entrada )
    ( r_ext       0  -entrada )
    ( 0       r_ext  -entrada )
    ( -r_int      0  -entrada )
    ( 0      -r_int  -entrada )
    ( r_int       0  -entrada )
    ( 0       r_int  -entrada )
    
    ( -r_ext      0  z_rotor_neg )
    ( 0      -r_ext  z_rotor_neg )
    ( r_ext       0  z_rotor_neg )
    ( 0       r_ext  z_rotor_neg )
    ( -r_int      0  z_rotor_neg )
    ( 0      -r_int  z_rotor_neg )
    ( r_int       0  z_rotor_neg )
    ( 0       r_int  z_rotor_neg ) 

    ( -r_ext      0  z_rotor_pos )
    ( 0      -r_ext  z_rotor_pos )
    ( r_ext       0  z_rotor_pos )
    ( 0       r_ext  z_rotor_pos )
    ( -r_int      0  z_rotor_pos )
    ( 0      -r_int  z_rotor_pos )
    ( r_int       0  z_rotor_pos )
    ( 0       r_int  z_rotor_pos )

    ( -r_ext      0  salida )
    ( 0      -r_ext  salida )
    ( r_ext       0  salida )
    ( 0       r_ext  salida )
    ( -r_int      0  salida )
    ( 0      -r_int  salida )
    ( r_int       0  salida )
    ( 0       r_int  salida )   
);

blocks
(
    // seccion frontal    
    hex (0 1 5 4  8  9 13 12)  (x_front y_front z_front) simpleGrading (grading_front)
    hex (1 2 6 5  9 10 14 13)  (x_front y_front z_front) simpleGrading (grading_front)
    hex (2 3 7 6 10 11 15 14)  (x_front y_front z_front) simpleGrading (grading_front)
    hex (3 0 4 7 11  8 12 15)  (x_front y_front z_front) simpleGrading (grading_front)
    hex (4 5 6 7 12 13 14 15)  (x_front y_front z_front) simpleGrading (grading_front) 
    // seccion media
    hex ( 8  9 13 12 16 17 21 20)  (x_med y_med z_med) simpleGrading (grading_med)
    hex ( 9 10 14 13 17 18 22 21)  (x_med y_med z_med) simpleGrading (grading_med)
    hex (10 11 15 14 18 19 23 22)  (x_med y_med z_med) simpleGrading (grading_med)
    hex (11  8 12 15 19 16 20 23)  (x_med y_med z_med) simpleGrading (grading_med)
    // seccion trasera
    hex (16 17 21 20 24 25 29 28)  (x_tras y_tras z_tras) simpleGrading (grading_tras)
    hex (17 18 22 21 25 26 30 29)  (x_tras y_tras z_tras) simpleGrading (grading_tras)
    hex (18 19 23 22 26 27 31 30)  (x_tras y_tras z_tras) simpleGrading (grading_tras)
    hex (19 16 20 23 27 24 28 31)  (x_tras y_tras z_tras) simpleGrading (grading_tras)
    hex (20 21 22 23 28 29 30 31)  (x_tras y_tras z_tras) simpleGrading (grading_tras)
);

edges
(
    arc 0 1 (-r_ext_arc -r_ext_arc -entrada )
    arc 1 2 (r_ext_arc  -r_ext_arc -entrada )
    arc 2 3 (r_ext_arc   r_ext_arc -entrada )
    arc 3 0 (-r_ext_arc  r_ext_arc -entrada )

    arc  8  9 ( -r_ext_arc -r_ext_arc z_rotor_neg )  
    arc  9 10 (  r_ext_arc -r_ext_arc z_rotor_neg )
    arc 10 11 (  r_ext_arc  r_ext_arc z_rotor_neg )
    arc 11  8 ( -r_ext_arc  r_ext_arc z_rotor_neg ) 

    arc 16 17 ( -r_ext_arc -r_ext_arc z_rotor_pos )
    arc 17 18 (  r_ext_arc -r_ext_arc z_rotor_pos )
    arc 18 19 (  r_ext_arc  r_ext_arc z_rotor_pos )
    arc 19 16 ( -r_ext_arc  r_ext_arc z_rotor_pos )

    arc 24 25 (-r_ext_arc -r_ext_arc salida )
    arc 25 26 ( r_ext_arc -r_ext_arc salida )
    arc 26 27 ( r_ext_arc  r_ext_arc salida )
    arc 27 24 (-r_ext_arc  r_ext_arc salida )

    // interior
    arc 12 13 ( -r_int_arc -r_int_arc z_rotor_neg )
    arc 13 14 (  r_int_arc -r_int_arc z_rotor_neg )
    arc 14 15 (  r_int_arc  r_int_arc z_rotor_neg )
    arc 15 12 ( -r_int_arc  r_int_arc z_rotor_neg )

    arc 20 21 ( -r_int_arc -r_int_arc z_rotor_pos )
    arc 21 22 (  r_int_arc -r_int_arc z_rotor_pos )
    arc 22 23 (  r_int_arc  r_int_arc z_rotor_pos )
    arc 23 20 ( -r_int_arc  r_int_arc z_rotor_pos )
);

boundary
(
    AMI1
    {
        type patch;
        faces
        (
            (12 15 23 20)  
            (15 14 22 23)
            (14 13 21 22)
            (13 12 20 21)
            (12 13 14 15)
            (20 21 22 23)
         );
     }

    entrada_ext_dominio
    {
        type patch;
        faces
        (
            (0 1 5 4)
            (2 1 5 6)
            (3 2 6 7)
            (0 3 7 4)
            (4 5 6 7)
         );  
     }

    salida_ext_dominio
    {
        type patch;
        faces
        (
            (25 26 30 29)
            (26 27 31 30)
            (27 24 28 31)
            (24 25 29 28)
            (29 30 31 28)
         );  
     }

     cilindro_ext_dominio
     {
        type wall;
        faces
        (
            (  1  9 10  2 )
            (  2 10 11  3 )
            (  3 11  8  0 )
            (  0  8  9  1 )
            (  9 17 18 10 )
            ( 10 18 19 11 )
            ( 11 19 16  8 )
            (  8 16 17  9 )
            ( 17 25 26 18 )
            ( 18 26 27 19 )
            ( 19 27 24 16 )
            ( 16 24 25 17 )
        );
    }
);

mergePatchPairs
(
);

// ************************************************************************* //
